Flutter Web plugin for Yandex Games Sdk.

## Features

Player data save/load.
Show Fullscreen Ad.
Show Rewarded Ad.

## Getting started

## Installation

```yaml
dependencies:
  ...
  flutter_yandex_games: 0.0.1
```

Add this to your index.html. It's a temporary solution for data saving and will be removed later.

```html
<script>
    function savePlayerData(player, data) {
        player.o.setData(JSON.parse(data))
    }
</script>
```

If you get 404 error for js files in your game after uploading to Yandex, remove
```html
<base href="/">
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