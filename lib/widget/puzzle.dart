import '../providers/puzzle_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/firestore/user.dart';
import '../models/tile.dart';
import '../providers/auth_service.dart';

class Puzzle extends StatefulWidget {
  final double width;

  const Puzzle({super.key, required this.width});

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final IUser? user =
        Provider.of<AuthService>(context, listen: false).fireStoreUser;

    return Consumer<PuzzleGame>(builder: (context, controller, child) {
      return Center(
        child: SizedBox(
          height: widget.width,
          width: widget.width,
          child: Stack(
              children: List.generate(controller.tiles.length, (i) {
            double tileWidth = widget.width / controller.level;
            Tile indexTile = controller.tiles[i];
            Map<String, dynamic> tilePosition =
                indexTile.getPosition(tileWidth);

            var isLast = controller.tiles.last.value == indexTile.value;

            return AnimatedPositioned(
              width: tileWidth,
              height: tileWidth,
              top: tilePosition['y'],
              left: tilePosition['x'],
              duration: const Duration(milliseconds: 150),
              child: IgnorePointer(
                ignoring: indexTile.tileIsWhiteSpace || controller.isWon,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    bool canMoveRight =
                        details.velocity.pixelsPerSecond.dx >= 0 &&
                            indexTile.isLeftOf(controller.whiteSpaceTile);
                    bool canMoveLeft =
                        details.velocity.pixelsPerSecond.dx <= 0 &&
                            indexTile.isRightOf(controller.whiteSpaceTile);
                    bool tileIsMovable =
                        indexTile.isMovable(controller.whiteSpaceTile);
                    if (tileIsMovable && (canMoveLeft || canMoveRight)) {
                      controller.swapTilesAndUpdatePuzzle(
                          indexTile, context, user);
                    }
                  },
                  onVerticalDragEnd: (details) {
                    bool canMoveUp = details.velocity.pixelsPerSecond.dy <= 0 &&
                        indexTile.isBottomOf(controller.whiteSpaceTile);
                    bool canMoveDown =
                        details.velocity.pixelsPerSecond.dy >= 0 &&
                            indexTile.isTopOf(controller.whiteSpaceTile);
                    bool tileIsMovable =
                        indexTile.isMovable(controller.whiteSpaceTile);
                    if (tileIsMovable && (canMoveUp || canMoveDown)) {
                      controller.swapTilesAndUpdatePuzzle(
                          indexTile, context, user);
                    }
                  },
                  onTap: () {
                    bool tileIsMovable =
                        indexTile.isMovable(controller.whiteSpaceTile);
                    if (tileIsMovable) {
                      controller.swapTilesAndUpdatePuzzle(
                          indexTile, context, user);
                    }
                  },
                  child: Card(
                    elevation: controller.tiles[i].tileIsWhiteSpace ? 0 : 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    margin: const EdgeInsets.all(4),
                    color: controller.tiles[i].tileIsWhiteSpace
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.secondary,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: controller.tiles[i].tileIsWhiteSpace
                            ? Colors.transparent
                            : Theme.of(context).colorScheme.secondary,
                        image: !indexTile.tileIsWhiteSpace ? DecorationImage( image: AssetImage("assets/boards/${controller.level}x${controller.level}/${indexTile.value}.png"), fit: BoxFit.cover): null
                      ),
                      child: Text(
                        isLast ? " " : indexTile.value.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          })),
        ),
      );
    });
  }
}
