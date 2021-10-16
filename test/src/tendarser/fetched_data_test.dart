import 'dart:io';

import 'package:client/logger.dart';
import 'package:client/src/tendarser/fetched_data_fetch.dart';
import 'package:client/src/tendarser/parser_params.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'package:path/path.dart' as p;

void main() {
  test('fetched data ...', () async {
    final yaml = loadYamlDocuments(
        File(p.join('test', 'test_parser_params.yaml')).readAsStringSync());
    expect(yaml, isList);
    final p0 = ParserParams(yaml[0].contents.value);

    expect(p0.parser_uid, equals('example'));
    expect(p0.parser_name, equals('Имя'));
    expect(p0.base_url.toString(), equals('https://example.com/'));
    expect(p0.resolveQueryUrl(735).toString(),
        equals('https://example.com/page/735/?per=200'));
    expect(p0.query_method, equals('GET'));
    expect(p0.query_body, isNull);
    expect(p0.fetched_file_type, equals('html'));
    expect(p0.tender_items_max, equals(1000));
    expect(p0.tender_items_per_page, equals(200));
    expect(p0.pages_max, equals(5));
    expect(p0.pages_max_unvalible, isFalse);
    expect(p0.pages_only_next, isTrue);

    final fetched_data = await FetchedDataFetch(p0, 113, logger: logger);
    expect(fetched_data.head_data.page, equals(113));
    expect(fetched_data.head_data.parser_uid, equals('example'));
  }, timeout: Timeout.factor(5));
}
