import 'dart:convert';
import 'dart:js';

///Wraps callbacks so they can be called from JS
F? wrapCallback<F extends Function>(F? f) {
  if (f != null) {
    return allowInterop<F>(f);
  }
  return f;
}

///Converts JS object to Map
Map mapify(JsObject obj) {
  return jsonDecode(context['JSON'].callMethod('stringify', [obj]));
}
