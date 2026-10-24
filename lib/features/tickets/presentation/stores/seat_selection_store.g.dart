// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_selection_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SeatSelectionStore on _SeatSelectionStoreBase, Store {
  Computed<List<String>>? _$sortedSeatsComputed;

  @override
  List<String> get sortedSeats =>
      (_$sortedSeatsComputed ??= Computed<List<String>>(
        () => super.sortedSeats,
        name: '_SeatSelectionStoreBase.sortedSeats',
      )).value;
  Computed<double>? _$totalComputed;

  @override
  double get total => (_$totalComputed ??= Computed<double>(
    () => super.total,
    name: '_SeatSelectionStoreBase.total',
  )).value;
  Computed<bool>? _$canBuyComputed;

  @override
  bool get canBuy => (_$canBuyComputed ??= Computed<bool>(
    () => super.canBuy,
    name: '_SeatSelectionStoreBase.canBuy',
  )).value;

  late final _$selectedTimeAtom = Atom(
    name: '_SeatSelectionStoreBase.selectedTime',
    context: context,
  );

  @override
  String get selectedTime {
    _$selectedTimeAtom.reportRead();
    return super.selectedTime;
  }

  @override
  set selectedTime(String value) {
    _$selectedTimeAtom.reportWrite(value, super.selectedTime, () {
      super.selectedTime = value;
    });
  }

  late final _$seatsStateAtom = Atom(
    name: '_SeatSelectionStoreBase.seatsState',
    context: context,
  );

  @override
  ViewState get seatsState {
    _$seatsStateAtom.reportRead();
    return super.seatsState;
  }

  @override
  set seatsState(ViewState value) {
    _$seatsStateAtom.reportWrite(value, super.seatsState, () {
      super.seatsState = value;
    });
  }

  late final _$seatsErrorAtom = Atom(
    name: '_SeatSelectionStoreBase.seatsError',
    context: context,
  );

  @override
  String? get seatsError {
    _$seatsErrorAtom.reportRead();
    return super.seatsError;
  }

  @override
  set seatsError(String? value) {
    _$seatsErrorAtom.reportWrite(value, super.seatsError, () {
      super.seatsError = value;
    });
  }

  late final _$isPurchasingAtom = Atom(
    name: '_SeatSelectionStoreBase.isPurchasing',
    context: context,
  );

  @override
  bool get isPurchasing {
    _$isPurchasingAtom.reportRead();
    return super.isPurchasing;
  }

  @override
  set isPurchasing(bool value) {
    _$isPurchasingAtom.reportWrite(value, super.isPurchasing, () {
      super.isPurchasing = value;
    });
  }

  late final _$purchaseErrorAtom = Atom(
    name: '_SeatSelectionStoreBase.purchaseError',
    context: context,
  );

  @override
  String? get purchaseError {
    _$purchaseErrorAtom.reportRead();
    return super.purchaseError;
  }

  @override
  set purchaseError(String? value) {
    _$purchaseErrorAtom.reportWrite(value, super.purchaseError, () {
      super.purchaseError = value;
    });
  }

  late final _$purchasedTicketAtom = Atom(
    name: '_SeatSelectionStoreBase.purchasedTicket',
    context: context,
  );

  @override
  Ticket? get purchasedTicket {
    _$purchasedTicketAtom.reportRead();
    return super.purchasedTicket;
  }

  @override
  set purchasedTicket(Ticket? value) {
    _$purchasedTicketAtom.reportWrite(value, super.purchasedTicket, () {
      super.purchasedTicket = value;
    });
  }

  late final _$warningAtom = Atom(
    name: '_SeatSelectionStoreBase.warning',
    context: context,
  );

  @override
  String? get warning {
    _$warningAtom.reportRead();
    return super.warning;
  }

  @override
  set warning(String? value) {
    _$warningAtom.reportWrite(value, super.warning, () {
      super.warning = value;
    });
  }

  late final _$loadOccupiedSeatsAsyncAction = AsyncAction(
    '_SeatSelectionStoreBase.loadOccupiedSeats',
    context: context,
  );

  @override
  Future<void> loadOccupiedSeats() {
    return _$loadOccupiedSeatsAsyncAction.run(() => super.loadOccupiedSeats());
  }

  late final _$selectTimeAsyncAction = AsyncAction(
    '_SeatSelectionStoreBase.selectTime',
    context: context,
  );

  @override
  Future<void> selectTime(String time) {
    return _$selectTimeAsyncAction.run(() => super.selectTime(time));
  }

  late final _$purchaseAsyncAction = AsyncAction(
    '_SeatSelectionStoreBase.purchase',
    context: context,
  );

  @override
  Future<bool> purchase() {
    return _$purchaseAsyncAction.run(() => super.purchase());
  }

  late final _$_SeatSelectionStoreBaseActionController = ActionController(
    name: '_SeatSelectionStoreBase',
    context: context,
  );

  @override
  void toggleSeat(String seatId) {
    final _$actionInfo = _$_SeatSelectionStoreBaseActionController.startAction(
      name: '_SeatSelectionStoreBase.toggleSeat',
    );
    try {
      return super.toggleSeat(seatId);
    } finally {
      _$_SeatSelectionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearWarning() {
    final _$actionInfo = _$_SeatSelectionStoreBaseActionController.startAction(
      name: '_SeatSelectionStoreBase.clearWarning',
    );
    try {
      return super.clearWarning();
    } finally {
      _$_SeatSelectionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedTime: ${selectedTime},
seatsState: ${seatsState},
seatsError: ${seatsError},
isPurchasing: ${isPurchasing},
purchaseError: ${purchaseError},
purchasedTicket: ${purchasedTicket},
warning: ${warning},
sortedSeats: ${sortedSeats},
total: ${total},
canBuy: ${canBuy}
    ''';
  }
}
