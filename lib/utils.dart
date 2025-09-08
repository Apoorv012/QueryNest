String cleanText(String text) {
  // remove non-printable / weird Unicode characters
  return text.replaceAll(RegExp(r'[^\x20-\x7E]'), '');
}