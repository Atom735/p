import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:client/log.dart';

import '../fetched/fetched_data.dart';
import '../parsed/parsed_data.dart';
import 'params.dart';
import 'parser_handle.dart';
import 'selectors/base.dart';
import 'selectors/html_tendarser.dart';
import 'selectors/json_tendarser.dart';

Future<FetchedData> _fetch(
  ParserParams params,
  int page, [
  HttpClient? client,
  Logger? logger,
]) async {
  final timestamp_start = DateTime.now();
  (client ??= HttpClient()).autoUncompress = false;

  logger = LoggerPrefix('[HTTP]', logger);
  final uri = params.getUri(page);
  logger.trace('Покдлючение ${params.method} $uri', type: LogType.status);
  final stopwatch = Stopwatch()..start();
  final request = await client.openUrl(params.method, uri);
  stopwatch.stop();
  final times_connect = stopwatch.elapsedMilliseconds;
  final req_prefix = 'Request_${request.hashCode.toRadixString(16)}';
  logger.trace('Формирование запроса $req_prefix', type: LogType.status);
  final body = params.getBody(page);
  if (body != null) {
    request.headers.contentType = ContentType.json;
    final data = const Utf8Encoder().convert(body);
    request.contentLength = data.length;
    request.add(data);
  }
  {
    final headers = StringBuffer('${params.method} $uri\n'
        '=== Headers ===\n');
    request.headers
        .forEach((name, value) => headers.write('* $name: $value\n'));

    logger.trace(req_prefix, data: headers.toString());
  }
  logger.debug('Отправка запроса $req_prefix', type: LogType.status);

  stopwatch.reset();
  final response = await request.close();
  final times_response = stopwatch.elapsedMilliseconds;
  stopwatch.reset();
  final res_prefix = 'Response_${response.hashCode.toRadixString(16)}';
  logger.trace('Приём ответа $res_prefix на запрос $req_prefix',
      type: LogType.status);
  {
    final headers =
        StringBuffer('${response.statusCode} ${response.reasonPhrase}\n'
            '=== Headers ===\n');
    response.headers
        .forEach((name, value) => headers.write('* $name: $value\n'));
    logger.debug(res_prefix, data: headers.toString());
  }
  int? times_ttfb;
  var data = BytesBuilder(copy: false);
  await for (final chunk in response) {
    times_ttfb ??= stopwatch.elapsedMilliseconds;
    data.add(chunk);
  }
  stopwatch.stop();
  final times_download = stopwatch.elapsedMilliseconds;
  logger.debug('Ответ $res_prefix получен размера ${data.length}',
      type: LogType.status);
  var data_raw = data.takeBytes();
  final len = data_raw.length;
  if (response.compressionState ==
      HttpClientResponseCompressionState.compressed) {
    data_raw = Uint8List.fromList(GZipCodec().decode(data_raw));
  }
  return FetchedData(
    params.parser_uid,
    timestamp_start,
    page,
    times_connect,
    times_response,
    times_ttfb!,
    times_download,
    const Utf8Decoder(allowMalformed: true).convert(data_raw),
    len,
  );
}

class Parser with ParserHandleMixin implements ParserHandle {
  /// Уникальный айди парсера
  @override
  String get parser_uid => params.parser_uid;

  /// Параметры парсера
  ParserParams params;

  /// Корневой селектор
  late SelectorRoot rootSelector;

  final HttpClient client = HttpClient();

  Parser(Map<String, dynamic> json) : params = ParserParams.fromJson(json) {
    switch (params.type) {
      case 'html':
        rootSelector = HtmlSelectorRootTendarser(
            ParserParams.getJsonRemoved(json), params);
        break;
      case 'json':
        rootSelector = JsonSelectorRootTendarser(
            ParserParams.getJsonRemoved(json), params);
        break;
      default:
        throw ArgumentError('Неизвестный тип парсера');
    }
  }

  Future<FetchedData> fetch(int page, [Logger? logger]) => _fetch(
        params,
        page,
        client,
        logger,
      );

  Future<ParsedData> parse(FetchedData fetched, [Logger? logger]) =>
      rootSelector.resolveRoot(fetched, logger);
}
