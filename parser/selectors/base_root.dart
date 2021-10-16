import 'package:client/log.dart';

import '../../fetched/fetched_data.dart';
import '../../parsed/parsed_data.dart';
import '../params.dart';
import 'base.dart';
import 'base_item.dart';

export '../../fetched/fetched_data.dart';
export '../../parsed/parsed_data.dart';
export '../params.dart';

abstract class SelectorRoot extends SelectorItem {
  final ParserParams params;

  SelectorRoot(Map json, this.params) : super(null, json);

  @override
  SelectorRoot get root => this;

  Future<ParsedData> resolveRoot(
    FetchedData fetched, [
    Logger? logger,
  ]);

  @override
  SelectorItem itemFactory(Selector parent, Map json, String key) =>
      throw UnimplementedError();

  @override
  SelectorBlock blockFactory(Selector parent, Map json, String key) =>
      throw UnimplementedError();
}
