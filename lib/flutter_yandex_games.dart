import 'dart:js_interop';

import 'js_utils.dart';
import 'yandex_games_js_proxy.dart';

class YandexGames {
  /// Initializes the Yandex Games sdk and gets the player object.
  /// Call this on start of your application.
  static Future<bool> init() async {
    _yaSdk = await yaGamesInit().toDart;
    _player = await _loadPlayer();
    _loadingApi = LoadingApi(_yaSdk);
    _gameplayApi = GameplayApi(_yaSdk);
    return true;
  }

  static Future<Player> _loadPlayer() async {
    return Player(
        await _yaSdk.getPlayer(GetPlayerOptions(scopes: false)).toDart);
  }

  static late YaSdk _yaSdk;
  static late Player _player;
  static late LoadingApi _loadingApi;
  static late GameplayApi _gameplayApi;

  static Player getPlayer() {
    return _player;
  }

  static LoadingApi get loadingApi => _loadingApi;

  static GameplayApi get gameplayApi => _gameplayApi;

  ///Displays Fullscreen AD
  static void showFullscreenAd(
      {void Function()? onOpen,
      void Function(bool wasShown)? onClose,
      void Function(dynamic error)? onError}) {
    _yaSdk.adv.showFullscreenAdv(ShowFullscreenAdOptions(
        callbacks: FullscreenAdCallbacks(
      onOpen: onOpen?.toJS,
      onClose: onClose?.toJS,
      onError: ((JSAny? error) {
        onError?.call(mapify(error));
      } as void Function(JSAny?)).toJS,
    )));
  }

  /// Displays Rewarded Video AD and calls callback functions on Ad events
  static void showRewardedVideoAd(
      {void Function()? onOpen,
      void Function()? onRewarded,
      void Function()? onClose,
      void Function(dynamic error)? onError}) {
    _yaSdk.adv.showRewardedVideo(ShowRewardedVideoOptions(
        callbacks: RewardedVideoCallbacks(
      onOpen: onOpen?.toJS,
      onRewarded: onRewarded?.toJS,
      onClose: onClose?.toJS,
      onError: ((JSAny? error) {
        onError?.call(mapify(error));
      } as void Function(JSAny?)).toJS,
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
    return _yaSdk.feedback.canReview().toDart;
  }

  /// Displays review dialog.
  ///
  /// Returns [feedbackSent] true if user reviewed the game.
  /// And false if user closed the review dialog.
  static Future<RequestReviewResponse> requestReview() async {
    return _yaSdk.feedback.requestReview().toDart;
  }

  /// Opens Authentication dialog.
  static Future<bool> openAuthDialog() async {
    await _yaSdk.auth.openAuthDialog().toDart;
    _player = await _loadPlayer();
    return true;
  }

  /// Checks if it's possible to add a shortcut.
  static Future<bool> canShowShortcutPrompt() async {
    var response = await _yaSdk.shortcut.canShowPrompt().toDart;
    return response.canShow;
  }

  /// Shows a prompt to add a shortcut to desktop.
  ///
  /// Use [canShowShortcutPrompt] before calling this method, because
  /// it's not always possible to add a shortcut.
  ///
  /// Will return true in case of the accepted prompt.
  static Future<bool> showShortcutPrompt() async {
    var response = await _yaSdk.shortcut.showPrompt().toDart;
    return response.outcome == "accepted";
  }

  /// Contains Yandex Games environment variables.
  ///
  /// More details: https://yandex.com/dev/games/doc/dg/sdk/sdk-environment.html
  static Environment get environment {
    return _yaSdk.environment;
  }
}

class Player {
  YaPlayer player;

  Player(this.player);

  //Returns player's ID
  String getUniqueID() => player.getUniqueID().toString();

  /// Sets player data.
  ///
  /// Be sure to include all data when you use it.
  /// Data will not be merged with existing data.
  /// If [flush] is true sends the data immediately.
  void setData(Map<dynamic, dynamic> data, {bool flush = false}) {
    var newData = data.jsify();
    player.setData(newData, flush);
  }

  /// Sets player data.
  ///
  /// Be sure to include all data when you use it.
  /// Data will not be merged with existing data.
  Future<Map<dynamic, dynamic>> getData() async {
    JSObject data = await player.getData().toDart;
    var map = mapify(data);
    return map;
  }

  /// Returns the player authorization mode.
  ///
  /// Yandex Games SDK returns mode 'lite' if player is not authorized.
  bool isAuthorized() {
    return player.isAuthorized();
  }
}

class LoadingApi {
  final YaSdk _yaSdk;

  LoadingApi(this._yaSdk);

  /// Method should be called when all resources are loaded and the game is ready for user interaction.
  void ready() {
    _yaSdk.features.LoadingAPI?.ready();
  }
}

class GameplayApi {
  final YaSdk _yaSdk;

  GameplayApi(this._yaSdk);

  /// method should be called in cases where the player starts or resumes gameplay:
  /// - Starting a level;
  /// - Closing a menu;
  /// - Unpausing the game;
  /// - Resuming the game after an advertisement;
  /// - Returning to the current browser tab.
  /// - Ensure that after sending the GameplayAPI.start() event, the gameplay is immediately started.
  void start() {
    _yaSdk.features.GameplayAPI?.start();
  }

  /// Method should be called in cases where the player pauses or ends gameplay:
  /// - Completing a level or losing;
  /// - Opening a menu;
  /// - Pausing the game;
  /// - Displaying fullscreen or rewarded advertisements;
  /// - Switching to another browser tab.
  void stop() {
    _yaSdk.features.GameplayAPI?.stop();
  }
}
