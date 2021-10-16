import 'base.dart';

abstract class SelectorBlock extends Selector {
  String _block;
  String get block => _block;
  set block(String? block) {
    if ((block ?? '') != _block) {
      _block = block ?? '';
      updated();
    }
  }

  String _selector;
  String get selector => _selector;
  set selector(String? selector) {
    if ((selector ?? '') != _selector) {
      _selector = selector ?? '';
      updated();
    }
  }

  bool _opt;
  bool get opt => _opt;
  set opt(bool? opt) {
    if ((opt ?? false) != _opt) {
      _opt = opt ?? false;
      updated();
    }
  }

  bool _allow_empty;
  bool get allow_empty => _allow_empty;
  set allow_empty(bool? allow_empty) {
    if ((allow_empty ?? false) != _allow_empty) {
      _allow_empty = allow_empty ?? false;
      updated();
    }
  }

  late Selector _item;
  Selector get item => _item;
  set item(Selector item) {
    if (item != _item) {
      _item = item;
      _item.parent = this;
      updated();
    }
  }

  SelectorBlock(Selector parent, Map json)
      : _block = json['block'] as String? ?? '',
        _selector = json['selector'] as String? ?? '',
        _opt = json['opt'] as bool? ?? false,
        _allow_empty = json['allow_empty'] as bool? ?? false,
        super(parent) {
    _item = selectorFactory(parent: this, json: json['item'], key: '');
    genItems(json);
  }

  @override
  Map toJson() => {
        'block': block,
        if (selector.isNotEmpty) 'selector': selector,
        if (_opt) 'opt': _opt,
        if (_allow_empty) 'allow_empty': _allow_empty,
        'item': item.toJson(),
        ...items.map((key, value) =>
            MapEntry(key.startsWith('=') ? key : '\$$key', value.toJson())),
      };
}
