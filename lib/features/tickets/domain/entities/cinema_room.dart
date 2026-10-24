class CinemaRoom {
  static const rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  static const seatsPerRow = 10;
  static const ticketPrice = 32.0;
  static const maxSeatsPerPurchase = 6;
  static const showtimes = ['14:00', '16:30', '19:00', '21:30'];

  /// ['A1', 'A2', ..., 'H10']
  static List<String> get allSeatIds => [
        for (final row in rows)
          for (var number = 1; number <= seatsPerRow; number++) '$row$number',
      ];
}
