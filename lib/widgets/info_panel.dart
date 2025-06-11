import 'package:flutter/material.dart';
import '../game/game_logic.dart';
import '../models/tetromino.dart';

class InfoPanel extends StatelessWidget {
  final GameLogic gameLogic;
  final VoidCallback onPause;
  final VoidCallback onRestart;

  const InfoPanel({
    super.key,
    required this.gameLogic,
    required this.onPause,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 游戏状态
              _buildGameStatus(),
              const SizedBox(height: 12),

              // 下一个方块
              _buildNextPiece(),
              const SizedBox(height: 12),

              // 控制按钮
              _buildControlButtons(),
              const SizedBox(height: 12),

              // 控制说明
              _buildControlInstructions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGameStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[800]!, Colors.grey[900]!],
        ),
        border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '俄罗斯方块',
            style: TextStyle(
              color: Colors.cyan,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 10),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 分数信息
          _buildStatRow('分数', gameLogic.score.toString()),
          _buildStatRow('行数', gameLogic.lines.toString()),
          _buildStatRow('等级', gameLogic.level.toString()),

          const SizedBox(height: 16),

          // 游戏状态提示
          if (gameLogic.gameState == GameState.paused)
            const Text(
              '游戏暂停',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (gameLogic.gameState == GameState.gameOver)
            const Text(
              '游戏结束',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPiece() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          NextPiecePreview(nextType: gameLogic.nextType),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: onPause,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  gameLogic.gameState == GameState.paused
                      ? Colors.green
                      : Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                gameLogic.gameState == GameState.paused ? '继续' : '暂停',
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: onRestart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const FittedBox(fit: BoxFit.scaleDown, child: Text('重新开始')),
          ),
        ),
      ],
    );
  }

  Widget _buildControlInstructions() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 180),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '控制说明:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildInstructionList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInstructionList() {
    final instructions = [
      '← → 左右移动',
      '↓ 软降',
      '↑/空格 旋转',
      'Enter 硬降',
      'P 暂停/继续',
      'R 重新开始',
    ];

    return instructions.map((instruction) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Text(
          instruction,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      );
    }).toList();
  }
}

class NextPiecePreview extends StatelessWidget {
  final TetrominoType? nextType;

  const NextPiecePreview({super.key, required this.nextType});

  @override
  Widget build(BuildContext context) {
    if (nextType == null) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.black,
        ),
        child: const Center(
          child: Text('?', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
      );
    }

    List<List<int>> shape = Tetromino.getShape(nextType!, 0);
    Color color = Tetromino.getColor(nextType!);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(shape.length, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(shape[row].length, (col) {
              return Container(
                width: 15,
                height: 15,
                margin: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  color: shape[row][col] == 1 ? color : Colors.transparent,
                  border:
                      shape[row][col] == 1
                          ? Border.all(
                            color: color.withOpacity(0.7),
                            width: 0.5,
                          )
                          : null,
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
