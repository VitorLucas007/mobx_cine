/// Configurações fixas do app (endereços da API e a chave).
class AppConfig {
  // A chave NÃO fica no código. Ela entra na hora de rodar o app:
  //   flutter run --dart-define=TMDB_API_KEY=xxxx
  // O texto dentro de fromEnvironment é o NOME da variável, não o valor da chave.
  // Se a variável não for passada, o resultado é uma string vazia ('').
  static const tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

  // Endereço base de todas as chamadas à API do TMDB
  static const tmdbBaseUrl = 'https://api.themoviedb.org/3';

  // Endereço base das imagens. "w500" = imagem com 500px de largura.
  // O TMDB só devolve o final do caminho (ex.: /abc.jpg), então juntamos os dois.
  static const tmdbImageUrl = 'https://image.tmdb.org/t/p/w500';
}
