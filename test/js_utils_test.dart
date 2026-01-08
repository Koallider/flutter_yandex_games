// This test file requires the web platform to run because it uses dart:js_interop
// 
// To run this test:
//   flutter test --platform chrome test/js_utils_test.dart
//
// To exclude this test when running all tests on non-web platforms:
//   flutter test --exclude-tags web
//
// Note: This test file cannot be compiled on non-web platforms due to dart:js_interop dependency

import 'dart:js_interop';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_yandex_games/js_utils.dart';

void main() {
  test('JSObject correctly converted to dart map', () {
    final data = {
      "testString": "String",
      "testInt": 1
    };
    final jsObject = data.jsify() as JSObject;

    final result = mapify(jsObject);
    expect(result.length, data.length);
    expect(result["testString"], data["testString"]);
    expect(result["testInt"], data["testInt"]);
  }, tags: ['web']);
}