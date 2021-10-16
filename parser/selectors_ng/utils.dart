/// Очистка всех White-space символов
String rws(String str) => str.replaceAll(_reWs, ' ').trim();
final _reWs = RegExp(r'[\t\n\r ]+');
