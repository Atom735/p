import 'selector_base_html.dart';

class ParserTendersHtmlSelectorRoot
    with
        ParserSelectorMixin,
        ParserSelectorItemMixin,
        ParserSelectorRootMixin,
        ParserHtmlSelectorMixin,
        ParserHtmlSelectorRootMixin {
  @override
  String get attr => throw UnimplementedError();

  @override
  void createSelectorItem(Map json, String key) {}

  @override
  void createSelectorList(Map json, String key) => throw UnimplementedError();

  @override
  bool get opt => throw UnimplementedError();

  @override
  String get regexp => throw UnimplementedError();

  @override
  RegExp? get regexp_ => throw UnimplementedError();

  @override
  String get selector => throw UnimplementedError();

  @override
  String get text => throw UnimplementedError();

  @override
  String get type => throw UnimplementedError();

  @override
  String get value => throw UnimplementedError();

  @override
  final HashSet<ParserHtmlSelectorMixin> childrens =
      HashSet<ParserHtmlSelectorMixin>();
}
