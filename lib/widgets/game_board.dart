import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../game/game_logic.dart';

class GameBoard extends StatelessWidget {
  final GameLogic gameLogic;
  final bool showGhost;

  const GameBoard({super.key, required this.gameLogic, this.showGhost = true});

  @override
  Widget build(BuildContext context) {
    List<List<Color?>> board = gameLogic.getBoardWithCurrentTetromino();

    // 获取屏幕尺寸
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;

    // 计算合适的方块尺寸，确保不会溢出
    double maxCellSize = isMobile ? 18.0 : 22.0;
    double availableWidth = isMobile ? screenWidth * 0.85 : screenWidth * 0.4;
    double cellSize = math.min(
      maxCellSize,
      (availableWidth - 20) / GameLogic.boardWidth,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan, width: 3),
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(GameLogic.boardHeight, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(GameLogic.boardWidth, (col) {
              Color? cellColor = board[row][col];
              bool isGhostCell = false;

              // 显示幽灵方块
              if (showGhost && gameLogic.currentTetromino != null) {
                var ghost = gameLogic.getGhostTetromino();
                if (ghost != null && cellColor == null) {
                  List<List<int>> ghostShape = ghost.shape;
                  int relativeRow = row - ghost.y;
                  int relativeCol = col - ghost.x;

                  if (relativeRow >= 0 &&
                      relativeRow < ghostShape.length &&
                      relativeCol >= 0 &&
                      relativeCol < ghostShape[relativeRow].length &&
                      ghostShape[relativeRow][relativeCol] == 1) {
                    isGhostCell = true;
                  }
                }
              }

              return GameCell(
                color: cellColor,
                isGhost: isGhostCell,
                ghostColor: gameLogic.currentTetromino?.color,
                size: cellSize,
              );
            }),
          );
        }),
      ),
    );
  }
}

class GameCell extends StatelessWidget {
  final Color? color;
  final bool isGhost;
  final Color? ghostColor;
  final double size;

  const GameCell({
    super.key,
    this.color,
    this.isGhost = false,
    this.ghostColor,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Border? cellBorder;

    if (color != null) {
      // 实体方块
      backgroundColor = color!;
      cellBorder = Border.all(color: _getBorderColor(color!), width: 1);
    } else if (isGhost && ghostColor != null) {
      // 幽灵方块
      backgroundColor = ghostColor!.withOpacity(0.3);
      cellBorder = Border.all(
        color: ghostColor!.withOpacity(0.6),
        width: 1,
        style: BorderStyle.solid,
      );
    } else {
      // 空格子
      backgroundColor = Colors.grey[900]!;
      cellBorder = Border.all(color: Colors.grey[700]!, width: 0.5);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: cellBorder,
        borderRadius: BorderRadius.circular(1),
      ),
      child: color != null ? _buildBlockHighlight() : null,
    );
  }

  // 为实体方块添加高光效果
  Widget _buildBlockHighlight() {
    return Container(
      margin: EdgeInsets.all(size * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.transparent,
            Colors.black.withOpacity(0.3),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  // 获取方块边框颜色
  Color _getBorderColor(Color blockColor) {
    // 返回比方块颜色更亮的颜色作为边框
    HSLColor hsl = HSLColor.fromColor(blockColor);
    return hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
  }
}
