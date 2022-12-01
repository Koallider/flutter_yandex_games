@JS()
library yandexgames.js;

import 'dart:js';
import 'package:js/js.dart';

@JS("YaGames")
class YaGamesJs {
  external static Object init();
}

@JS("Player")
class YaPlayer {
  external String getUniqueID();

  external void setData(JsObject data, bool flush);

  external JsObject getData();

  external String getMode();
}

@JS("YaSdk")
class YaSdk {
  external Object getPlayer(GetPlayerOptions options);

  external YaAdv get adv;

  external YaAuth get auth;

  external YaFeedback get feedback;

  external Environment get environment;

  external Shortcut get shortcut;
}

@JS("Auth")
class YaAuth {
  external JsObject openAuthDialog();
}

@JS("Adv")
class YaAdv {
  external void showFullscreenAdv(ShowFullscreenAdOptions options);

  external void showRewardedVideo(ShowRewardedVideoOptions options);
}

@JS("Feedback")
class YaFeedback {
  external JsObject canReview();

  external JsObject requestReview();
}

@JS()
class Shortcut {
  external JsObject canShowPrompt();

  external JsObject showPrompt();
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
class ShowFullscreenAdOptions {
  external factory ShowFullscreenAdOptions({FullscreenAdCallbacks callbacks});
}

@anonymous
@JS()
class RewardedVideoCallbacks {
  external factory RewardedVideoCallbacks(
      {Function? onOpen,
      Function? onRewarded,
      Function? onClose,
      Function? onError});
}

@anonymous
@JS()
class FullscreenAdCallbacks {
  external factory FullscreenAdCallbacks(
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

@JS()
class CanShowPromptResponse {
  external bool get canShow;
}

@JS()
class ShowPromptResponse {
  external String get outcome;
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
