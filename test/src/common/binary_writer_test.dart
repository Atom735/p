import 'dart:convert';
import 'dart:typed_data';

import 'package:client/common.dart';
import 'package:test/test.dart';

void main() {
  test('binary read writer sizes', () async {
    expect(() => MyBinaryWriter().writeSize(-1), throwsArgumentError);
    expect((MyBinaryWriter()..writeSize(0x7f)).takeBytes(), equals([0x7f]));
    expect((MyBinaryWriter()..writeSize(0x087f)).takeBytes(),
        equals([0xff, 0x10]));
    expect((MyBinaryWriter()..writeSize(0x7fff)).takeBytes(),
        equals([0xff, 0xff, 0x01]));
    expect((MyBinaryWriter()..writeSize(0x7fffff)).takeBytes(),
        equals([0xff, 0xff, 0xff, 0x03]));
    expect((MyBinaryWriter()..writeSize(0x1fffffff)).takeBytes(),
        equals([0xff, 0xff, 0xff, 0xff]));
    expect(() => MyBinaryWriter().writeSize(0x2fffffff), throwsArgumentError);
    expect(() => MyBinaryWriter().writeSize(0, csz: 5), throwsRangeError);
    expect(
        MyBinaryReader((MyBinaryWriter()..writeSize(0x7f, csz: 2)).takeBytes())
            .readSize(csz: 2),
        equals(0x7f));
    expect(
        MyBinaryReader(
                (MyBinaryWriter()..writeSize(0xfefefee, csz: 4)).takeBytes())
            .readSize(csz: 4),
        equals(0xfefefee));
    expect(
        MyBinaryReader((MyBinaryWriter()..writeSize(735, csz: 2)).takeBytes())
            .readSize(csz: 2),
        equals(735));
    expect(
        MyBinaryReader((MyBinaryWriter()..writeSize(735, csz: 3)).takeBytes())
            .readSize(csz: 3),
        equals(735));
  });
  test('binary writer strings', () async {
    expect((MyBinaryWriter()..writeString('Привет мир')).takeBytes().sublist(1),
        equals(const Utf8Encoder().convert('Привет мир')));
    expect(
        MyBinaryReader(
                (MyBinaryWriter()..writeString('Привет мир')).takeBytes())
            .readString(),
        equals('Привет мир'));
    expect(
        MyBinaryReader((MyBinaryWriter()..writeString('☺☻♥')).takeBytes())
            .readString(),
        equals('☺☻♥'));
    expect(
        Uint16List.sublistView(
            Uint8List.fromList(
                (MyBinaryWriter()..writeStringW('Привет мир')).takeBytes()),
            2),
        equals('Привет мир'.codeUnits));
    expect(
        MyBinaryReader(
                (MyBinaryWriter()..writeStringW('Привет мир')).takeBytes())
            .readStringW(),
        equals('Привет мир'));
    expect(
        MyBinaryReader((MyBinaryWriter()..writeStringW('☺☻♥')).takeBytes())
            .readStringW(),
        equals('☺☻♥'));
    expect(
        MyBinaryReader((MyBinaryWriter()..writeStringW('Привет мир', size: 3))
                .takeBytes())
            .readStringW(size: 3),
        equals('При'));
  });
}
