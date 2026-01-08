library yandexgames.js;

import 'dart:js_interop';

@JS('YaGames.init')
external JSPromise<YaSdk> yaGamesInit();

extension type YaSdk._(JSObject _) implements JSObject {
  external JSPromise<YaPlayer> getPlayer(GetPlayerOptions options);

  external YaAdv get adv;

  external YaAuth get auth;

  external YaFeedback get feedback;

  external Environment get environment;

  external Shortcut get shortcut;

  external Features get features;
}

extension type YaPlayer._(JSObject _) implements JSObject {
  external JSString getUniqueID();

  external void setData(JSAny? data, bool flush);

  external JSPromise<JSObject> getData();

  external bool isAuthorized();
}

extension type LoadingAPIImpl._(JSObject _) implements JSObject {
  external void ready();
}

extension type GameplayAPIImpl._(JSObject _) implements JSObject {
  external void stop();

  external void start();
}

extension type YaAuth._(JSObject _) implements JSObject {
  external JSPromise<JSAny?> openAuthDialog();
}

extension type YaAdv._(JSObject _) implements JSObject {
  external void showFullscreenAdv(ShowFullscreenAdOptions options);

  external void showRewardedVideo(ShowRewardedVideoOptions options);
}

extension type YaFeedback._(JSObject _) implements JSObject {
  external JSPromise<CanReviewResponse> canReview();

  external JSPromise<RequestReviewResponse> requestReview();
}

extension type Shortcut._(JSObject _) implements JSObject {
  external JSPromise<CanShowPromptResponse> canShowPrompt();

  external JSPromise<ShowPromptResponse> showPrompt();
}

extension type Features._(JSObject _) implements JSObject {
  external LoadingAPIImpl? get LoadingAPI;

  external GameplayAPIImpl? get GameplayAPI;
}

extension type GetPlayerOptions._(JSObject _) implements JSObject {
  external bool get scopes;

  external factory GetPlayerOptions({bool scopes});
}

@anonymous
@JS()
@staticInterop
class ShowRewardedVideoOptions {
  external factory ShowRewardedVideoOptions({RewardedVideoCallbacks callbacks});
}

@anonymous
@JS()
@staticInterop
class ShowFullscreenAdOptions {
  external factory ShowFullscreenAdOptions({FullscreenAdCallbacks callbacks});
}

@anonymous
@JS()
@staticInterop
class RewardedVideoCallbacks {
  external factory RewardedVideoCallbacks(
      {JSFunction? onOpen,
      JSFunction? onRewarded,
      JSFunction? onClose,
      JSFunction? onError});
}

@JS()
@anonymous
@staticInterop
class FullscreenAdCallbacks {
  external factory FullscreenAdCallbacks(
      {JSFunction? onOpen, JSFunction? onClose, JSFunction? onError});
}

extension type CanReviewResponse._(JSObject _) implements JSObject {
  external bool get value;

  external String? get reason;
}

extension type RequestReviewResponse._(JSObject _) implements JSObject {
  external bool get feedbackSent;
}

extension type CanShowPromptResponse._(JSObject _) implements JSObject {
  external bool get canShow;
}

extension type ShowPromptResponse._(JSObject _) implements JSObject {
  external String? get outcome;
}

/// Environment variables
///
/// More data https://yandex.ru/dev/games/doc/dg/sdk/sdk-environment.html
extension type Environment._(JSObject _) implements JSObject {
  external App get app;

  external Browser get browser;

  external Locale get i18n;

  /// Custom payload from the game URL.
  ///
  /// https://yandex.ru/games/app/123?payload=test
  external String? get payload;
}

/// Locale related environment variables
extension type Locale._(JSObject _) implements JSObject {
  /// Yandex games interface language in ISO 639-1 format.
  /// Use this property to localize your game.
  external String get lang;

  /// Top level domain value.
  ///
  /// E.g. for the international Yandex Games page the value will be 'com'.
  external String get tld;
}

/// App related environment variables
extension type App._(JSObject _) implements JSObject {
  /// Game ID
  external String get id;
}

/// Browser related environment variables
extension type Browser._(JSObject _) implements JSObject {
  /// Browser language in ISO 639-1 format
  external String get lang;
}
