import 'dart:async';

import 'package:flutter/services.dart';

class HlsParser {
  static const MethodChannel _channel =
      const MethodChannel('hls_parser');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
