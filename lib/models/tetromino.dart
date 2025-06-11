import 'package:flutter/material.dart';

// 方块类型定义
enum TetrominoType { I, O, T, S, Z, J, L }

// 游戏状态枚举
enum GameState { playing, paused, gameOver }

// 方块形状和颜色定义
class Tetromino {
  static const Map<TetrominoType, List<List<List<int>>>> shapes = {
    TetrominoType.I: [
      [
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [0, 0, 1, 0],
        [0, 0, 1, 0],
        [0, 0, 1, 0],
        [0, 0, 1, 0],
      ],
    ],
    TetrominoType.O: [
      [
        [1, 1],
        [1, 1],
      ],
    ],
    TetrominoType.T: [
      [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 1],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 1, 0],
      ],
      [
        [0, 1, 0],
        [1, 1, 0],
        [0, 1, 0],
      ],
    ],
    TetrominoType.S: [
      [
        [0, 1, 1],
        [1, 1, 0],
        [0, 0, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 1],
        [0, 0, 1],
      ],
    ],
    TetrominoType.Z: [
      [
        [1, 1, 0],
        [0, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 0, 1],
        [0, 1, 1],
        [0, 1, 0],
      ],
    ],
    TetrominoType.J: [
      [
        [1, 0, 0],
        [1, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 1, 1],
        [0, 1, 0],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 0, 1],
      ],
      [
        [0, 1, 0],
        [0, 1, 0],
        [1, 1, 0],
      ],
    ],
    TetrominoType.L: [
      [
        [0, 0, 1],
        [1, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 1],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [1, 0, 0],
      ],
      [
        [1, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
      ],
    ],
  };

  static const Map<TetrominoType, Color> colors = {
    TetrominoType.I: Colors.cyan,
    TetrominoType.O: Colors.yellow,
    TetrominoType.T: Colors.purple,
    TetrominoType.S: Colors.green,
    TetrominoType.Z: Colors.red,
    TetrominoType.J: Colors.blue,
    TetrominoType.L: Colors.orange,
  };

  // 获取指定类型和旋转状态的形状
  static List<List<int>> getShape(TetrominoType type, int rotation) {
    List<List<List<int>>> typeShapes = shapes[type]!;
    return typeShapes[rotation % typeShapes.length];
  }

  // 获取指定类型的颜色
  static Color getColor(TetrominoType type) {
    return colors[type]!;
  }

  // 获取指定类型的最大旋转数
  static int getMaxRotations(TetrominoType type) {
    return shapes[type]!.length;
  }
}

// 当前方块状态类
class TetrominoState {
  TetrominoType type;
  int x;
  int y;
  int rotation;

  TetrominoState({
    required this.type,
    required this.x,
    required this.y,
    this.rotation = 0,
  });

  // 获取当前形状
  List<List<int>> get shape => Tetromino.getShape(type, rotation);

  // 获取当前颜色
  Color get color => Tetromino.getColor(type);

  // 复制状态
  TetrominoState copy() {
    return TetrominoState(type: type, x: x, y: y, rotation: rotation);
  }

  // 移动方块
  TetrominoState move(int deltaX, int deltaY) {
    return TetrominoState(
      type: type,
      x: x + deltaX,
      y: y + deltaY,
      rotation: rotation,
    );
  }

  // 旋转方块
  TetrominoState rotate() {
    return TetrominoState(
      type: type,
      x: x,
      y: y,
      rotation: (rotation + 1) % Tetromino.getMaxRotations(type),
    );
  }
}
