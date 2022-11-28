import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_yandex_games/flutter_yandex_games.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yandex Games Plugin Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String status = "Initializing...";

  bool initFinished = false;

  @override
  void initState() {
    initYandexGames();
  }

  void initYandexGames() {
    YandexGames.init().then((value) {
      setState(() {
        status = "Yandex Games Sdk Init Successful";
        initFinished = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(status),
          TextButton(
              onPressed: initFinished ? showFullscreenAd : null,
              child: const Text("Show Fullscreen Ad")),
          TextButton(
              onPressed: initFinished ? showRewardedVideoAd : null,
              child: const Text("Show Rewarded Video Ad")),
          TextButton(
              onPressed: initFinished ? savePlayerData : null,
              child: const Text("Save Status To Player Data")),
          TextButton(
              onPressed: initFinished ? getPlayerData : null,
              child: const Text("Load Player Data")),
          TextButton(
              onPressed: initFinished ? canReview : null,
              child: const Text("Call can review")),
          TextButton(
              onPressed: initFinished ? requestReview : null,
              child: const Text("Request Review")),
          TextButton(
              onPressed: initFinished ? isPlayerAuthorized : null,
              child: const Text("Check if player is Authorized")),
          TextButton(
              onPressed: initFinished ? openAuthDialog : null,
              child: const Text("Open Auth Dialog")),
        ],
      ),
    );
  }

  void showFullscreenAd() {
    YandexGames.showFullscreenAd(
      onClose: (wasShown) {
        debugPrint("onClose: $wasShown");
      },
      onError: (error) {
        debugPrint("onError message: $error");
        setState(() {
          status = "Fullscreen Ad Not Loaded";
        });
      },
    );
  }

  void showRewardedVideoAd() {
    YandexGames.showRewardedVideoAd(
      onOpen: () {
        debugPrint("onOpen");
        setState(() {
          status = "Rewarded Video Opened";
        });
      },
      onRewarded: () {
        debugPrint("onRewarded");
        setState(() {
          status = "Rewarded Video Rewarded";
        });
      },
      onClose: () {
        debugPrint("onClose");
      },
      onError: (error) {
        debugPrint("onError message: $error");
        setState(() {
          status = "Rewarded Video Not Loaded";
        });
      },
    );
  }

  void savePlayerData() {
    YandexGames.getPlayer().setData({"status": status});
  }

  void getPlayerData() {
    YandexGames.getPlayer().getData().then((value) {
      setState(() {
        status = "Player Data Received: ${jsonEncode(value)}";
      });
    });
  }

  void canReview() {
    YandexGames.canReview().then((response) {
      setState(() {
        status =
            "Can review value: ${response.value}, reason: ${response.reason}";
      });
    });
  }

  void requestReview() {
    YandexGames.requestReview().then((response) {
      setState(() {
        status = "Requested review. feedbackSent: ${response.feedbackSent}";
      });
    });
  }

  void isPlayerAuthorized() {
    setState(() {
      status = "Player Authorized: ${YandexGames.getPlayer().isAuthorized()}";
    });
  }

  void openAuthDialog() {
    YandexGames.openAuthDialog().then((value) {
      setState(() {
        status = "Player Authorization Success";
      });
    }, onError: (error) {
      setState(() {
        status = "Player Authorization Fail $error";
      });
    });
  }
}
