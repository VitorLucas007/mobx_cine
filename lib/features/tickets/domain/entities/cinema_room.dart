/// As regras fixas da sala de cinema. Para mudar o tamanho da sala, o preço ou os horários,
/// basta alterar aqui: telas e stores usam estes valores.
class CinemaRoom {
  static const rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']; // 8 fileiras
  static const seatsPerRow = 10; // 8 × 10 = 80 assentos
  static const ticketPrice = 32.0; // preço de cada ingresso
  static const maxSeatsPerPurchase = 6; // limite por compra
  static const showtimes = ['14:00', '16:30', '19:00', '21:30'];

  /// Lista com o id de todos os assentos: ['A1', 'A2', ..., 'H10']
  /// (o id é a letra da fileira + o número do assento)
  static List<String> get allSeatIds => [
        for (final row in rows)
          for (var number = 1; number <= seatsPerRow; number++) '$row$number',
      ];
}
