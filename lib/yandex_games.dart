@JS()
library yandex_games.js;

import 'dart:convert';
import 'dart:js';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:js/js.dart';

void initializeYandexGamesPlugin() {}

Map mapify(JsObject obj) {
  return jsonDecode(context['JSON'].callMethod('stringify', [obj]));
}

class YandexGames {
  static Future<bool> init() async {
    _yaSdk = await promiseToFuture(YaGamesJs.init());
    _player = Player(await promiseToFuture(
        _yaSdk.getPlayer(GetPlayerOptions(scopes: false))));
    return true;
  }

  static late YaSdk _yaSdk;
  static late Player _player;

  static Player getPlayer() {
    return _player;
  }

  static void showFullscreenAd() {
    _yaSdk.adv.showFullscreenAdv();
  }

  static void showRewardedVideoAd(
      {required Function onOpen,
      required Function onRewarded,
      required Function onClose,
      required Function onError}) {
    _yaSdk.adv.showRewardedVideo(ShowRewardedVideoOptions(
      callbacks: RewardedVideoCallbacks(
        onOpen: allowInterop<Function>(onOpen),
        onRewarded: allowInterop<Function>(onRewarded),
        onClose: allowInterop<Function>(onClose),
        onError: allowInterop<Function>(onError),
      )
    ));
  }
}

class Player {
  YaPlayer player;

  Player(this.player);

  String getUniqueID() => player.getUniqueID();

  //data from yandex and data after setData is different. and sometimes has fields "o" and "_js\$_jsObject".
  //todo fix that
  void setData(Map<dynamic, dynamic> data, {bool flush = false}) {
    var encodedData = context['JSON'].callMethod('parse', [jsonEncode(data)]);
    //debugPrint(encodedData);
    context.callMethod("savePlayerData", [player, jsonEncode(data)]);
    //player.setData(context['JSON'].callMethod('parse', [encodedData]), flush);
  }

  Future<Map<dynamic, dynamic>> getData() async {
    JsObject data = await promiseToFuture<JsObject>(player.getData());
    //todo fix this shit
    var map = mapify(data);
    debugPrint("Map content: ${map.toString()}");
    if (map["o"] != null) {
      return map["o"];
    }
    return map;
  }
}

@JS("YaGames")
class YaGamesJs {
  external static Object init();
}

@JS("Player")
class YaPlayer {
  external String getUniqueID();

  external void setData(Object data, bool flush);

  external JsObject getData();
}

@JS("YaSdk")
class YaSdk {
  external Object getPlayer(GetPlayerOptions options);

  external YaAdv get adv;
}

@JS("Adv")
class YaAdv {
  external void showFullscreenAdv();

  external void showRewardedVideo(ShowRewardedVideoOptions options);
}

@anonymous
@JS()
class GetPlayerOptions {
  external bool get scopes;

  external factory GetPlayerOptions({bool scopes});
}

@anonymous
@JS()
class ShowRewardedVideoOptions {
  external factory ShowRewardedVideoOptions({RewardedVideoCallbacks callbacks});
}

@anonymous
@JS()
class RewardedVideoCallbacks {
  external factory RewardedVideoCallbacks(
      {Function onOpen,
        Function onRewarded,
        Function onClose,
        Function onError});
}
