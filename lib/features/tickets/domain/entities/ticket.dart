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
  final String time;
  final List<String> seats;
  final double total;
  final DateTime purchasedAt;
}
