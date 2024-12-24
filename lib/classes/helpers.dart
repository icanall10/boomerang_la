import 'dart:convert';
import 'dart:developer' as developer;

void dd(var data) {
  if (data is String) {
    developer.log('', name: data);

    return;
  }

  if (data is int) {
    developer.log('', name: data.toString());

    return;
  }

  JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  String pretty = encoder.convert(data);

  developer.log('', name: pretty);

  return;
}
