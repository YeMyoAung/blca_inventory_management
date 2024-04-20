import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_repo.dart';
import 'package:inventory_management_with_sql/shop/controller/shop_list_event.dart';
import 'package:inventory_management_with_sql/shop/controller/shop_list_state.dart';

class ShopListBloc extends Bloc<ShopListEvent, ShopListState> {
  StreamSubscription? onChangeSubscription;

  int currentOffset = 0;

  final ShopRepo shop;
  ShopListBloc(
    super.initialState,
    this.shop,
  ) {
    onChangeSubscription = shop.onChange.listen((event) {
      if (event.operation is CreateOperation) {
        add(ShopListCreatedEvent(event.model));
        return;
      }
      if (event.operation is UpdateOperation) {
        add(ShopListUpdatedEvent(event.model));
        return;
      }
      add(ShopListDeletedEvent(event.model));
    });

    ///Get Event
    on<ShopListGetEvent>((_, emit) async {
      final list = state.list.toList();
      if (list.isEmpty) {
        emit(ShopListLoadingState(list));
      } else {
        emit(ShopListSoftLoadingState(list));
      }
      final incomingList = await shop.findModels(offset: currentOffset);
      list.addAll(incomingList);

      emit(ShopListReceiveState(list));
    });

    ///Create Event
    on<ShopListCreatedEvent>((event, emit) {
      final list = state.list.toList();

      list.add(event.shop);
      emit(ShopListReceiveState(list));
    });

    ///Update Event
    on<ShopListUpdatedEvent>((event, emit) {
      final list = state.list.toList();
      final index = list.indexOf(event.shop);
      list[index] = event.shop;
      emit(ShopListReceiveState(list));
    });

    ///Delete Event
    on<ShopListDeletedEvent>((event, emit) {
      final list = state.list.toList();
      list.remove(event.shop);
      emit(ShopListReceiveState(list));
    });
  }

  @override
  Future<void> close() async {
    await onChangeSubscription?.cancel();
    return super.close();
  }
}
