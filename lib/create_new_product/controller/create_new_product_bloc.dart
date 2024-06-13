import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_form.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_form.dart';
import 'package:inventory_management_with_sql/repo/attribute_repo/attribute_entity.dart';
import 'package:inventory_management_with_sql/repo/option_repo/option_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_create_new_product_use_case.dart';

class ProductCreateEvent extends NullObject {
  final Result<List<Map<String, dynamic>>> Function() getPayload;
  final Map<int, SetOptionValueForm> formGroups;
  final List<int> selectedVariants;
  const ProductCreateEvent({
    required this.formGroups,
    required this.getPayload,
    required this.selectedVariants,
  });
}

class OptionAttributePair {
  final Option option;
  final List<Attribute> attribute;

  const OptionAttributePair({
    required this.option,
    required this.attribute,
  });
}

class CreateNewProductBloc extends SqliteCreateBloc<
    Product,
    VariantProductParams,
    SqliteCreateNewProductUseCase,
    CreateNewProductForm,
    ProductCreateEvent> {
  final ImagePicker imagePicker;

  //left index => ui index
  //right index => form index
  Map<int, int> variantUiAndFormIndexMapper = {};

  CreateNewVariantForm? singleProductForm;

  void addVariant(int index) {
    /// single product (variant)= [singleProductFrom]
    /// variant[0] is singleProduct => singleProduct store
    /// varint (1) length=>1,index => 0
    /// index 0 exist => 1
    print("Before: $variantUiAndFormIndexMapper");
    final leftMostV = form.varaints[0];
    print("LeftMost: ${leftMostV.isVariant}");
    if (!leftMostV.isVariant) {
      print("Save Left Most Form");

      ///origin
      singleProductForm = leftMostV;
      form.varaints.clear();
    }
    // final afterAddingIndex = form.varaints.length; //(1)
    form.varaints.add(CreateNewVariantForm.form(true)); //length 2,(1,2) ,(0,1)
    variantUiAndFormIndexMapper[index] = form.varaints.length - 1;
    print("After: $variantUiAndFormIndexMapper");
  }

  void removeVariant(int index) {
    print("Before: $variantUiAndFormIndexMapper ${form.varaints}");
    final formIndex = variantUiAndFormIndexMapper.remove(index);
    if (formIndex == null) return;
    final result = form.varaints.toList()..removeAt(formIndex);

    ///[1,2,3] => [1,3]
    form.varaints.clear();
    form.varaints.addAll(result);
    if (form.varaints.isEmpty && singleProductForm != null) {
      form.varaints.add(singleProductForm!);
      form.index = 0;
    }

    variantUiAndFormIndexMapper = variantUiAndFormIndexMapper.map((key, value) {
      return MapEntry(key, formIndex < value ? value - 1 : value);
    });

    print("After: $variantUiAndFormIndexMapper ${form.varaints}");
  }

  void clean() {
    final temp = form.varaints[0];
    if (!temp.isVariant) {
      return;
    }
    changeToSingleProduct();
  }

  void changeToSingleProduct() {
    if (singleProductForm == null) return;
    form.varaints.clear();
    form.varaints.add(singleProductForm!);
    form.index = 0;
  }

  @override
  FutureOr<Result<Product>> onCreate(
    SqliteCreateEvent<ProductCreateEvent> event,
    VariantProductParams param,
  ) async {
    final arg = event.arguments;
    if (arg == null) {
      return Result(
        exception: Error("Invaild Params"),
      );
    }
    //option/attributes
    /// {
    ///   option_name:"",
    ///   attribute_names:[{
    /// name:}]
    /// }
    // Map<int, SetOptionValueForm> formGroups;
    // 1. product,variants super.onCreate
    // 2. formGroups.values
    // 3. option_name -> option create
    // 4. option.id + attribute_names -> attribute create
    // 5. variant properites create

    final productCreateResult = await super.onCreate(event, param);

    if (productCreateResult.hasError) {
      return productCreateResult;
    }

    /// {
    ///   option_name:"",
    ///   attribute_names:[{
    /// name:}]
    /// }
    final optionAndAttributes = arg.getPayload();
    if (optionAndAttributes.hasError) {
      return Result(
        exception: optionAndAttributes.exception,
      );
    }
    final optionAttributes = optionAndAttributes.result!;

    if (optionAttributes.isEmpty) return productCreateResult;

    final productData = productCreateResult.result;
    final productID = productData!.id;

    final bulkCreatePayload = optionAttributes.map((payload) async {
      ///1. option create
      final optionResult = await useCase.optionRepo.create(
        OptionParam(
          productId: productID,
          name: payload['name'],
        ),
      );

      if (optionResult.hasError) {
        return Result<OptionAttributePair>(
          exception: Error("Failed to create option"),
        );
      }

      final optionID = optionResult.result!.id;
      //2. attribute create
      final attributeResult = await useCase.attributeRepo.bulkCreate(
          (payload['attributes'] as List).map((attribute) {
            return AttributeParam.create(
              name: attribute['name'],
              optionId: optionID,
            );
          }).toList(), (param) {
        return [
          FieldValidator(
            columnName: "$attributeTb.name",
            operationSign: "=",
            value: param.name,
          ),
          const AndOp(),
          FieldValidator(
            columnName: "$attributeTb.option_id",
            operationSign: "=",
            value: optionID.toString(),
          )
        ];
      });

      if (attributeResult.hasError) {
        return Result<OptionAttributePair>(
          exception: attributeResult.exception,
        );
      }
      return Result<OptionAttributePair>(
          result: OptionAttributePair(
        option: optionResult.result!,
        attribute: attributeResult.result!,
      ));
    });

    final bulkCreateResult = await Future.wait(bulkCreatePayload);

    if (bulkCreateResult.any((element) => element.hasError)) {
      final deleteResult = await useCase.productRepo.delete(productID);
      if (deleteResult.hasError) {
        return Result(
          exception: deleteResult.exception,
        );
      }
      return Result(
        exception: Error("Failed to create variant options and attributes"),
      );
    }

    /// 3
    /// [a,b,c] sku = ''  price = 100 h 1
    /// [b,a,c] sku = 'a' price = 100 h 2
    /// [c,a,b] sku = ''  price = 200 h 3

    ///variant properites
    // final uiKeys = variantUiAndFormIndexMapper.keys; // option-value index
    logger.i("Product: $variantUiAndFormIndexMapper");
    logger.i("Variant: ${arg.selectedVariants}");
    logger.i("SetOption: ${arg.formGroups}");

    for (final selectedVariantIndex in variantUiAndFormIndexMapper.keys) {
      final variantForm =
          form.varaints[variantUiAndFormIndexMapper[selectedVariantIndex]!];
      ///TODO
      /// find variant form
      /// find attribute
      /// variantForm == createdVariant and attribute index
    }

    return Result(exception: Error(productCreateResult.toString()));
  }

  CreateNewProductBloc(
    super.form,
    this.imagePicker,
    super.useCase,
  ) {
    on<CreateNewProductPickCoverPhotoEvent>(
      _createNewProductPickCoverPhotoEventListener,
    );
    on<CreateNewVariantProductPickCoverPhotoEvent>(
      _createNewVariantProductPickCoverPhotoEventListener,
    );
    on<CreateNewProductAvailabeToSellWhenOutOfStockEvent>(
      _createNewProductAvailableToSellWhenOutOfStockEventListener,
    );
    on<CreateNewProducCategorySelectEvent>(
      _createNewProductCategorySelectEvent,
    );
    on<CreateNewProductNewStockEvent>(_createNewProductNewStockEvent);

    on<CreateNewProductSetPriceEvent>((CreateNewProductSetPriceEvent event,
        Emitter<SqliteCreateBaseState> emit) {
      emit(CreateNewProductSetPriceState(index: event.index));
    });
  }

  FutureOr<void> _createNewProductNewStockEvent(
    CreateNewProductNewStockEvent _,
    Emitter<SqliteCreateBaseState> emit,
  ) {
    emit(CreateNewProductNewStockState());
  }

  FutureOr<void> _createNewProductCategorySelectEvent(
    CreateNewProducCategorySelectEvent event,
    Emitter<SqliteCreateBaseState> emit,
  ) {
    form.category.input = event.category;
    emit(CreateNewProductCategorySelectedState());
  }

  FutureOr<void> _createNewProductAvailableToSellWhenOutOfStockEventListener(
    CreateNewProductAvailabeToSellWhenOutOfStockEvent event,
    Emitter<SqliteCreateBaseState> emit,
  ) {
    form.availableToSellWhenOutOfStock.input = event.canSell;
    emit(CreateNewProductAvailableToSellWhenOutOfStockSelectedState());
  }

  Future<void> _createNewProductPickCoverPhotoEventListener(
    CreateNewProductPickCoverPhotoEvent _,
    Emitter<SqliteCreateBaseState> emit,
  ) async {
    form.coverPhoto.input =
        (await imagePicker.pickImage(source: ImageSource.gallery))?.path;
    if (form.coverPhoto.input != null) {
      emit(CreateNewProductCoverPhotoSelectedState());
    }
  }

  Future<void> _createNewVariantProductPickCoverPhotoEventListener(
    CreateNewVariantProductPickCoverPhotoEvent _,
    Emitter<SqliteCreateBaseState> emit,
  ) async {
    form.variantCoverPhoto.input =
        (await imagePicker.pickImage(source: ImageSource.gallery))?.path;
    if (form.variantCoverPhoto.input != null) {
      emit(CreateNewVariantProductCoverPhotoSelectedState());
    }
  }
}
