Flutter Web plugin for Yandex Games Sdk.

## Features

This is the minimal sufficient level of features I need for My project. 
Feel free to contribute. Or open an issue if you need more features.

Player data save/load.
Show Fullscreen Ad.
Show Rewarded Ad.

## Getting started

## Installation

Add this to your index.html

```html
<script src="https://yandex.ru/games/sdk/v2"></script>
```

```yaml
dependencies:
  ...
  flutter_yandex_games: 0.0.1
```

If you get 404 error for js files in your game after uploading to Yandex, remove
```html
<base href="$FLUTTER_BASE_HREF">
```
from your index.html

## Usage

### Init Sdk

```dart
await YandexGames.init();
```

### Get Player Data

```dart
var player = YandexGames.getPlayer();
var data = player.getData()
```

### Set Player Data

```dart
var player = YandexGames.getPlayer();
player.setData({"gold": 100});
```

### Show Fullscreen Ad

```dart
YandexGames.showFullscreenAd()
```

### Show Rewarded Video Ad

```dart
YandexGames.showRewardedVideoAd(
  onOpen: (){
    debugPrint("rewardedVideo onOpen");
  },
  onRewarded: (){
    //Give reward
  },
  onClose: (){
    debugPrint("rewardedVideo onClosed");
  },
  onError: (){
    //Show error
  },
);
```
