/// Nomes das rotas (telas) do app.
/// Usar constantes evita erro de digitação: em vez de '/home' escrito à mão, usamos AppRoutes.home.
/// Quem liga cada nome à sua tela é o AppRouter.
class AppRoutes {
  static const splash = '/'; // tela inicial: decide se vai para login ou home
  static const login = '/login';
  static const register = '/register';
  static const home = '/home'; // lista de filmes
  static const details = '/details'; // detalhes de um filme
  static const seats = '/seats'; // escolha de horário e assentos
  static const result = '/result'; // resultado da compra (sucesso ou erro)
}
