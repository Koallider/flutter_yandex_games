import 'dart:js';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_yandex_games/js_utils.dart';

void main() {
  test('JSObject correctly converted to dart map', () {
    final data = {
      "testString": "String",
      "testInt": 1
    };
    final jsObject = JsObject.jsify(data);

    final result = mapify(jsObject);
    expect(result.length, data.length);
    expect(result["testString"], data["testString"]);
    expect(result["testInt"], data["testInt"]);
  });
}