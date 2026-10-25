import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/core/utils/view_state.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/tickets/domain/entities/cinema_room.dart';
import 'package:mobx_cine/features/tickets/domain/entities/seat_status.dart';
import 'package:mobx_cine/features/tickets/domain/entities/ticket.dart';
import 'package:mobx_cine/features/tickets/domain/usecases/get_occupied_seats_usecase.dart';
import 'package:mobx_cine/features/tickets/domain/usecases/purchase_ticket_usecase.dart';
import 'package:mobx/mobx.dart';

part 'seat_selection_store.g.dart';

/// STORE da tela de assentos: horário escolhido, assentos ocupados/selecionados,
/// total a pagar e a compra. Recebe o filme no construtor (veja o registro no injection.dart).
class SeatSelectionStore = _SeatSelectionStoreBase with _$SeatSelectionStore;

abstract class _SeatSelectionStoreBase with Store {
  _SeatSelectionStoreBase(this.movie, this._getOccupiedSeats, this._purchaseTicket);

  final Movie movie;
  final GetOccupiedSeatsUseCase _getOccupiedSeats;
  final PurchaseTicketUseCase _purchaseTicket;

  // ───────── Estado ─────────
  @observable
  String selectedTime = CinemaRoom.showtimes.first;

  @observable
  ViewState seatsState = ViewState.initial;

  @observable
  String? seatsError;

  @observable
  bool isPurchasing = false;

  @observable
  String? purchaseError;

  @observable
  Ticket? purchasedTicket;

  /// Mensagem de aviso rápido (a tela mostra num SnackBar via reaction)
  @observable
  String? warning;

  // Coleções observáveis (add/remove são percebidos pelo MobX)
  final ObservableSet<String> occupiedSeats = ObservableSet<String>();
  final ObservableSet<String> selectedSeats = ObservableSet<String>();

  // ───────── Derivados ─────────

  /// Assentos escolhidos em ordem natural: A2 vem antes de A10.
  @computed
  List<String> get sortedSeats {
    final list = selectedSeats.toList();
    list.sort((a, b) {
      final byRow = a[0].compareTo(b[0]);
      return byRow != 0 ? byRow : int.parse(a.substring(1)).compareTo(int.parse(b.substring(1)));
    });
    return list;
  }

  @computed
  double get total => selectedSeats.length * CinemaRoom.ticketPrice;

  @computed
  bool get canBuy =>
      selectedSeats.isNotEmpty && !isPurchasing && seatsState == ViewState.success;

  // ───────── Consulta (não é @computed porque recebe parâmetro) ─────────
  SeatStatus statusOf(String seatId) {
    if (occupiedSeats.contains(seatId)) return SeatStatus.occupied;
    if (selectedSeats.contains(seatId)) return SeatStatus.selected;
    return SeatStatus.free;
  }

  // ───────── Ações ─────────
  @action
  Future<void> loadOccupiedSeats() async {
    final requestedTime = selectedTime;
    seatsState = ViewState.loading;
    seatsError = null;
    try {
      final result = await _getOccupiedSeats(movieId: movie.id, time: requestedTime);

      // O usuário trocou de horário enquanto carregava? Ignora a resposta velha.
      if (requestedTime != selectedTime) return;

      occupiedSeats
        ..clear()
        ..addAll(result);
      seatsState = ViewState.success;
    } on AppException catch (e) {
      seatsError = e.message;
      seatsState = ViewState.error;
    } catch (_) {
      seatsError = 'Não foi possível carregar os assentos.';
      seatsState = ViewState.error;
    }
  }

  @action
  Future<void> selectTime(String time) async {
    if (time == selectedTime) return;
    selectedTime = time;
    selectedSeats.clear(); // assentos de outro horário não valem mais
    await loadOccupiedSeats();
  }

  @action
  void toggleSeat(String seatId) {
    if (isPurchasing || occupiedSeats.contains(seatId)) return;

    if (selectedSeats.contains(seatId)) {
      selectedSeats.remove(seatId);
      return;
    }
    if (selectedSeats.length >= CinemaRoom.maxSeatsPerPurchase) {
      warning = 'Você pode escolher no máximo ${CinemaRoom.maxSeatsPerPurchase} assentos.';
      return;
    }
    selectedSeats.add(seatId);
  }

  @action
  void clearWarning() => warning = null;

  /// Retorna true se a compra deu certo.
  @action
  Future<bool> purchase() async {
    if (!canBuy) return false;

    isPurchasing = true;
    purchaseError = null;
    try {
      purchasedTicket = await _purchaseTicket(
        movie: movie,
        time: selectedTime,
        seats: sortedSeats,
      );
      return true;
    } on AppException catch (e) {
      purchaseError = e.message;
      return false;
    } catch (_) {
      purchaseError = 'Não foi possível concluir a compra.';
      return false;
    } finally {
      isPurchasing = false;
    }
  }
}
