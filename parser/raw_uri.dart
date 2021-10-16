class RawUri implements Uri {
  static final _re =
      RegExp(r'^(([^:\/?#]+):)?(\/\/([^\/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?');
  @override
  late String fragment;
  @override
  late String host;

  @override
  late String path;

  @override
  late int port;

  @override
  late String query;

  @override
  late String scheme;

  RawUri(String url) {
    final m = _re.matchAsPrefix(url);
    if (m == null) {
      throw FormatException('Invalid URL');
    }
    scheme = m.group(2) ?? 'http';
    host = m.group(4) ?? '';
    path = m.group(5) ?? '/';
    query = m.group(7) ?? '';
    fragment = m.group(9) ?? '';

    if (path.isEmpty) {
      path = '/';
    }

    switch (scheme) {
      case 'https':
        port = 443;
        break;
      case 'http':
        port = 80;
        break;
      default:
        port = -1;
    }
  }

  @override
  String get authority => host;

  @override
  // TODO: implement data
  UriData? get data => throw UnimplementedError();

  @override
  bool get hasAbsolutePath => true;

  @override
  bool get hasAuthority => true;

  @override
  bool get hasEmptyPath => path == '/';

  @override
  bool get hasFragment => fragment.isNotEmpty;

  @override
  // TODO: implement hasPort
  bool get hasPort => throw UnimplementedError();

  @override
  bool get hasQuery => query.isNotEmpty;

  @override
  // TODO: implement hasScheme
  bool get hasScheme => true;

  @override
  // TODO: implement isAbsolute
  bool get isAbsolute => throw UnimplementedError();

  @override
  // TODO: implement origin
  String get origin => throw UnimplementedError();

  @override
  List<String> get pathSegments => path.split('/').sublist(1);

  @override
  // TODO: implement queryParameters
  Map<String, String> get queryParameters => throw UnimplementedError();

  @override
  // TODO: implement queryParametersAll
  Map<String, List<String>> get queryParametersAll =>
      throw UnimplementedError();

  @override
  String get userInfo => '';

  @override
  bool isScheme(String _scheme) => _scheme == scheme;

  @override
  Uri normalizePath() {
    // TODO: implement normalizePath
    throw UnimplementedError();
  }

  @override
  Uri removeFragment() {
    if (!hasFragment) {
      return this;
    }
    // TODO: implement removeFragment
    throw UnimplementedError();
  }

  @override
  Uri replace(
      {String? scheme,
      String? userInfo,
      String? host,
      int? port,
      String? path,
      Iterable<String>? pathSegments,
      String? query,
      Map<String, dynamic>? queryParameters,
      String? fragment}) {
    // TODO: implement replace
    throw UnimplementedError();
  }

  @override
  Uri resolve(String reference) {
    // TODO: implement resolve
    throw UnimplementedError();
  }

  @override
  Uri resolveUri(Uri reference) {
    // TODO: implement resolveUri
    throw UnimplementedError();
  }

  @override
  String toFilePath({bool? windows}) {
    // TODO: implement toFilePath
    throw UnimplementedError();
  }

  @override
  String toString() =>
      '$scheme://$host' +
      ((port == 80 && scheme == 'http') || (port == 443 && scheme == 'https')
          ? ''
          : ':$port') +
      path +
      (hasQuery ? '?$query' : '') +
      (hasFragment ? '$fragment' : '');
}
