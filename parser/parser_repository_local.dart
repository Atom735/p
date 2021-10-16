import 'dart:collection';
import 'dart:io';

import 'parser_handle.dart';
import 'package:yaml/yaml.dart';

import 'parser.dart';

mixin ParserRepositoryLocalMixin {
  Directory get dir_parsers;

  var parsers = HashSet<Parser>();

  Future<void>? _loadParserHandles;
  Future<void> loadParserHandles() =>
      _loadParserHandles ??= refreshParserHandles();

  /// Обновить хендлы парсеров
  Future<void> refreshParserHandles() async {
    parsers = HashSet.from(await getParsersStream().toList());
  }

  Future<Set<Parser>> getParsers() async {
    await loadParserHandles();
    return parsers;
  }

  Future<Set<ParserHandle>> getParserHandles() async {
    await loadParserHandles();
    return parsers;
  }

  /// Получение парсеров с диска
  Stream<Parser> getParsersStream() async* {
    await for (final file in dir_parsers
        .list()
        .where((e) => e is File && e.path.endsWith('.yaml'))
        .cast<File>()) {
      final json =
          (loadYaml(await file.readAsString()) as Map).cast<String, dynamic>();
      final parser = Parser(json);
      yield parser;
    }
  }
}

class ParserRepositoryLocal with ParserRepositoryLocalMixin {
  @override
  final Directory dir_parsers;

  ParserRepositoryLocal(this.dir_parsers);
}
