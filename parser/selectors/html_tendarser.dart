import 'package:client/log.dart';
import 'package:html/parser.dart';

import 'html_base.dart';
import 'tendarser.dart';

class HtmlSelectorRootTendarser extends HtmlSelectorRoot
    with SelectorTendersRoot {
  HtmlSelectorRootTendarser(Map json, ParserParams params)
      : super(json, params);

  @override
  SelectorItem itemFactory(Selector parent, Map json, String key) =>
      HtmlSelectorItem(parent, json);

  @override
  SelectorBlock blockFactory(Selector parent, Map json, String key) {
    switch (key) {
      case '=pages':
        return HtmlSelectorBlockTendarserPages(parent, json);
      case '=tenders':
        return HtmlSelectorBlockTendarserTenders(parent, json);
      default:
        return super.blockFactory(parent, json, key);
    }
  }

  @override
  Future<ParsedData> resolveRoot(
    FetchedData fetched, [
    Logger? logger,
  ]) async {
    final stopwatch = Stopwatch();
    stopwatch.start();
    final page = fetched.page;
    final ctx = HtmlContext(
      label: 'Parser(${params.parser_uid}).$page',
      values: {
        r'*fetched': fetched,
        r'*url': params.getUri(page).toString(),
        r'*page': page.toString(),
      },
      logger: LoggerPrefix('[HTML] Parser(${params.parser_uid}).$page', logger),
    );
    ctx.el = parse(fetched.data).body!;
    return (resolveTendarser(ctx, fetched, stopwatch));
  }
}

class HtmlSelectorBlockTendarserPages extends HtmlSelectorBlock
    with SelectorPagesBlock {
  HtmlSelectorBlockTendarserPages(Selector parent, Map json)
      : super(parent, json);
}

class HtmlSelectorBlockTendarserTenders extends HtmlSelectorBlock
    with SelectorTendersBlock {
  HtmlSelectorBlockTendarserTenders(Selector parent, Map json)
      : super(parent, json);

  @override
  SelectorItem itemFactory(Selector parent, Map json, [String? key]) =>
      HtmlSelectorItemTendarserTenders(parent, json);
}

class HtmlSelectorItemTendarserTenders extends HtmlSelectorItem
    with SelectorTenderItem {
  HtmlSelectorItemTendarserTenders(Selector parent, Map json)
      : super(parent, {...json, 'text': '#'});

  @override
  SelectorItem itemFactory(Selector parent, Map json, String key) {
    switch (key) {
      case '=link':
        return HtmlSelectorItemTendarserLink(parent, json);
    }
    return super.itemFactory(parent, json, key);
  }
}

class HtmlSelectorItemTendarserLink extends HtmlSelectorItem {
  HtmlSelectorItemTendarserLink(Selector parent, Map json)
      : super(parent, json);

  @override
  Future<Object?> resolveMod(String key, Object? data) async {
    if (key.isEmpty) {
      return (root as HtmlSelectorRootTendarser)
          .params
          .resolveLink((data as HtmlContext?)?.value?.toString() ?? '');
    }
    return super.resolveMod(key, data);
  }
}
