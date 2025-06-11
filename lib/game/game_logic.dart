import 'dart:math';
import 'package:flutter/material.dart';
import '../models/tetromino.dart';

class GameLogic {
  static const int boardWidth = 10; // 改回10，减少溢出问题
  static const int boardHeight = 20;

  // 游戏板
  List<List<Color?>> board;

  // 游戏状态
  GameState gameState = GameState.playing;
  int score = 0;
  int lines = 0;
  int level = 1;

  // 当前和下一个方块
  TetrominoState? currentTetromino;
  TetrominoType? nextType;

  final Random _random = Random();

  GameLogic() : board = _createEmptyBoard();

  // 创建空游戏板
  static List<List<Color?>> _createEmptyBoard() {
    return List.generate(
      boardHeight,
      (_) => List.generate(boardWidth, (_) => null),
    );
  }

  // 初始化游戏
  void initGame() {
    board = _createEmptyBoard();
    score = 0;
    lines = 0;
    level = 1;
    gameState = GameState.playing;

    _spawnNewTetromino();
    _generateNextTetromino();
  }

  // 生成新方块
  void _spawnNewTetromino() {
    TetrominoType type;
    if (nextType != null) {
      type = nextType!;
    } else {
      type = _getRandomTetrominoType();
    }

    currentTetromino = TetrominoState(type: type, x: boardWidth ~/ 2 - 1, y: 0);

    _generateNextTetromino();

    // 检查游戏是否结束
    if (isCollision(currentTetromino!)) {
      gameState = GameState.gameOver;
    }
  }

  // 生成下一个方块类型
  void _generateNextTetromino() {
    nextType = _getRandomTetrominoType();
  }

  // 获取随机方块类型
  TetrominoType _getRandomTetrominoType() {
    return TetrominoType.values[_random.nextInt(TetrominoType.values.length)];
  }

  // 检查碰撞
  bool isCollision(TetrominoState tetromino) {
    List<List<int>> shape = tetromino.shape;

    for (int row = 0; row < shape.length; row++) {
      for (int col = 0; col < shape[row].length; col++) {
        if (shape[row][col] == 1) {
          int boardX = tetromino.x + col;
          int boardY = tetromino.y + row;

          // 检查边界
          if (boardX < 0 || boardX >= boardWidth || boardY >= boardHeight) {
            return true;
          }

          // 检查是否与已放置的方块碰撞
          if (boardY >= 0 && board[boardY][boardX] != null) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // 方块下落
  bool dropTetromino() {
    if (currentTetromino == null || gameState != GameState.playing) {
      return false;
    }

    TetrominoState newState = currentTetromino!.move(0, 1);

    if (!isCollision(newState)) {
      currentTetromino = newState;
      return true;
    } else {
      _placeTetromino();
      _clearLines();
      _spawnNewTetromino();
      return false;
    }
  }

  // 放置方块到游戏板
  void _placeTetromino() {
    if (currentTetromino == null) return;

    List<List<int>> shape = currentTetromino!.shape;
    Color color = currentTetromino!.color;

    for (int row = 0; row < shape.length; row++) {
      for (int col = 0; col < shape[row].length; col++) {
        if (shape[row][col] == 1) {
          int boardX = currentTetromino!.x + col;
          int boardY = currentTetromino!.y + row;

          if (boardY >= 0 &&
              boardY < boardHeight &&
              boardX >= 0 &&
              boardX < boardWidth) {
            board[boardY][boardX] = color;
          }
        }
      }
    }
  }

  // 清除满行
  void _clearLines() {
    int linesCleared = 0;

    for (int row = boardHeight - 1; row >= 0; row--) {
      bool isLineFull = true;
      for (int col = 0; col < boardWidth; col++) {
        if (board[row][col] == null) {
          isLineFull = false;
          break;
        }
      }

      if (isLineFull) {
        board.removeAt(row);
        board.insert(0, List.generate(boardWidth, (_) => null));
        linesCleared++;
        row++; // 重新检查同一行
      }
    }

    if (linesCleared > 0) {
      _updateScore(linesCleared);
    }
  }

  // 更新分数和等级
  void _updateScore(int linesCleared) {
    lines += linesCleared;

    // 计算分数：基础分数 * 消除行数 * 等级
    int baseScore = 100;
    switch (linesCleared) {
      case 1:
        score += baseScore * level;
        break;
      case 2:
        score += baseScore * 3 * level;
        break;
      case 3:
        score += baseScore * 5 * level;
        break;
      case 4:
        score += baseScore * 8 * level; // 四消奖励
        break;
    }

    // 升级逻辑：每消除10行升一级
    int newLevel = (lines ~/ 10) + 1;
    if (newLevel > level) {
      level = newLevel;
    }
  }

  // 移动方块
  bool moveTetromino(int direction) {
    if (currentTetromino == null || gameState != GameState.playing) {
      return false;
    }

    TetrominoState newState = currentTetromino!.move(direction, 0);

    if (!isCollision(newState)) {
      currentTetromino = newState;
      return true;
    }
    return false;
  }

  // 旋转方块
  bool rotateTetromino() {
    if (currentTetromino == null || gameState != GameState.playing) {
      return false;
    }

    TetrominoState newState = currentTetromino!.rotate();

    if (!isCollision(newState)) {
      currentTetromino = newState;
      return true;
    }

    // 尝试墙踢（Wall Kick）
    for (int offset in [-1, 1, -2, 2]) {
      TetrominoState kickState = newState.move(offset, 0);
      if (!isCollision(kickState)) {
        currentTetromino = kickState;
        return true;
      }
    }

    return false;
  }

  // 硬降
  void hardDrop() {
    if (currentTetromino == null || gameState != GameState.playing) {
      return;
    }

    while (!isCollision(currentTetromino!.move(0, 1))) {
      currentTetromino = currentTetromino!.move(0, 1);
    }

    // 立即放置
    _placeTetromino();
    _clearLines();
    _spawnNewTetromino();
  }

  // 暂停/继续游戏
  void togglePause() {
    if (gameState == GameState.playing) {
      gameState = GameState.paused;
    } else if (gameState == GameState.paused) {
      gameState = GameState.playing;
    }
  }

  // 重新开始游戏
  void restartGame() {
    initGame();
  }

  // 获取下降速度（毫秒）
  int getDropSpeed() {
    return (1000 - (level - 1) * 50).clamp(100, 1000);
  }

  // 获取游戏板的副本（用于渲染）
  List<List<Color?>> getBoardWithCurrentTetromino() {
    // 复制当前游戏板
    List<List<Color?>> renderBoard =
        board.map((row) => List<Color?>.from(row)).toList();

    // 添加当前下落的方块
    if (currentTetromino != null) {
      List<List<int>> shape = currentTetromino!.shape;
      Color color = currentTetromino!.color;

      for (int row = 0; row < shape.length; row++) {
        for (int col = 0; col < shape[row].length; col++) {
          if (shape[row][col] == 1) {
            int boardX = currentTetromino!.x + col;
            int boardY = currentTetromino!.y + row;

            if (boardY >= 0 &&
                boardY < boardHeight &&
                boardX >= 0 &&
                boardX < boardWidth) {
              renderBoard[boardY][boardX] = color;
            }
          }
        }
      }
    }

    return renderBoard;
  }

  // 获取幽灵方块位置（显示方块将要落下的位置）
  TetrominoState? getGhostTetromino() {
    if (currentTetromino == null) return null;

    TetrominoState ghost = currentTetromino!.copy();

    while (!isCollision(ghost.move(0, 1))) {
      ghost = ghost.move(0, 1);
    }

    return ghost;
  }
}
