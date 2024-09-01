import 'dart:async';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import '../models/firestore/user.dart';
import '../widget/dialogs/win_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/tile.dart';
import '../services/admob/ads_controller.dart';
import '../services/firestore.dart';
import '../widget/dialogs/my_snackbar.dart';
import 'auth_service.dart';

class PuzzleGame with ChangeNotifier {
  int _level = 4;
  List<Tile> _tiles = [];
  bool _isWon = false;
  int _movesCount = 0;
  late Timer _timer;
  int _timeTaken = 0;
  bool _isActive = false;
  final List<int> _availableLayouts = [3, 4, 5, 6];

  int get level => _level;
  List<Tile> get tiles => _tiles;
  bool get isWon => _isWon;
  int get movesCount => _movesCount;
  int get timeTaken => _timeTaken;
  List<int> get availableLayouts => _availableLayouts;
  AdsController adsController = AdsController();
  PuzzleGame() {
    generateTiles();
    shuffleTiles();
    adsController.createInterstitialAd();
    adsController.createRewardedAd();
  }

  void playSound(String fileName) async {
    AssetSource source = AssetSource("audio/$fileName.mp3");
    await AudioPlayer().play(source);
  }

  void changeLevel(level) {
    _level = level;
    _tiles = [];
    generateTiles();
    restartGame();
  }

  void generateTiles() {
    int value = 1;

    for (int i = 0; i < _level; i++) {
      for (int j = 0; j < _level; j++) {
        _tiles.add(Tile(
          value: value,
          correctLocation: Location(x: j, y: i),
          currentLocation: Location(x: j, y: i),
          tileIsWhiteSpace: false,
        ));
        value++;
      }
    }
    _tiles.last.tileIsWhiteSpace = true;
  }

  void shuffleTiles() {
    adsController.showInterstitialAd();
    // var temp = _tiles[14].correctLocation;
    // _tiles[14].currentLocation = _tiles[15].correctLocation;
    // _tiles[15].currentLocation = temp;
    List<Location> listOfCorrectLocations = _tiles.map((element) {
      return element.correctLocation;
    }).toList();

    math.Random random = math.Random();
    listOfCorrectLocations.shuffle(random);

    for (var i = 0; i < _tiles.length; i++) {
      _tiles[i].currentLocation = listOfCorrectLocations[i];
    }
    notifyListeners();
  }

  void restartGame() {
    _movesCount = 0;
    _timeTaken = 0;
    _isWon = false;

    if (_isActive) {
      _timer.cancel();
      _isActive = false;
    }

    shuffleTiles();
  }

  Tile get whiteSpaceTile => _tiles.firstWhere((tile) => tile.tileIsWhiteSpace);

  void swapTilesAndUpdatePuzzle(
      Tile tile, BuildContext context, IUser? oldUser) {
    if (!_isWon && _movesCount == 0 && _timeTaken == 0) {
      _isActive = true;
      startTimer();
    }

    var movedTileLoc = tile.currentLocation;
    var whiteSpaceTileLoc = whiteSpaceTile.currentLocation;

    tile.currentLocation = whiteSpaceTileLoc;
    whiteSpaceTile.currentLocation = movedTileLoc;

    bool isAtCorrectLoc = tile.correctLocation.x == tile.currentLocation.x &&
        tile.correctLocation.y == tile.currentLocation.y;

    if (isAtCorrectLoc) {
      checkIsWon(context, oldUser);
    }

    _movesCount++;
    playSound("slide");
    notifyListeners();
  }

  Future<void> checkIsWon(BuildContext context, IUser? oldUser) async {
    List<Tile> tilesCheck = _tiles
        .where((tile) =>
            tile.correctLocation.x != tile.currentLocation.x ||
            tile.correctLocation.y != tile.currentLocation.y)
        .toList();

    if (tilesCheck.isEmpty) {
      _isWon = true;
      _timer.cancel();
      _isActive = false;
      notifyListeners();
      // update user score to firebase
      if (oldUser != null) {
        try {
          FireStoreService fireStoreService = FireStoreService();
          IUser updatedUser = await fireStoreService.updateScore(
              uid: oldUser.uid!,
              steps: _movesCount,
              timeTaken: _timeTaken,
              oldUser: oldUser);
          if (context.mounted) {
            Provider.of<AuthService>(context, listen: false)
                .setFireStoreUser(updatedUser);
          }
        } catch (error) {
          showSnackBar(
              context: context,
              text: "Unable to update code to database.",
              duration: 5);
        }
      }

      if (context.mounted) {
        adsController.showRewardedAd();
        showWinDialog(context);
      }
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      _timeTaken++;
      notifyListeners();
    });
  }

  void showWinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return WinGameDialog(
          movesCount: _movesCount.toString(),
          timeTaken: _timeTaken.toString(),
          onRestartAction: () {
            restartGame();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
