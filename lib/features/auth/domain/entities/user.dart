/// ENTIDADE: o usuário logado.
/// Não tem senha de propósito: a tela nunca precisa dela depois do login.
class User {
  const User({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;
}
