import 'dart:collection';

import 'package:client/log.dart';

export 'dart:collection';

export 'package:client/log.dart';

export 'utils.dart';

mixin ParserSelectorMixin {
  String get name;
  ParserSelectorMixin? get parent;
  ParserSelectorRootMixin get root => parent!.root;

  /// Полная UID строка селектора
  String get uid => '${parent!.uid}.$name';

  @override
  String toString() => uid;

  /// Создаёт дочерний селектор
  void createSelector(Object? json, String key) {
    if (json is Map) {
      if (json.containsKey('block')) {
        return createSelectorList(json, key);
      }
      return createSelectorItem(json, key);
    }
    if (json is String?) {
      return createSelectorItem({'selector': json}, key);
    }
    throw UnimplementedError();
  }

  /// Создаёт дочерний селектор элемента
  void createSelectorItem(Map json, String key);

  /// Создаёт дочерний селектор списка
  void createSelectorList(Map json, String key);

  /// Серриализация селектора
  Object toJson();
}
mixin ParserSelectorRootMixin on ParserSelectorItemMixin {
  @override
  String get name => 'ROOT';

  @override
  Null get parent => null;

  @override
  String get uid => name;
}

/// Селектор единичного элементами
///
/// Получает элемент из блока контекста как указано в [selector]
///
/// Если не указан [text] то получает его через [attr] если он указае, иначе
/// пытается получить текст напрямую из выбранного элемента
///
/// Если указан [regexp] то выполняем его над [text], и добовляем в контекст
/// группы найденных выражений
///
/// Если указан [value] то в коненчое значение заходит оно, иначе [text]
///
/// [type] Конечный тип данных в которое трансформируется [value]
mixin ParserSelectorItemMixin on ParserSelectorMixin {
  /// Строка выборки элемента в блоке
  String get selector;

  /// Получаемое значение текста
  String get text;

  /// Выборка атриббута элемента
  String get attr;

  /// Регялрное выражение для текста
  String get regexp;

  /// Само регулярное выражение, если отсутсвует, значит оно вычисляет через контекст
  RegExp? get regexp_;

  /// Флаг необязательности (Отключает ошибки в большинстве случаев)
  bool get opt;

  /// Конечное значение принимаемое после получения и оброботки текста.
  String get value;

  /// Конечный тип данных
  String get type;

  /// Дочерние селекторы
  HashSet<ParserSelectorMixin> get childrens;

  @override
  Object toJson() {
    final out = {
      'selector': selector,
      if (text.isNotEmpty) 'text': text,
      if (attr.isNotEmpty) 'attr': attr,
      if (regexp.isNotEmpty) 'regexp': regexp,
      if (value.isNotEmpty) 'value': value,
      if (opt) 'opt': true,
      if (type != 'String') 'type': type,
      ...Map.fromEntries(childrens.map((e) => MapEntry(e.name, e.toJson()))),
    };
    if (out.length == 1) {
      return selector;
    } else {
      return out;
    }
  }
}
mixin ParserSelectorListMixin on ParserSelectorMixin {
  /// Строка выборки блока со списком
  String get selector_block;

  /// Строка выборки элементов в блоке и построение по нему списка
  String get selector_item;

  /// Флаг дополнительности (Не выдаёт ошибку, в случае отсутсвия блока со списком)
  bool get opt;

  /// Флаг принятия пустого блока
  bool get allow_empty;

  /// Селектор обработки каждого элемента
  ParserSelectorMixin get children;

  @override
  Map toJson() => {
        'block': selector_block,
        if (selector_item.isNotEmpty) 'selector': selector_item,
        if (opt) 'opt': opt,
        if (allow_empty) 'allow_empty': allow_empty,
        'item': children.toJson(),
      };
}

mixin ParserSelectorContextMixin {
  ParserSelectorContextMixin get parent;

  /// Связанный с контекстом селектор
  ParserSelectorMixin get selector;

  /// Список логов для трасировки ошибки (т.е. сюда помещаются весь лог
  /// отработки данного селектора)
  List<LogData> get log_trace;

  /// Общий логгер в который передаются все лог сообщения
  Logger get logger;

  /// Таймер работы обработчика
  final stopwatch = Stopwatch();
}
