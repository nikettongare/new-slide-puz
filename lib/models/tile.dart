import './location.dart';

class Tile {
  final int value;
  bool tileIsWhiteSpace;
  final Location correctLocation;
  Location currentLocation;

  Tile({
    required this.value,
    required this.correctLocation,
    required this.currentLocation,
    this.tileIsWhiteSpace = false,
  });

  Map<String, dynamic> getPosition(double tileWidth) {
    return {
      'y': currentLocation.y * tileWidth,
      'x': currentLocation.x * tileWidth
    };
  }

  bool isLeftOf(Tile whiteSpaceTile) {
    return whiteSpaceTile.currentLocation.y == currentLocation.y &&
        whiteSpaceTile.currentLocation.x == currentLocation.x + 1;
  }

  bool isRightOf(Tile whiteSpaceTile) {
    return whiteSpaceTile.currentLocation.y == currentLocation.y &&
        whiteSpaceTile.currentLocation.x == currentLocation.x - 1;
  }

  bool isTopOf(Tile whiteSpaceTile) {
    return whiteSpaceTile.currentLocation.x == currentLocation.x &&
        whiteSpaceTile.currentLocation.y == currentLocation.y + 1;
  }

  bool isBottomOf(Tile whiteSpaceTile) {
    return whiteSpaceTile.currentLocation.x == currentLocation.x &&
        whiteSpaceTile.currentLocation.y == currentLocation.y - 1;
  }

  bool isMovable(Tile whiteSpaceTile) {
    if (tileIsWhiteSpace) {
      return false;
    }
    return isLeftOf(whiteSpaceTile) ||
        isRightOf(whiteSpaceTile) ||
        isBottomOf(whiteSpaceTile) ||
        isTopOf(whiteSpaceTile);
  }

}
