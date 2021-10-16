import 'context.dart';

String ContextModifyer(String mod, Object? data) {
  final match = _reArgs.matchAsPrefix(mod);
  var args = '';
  var argv = [];
  if (match != null) {
    mod = match.group(1)!;
    args = match.group(2) ?? '';
    final arg = _reArgRegExp.matchAsPrefix(args);
    if (arg != null) {
      argv.add(RegExp(arg.group(1)!));
    }
  }

  switch (mod) {
    case '':
      while (data is Context) {
        data = data.value;
      }
      return data?.toString() ?? '';
    case 'add':
    case 'mul':
    case 'div':
      while (data is Context) {
        data = data.value;
      }
      if (data is String) data = int.tryParse(data);
      final arg = int.tryParse(args);
      if (arg == null) {
        throw ArgumentError('Аргумент должен быть числом');
      }
      if (data is int) {
        return (mod == 'div'
                ? (data ~/ arg)
                : mod == 'mul'
                    ? (data * arg)
                    : (data + arg))
            .toString();
      }
      throw ArgumentError('Невозможно преобразовать данные в число');

    case 'YYYY':
      data ??= 1970;
      if (data is String) data = int.tryParse(data);
      if (data is int) {
        return data.toString().padLeft(4, '0');
      }
      throw ArgumentError('Невозможно преобразовать данные в номер года');
    case 'MM':
      data ??= 1;
      if (data is String) {
        if (data.length >= 3) {
          switch (data[0].toUpperCase()) {
            case 'Я':
              data = 1;
              break;
            case 'Ф':
              data = 2;
              break;
            case 'М':
              data = data[2].toLowerCase() == 'р' ? 3 : 5;
              break;
            case 'А':
              data = data[1].toLowerCase() == 'п' ? 4 : 8;
              break;
            case 'И':
              data = data[2].toLowerCase() == 'н' ? 6 : 7;
              break;
            case 'С':
              data = 9;
              break;
            case 'О':
              data = 10;
              break;
            case 'Н':
              data = 11;
              break;
            case 'Д':
              data = 12;
              break;
          }
        }
        if (data is String) {
          data = int.tryParse(data);
        }
      }
      if (data is int) {
        return data.toString().padLeft(2, '0');
      }
      throw ArgumentError('Невозможно преобразовать данные в число месяца');
    case 'DD':
      data ??= 1;
      if (data is String) data = int.tryParse(data);
      if (data is int) {
        return data.toString().padLeft(2, '0');
      }
      throw ArgumentError('Невозможно преобразовать данные в номер дня месяца');

    case 'hh':
    case 'mm':
    case 'ss':
      data ??= 0;
      if (data is String) data = int.tryParse(data);
      if (data is int) {
        return data.toString().padLeft(mod.length, '0');
      }
      throw ArgumentError('Невозможно преобразовать данные число');
    case 'where':
      if (data is Context) {
        final i = data.items.indexWhere((e) {
          e = ContextModifyer('', e);
          if (e is! String) {
            e = e.toString();
          }
          return (argv[0] as Pattern).allMatches(e).isNotEmpty;
        });
        data = i == -1 ? '' : data.items[i];
        return ContextModifyer('', data);
      }
      throw ArgumentError('Модификатор работает только со списками');
  }
  throw ArgumentError('Неизвестный модификатор');
}

final _reArgs = RegExp(r'^\s*(\w+)\s*(?:\(\s*(.*)\s*\)\s*)?$');
final _reArgRegExp = RegExp(r'^\s*\/(.+)\/\s*$');
