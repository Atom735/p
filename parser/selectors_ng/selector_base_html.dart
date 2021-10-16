import 'package:html/dom.dart';

import 'selector_base.dart';

export 'package:html/dom.dart';

export 'selector_base.dart';
export 'utils_html_query.dart';

mixin ParserHtmlSelectorMixin on ParserSelectorMixin {}
mixin ParserHtmlSelectorRootMixin
    on ParserSelectorRootMixin, ParserHtmlSelectorMixin {
  @override
  String get name => '[HTML] ROOT';
}
mixin ParserHtmlSelectorItemMixin
    on ParserSelectorItemMixin, ParserHtmlSelectorMixin {}
mixin ParserHtmlSelectorListMixin
    on ParserSelectorListMixin, ParserHtmlSelectorMixin {}

mixin ParserHtmlSelectorContextMixin on ParserSelectorContextMixin {
  @override
  ParserHtmlSelectorContextMixin get parent;

  /// Связанный с контекстом селектор
  @override
  ParserHtmlSelectorMixin get selector;

  /// Обрабатываемый элемент
  Element get el;
}
