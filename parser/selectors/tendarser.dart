import 'dart:math' show max;

import '../../tender/tender_unboxed_data.dart';
import 'base.dart';

mixin SelectorPagesBlock on SelectorBlock {
  @override
  Future<Object?> resolveMod(String key, Object? data) async {
    if (key.isEmpty) {
      data = data as Context;
      return (data.items)
          .map((e) => int.tryParse((e as Context).value as String))
          .where((e) => e != null)
          .cast<int>()
          .fold<int>(0, (p, e) => max(p, e));
    }

    return super.resolveMod(key, data);
  }
}

mixin SelectorTendersRoot on SelectorRoot {
  Future<ParsedData> resolveTendarser(
      Context ctx, FetchedData fetched, Stopwatch stopwatch) async {
    final data = await resolve(ctx) as Context;
    final pages = data['=pages'] as int?;
    final items = (data['=tenders'] as List? ?? <TenderUnboxedData>[])
        .cast<TenderUnboxedData>();
    stopwatch.stop();
    return ParsedData(fetched.parser_uid, fetched.timestamp, fetched.page,
        stopwatch.elapsedMilliseconds, pages, items);
  }
}

mixin SelectorTendersBlock on SelectorBlock {
  @override
  Future<Object?> resolveMod(String key, Object? data) async {
    if (key.isEmpty) {
      data = data as Context;
      return data.items;
    }

    return super.resolveMod(key, data);
  }
}

mixin SelectorTenderItem on SelectorItem {
  @override
  Future<Object?> resolveMod(String key, Object? data) async {
    if (key.isEmpty) {
      data = data as Context;
      final key = (data['=key'] as Context?)?.value as String?;
      final link = data['=link'] as String?;
      final number = (data['=number'] as Context?)?.value as String? ?? '';
      final name = (data['=name'] as Context?)?.value as String? ?? '';
      final start = _resolveDateTime((data['=start'] as Context?)?.value);
      final end = _resolveDateTime((data['=end'] as Context?)?.value);
      final price = _resolveInt((data['=price'] as Context?)?.value) ?? 0;
      // final msp = _resolveBool((data['=msp'] as Context?)?.value) ?? false;

      final type = (data['=type'] as Context?)?.value as String? ?? '';
      final status = (data['=status'] as Context?)?.value as String? ?? '';
      final organizer =
          (data['=organizer'] as Context?)?.value as String? ?? '';
      // final OKDP = data['=OKDP'] as int? ?? 0;
      // final OKVED = data['=OKVED'] as int? ?? 0;

      if (key == null) {
        throw StateError('Отсутсвует ключевое значение');
      }
      if (link == null) {
        throw StateError('Отсутсвует ссылка на тендер');
      }
      final fetched = data.getValue('*fetched') as FetchedData;
      return TenderUnboxedData(fetched.parser_uid, key, -1, link, number, name,
          start, end, organizer, price, type, status);
    }
    return super.resolveMod(key, data);
  }
}

DateTime? _resolveDateTime(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  throw UnimplementedError();
}

int? _resolveInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  throw UnimplementedError();
}

// bool? _resolveBool(Object? value) {
//   if (value == null) return null;
//   if (value is int) return value != 0;
//   if (value is String) {
//     return !(value == '0' || value == 'false' || value.isEmpty);
//   }
//   if (value is bool) return value;
//   throw UnimplementedError();
// }
