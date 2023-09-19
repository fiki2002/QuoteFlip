class QuoteModel {
  final String id;
  final String content;
  final String author;
  QuoteModel({
    required this.id,
    required this.content,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    final id = json["_id"];
    if (id is! String) {
      throw FormatException(
          'Invalid JSON: required "id" field of type String in $json');
    }

    final content = json["content"];
    if (content is! String) {
      throw FormatException(
          'Invalid JSON: required "content" field of type String in $json');
    }

    final author = json["author"];
    if (author is! String) {
      throw FormatException(
          'Invalid JSON: required "author" field of type String in $json');
    }
    return QuoteModel(
      id: id,
      content: content,
      author: author,
    );
  }
}
