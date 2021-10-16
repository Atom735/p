import 'dart:convert';

import 'package:client/log.dart';

import 'json_base.dart';
import 'tendarser.dart';

class JsonSelectorRootTendarser extends JsonSelectorRoot
    with SelectorTendersRoot {
  JsonSelectorRootTendarser(Map json, ParserParams params)
      : super(json, params);

  @override
  SelectorItem itemFactory(Selector parent, Map json, String key) =>
      JsonSelectorItem(parent, json);

  @override
  SelectorBlock blockFactory(Selector parent, Map json, String key) {
    switch (key) {
      case '=pages':
        return JsonSelectorBlockTendarserPages(parent, json);
      case '=tenders':
        return JsonSelectorBlockTendarserTenders(parent, json);
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
    final ctx = JsonContext(
      label: 'Parser(${params.parser_uid}).$page',
      values: {
        r'*fetched': fetched,
        r'*url': params.getUri(page).toString(),
        r'*page': page.toString(),
      },
      logger: LoggerPrefix('[JSON] Parser(${params.parser_uid}).$page', logger),
    );
    ctx.el = jsonDecode(fetched.data);
    return (resolveTendarser(ctx, fetched, stopwatch));
  }
}

class JsonSelectorBlockTendarserPages extends JsonSelectorBlock
    with SelectorPagesBlock {
  JsonSelectorBlockTendarserPages(Selector parent, Map json)
      : super(parent, json);
}

class JsonSelectorBlockTendarserTenders extends JsonSelectorBlock
    with SelectorTendersBlock {
  JsonSelectorBlockTendarserTenders(Selector parent, Map json)
      : super(parent, json);

  @override
  SelectorItem itemFactory(Selector parent, Map json, [String? key]) =>
      JsonSelectorItemTendarserTenders(parent, json);
}

class JsonSelectorItemTendarserTenders extends JsonSelectorItem
    with SelectorTenderItem {
  JsonSelectorItemTendarserTenders(Selector parent, Map json)
      : super(parent, {...json, 'text': '#'});

  @override
  SelectorItem itemFactory(Selector parent, Map json, String key) {
    switch (key) {
      case '=link':
        return JsonSelectorItemTendarserLink(parent, json);
    }
    return super.itemFactory(parent, json, key);
  }
}

class JsonSelectorItemTendarserLink extends JsonSelectorItem {
  JsonSelectorItemTendarserLink(Selector parent, Map json)
      : super(parent, json);

  @override
  Future<Object?> resolveMod(String key, Object? data) async {
    if (key.isEmpty) {
      return (root as JsonSelectorRootTendarser)
          .params
          .resolveLink((data as JsonContext?)?.value?.toString() ?? '');
    }
    return super.resolveMod(key, data);
  }
}
