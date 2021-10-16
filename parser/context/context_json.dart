import 'package:client/log.dart';

import 'context.dart';

export 'context.dart';

Object? myJsonSelector(Object? node, String selector) {
  if (node == null) return null;
  if (selector.isEmpty) {
    return node;
  }
  final ks = selector.split('.').map((e) => e.trim()).toList();
  var _key = ks.first;
  var v;
  if (node is Map) {
    v = node[_key];
  }
  if (Context.regexpNum.matchAsPrefix(_key) != null) {
    final i = int.parse(_key);
    if (node is List) {
      if (node.length > i) {
        v = node[i];
      }
    }
  }
  if (ks.length > 1) {
    return myJsonSelector(v, ks.sublist(1).join('.'));
  }
  return v;
}

List<Object> myJsonSelectorAll(Object? node, String selector) {
  final v = _myJsonSelectorAll(node, selector);
  return [...v.where((e) => e != null).cast<Object>()];
}

List<Object?> _myJsonSelectorAll(Object? node, String selector) {
  if (node == null) return [];
  if (selector.isEmpty) {
    if (node is Map) {
      return [...node.values];
    }
    if (node is List) {
      return [...node];
    } else {
      return [node];
    }
  }
  final ks = selector.split('.').map((e) => e.trim()).toList();
  var _key = ks.first;
  var v;
  if (node is Map) {
    v = node[_key];
  }
  if (Context.regexpNum.matchAsPrefix(_key) != null) {
    final i = int.parse(_key);
    if (node is List) {
      if (node.length > i) {
        v = node[i];
      }
    }
  }
  if (ks.length > 1) {
    return _myJsonSelectorAll(v, ks.sublist(1).join('.'));
  }
  if (v == null) {
    return v;
  }
  if (v is Map) {
    return [...v.values];
  }
  if (v is List) {
    return [...v];
  } else {
    return [v];
  }
}

class JsonContext extends Context {
  late Object el;

  @override
  Object? getValueInternal(String key) {
    switch (key) {
      case 'el':
        return el;
    }
    return super.getValueInternal(key);
  }

  @override
  Context contextFactory({
    required String label,
    required covariant JsonContext parent,
    required Logger logger,
    Map<String, Object?>? values,
  }) =>
      JsonContext(label: label, values: values, parent: parent, logger: logger);

  JsonContext({
    required String label,
    JsonContext? parent,
    required Logger logger,
    Map<String, Object?>? values,
  }) : super(
          label: label,
          values: values,
          parent: parent,
          logger: LoggerEventWrap([LogLevel.error, LogLevel.fatal], (data) {
            throw Exception(data);
          }, logger),
        );

  @override
  JsonContext push({required String label, Map<String, Object?>? values}) =>
      (super.push(label: label, values: values) as JsonContext)..el = el;
}
