import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hls_parser/hls_parser.dart';

void main() {
  const MethodChannel channel = MethodChannel('hls_parser');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await HlsParser.platformVersion, '42');
  });
}
