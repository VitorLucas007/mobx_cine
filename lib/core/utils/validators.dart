/// Retornam null se estiver OK, ou a mensagem de erro.
/// Servem tanto para os campos do formulário quanto para os casos de uso.
class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().length < 2) return 'Informe seu nome';
    return null;
  }

  static String? email(String? value) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (value == null || !regex.hasMatch(value.trim())) return 'E-mail inválido';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }
}
