import 'dart:math';

import 'package:mobx_cine/core/errors/app_exception.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/tickets/data/datasources/ticket_local_datasource.dart';
import 'package:mobx_cine/features/tickets/data/models/ticket_model.dart';
import 'package:mobx_cine/features/tickets/domain/entities/cinema_room.dart';
import 'package:mobx_cine/features/tickets/domain/entities/ticket.dart';
import 'package:mobx_cine/features/tickets/domain/repositories/ticket_repository.dart';

/// Simula um "servidor de ingressos": assentos vendidos, pagamento e erros.
/// Tudo é de mentirinha, mas se comporta como uma API real (demora e pode falhar).
class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl(this._local);

  final TicketLocalDataSource _local;
  final _random = Random();

  /// Chance (0 a 1) de "pagamento recusado". Coloque 0 para nunca falhar.
  static const _simulatedFailureRate = 0.15;

  @override
  Future<Set<String>> getOccupiedSeats({required int movieId, required String time}) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simula a rede
    return _occupiedSeats(movieId, time);
  }

  Set<String> _occupiedSeats(int movieId, String time) {
    // Assentos "já vendidos" de mentirinha, mas sempre iguais para o mesmo filme+horário.
    // Truque: o "seed" (semente) é um número calculado a partir do filme e do horário.
    // Um Random com a mesma semente sempre sorteia a mesma sequência, então o resultado se repete.
    final seed = (movieId * 31 + time.codeUnits.fold<int>(0, (a, b) => (a * 31 + b) % 100000)) % 100000;
    final fake = Random(seed);
    final occupied = <String>{
      for (final id in CinemaRoom.allSeatIds)
        if (fake.nextDouble() < 0.25) id, // cada assento tem 25% de chance de estar ocupado
    };

    // + os assentos que o próprio usuário já comprou
    for (final ticket in _local.getAll()) {
      if (ticket.movieId == movieId && ticket.time == time) {
        occupied.addAll(ticket.seats);
      }
    }
    return occupied;
  }

  @override
  Future<Ticket> purchase({
    required Movie movie,
    required String time,
    required List<String> seats,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200)); // "processando pagamento"

    if (_random.nextDouble() < _simulatedFailureRate) {
      throw const AppException('Pagamento recusado. Tente novamente.');
    }

    // Confere de novo na hora de pagar: alguém pode ter pegado o assento enquanto você decidia
    final occupied = _occupiedSeats(movie.id, time);
    final taken = seats.where(occupied.contains).toList();
    if (taken.isNotEmpty) {
      throw AppException('Os assentos ${taken.join(', ')} acabaram de ser ocupados.');
    }

    final ticket = TicketModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      movieId: movie.id,
      movieTitle: movie.title,
      posterUrl: movie.posterUrl,
      time: time,
      seats: seats,
      total: seats.length * CinemaRoom.ticketPrice,
      purchasedAt: DateTime.now(),
    );
    await _local.save(ticket);
    return ticket;
  }
}
