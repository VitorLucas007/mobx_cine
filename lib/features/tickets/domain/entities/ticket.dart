/// ENTIDADE: um ingresso comprado.
/// Guarda o título e o pôster do filme (não só o id) para mostrar o ingresso sem buscar nada de novo.
class Ticket {
  const Ticket({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.posterUrl,
    required this.time,
    required this.seats,
    required this.total,
    required this.purchasedAt,
  });

  final String id;
  final int movieId;
  final String movieTitle;
  final String? posterUrl;
  final String time; // horário da sessão, ex.: '19:00'
  final List<String> seats; // ex.: ['A1', 'A2']
  final double total; // valor pago
  final DateTime purchasedAt;
}
