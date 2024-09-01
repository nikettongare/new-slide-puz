import 'dart:io';
import 'package:image/image.dart';

void main() async {
  String packageName = "com.useapi.slide_puzzle";
  // change_app_package_name
  // flutter_launcher_icons
  // flutter_native_splash
}


void generateAssets () {
  final String currentDir = Directory.current.path;

  final List<int> gridSizes = [];

  for (int size in [3, 4, 5, 6]) {
    final Directory directory =
    Directory('$currentDir/assets/boards/${size}x$size');
    if (!directory.existsSync()) {
      gridSizes.add(size);
    }
  }

  if (gridSizes.isEmpty) return;

  // Load image as an asset
  final String boardPath = '$currentDir/assets/boards/board.png';

  final File imageFile = File(boardPath);
  if (!imageFile.existsSync()) {
    print('File not found at $boardPath');
    return;
  }

  final image = decodeImage(imageFile.readAsBytesSync());
  if (image == null) {
    print('Could not decode image.');
    return;
  }

  for (int gridSize in gridSizes) {
    int pieceWidth = (image.width / gridSize).round();
    int pieceHeight = (image.height / gridSize).round();

    // Create output directory for this grid size
    final outputDir = Directory('$currentDir/assets/boards/${gridSize}x$gridSize');
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final piece = copyCrop(
          image,
          x: x * pieceWidth,
          y: y * pieceHeight,
          width: pieceWidth,
          height: pieceHeight,
        );        final outputPath = 'assets/boards/${gridSize}x$gridSize/${y * gridSize + x + 1}.png';
        File(outputPath).writeAsBytesSync(encodePng(piece));
        print('Generated: $outputPath');
      }
    }
  }

  print('All pieces generated successfully.');
}

