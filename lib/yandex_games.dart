@JS()
library yandex_games.js;

import 'dart:convert';
import 'dart:js';
import 'dart:js_util';

import 'package:js/js.dart';

class YandexGames {
  /// Initializes the Yandex Games sdk and gets the player object.
  /// Call this on start of your application.
  static Future<bool> init() async {
    _yaSdk = await promiseToFuture(_YaGamesJs.init());
    _player = Player(await promiseToFuture(
        _yaSdk.getPlayer(_GetPlayerOptions(scopes: false))));
    return true;
  }

  static late _YaSdk _yaSdk;
  static late Player _player;

  static Player getPlayer() {
    return _player;
  }

  ///Displays Fullscreen AD
  static void showFullscreenAd() {
    _yaSdk.adv.showFullscreenAdv();
  }

  /// Displays Rewarded Video AD and calls callback functions on Ad events
  static void showRewardedVideoAd(
      {required Function onOpen,
      required Function onRewarded,
      required Function onClose,
      required Function onError}) {
    _yaSdk.adv.showRewardedVideo(_ShowRewardedVideoOptions(
        callbacks: _RewardedVideoCallbacks(
      onOpen: allowInterop<Function>(onOpen),
      onRewarded: allowInterop<Function>(onRewarded),
      onClose: allowInterop<Function>(onClose),
      onError: allowInterop<Function>(onError),
    )));
  }
}

class Player {
  _YaPlayer player;

  Player(this.player);

  //Returns player's ID
  String getUniqueID() => player.getUniqueID();

  /// Sets player data.
  ///
  /// Be sure to include all data when you use it.
  /// Data will not be merged with existing data.
  /// If [flush] is true sends the data immediately.
  void setData(Map<dynamic, dynamic> data, {bool flush = false}) {
    var newData = jsify(data);
    player.setData(newData, flush);
  }

  /// Sets player data.
  ///
  /// Be sure to include all data when you use it.
  /// Data will not be merged with existing data.
  Future<Map<dynamic, dynamic>> getData() async {
    JsObject data = await promiseToFuture<JsObject>(player.getData());
    var map = _mapify(data);
    //Dart objects contain a JS object in 'o' field? Have to do this for now.
    if (map["o"] != null) {
      return map["o"];
    }
    return map;
  }
}

///Converts JS object to Map
Map _mapify(JsObject obj) {
  return jsonDecode(context['JSON'].callMethod('stringify', [obj]));
}

@JS("YaGames")
class _YaGamesJs {
  external static Object init();
}

@JS("Player")
class _YaPlayer {
  external String getUniqueID();

  external void setData(JsObject data, bool flush);

  external JsObject getData();
}

@JS("YaSdk")
class _YaSdk {
  external Object getPlayer(_GetPlayerOptions options);

  external _YaAdv get adv;
}

@JS("Adv")
class _YaAdv {
  external void showFullscreenAdv();

  external void showRewardedVideo(_ShowRewardedVideoOptions options);
}

@anonymous
@JS()
class _GetPlayerOptions {
  external bool get scopes;

  external factory _GetPlayerOptions({bool scopes});
}

@anonymous
@JS()
class _ShowRewardedVideoOptions {
  external factory _ShowRewardedVideoOptions(
      {_RewardedVideoCallbacks callbacks});
}

@anonymous
@JS()
class _RewardedVideoCallbacks {
  external factory _RewardedVideoCallbacks(
      {Function onOpen,
      Function onRewarded,
      Function onClose,
      Function onError});
}
