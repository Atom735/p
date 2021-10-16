mixin ParserHandleMixin {
  /// Уникальный ключ парсера
  String get parser_uid;

  String get uid => '$runtimeType.$parser_uid';

  ParserHandle get parser_handle => ParserHandle(parser_uid);

  @override
  int get hashCode => parser_uid.hashCode;
  @override
  bool operator ==(covariant ParserHandleMixin other) =>
      parser_uid == other.parser_uid;
  @override
  String toString() => uid;
}

class ParserHandle with ParserHandleMixin {
  @override
  final String parser_uid;

  ParserHandle(this.parser_uid);
}
