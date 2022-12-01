import 'dart:js';
import 'dart:js_util';

import 'yandex_games_js_proxy.dart';
import 'js_utils.dart';

class YandexGames {
  /// Initializes the Yandex Games sdk and gets the player object.
  /// Call this on start of your application.
  static Future<bool> init() async {
    _yaSdk = await promiseToFuture(YaGamesJs.init());
    _player = await _loadPlayer();
    return true;
  }

  static Future<Player> _loadPlayer() async {
    return Player(await promiseToFuture(
        _yaSdk.getPlayer(GetPlayerOptions(scopes: false))));
  }

  static late YaSdk _yaSdk;
  static late Player _player;

  static Player getPlayer() {
    return _player;
  }

  ///Displays Fullscreen AD
  static void showFullscreenAd(
      {Function(bool wasShown)? onClose, Function(dynamic error)? onError}) {
    _yaSdk.adv.showFullscreenAdv(ShowFullscreenAdOptions(
        callbacks: FullscreenAdCallbacks(
            onClose: wrapCallback<Function>(onClose),
            onError: wrapCallback<Function>(onError))));
  }

  /// Displays Rewarded Video AD and calls callback functions on Ad events
  static void showRewardedVideoAd(
      {Function? onOpen,
      Function? onRewarded,
      Function? onClose,
      Function(dynamic error)? onError}) {
    _yaSdk.adv.showRewardedVideo(ShowRewardedVideoOptions(
        callbacks: RewardedVideoCallbacks(
      onOpen: wrapCallback<Function>(onOpen),
      onRewarded: wrapCallback<Function>(onRewarded),
      onClose: wrapCallback<Function>(onClose),
      onError: wrapCallback<Function>(onError),
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

  /// Checks if it's possible to add a shortcut.
  static Future<bool> canShowShortcutPrompt() async {
    var response = await promiseToFuture<CanShowPromptResponse>(
      _yaSdk.shortcut.canShowPrompt()
    );
    return response.canShow;
  }

  /// Shows a prompt to add a shortcut to desktop.
  ///
  /// Use [canShowShortcutPrompt] before calling this method, because
  /// it's not always possible to add a shortcut.
  ///
  /// Will return true in case of the accepted prompt.
  static Future<bool> showShortcutPrompt() async {
    var response = await promiseToFuture<ShowPromptResponse>(
        _yaSdk.shortcut.showPrompt()
    );
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
    var map = mapify(data);
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