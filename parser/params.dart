import 'parser_handle.dart';
import 'raw_uri.dart';

class ParserParams with ParserHandleMixin implements ParserHandle {
  /// Уникальный ключ парсера
  @override
  final String parser_uid;

  /// Название парсера
  final String? name;

  /// Базовая ссылка с которой будут разраешаться остальные ссылки
  final String url;

  /// Тип HTTP запроса
  final String method;

  /// Тело запроса
  final String? body;

  /// Тип получаемого файла
  final String type;

  /// Количество тендеров на сайте
  final int? items_max;

  /// Количество тендеров на странице
  final int? items_per_page;

  /// Максимальное количество страниц
  final int? pages_max;

  /// Сканировать пока найдена следующая страница
  final bool pages_while_next;

  /// Максимальное кол-во страниц указаных на странице может быть неверным
  final bool pages_max_unvalible;

  /// Ссылка запроса для генерации
  final ParserParamsUrlScheme url_scheme;

  ParserParams(
    this.parser_uid,
    this.name,
    this.url,
    this.url_scheme, {
    this.method = 'GET',
    this.body,
    this.type = 'html',
    this.items_max,
    this.items_per_page,
    this.pages_max,
    this.pages_while_next = false,
    this.pages_max_unvalible = false,
  }) : assert(
            (items_max != null &&
                    items_max > 0 &&
                    items_per_page != null &&
                    items_per_page > 0) ||
                (pages_max != null && pages_max > 0),
            'Должны быть указаны положительные items_max и items_per_page, или только pages_max');

  factory ParserParams.fromJson(Map<String, dynamic> json) => ParserParams(
        json['key'] as String,
        json['name'] as String?,
        json['url'] as String,
        ParserParamsUrlScheme.fromJson(json['url_scheme'] as Object),
        method: json['method'] as String? ?? 'GET',
        body: json['body'] as String?,
        type: json['type'] as String? ?? 'html',
        items_max: json['items_max'] as int?,
        items_per_page: json['items_per_page'] as int?,
        pages_max: json['pages_max'] as int?,
        pages_while_next: json['pages_while_next'] as bool? ?? false,
        pages_max_unvalible: json['pages_max_unvalible'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'key': parser_uid,
        if (name != null) 'name': name,
        'url': url,
        'url_scheme': url_scheme.toJson(),
        if (method != 'GET') 'method': method,
        if (body != null) 'body': body,
        if (type != 'html') 'type': type,
        if (items_max != null) 'items_max': items_max,
        if (items_per_page != null) 'items_per_page': items_per_page,
        if (pages_max != null) 'pages_max': pages_max,
        if (pages_while_next) 'pages_while_next': pages_while_next,
        if (pages_max_unvalible) 'pages_max_unvalible': pages_max_unvalible,
      };

  /// Получает ссылку для построении других ссылок
  Uri get uri => Uri.parse(url);

  /// Получить имя или ключ в случае его отсутсвия
  String get name_s => name ?? parser_uid;

  /// Получить максимальное количество страниц
  int get pages_max_s => pages_max ?? (items_max! / items_per_page!).ceil();

  /// Получает текст тела запроса
  String? getBody(int page) {
    if (body == null) return null;
    var out = body!.replaceAll(r'${page}', page.toString());
    if (items_per_page != null) {
      out = out.replaceAll(
          r'${items}', ((page - 1) * items_per_page!).toString());
    }
    return out;
  }

  /// Получаем [Uri] для Http запроса
  Uri getUri(int page) => url_scheme.resolve(page);

  /// Получаем абсолютную ссылку тендера
  String resolveLink(String link) => uri.resolve(link).toString();

  static const _removedKeys = [
    'key',
    'name',
    'url',
    'method',
    'body',
    'type',
    'items_max',
    'items_per_page',
    'pages_max',
    'pages_while_next',
    'pages_max_unvalible',
    'url_scheme',
  ];

  /// Получает JSON без объектов описывающих эту структуру
  static Map<String, dynamic> getJsonRemoved(Map<String, dynamic> json) {
    return {...json}..removeWhere((key, value) => _removedKeys.contains(key));
  }
}

class ParserParamsUrlSchemeList implements ParserParamsUrlScheme {
  final List<ParserParamsUrlScheme> data;
  ParserParamsUrlSchemeList(this.data)
      : assert(data.isNotEmpty, 'Список URL должен быть не пустым');

  @override
  String get url => data.first.url;
  @override
  bool get raw => data.first.raw;
  @override
  Map<String, String>? get query => data.first.query;

  @override
  Uri resolve(int page) {
    if (page > data.length || page < 1) {
      throw ArgumentError('Невозможный номер страницы $page/${data.length}');
    }
    return data[page - 1].resolve(page);
  }

  @override
  Object toJson() => [...data.map((e) => e.toJson())];
}

class ParserParamsUrlScheme {
  /// Строка схемы
  final String url;

  /// Флаг того что необходимо генерировать свою Uri
  final bool raw;

  /// Карта параметров
  final Map<String, String>? query;

  const ParserParamsUrlScheme(this.url, [this.raw = false, this.query]);

  static const scheme = {
    '#UrlScheme': 'Поддерживаемые типа для схемы генерации запроса',
    'UrlScheme': 'String | List<UrlSchemeQuery> | UrlSchemeQuery',
    '#UrlSchemeQuery': 'Более подробное описание схемы',
    'UrlSchemeQuery': {
      '#url': 'Начальная строка формирования запроса',
      'url': 'String',
      '#raw': 'Флаг отсутсвия необходимости в стандартном кодировании URL',
      '?raw': 'bool(false)',
      '#query': 'Карта параметров запроса',
      '?query': 'Map<String, String>',
    },
  };

  factory ParserParamsUrlScheme.fromJson(Object json) {
    if (json is String) return ParserParamsUrlScheme(json);
    if (json is List) {
      return ParserParamsUrlSchemeList(
          [...json.map((e) => ParserParamsUrlScheme.fromJson(e))]);
    }
    if (json is Map) {
      return ParserParamsUrlScheme(
        json['url'] as String,
        json['raw'] as bool? ?? false,
        (json['query'] as Map?)
            ?.map((key, value) => MapEntry(key as String, value.toString())),
      );
    }
    throw ArgumentError('Неправильное описание типа <UrlSheme>');
  }

  /// Вычисляет получившийся Uri для запроса
  Uri resolve(int page) {
    if (page < 1) {
      throw ArgumentError('Невозможный номер страницы $page');
    }
    final query = this.query;
    var url = this.url;
    if (query != null && query.isNotEmpty) {
      final q = query.entries.map((e) => '${e.key}=${e.value}').join('&');
      if (url.contains('?')) {
        url += '&$q';
      } else {
        url += '?$q';
      }
    }
    url = url.replaceAll(r'${page}', page.toString());
    return raw ? RawUri(url) : Uri.parse(url);
  }

  Object toJson() {
    if (query == null || query!.isEmpty) {
      if (raw) {
        return {
          'url': url,
          'raw': raw,
        };
      } else {
        return url;
      }
    } else {
      return {
        'url': url,
        if (raw) 'raw': raw,
        'query': query,
      };
    }
  }
}
