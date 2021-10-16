import 'dart:collection';

import '../context/context.dart';
import 'base_block.dart';
import 'base_item.dart';
import 'base_root.dart';

export '../context/context.dart';
export 'base_block.dart';
export 'base_item.dart';
export 'base_root.dart';

/// Очистка всех White-space символов
String rws(String str) => str.replaceAll(_reWs, ' ').trim();
final _reWs = RegExp(r'[\t\n\r ]+');

Future get microfreeze => Future.delayed(Duration.zero);

abstract class Selector {
  Selector(this.parent);

  /// Родительский селектор
  Selector? parent;

  /// Модификация возвращаемого значение
  Future<Object?> resolveMod(String key, Object? data) async {
    return data;
  }

  Future<Object?> resolve(Context ctx);
  Object toJson();
  final Map<String, Selector> items = {};

  void genItems(Map json) {
    for (var entry in json.entries) {
      final key = entry.key as String;
      final value = entry.value;
      if (key.startsWith('=')) {
        items[key] = selectorFactory(
          parent: this,
          json: value,
          key: key,
        );
      } else if (key.startsWith(r'$')) {
        items[key] = selectorFactory(
          parent: this,
          json: value,
          key: key.substring(1),
        );
      }
    }
  }

  SelectorItem itemFactory(Selector parent, Map json, String key) =>
      root.itemFactory(parent, json, key);

  SelectorBlock blockFactory(Selector parent, Map json, String key) =>
      root.blockFactory(parent, json, key);

  Selector selectorFactory({
    required Selector parent,
    required Object? json,
    required String key,
  }) {
    if (json is Map) {
      if (json.containsKey('block')) {
        return blockFactory(parent, json, key);
      }
      return itemFactory(parent, json, key);
    }
    if (json is List) {
      return SelectorList(parent, json);
    }
    if (json is String?) {
      return itemFactory(parent, {'selector': json}, key);
    }

    throw UnimplementedError();
  }

  SelectorRoot get root => parent!.root;
  void updated() => parent!.updated();
}

class SelectorList extends Selector {
  final List<String> values;

  SelectorList(Selector parent, List json)
      : values = [...json.map((e) => e?.toString() ?? '')],
        super(parent);

  @override
  Future<Object?> resolve(Context ctx) async {
    ctx.items = [...values];
    return ctx;
  }

  @override
  Object toJson() => values;
}
