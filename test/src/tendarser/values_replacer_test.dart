import 'package:client/common.dart';
import 'package:test/test.dart';

void main() {
  test('values replacer identity', () {
    expect(ValueReplacer.replace('some string', {}), equals('some string'));
  });
  test('values replacer replace string', () {
    expect(
        ValueReplacer.replace(r'some $  { some arg }', {'some arg': 'string'}),
        equals('some string'));
  });
  test('values replacer replace string recursivly', () {
    expect(
        ValueReplacer.replace(r'$  { ss } $  { ${ss} arg }',
            {'ss': 'some', 'some arg': 'string'}),
        equals('some string'));
  });
  test('values replacer put int', () {
    expect(
        ValueReplacer.replace(
            r'$  { ss } $  { ${ss} arg }', {'ss': 256, '256 arg': 'string'}),
        equals('256 string'));
  });
}
