import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/tickets/domain/entities/cinema_room.dart';
import 'package:mobx_cine/features/tickets/domain/entities/ticket.dart';
import 'package:mobx_cine/features/tickets/domain/repositories/ticket_repository.dart';

/// CASO DE USO: comprar ingresso. Valida as regras ANTES de chamar o repositório,
/// assim uma compra inválida nem chega a ser enviada.
class PurchaseTicketUseCase {
  const PurchaseTicketUseCase(this._repository);

  final TicketRepository _repository;

  Future<Ticket> call({
    required Movie movie,
    required String time,
    required List<String> seats,
  }) async {
    if (seats.isEmpty) {
      throw const AppException('Escolha pelo menos um assento.');
    }
    if (seats.length > CinemaRoom.maxSeatsPerPurchase) {
      throw AppException('Máximo de ${CinemaRoom.maxSeatsPerPurchase} assentos por compra.');
    }
    return _repository.purchase(movie: movie, time: time, seats: seats);
  }
}
