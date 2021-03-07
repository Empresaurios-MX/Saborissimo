class ValidationUtils {
  static String validateEmpty(String text) {
    if (text.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
}
