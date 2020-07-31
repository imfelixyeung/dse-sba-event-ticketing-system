class WhatsAppAPI {
  static String generateLink(String text) {
    var encoded = Uri.encodeComponent(text);
    return 'https://wa.me/?text=$encoded';
  }
}
