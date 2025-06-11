import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;
  final VoidCallback onSoftDrop;
  final VoidCallback onHardDrop;
  final VoidCallback onRotate;

  const GameControls({
    super.key,
    required this.onMoveLeft,
    required this.onMoveRight,
    required this.onSoftDrop,
    required this.onHardDrop,
    required this.onRotate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 旋转按钮
        _buildControlButton(
          onPressed: onRotate,
          icon: Icons.rotate_right,
          label: '旋转',
          color: Colors.purple,
        ),

        const SizedBox(height: 16),

        // 方向控制区域
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 左移
            _buildControlButton(
              onPressed: onMoveLeft,
              icon: Icons.keyboard_arrow_left,
              label: '左',
              color: Colors.blue,
            ),

            const SizedBox(width: 8),

            // 中间的上下控制
            Column(
              children: [
                // 硬降
                _buildControlButton(
                  onPressed: onHardDrop,
                  icon: Icons.keyboard_double_arrow_up,
                  label: '硬降',
                  color: Colors.red,
                ),

                const SizedBox(height: 8),

                // 软降
                _buildControlButton(
                  onPressed: onSoftDrop,
                  icon: Icons.keyboard_arrow_down,
                  label: '软降',
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(width: 8),

            // 右移
            _buildControlButton(
              onPressed: onMoveRight,
              icon: Icons.keyboard_arrow_right,
              label: '右',
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(60, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// 手势控制组件（用于触屏设备）
class GestureGameControls extends StatelessWidget {
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;
  final VoidCallback onSoftDrop;
  final VoidCallback onHardDrop;
  final VoidCallback onRotate;

  const GestureGameControls({
    super.key,
    required this.onMoveLeft,
    required this.onMoveRight,
    required this.onSoftDrop,
    required this.onHardDrop,
    required this.onRotate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRotate,
      onPanUpdate: (details) {
        // 水平滑动
        if (details.delta.dx > 5) {
          onMoveRight();
        } else if (details.delta.dx < -5) {
          onMoveLeft();
        }

        // 垂直滑动
        if (details.delta.dy > 5) {
          onSoftDrop();
        } else if (details.delta.dy < -5) {
          onHardDrop();
        }
      },
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[800]?.withOpacity(0.3),
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app, color: Colors.white70, size: 32),
              SizedBox(height: 8),
              Text(
                '手势控制区域',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '滑动移动 • 点击旋转',
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
