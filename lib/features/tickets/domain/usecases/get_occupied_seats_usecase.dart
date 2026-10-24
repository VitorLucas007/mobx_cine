import 'package:mobx_cine/features/tickets/domain/repositories/ticket_repository.dart';

class GetOccupiedSeatsUseCase {
  const GetOccupiedSeatsUseCase(this._repository);

  final TicketRepository _repository;

  Future<Set<String>> call({required int movieId, required String time}) =>
      _repository.getOccupiedSeats(movieId: movieId, time: time);
}
