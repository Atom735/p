import 'base.dart';

abstract class SelectorItem extends Selector {
  String _selector;
  String get selector => _selector;
  set selector(String? selector) {
    if ((selector ?? '') != _selector) {
      _selector = selector ?? '';
      updated();
    }
  }

  String _text;
  String get text => _text;
  set text(String? text) {
    if ((text ?? '') != _text) {
      _text = text ?? '';
      updated();
    }
  }

  String _attr;
  String get attr => _attr;
  set attr(String? attr) {
    if ((attr ?? '') != _attr) {
      _attr = attr ?? '';
      updated();
    }
  }

  String _regexp;
  String get regexp => _regexp;
  set regexp(String? regexp) {
    if ((regexp ?? '') != _regexp) {
      _regexp = regexp ?? '';
      updated();
      regexpReCompile(_regexp);
    }
  }

  RegExp? regexp_;
  bool _opt;
  bool get opt => _opt;
  set opt(bool? opt) {
    if ((opt ?? false) != _opt) {
      _opt = opt ?? false;
      updated();
    }
  }

  RegExp? regexpCompile(String str) {
    try {
      return RegExp(
        str,
        caseSensitive: false,
        dotAll: true,
      );
    } catch (e) {
      return null;
    }
  }

  void regexpReCompile(String? _re) {
    if (_re != null && _re.isNotEmpty && !Context.hasExpr(_re)) {
      regexp_ = regexpCompile(_regexp);
    } else {
      regexp_ = null;
    }
  }

  String _value;
  String get value => _value;
  set value(String? value) {
    if ((value ?? '') != _value) {
      _value = value ?? '';
      updated();
    }
  }

  String _type;
  String get type => _type;
  set type(String? type) {
    if ((type ?? '') != _type) {
      _type = type ?? '';
      updated();
    }
  }

  SelectorItem(Selector? parent, Map json)
      : _selector = json['selector'] as String? ?? '',
        _text = json['text'] as String? ?? '',
        _attr = json['attr'] as String? ?? '',
        _regexp = json['regexp'] as String? ?? '',
        _value = json['value'] as String? ?? '',
        _opt = json['opt'] as bool? ?? false,
        _type = json['type'] as String? ?? 'String',
        super(parent) {
    regexpReCompile(_regexp);
    genItems(json);
  }
  @override
  Object toJson() {
    final out = {
      'selector': selector,
      if (text.isNotEmpty) 'text': text,
      if (attr.isNotEmpty) 'attr': attr,
      if (regexp.isNotEmpty) 'regexp': regexp,
      if (value.isNotEmpty) 'value': value,
      if (opt) 'opt': true,
      if (type != 'String') 'type': type,
      ...items.map((key, value) =>
          MapEntry(key.startsWith('=') ? key : '\$$key', value.toJson())),
    };
    if (out.length == 1) {
      return selector;
    } else {
      return out;
    }
  }
}
