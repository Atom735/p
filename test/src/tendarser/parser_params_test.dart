import 'dart:io';

import 'package:client/src/tendarser/parser_params.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'package:path/path.dart' as p;

void main() {
  test('parser params ...', () async {
    final yaml = loadYamlDocuments(
        File(p.join('test', 'test_parser_params.yaml')).readAsStringSync());
    expect(yaml, isList);
    final p0 = ParserParams(yaml[0].contents.value);

    // ---
    // parser_uid: example
    // parser_name: Имя
    // base_url: https://example.com/
    // query_url:
    //   url: https://example.com/page/${page}/
    //   query:
    //     per: ${tender_items_per_page}
    // tender_items_max: 1000
    // tender_items_per_page: 200
    // pages_only_next: true
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
    // ---
    // parser_uid: example
    // base_url: https://example.com/
    // query_method: METHOD
    // query_body: Some Body ${like} this
    // fetched_file_type: type of file
    // pages_max: 10
    // pages_max_unvalible: true
    final p1 = ParserParams(yaml[1].contents.value);
    expect(p1.parser_uid, equals('example'));
    expect(p1.parser_name, equals('example'));
    expect(p1.base_url.toString(), equals('https://example.com/'));
    expect(p1.resolveQueryUrl(735).toString(), equals('https://example.com/'));
    expect(p1.query_method, equals('METHOD'));
    expect(p1.query_body, isNotNull);
    expect(p1.resolveQueryBody(2, const {'like': 'Kazoo'}),
        equals('Some Body Kazoo this'));
    expect(p1.fetched_file_type, equals('type of file'));
    expect(p1.tender_items_max, isNull);
    expect(p1.tender_items_per_page, isNull);
    expect(p1.pages_max, 10);
    expect(p1.pages_max_unvalible, isTrue);
    expect(p1.pages_only_next, isFalse);
  });
}
