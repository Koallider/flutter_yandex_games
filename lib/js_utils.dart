import 'dart:js_interop';

///Converts JS object to Map
Map<dynamic, dynamic> mapify(JSAny? obj) {
  return obj.dartify() as Map<dynamic, dynamic>;
}
