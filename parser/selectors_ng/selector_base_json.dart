import 'selector_base.dart';

mixin ParserJsonSelectorMixin on ParserSelectorMixin {}
mixin ParserJsonSelectorRootMixin
    on ParserSelectorRootMixin, ParserJsonSelectorMixin {}
mixin ParserJsonSelectorItemMixin
    on ParserSelectorItemMixin, ParserJsonSelectorMixin {}
mixin ParserJsonSelectorListMixin
    on ParserSelectorListMixin, ParserJsonSelectorMixin {}

mixin ParserJsonSelectorContextMixin on ParserSelectorContextMixin {
  @override
  ParserJsonSelectorContextMixin get parent;

  /// Связанный с контекстом селектор
  @override
  ParserJsonSelectorMixin get selector;
}
