import 'package:mobx_cine/features/tickets/domain/entities/ticket.dart';

class TicketModel extends Ticket {
  const TicketModel({
    required super.id,
    required super.movieId,
    required super.movieTitle,
    required super.posterUrl,
    required super.time,
    required super.seats,
    required super.total,
    required super.purchasedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        id: json['id'] as String,
        movieId: json['movieId'] as int,
        movieTitle: json['movieTitle'] as String,
        posterUrl: json['posterUrl'] as String?,
        time: json['time'] as String,
        seats: (json['seats'] as List).cast<String>(),
        total: (json['total'] as num).toDouble(),
        purchasedAt: DateTime.parse(json['purchasedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'movieId': movieId,
        'movieTitle': movieTitle,
        'posterUrl': posterUrl,
        'time': time,
        'seats': seats,
        'total': total,
        'purchasedAt': purchasedAt.toIso8601String(),
      };
}
