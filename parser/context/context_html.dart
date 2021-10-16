import 'package:client/log.dart';
import 'package:client/src/log/_.dart';
import 'package:html/dom.dart';

import 'context.dart';

export 'package:html/dom.dart';

export 'context.dart';

class HtmlContext extends Context {
  late Element el;

  @override
  Object? getValueInternal(String key) {
    switch (key) {
      case 'el':
        return el;
    }
    return super.getValueInternal(key);
  }

  @override
  Context contextFactory({
    required String label,
    required covariant HtmlContext parent,
    required Logger logger,
    Map<String, Object?>? values,
  }) =>
      HtmlContext(label: label, values: values, parent: parent, logger: logger);

  HtmlContext({
    required String label,
    HtmlContext? parent,
    required Logger logger,
    Map<String, Object?>? values,
  }) : super(
          label: label,
          values: values,
          parent: parent,
          logger: logger,
        );

  @override
  HtmlContext push({required String label, Map<String, Object?>? values}) =>
      (super.push(label: label, values: values) as HtmlContext)..el = el;
}
