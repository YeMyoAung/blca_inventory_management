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
import 'package:inventory_management_with_sql/repo/variant_properties_repo/variant_property_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_create_new_product_use_case.dart';

class ProductCreateEvent extends NullObject {
  final Result<List<Map<String, dynamic>>> Function() getPayload;
  final Map<int, SetOptionValueForm> formGroups;
  final List<List<Map<dynamic, dynamic>>> variants;
  const ProductCreateEvent({
    required this.formGroups,
    required this.getPayload,
    required this.variants,
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

class CreateNewProductBloc extends SqliteExecuteBloc<
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

  void mapUiAndForm(
    int index,
    String propertiesString,
  ) {
    final int formIndex = form.varaints.indexWhere((element) {
      return propertiesString == element.propertiesString;
    });

    variantUiAndFormIndexMapper[index] = formIndex;
  }

  void addVariant(int index, [CreateNewVariantForm? variantForm]) {
    logger.w(
        "Form Length: ${form.varaints.map((e) => e.price.input?.text)}, Index: $index ${variantUiAndFormIndexMapper.length} ${variantUiAndFormIndexMapper.keys} ${variantUiAndFormIndexMapper.values}");

    /// single product (variant)= [singleProductFrom]
    /// variant[0] is singleProduct => singleProduct store
    /// varint (1) length=>1,index => 0
    /// index 0 exist => 1
    final leftMostV = form.varaints[0];
    if (!leftMostV.isVariant) {
      ///origin
      singleProductForm = leftMostV;
      form.varaints.clear();
    }
    // final afterAddingIndex = form.varaints.length; //(1)
    form.varaints.add(variantForm ??
        CreateNewVariantForm.form(
          isVariant: true,
        )); //length 2,(1,2) ,(0,1)

    variantUiAndFormIndexMapper[index] = form.varaints.length - 1;
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
    if (form.varaints.isEmpty) return;
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
  FutureOr<Result<Product>> onExecute(
    SqliteExecuteEvent<ProductCreateEvent> event,
    VariantProductParams param, [
    int? id,
  ]) async {
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

    final productCreateResult = await super.onExecute(event, param);

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
    logger.i("Variant: ${arg.variants}");

    final visitedVariantIDs = <int>[];

    final List<Future<Result<List<VariantProperty>>>> variantPropertiesPayload =
        [];

    for (final selectedVariantIndex in variantUiAndFormIndexMapper.keys) {
      final formValue =
          form.varaints[variantUiAndFormIndexMapper[selectedVariantIndex]!];

      final optionAttributeValue = arg.variants[selectedVariantIndex];

      final matchVariant = productData.variants.firstWhere(
        (element) {
          final fPrice =
              double.tryParse(formValue.price.input?.text ?? "") ?? 0.0;
          final fAva =
              double.tryParse(formValue.available.input?.text ?? "") ?? 0.0;
          final fOnHand =
              double.tryParse(formValue.onHand.input?.text ?? '') ?? 0.0;
          final fDamage =
              double.tryParse(formValue.damage.input?.text ?? "") ?? 0.0;
          final fLost =
              double.tryParse(formValue.lost.input?.text ?? "") ?? 0.0;
          final fCoverPhoto = formValue.coverPhoto.input ?? "";
          final fAllow = formValue.allowPurchaseWhenOutOfStock.input ?? false;
          final fSku = formValue.sku.input?.text ?? '';

          logger.i(
              "Form: $fPrice=${element.price} $fAva=${element.available} $fOnHand=${element.onHand} $fDamage=${element.damage} $fLost=${element.lost} $fCoverPhoto=${element.coverPhoto} $fAllow=${element.allowPurchaseWhenOutOfStock} $fSku=${element.sku}");

          return element.price == fPrice &&
              element.sku == fSku &&
              element.available == fAva &&
              element.onHand == fOnHand &&
              element.damage == fDamage &&
              element.lost == fLost &&
              element.allowPurchaseWhenOutOfStock == fAllow &&
              element.coverPhoto == fCoverPhoto &&
              !visitedVariantIDs.contains(element.id);
        },
        orElse: () => Variant(
          id: -1,
          productID: -1,
          coverPhoto: '',
          sku: '',
          price: 0,
          available: 0,
          damage: 0,
          onHand: 0,
          lost: 0,
          allowPurchaseWhenOutOfStock: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          properties: [],
        ),
      );

      logger.i("Match $matchVariant");

      if (matchVariant.id == -1) {
        continue;
      }

      visitedVariantIDs.add(matchVariant.id);

      final List<Attribute> matchProperties = [];

      for (final setdata in optionAttributeValue) {
        final opName = setdata['option'];
        final attName = setdata['name'];

        matchProperties.addAll(bulkCreateResult.where((element) {
          return element.result?.option.name == opName;
        }).fold<List<Attribute>>([], (p, c) {
          p.addAll(c.result?.attribute ?? []);
          return p;
        }).where((element) => element.name == attName));
      }

      logger.i("Match Variant: $matchVariant");
      logger.i("Match Properties: $matchProperties");

      final variantPropertiesBulk = useCase.variantPropertyRepo.bulkCreate(
        matchProperties.map((e) {
          return VariantPropertyParam(
            variantId: matchVariant.id,
            valueId: e.id,
          );
        }).toList(),
        (param) {
          return [
            FieldValidator(
              columnName: "variant_id",
              operationSign: "=",
              value: param.variantId.toString(),
            ),
            const AndOp(),
            FieldValidator(
              columnName: "value_id",
              operationSign: "=",
              value: param.valueId.toString(),
            ),
          ];
        },
      );

      variantPropertiesPayload.add(variantPropertiesBulk);
    }

    final variantPropertiesResult = await Future.wait(variantPropertiesPayload);

    final variantPropertiesErr =
        variantPropertiesResult.where((element) => element.hasError);

    if (variantPropertiesErr.isNotEmpty) {
      return Result(exception: variantPropertiesErr.elementAt(0).exception);
    }

    for (int i = 0; i < variantPropertiesResult.length; i++) {
      productData.variants[i].properties.addAll(
        variantPropertiesResult[i].result ?? [],
      );
    }

    return Result(
      result: productData,
    );
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
        Emitter<SqliteExecuteBaseState> emit) {
      emit(CreateNewProductSetPriceState(index: event.index));
    });
  }

  FutureOr<void> _createNewProductNewStockEvent(
    CreateNewProductNewStockEvent _,
    Emitter<SqliteExecuteBaseState> emit,
  ) {
    emit(CreateNewProductNewStockState());
  }

  FutureOr<void> _createNewProductCategorySelectEvent(
    CreateNewProducCategorySelectEvent event,
    Emitter<SqliteExecuteBaseState> emit,
  ) {
    form.category.input = event.category;
    emit(CreateNewProductCategorySelectedState());
  }

  FutureOr<void> _createNewProductAvailableToSellWhenOutOfStockEventListener(
    CreateNewProductAvailabeToSellWhenOutOfStockEvent event,
    Emitter<SqliteExecuteBaseState> emit,
  ) {
    form.availableToSellWhenOutOfStock.input = event.canSell;
    emit(CreateNewProductAvailableToSellWhenOutOfStockSelectedState());
  }

  Future<void> _createNewProductPickCoverPhotoEventListener(
    CreateNewProductPickCoverPhotoEvent _,
    Emitter<SqliteExecuteBaseState> emit,
  ) async {
    form.coverPhoto.input =
        (await imagePicker.pickImage(source: ImageSource.gallery))?.path;
    if (form.coverPhoto.input != null) {
      emit(CreateNewProductCoverPhotoSelectedState());
    }
  }

  Future<void> _createNewVariantProductPickCoverPhotoEventListener(
    CreateNewVariantProductPickCoverPhotoEvent _,
    Emitter<SqliteExecuteBaseState> emit,
  ) async {
    form.variantCoverPhoto.input =
        (await imagePicker.pickImage(source: ImageSource.gallery))?.path;
    if (form.variantCoverPhoto.input != null) {
      emit(CreateNewVariantProductCoverPhotoSelectedState());
    }
  }
}
