/// ENTIDADE: representa um filme para o app inteiro.
/// É uma classe simples, sem nada de JSON ou API. Quem converte o JSON do TMDB nela é o MovieModel.
class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.rating,
    required this.releaseDate,
  });

  final int id;
  final String title;
  final String overview; // sinopse
  final String? posterUrl; // pode não ter pôster
  final double rating; // nota de 0 a 10
  final String releaseDate;
}
