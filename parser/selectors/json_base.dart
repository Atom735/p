import '../context/context_json.dart';
import 'base.dart';

export '../context/context_json.dart';
export 'base.dart';

abstract class JsonSelectorRoot extends SelectorRoot {
  JsonSelectorRoot(Map json, ParserParams params) : super(json, params);

  @override
  SelectorItem itemFactory(Selector parent, Map json, String key) =>
      JsonSelectorItem(parent, json);

  @override
  SelectorBlock blockFactory(Selector parent, Map json, String key) =>
      JsonSelectorBlock(parent, json);

  @override
  Future<Object?> resolve(covariant JsonContext ctx) async {
    for (var entry in items.entries) {
      final key = entry.key;
      final nctx = ctx.push(label: key);
      ctx[key] = await resolveMod(key, await entry.value.resolve(nctx));
    }
    return await resolveMod('', ctx);
  }
}

class JsonSelectorBlock extends SelectorBlock {
  JsonSelectorBlock(Selector parent, Map json) : super(parent, json);

  @override
  Future<Object?> resolve(covariant JsonContext ctx) async {
    final el = ctx.el;
    final trace = ctx.logger.trace;
    final error = ctx.logger.error;
    final el_block = myJsonSelector(el, block);
    ctx.items = [];
    if (el_block == null) {
      (opt ? trace : error)('Элемент содержащий список не найден "$block"');
    } else {
      final els = myJsonSelectorAll(el_block, selector);
      final length = els.length;
      ctx.length = length;
      if (length == 0) {
        (allow_empty
            ? trace
            : error)('Найден пустой список элементов "$block" -> "$selector"');
      } else {
        trace('Найден список элементов ($length) "$block" -> "$selector"');
        for (var i = 0; i < length; i++) {
          final nctx = ctx.push(label: i.toString());
          nctx.el = els[i];
          nctx.index = i;
          ctx.items.add(await resolveMod('@item', await item.resolve(nctx)));
        }
      }
    }
    await microfreeze;
    for (var entry in items.entries) {
      final key = entry.key;
      final nctx = ctx.push(label: key);
      ctx[key] = await resolveMod(key, await entry.value.resolve(nctx));
    }
    return await resolveMod('', ctx);
  }
}

class JsonSelectorItem extends SelectorItem {
  JsonSelectorItem(Selector parent, Map json) : super(parent, json);

  @override
  Future<Object?> resolve(covariant JsonContext ctx) async {
    final ctx_el = ctx.el;
    final trace = ctx.logger.trace;
    final error = ctx.logger.error;
    final selector = ctx.resolveExpr(this.selector);
    final el = myJsonSelector(ctx_el, selector);
    var text = ctx.resolveExpr(this.text);
    if (el == null) {
      (opt ? trace : error)('Элемент не найден "$selector"');
      ctx.value = null;
    } else {
      if (selector.isNotEmpty) {
        trace('Найден элемент "$selector"');
      }
      if (text.isEmpty) {
        text = el.toString();
      }
      trace('Разбор данных', data: text);
      await microfreeze;
      if (regexp.isNotEmpty) {
        final regexp = regexp_ ?? regexpCompile(ctx.resolveExpr(this.regexp));
        if (regexp == null) {
          error('Ошибка компиляции RegExp', data: ctx.resolveExpr(this.regexp));
        } else {
          final match = regexp.firstMatch(text);
          if (match == null) {
            (opt ? trace : error)('Данные не прошли регулярное выражение');
          } else {
            // final rectx = ctx.push(label: '$i');
            final length = match.groupCount;
            ctx.length = length;
            ctx.start = match.start;
            ctx.end = match.end;
            ctx.items = List.generate(length + 1, (k) => match.group(k));
          }
          // final matches = regexp.allMatches(text).toList();
          // ctx.length = matches.length;
          // for (var i = 0; i < matches.length; i++) {
          //   final match = matches[i];
          //   final rectx = ctx.push(label: '$i');
          //   final length = match.groupCount;
          //   rectx.length = length;
          //   rectx.start = match.start;
          //   rectx.end = match.end;
          //   for (var k = 0; k <= length; k++) {
          //     rectx.setValue(k.toString(), match.group(k));
          //   }
          // }
        }
      }
      if (this.value.isNotEmpty) {
        text = ctx.resolveExpr(this.value);
      }
      Object? value = text;
      switch (type) {
        case 'String':
          value = text;
          break;
        case 'bool':
          value = !(text.isEmpty || text == 'false' || text == '0');
          break;
        case 'int':
        case 'int32':
        case 'int64':
          value = int.tryParse(text);
          break;
        case 'DateTime':
          value = DateTime.tryParse(text);
          break;
        default:
          ctx.logger.warn('Неизвестный тип данных');
          value = text;
      }
      ctx.value = value;
      await microfreeze;
      for (var entry in items.entries) {
        final key = entry.key;
        final nctx = ctx.push(label: key);
        ctx[key] = await resolveMod(key, await entry.value.resolve(nctx));
      }
    }
    return await resolveMod('', ctx);
  }
}
