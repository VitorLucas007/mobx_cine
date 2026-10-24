import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/tickets/domain/entities/ticket.dart';

abstract class TicketRepository {
  /// IDs das cadeiras já ocupadas naquele filme e horário.
  Future<Set<String>> getOccupiedSeats({required int movieId, required String time});

  Future<Ticket> purchase({
    required Movie movie,
    required String time,
    required List<String> seats,
  });
}
