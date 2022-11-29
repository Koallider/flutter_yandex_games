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
    _player = await _loadPlayer();
    return true;
  }

  static Future<Player> _loadPlayer() async {
    return Player(await promiseToFuture(
        _yaSdk.getPlayer(_GetPlayerOptions(scopes: false))));
  }

  static late _YaSdk _yaSdk;
  static late Player _player;

  static Player getPlayer() {
    return _player;
  }

  ///Displays Fullscreen AD
  static void showFullscreenAd(
      {Function(bool wasShown)? onClose, Function(dynamic error)? onError}) {
    _yaSdk.adv.showFullscreenAdv(_ShowFullscreenAdOptions(
        callbacks: _FullscreenAdCallbacks(
            onClose: _wrapCallback<Function>(onClose),
            onError: _wrapCallback<Function>(onError))));
  }

  /// Displays Rewarded Video AD and calls callback functions on Ad events
  static void showRewardedVideoAd(
      {Function? onOpen,
      Function? onRewarded,
      Function? onClose,
      Function(dynamic error)? onError}) {
    _yaSdk.adv.showRewardedVideo(_ShowRewardedVideoOptions(
        callbacks: _RewardedVideoCallbacks(
      onOpen: _wrapCallback<Function>(onOpen),
      onRewarded: _wrapCallback<Function>(onRewarded),
      onClose: _wrapCallback<Function>(onClose),
      onError: _wrapCallback<Function>(onError),
    )));
  }

  /// Asks sdk if [requestReview] can be called
  ///
  /// Call this before you call [requestReview]
  /// If [response.value] is true you can call requestReview.
  /// If it's false. [response.reason] will have information
  /// why it can't be called.
  ///
  /// More info:
  /// https://yandex.ru/dev/games/doc/dg/sdk/sdk-review.html
  static Future<CanReviewResponse> canReview() async {
    return promiseToFuture<CanReviewResponse>(_yaSdk.feedback.canReview());
  }

  /// Displays review dialog.
  ///
  /// Returns [feedbackSent] true if user reviewed the game.
  /// And false if user closed the review dialog.
  static Future<RequestReviewResponse> requestReview() async {
    return promiseToFuture<RequestReviewResponse>(
        _yaSdk.feedback.requestReview());
  }

  /// Opens Authentication dialog.
  static Future<bool> openAuthDialog() async {
    await promiseToFuture(_yaSdk.auth.openAuthDialog());
    _player = await _loadPlayer();
    return true;
  }

  static Environment get environment {
    return _yaSdk.environment;
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

  /// Returns the player authorization mode.
  ///
  /// Yandex Games SDK returns mode 'lite' if player is not authorized.
  bool isAuthorized() {
    return player.getMode() != 'lite';
  }
}

///Wraps callbacks so they can be called from JS
F? _wrapCallback<F extends Function>(F? f) {
  if (f != null) {
    return allowInterop<F>(f);
  }
  return f;
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

  external String getMode();
}

@JS("YaSdk")
class _YaSdk {
  external Object getPlayer(_GetPlayerOptions options);

  external _YaAdv get adv;

  external _YaAuth get auth;

  external _YaFeedback get feedback;

  external Environment get environment;
}

@JS("Auth")
class _YaAuth {
  external JsObject openAuthDialog();
}

@JS("Adv")
class _YaAdv {
  external void showFullscreenAdv(_ShowFullscreenAdOptions options);

  external void showRewardedVideo(_ShowRewardedVideoOptions options);
}

@JS("Feedback")
class _YaFeedback {
  external JsObject canReview();

  external JsObject requestReview();
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
class _ShowFullscreenAdOptions {
  external factory _ShowFullscreenAdOptions({_FullscreenAdCallbacks callbacks});
}

@anonymous
@JS()
class _RewardedVideoCallbacks {
  external factory _RewardedVideoCallbacks(
      {Function? onOpen,
      Function? onRewarded,
      Function? onClose,
      Function? onError});
}

@anonymous
@JS()
class _FullscreenAdCallbacks {
  external factory _FullscreenAdCallbacks(
      {Function? onClose, Function? onError});
}

@JS()
class CanReviewResponse {
  external bool get value;
  external String get reason;
}

@JS()
class RequestReviewResponse {
  external bool get feedbackSent;
}

/// Environment variables
///
/// More data https://yandex.ru/dev/games/doc/dg/sdk/sdk-environment.html
@JS()
class Environment {
  external App get app;
  external Browser get browser;
  external Locale get i18n;

  /// Custom payload from the game URL.
  ///
  /// https://yandex.ru/games/app/123?payload=test
  external String? get payload;
}

/// Locale related environment variables
@JS()
class Locale {
  /// Yandex games interface language in ISO 639-1 format.
  /// Use this property to localize your game.
  external String get lang;

  /// Top level domain value.
  ///
  /// E.g. for the international Yandex Games page the value will be 'com'.
  external String get tld;
}

/// App related environment variables
@JS()
class App {
  /// Game ID
  external String get id;
}

/// Browser related environment variables
@JS()
class Browser {
  /// Browser language in ISO 639-1 format
  external String get lang;
}
