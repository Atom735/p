import 'package:client/src/tendarser/parser_params_uri.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('parser params uri 1', () async {
    var string =
        r'''
url_scheme:
  url: https://zakupki.gazprom-neft.ru/tenderix/index.php
  raw: true
  query:
    PAGE: ${page}
    LIMIT: 100
    FILTER[STATE]: ALL
    FILTER[SORT]: DATE_START_DESC
''';
    final yaml = loadYaml(string);
    final uri_par = ParserParamsUri(yaml['url_scheme']);
    final uri = uri_par.resolve();

    expect(
        uri.toString(),
        equals(
            'https://zakupki.gazprom-neft.ru/tenderix/index.php?PAGE=1&LIMIT=100&FILTER[STATE]=ALL&FILTER[SORT]=DATE_START_DESC'));
  });
  test('parser params uri 2', () async {
    var string =
        r'''
url_scheme:
  url: https://zakupki.gazprom-neft.ru/tenderix/index.php
  raw: true
  query:
    PAGE: ${page}
    LIMIT: 100
    FILTER[STATE]: ALL
    FILTER[SORT]: DATE_START_DESC
''';
    final yaml = loadYaml(string);
    final uri_par = ParserParamsUri(yaml['url_scheme']);
    final uri = uri_par.resolve(735);

    expect(
        uri.toString(),
        equals(
            'https://zakupki.gazprom-neft.ru/tenderix/index.php?PAGE=735&LIMIT=100&FILTER[STATE]=ALL&FILTER[SORT]=DATE_START_DESC'));
  });

  test('parser params uri 1', () async {
    var string =
        r'''
url_scheme:
  url: https://zakupki.gazprom-neft.ru/tenderix/index.php
  raw: true
  query:
    PAGE: ${page}
    LIMIT: 100
    FILTER[STATE]: ALL
    FILTER[SORT]: DATE_START_DESC
''';
    final yaml = loadYaml(string);
    final uri_par = ParserParamsUri(yaml['url_scheme']);
    final uri = uri_par.resolve();

    expect(
        uri.toString(),
        equals(
            'https://zakupki.gazprom-neft.ru/tenderix/index.php?PAGE=1&LIMIT=100&FILTER[STATE]=ALL&FILTER[SORT]=DATE_START_DESC'));
  });
  test('parser params uri 2', () async {
    var string =
        r'''
url_scheme:
  url: https://zakupki.gazprom-neft.ru/tenderix/index.php
  raw: true
  query:
    PAGE: ${page}
    LIMIT: 100
    FILTER[STATE]: ALL
    FILTER[SORT]: DATE_START_DESC
''';
    final yaml = loadYaml(string);
    final uri_par = ParserParamsUri(yaml['url_scheme']);
    final uri = uri_par.resolve(735);

    expect(
        uri.toString(),
        equals(
            'https://zakupki.gazprom-neft.ru/tenderix/index.php?PAGE=735&LIMIT=100&FILTER[STATE]=ALL&FILTER[SORT]=DATE_START_DESC'));
  });

  test('parser params uri 3', () async {
    var string =
        r'''
url_scheme:
  - https://russneft.ru/tenders/russneft/
  - https://russneft.ru/tenders/all/zapsibgroop/
  - https://russneft.ru/tenders/all/centrsibgroop/
  - https://russneft.ru/tenders/all/volgagroop/
  - https://russneft.ru/tenders/all/belarus/
  - https://russneft.ru/tenders/all/overseas/
''';
    final yaml = loadYaml(string);
    final uri_par = ParserParamsUri(yaml['url_scheme']);
    final uri = uri_par.resolve();

    expect(uri.toString(), equals('https://russneft.ru/tenders/russneft/'));
  });

  test('parser params uri 4', () async {
    var string =
        r'''
url_scheme:
  - https://russneft.ru/tenders/russneft/
  - https://russneft.ru/tenders/all/zapsibgroop/
  - https://russneft.ru/tenders/all/centrsibgroop/
  - https://russneft.ru/tenders/all/volgagroop/
  - https://russneft.ru/tenders/all/belarus/
  - https://russneft.ru/tenders/all/overseas/
''';
    final yaml = loadYaml(string);
    final uri_par = ParserParamsUri(yaml['url_scheme']);
    final uri = uri_par.resolve(5);

    expect(uri.toString(), equals('https://russneft.ru/tenders/all/belarus/'));
  });

  test('parser params uri 5', () async {
    var string =
        r'''
url_scheme:
  - https://russneft.ru/tenders/russneft/
  - https://russneft.ru/tenders/all/zapsibgroop/
  - https://russneft.ru/tenders/all/centrsibgroop/
  - https://russneft.ru/tenders/all/volgagroop/
  - https://russneft.ru/tenders/all/belarus/
  - https://russneft.ru/tenders/all/overseas/
''';
    final yaml = loadYaml(string);
    final uri_par = ParserParamsUri(yaml['url_scheme']);

    expect(() => uri_par.resolve(10), throwsArgumentError);
  });

  test('parser params uri 6', () async {
    var string =
        r'''
url_scheme:
  - https://russneft.ru/tenders/russneft/
  - https://russneft.ru/tenders/all/zapsibgroop/
  - https://russneft.ru/tenders/all/centrsibgroop/
  - https://russneft.ru/tenders/all/volgagroop/
  - https://russneft.ru/tenders/all/belarus/
  - https://russneft.ru/tenders/all/overseas/
''';
    final yaml = loadYaml(string);
    final uri_par = ParserParamsUri(yaml['url_scheme']);

    expect(() => uri_par.resolve(-1), throwsArgumentError);
  });
}
