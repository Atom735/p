import 'package:client/log.dart';
import 'package:meta/meta.dart';

import 'modify.dart';

class Context {
  final Logger logger;
  final Context? parent;

  /// Доступные переменные в данном контексте
  final Map<String, Object?> _values;

  Context({
    required this.label,
    this.parent,
    this.logger = const LoggerMock(),
    Map<String, Object?>? values,
  })  : _values = values ?? {},
        items = [];

  final String label;
  late int length;
  late int index;
  late String text;
  late String attr;
  late Object? value;
  late List<Object?> items;
  late int start;
  late int end;

  static final _regexp = RegExp(r'\$\{([^\:\$\{\}]+?)(?:\:([^\$\{\}]+))?\}');
  static final regexpAlpha = RegExp(r'[a-zA-Z_]');
  static final regexpNum = RegExp(r'^\d+$');
  static bool hasExpr(String input) => _regexp.hasMatch(input);
  @nonVirtual
  String resolveExpr(String input) {
    if (_regexp.hasMatch(input)) {
      return resolveExpr(input.replaceAllMapped(_regexp, (match) {
        var key = match.group(1)!;
        final value = getValue(key);
        final mod = match.group(2)?.trim() ?? '';
        return modify(mod, value);
      }));
    }
    return input;
  }

  @nonVirtual
  String modify(String mod, Object? data) {
    try {
      return ContextModifyer(mod, data);
    } catch (e) {
      final o = data?.toString() ?? '';
      logger.error(e.toString(), data: o);
      return o;
    }
  }

  @mustCallSuper
  Object? getValueInternal(String key) {
    switch (key) {
      case 'label':
        return label;
      case 'length':
        return length;
      case 'index':
        return index;
      case 'text':
        return text;
      case 'attr':
        return attr;
      case 'value':
        return value;
      case 'items':
        return items;
      case 'start':
        return start;
      case 'end':
        return end;
    }
  }

  Context contextFactory({
    required String label,
    required Context parent,
    required Logger logger,
    Map<String, Object?>? values,
  }) =>
      Context(label: label, values: values, parent: parent, logger: logger);

  @nonVirtual
  Object? getValue(String key, [bool search = true]) {
    final ks = key.split('.').map((e) => e.trim()).toList();
    var _key = ks.first;
    var v;
    if (_key.isEmpty) {
      return parent?.getValue(ks.sublist(1).join('.'), false);
    }
    if (regexpNum.matchAsPrefix(_key) != null) {
      final i = int.parse(_key);
      if (items.length > i) {
        v = items[i];
      }
    }

    if (regexpAlpha.matchAsPrefix(_key) != null) {
      _key = '\$$_key';
    }
    v ??= _key.startsWith('@')
        ? getValueInternal(_key.substring(1))
        : _values[_key];
    if (ks.length > 1) {
      if (v is Context) {
        v = v.getValue(ks.sublist(1).join('.'), false);
      }
    }

    if (v == null && search && regexpNum.matchAsPrefix(_key) == null) {
      return parent?.getValue(key);
    }
    return v;
  }

  @nonVirtual
  void setValue(String key, Object? value) {
    if (_values.containsKey(key)) {
      logger.warn('Перезапись ключа $key в контексте на новый контекст');
    }
    _values[key] = value;
  }

  @nonVirtual
  String get fullLabel =>
      parent != null ? '${parent!.fullLabel} > $label' : '$label';

  @override
  @nonVirtual
  String toString() => fullLabel;

  Context push({required String label, Map<String, Object?>? values}) {
    final logger = this.logger;
    final nctx = contextFactory(
      label: label,
      values: values,
      parent: this,
      logger: logger is LoggerPrefix
          ? logger.withSuffix(' > $label')
          : LoggerPrefix(label, logger),
    );
    return nctx;
  }

  Object? operator [](String key) => getValue(key);
  void operator []=(String key, Object? value) => setValue(key, value);
}
