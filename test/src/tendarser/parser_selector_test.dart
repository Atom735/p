import 'dart:io';

import 'package:client/src/tendarser/parser_params.dart';
import 'package:client/src/tendarser/parser_selector.dart';
import 'package:client/src/tendarser/parser_selector_context_html.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('parser selector etpgbp', () async {
    final yaml = loadYamlDocuments(
        File(p.join('test', 'test_parser_params.yaml')).readAsStringSync());
    expect(yaml, isList);
    final json = yaml[2].contents.value;

    final selector = ParserSelector('etpgbp', json);

    final html = File(p.join('test', 'test_parser_selector_etpgbp.html'))
        .readAsStringSync();
    final ctx = ParserSelectorContextHtmlRoot(
      selector,
      html,
    );
    ctx.solve();
    print('object');
    // selector.resolve(html);
  });
  test('parser selector gazprom', () async {
    final yaml = loadYamlDocuments(
        File(p.join('test', 'test_parser_params.yaml')).readAsStringSync());
    expect(yaml, isList);
    final json = yaml[3].contents.value;

    final selector = ParserSelector('gazprom', json);

    final html = File(p.join('test', 'test_parser_selector_gazprom.html'))
        .readAsStringSync();
    final ctx = ParserSelectorContextHtmlRoot(
      selector,
      html,
    );
    ctx.solve();
    print('object');
    // selector.resolve(html);
  });
}
