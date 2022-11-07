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
      title: 'Flutter Demo',
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

  void initYandexGames(){
    YandexGames.init().then((value){
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
          TextButton(onPressed: initFinished ? showFullscreenAd : null, child: const Text("Show Fullscreen Ad")),
          TextButton(onPressed: initFinished ? showRewardedVideoAd : null, child: const Text("Show Rewarded Video Ad")),

          TextButton(onPressed: initFinished ? savePlayerData : null, child: const Text("Save Status To Player Data")),
          TextButton(onPressed: initFinished ? getPlayerData : null, child: const Text("Load Player Data")),
        ],
      ),
    );
  }

  void showFullscreenAd(){
    YandexGames.showFullscreenAd();
  }

  void showRewardedVideoAd() {
    YandexGames.showRewardedVideoAd(
      onOpen: (){
        setState(() {
          status = "Rewarded Video Open";
        });
      },
      onRewarded: (){
        setState(() {
          status = "Rewarded Video Rewarded";
        });
      },
      onClose: (){

      },
      onError: (){
        setState(() {
          status = "Rewarded Video Not Loaded";
        });
      },
    );
  }

  void savePlayerData(){
    YandexGames.getPlayer().setData({"status": status});
  }

  void getPlayerData(){
    YandexGames.getPlayer().getData().then((value) {
      setState(() {
        status = "Player Data Received: ${jsonEncode(value)}";
      });
    });
  }
}
