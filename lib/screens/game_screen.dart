import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;

import '../game/game_logic.dart';
import '../models/tetromino.dart';
import '../widgets/game_board.dart';
import '../widgets/info_panel.dart';
import '../widgets/game_controls.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic gameLogic;
  late Timer gameTimer;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    gameLogic = GameLogic();
    focusNode = FocusNode();

    // 初始化游戏
    gameLogic.initGame();

    // 启动游戏循环
    _startGameLoop();

    // 确保焦点在组件上以接收键盘输入
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    gameTimer.cancel();
    focusNode.dispose();
    super.dispose();
  }

  void _startGameLoop() {
    gameTimer = Timer.periodic(
      Duration(milliseconds: gameLogic.getDropSpeed()),
      (timer) {
        if (gameLogic.gameState == GameState.playing) {
          setState(() {
            gameLogic.dropTetromino();
          });

          // 检查是否需要更新下降速度
          int newSpeed = gameLogic.getDropSpeed();
          if (newSpeed != timer.tick) {
            timer.cancel();
            _startGameLoop();
          }
        }
      },
    );
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        setState(() {
          gameLogic.moveTetromino(-1);
        });
        break;
      case LogicalKeyboardKey.arrowRight:
        setState(() {
          gameLogic.moveTetromino(1);
        });
        break;
      case LogicalKeyboardKey.arrowDown:
        setState(() {
          gameLogic.dropTetromino();
        });
        break;
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.space:
        setState(() {
          gameLogic.rotateTetromino();
        });
        break;
      case LogicalKeyboardKey.enter:
        setState(() {
          gameLogic.hardDrop();
        });
        break;
      case LogicalKeyboardKey.keyP:
        _pauseGame();
        break;
      case LogicalKeyboardKey.keyR:
        _restartGame();
        break;
    }
  }

  void _pauseGame() {
    setState(() {
      gameLogic.togglePause();
    });

    if (gameLogic.gameState == GameState.paused) {
      gameTimer.cancel();
    } else {
      _startGameLoop();
    }
  }

  void _restartGame() {
    gameTimer.cancel();
    setState(() {
      gameLogic.restartGame();
    });
    _startGameLoop();
  }

  void _moveLeft() {
    setState(() {
      gameLogic.moveTetromino(-1);
    });
  }

  void _moveRight() {
    setState(() {
      gameLogic.moveTetromino(1);
    });
  }

  void _softDrop() {
    setState(() {
      gameLogic.dropTetromino();
    });
  }

  void _hardDrop() {
    setState(() {
      gameLogic.hardDrop();
    });
  }

  void _rotate() {
    setState(() {
      gameLogic.rotateTetromino();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Colors.grey[850]!, Colors.black, Colors.grey[900]!],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: RawKeyboardListener(
            focusNode: focusNode,
            autofocus: true,
            onKey: _handleKeyPress,
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          // 左侧装饰区域
          Expanded(flex: 1, child: _buildSideDecoration(isLeft: true)),

          // 主游戏区域
          Expanded(
            flex: 3,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 游戏板
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: GameBoard(gameLogic: gameLogic),
                  ),

                  const SizedBox(width: 40),

                  // 信息面板
                  SizedBox(
                    width: 280,
                    child: InfoPanel(
                      gameLogic: gameLogic,
                      onPause: _pauseGame,
                      onRestart: _restartGame,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 右侧装饰区域
          Expanded(flex: 1, child: _buildSideDecoration(isLeft: false)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 顶部信息栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMobileStatItem('分数', gameLogic.score.toString()),
                _buildMobileStatItem('行数', gameLogic.lines.toString()),
                _buildMobileStatItem('等级', gameLogic.level.toString()),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 游戏区域 - 垂直布局
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 游戏板
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: GameBoard(gameLogic: gameLogic),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 移动端信息面板
                  Row(
                    children: [
                      // 下一个方块
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '下一个',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              NextPiecePreview(nextType: gameLogic.nextType),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // 控制按钮
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _pauseGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      gameLogic.gameState == GameState.paused
                                          ? Colors.green
                                          : Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(
                                  gameLogic.gameState == GameState.paused
                                      ? '继续'
                                      : '暂停',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _restartGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text(
                                  '重新开始',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 移动端控制区域
                  GameControls(
                    onMoveLeft: _moveLeft,
                    onMoveRight: _moveRight,
                    onSoftDrop: _softDrop,
                    onHardDrop: _hardDrop,
                    onRotate: _rotate,
                  ),
                ],
              ),
            ),
          ),

          // 游戏状态提示
          if (gameLogic.gameState != GameState.playing)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    gameLogic.gameState == GameState.paused
                        ? Colors.orange.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                border: Border.all(
                  color:
                      gameLogic.gameState == GameState.paused
                          ? Colors.orange
                          : Colors.red,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                gameLogic.gameState == GameState.paused ? '游戏暂停' : '游戏结束',
                style: TextStyle(
                  color:
                      gameLogic.gameState == GameState.paused
                          ? Colors.orange
                          : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSideDecoration({required bool isLeft}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 顶部装饰
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.purple.withOpacity(0.3), Colors.transparent],
              ),
              border: Border.all(
                color: Colors.purple.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                isLeft ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
                size: 35,
                color: Colors.purple.withOpacity(0.6),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // 中间装饰方块
          ...List.generate(3, (index) => _buildDecorativeBlock(index, isLeft)),

          const SizedBox(height: 30),

          // 底部装饰
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              gradient: LinearGradient(
                begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
                colors: [Colors.blue.withOpacity(0.3), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeBlock(int index, bool isLeft) {
    final colors = [Colors.cyan, Colors.purple, Colors.orange];
    final sizes = [50.0, 40.0, 60.0];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 2000 + index * 500),
        width: sizes[index],
        height: sizes[index],
        decoration: BoxDecoration(
          color: colors[index].withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors[index].withOpacity(0.4), width: 2),
          boxShadow: [
            BoxShadow(
              color: colors[index].withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            _getRandomIcon(index),
            color: colors[index].withOpacity(0.6),
            size: sizes[index] * 0.4,
          ),
        ),
      ),
    );
  }

  IconData _getRandomIcon(int index) {
    final icons = [Icons.games, Icons.extension, Icons.sports_esports];
    return icons[index];
  }

  Widget _buildMobileStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
