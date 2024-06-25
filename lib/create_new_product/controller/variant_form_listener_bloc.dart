import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';

class VariantFormState extends BlocBaseState {
  // add - true
  // remove - false
  final bool? isAdded;
  final String? propertiesString;
  final int index;
  VariantFormState({
    this.isAdded,
    this.index = -1,
    this.propertiesString,
  });
}

class VariantFormListenerBloc extends Cubit<VariantFormState> {
  VariantFormListenerBloc() : super(VariantFormState());

  void addVariant(int index, String propertiesString) {
    emit(VariantFormState(
      isAdded: true,
      index: index,
      propertiesString: propertiesString,
    ));
  }

  void removeVariant(int index) {
    emit(VariantFormState(isAdded: false, index: index));
  }
}
