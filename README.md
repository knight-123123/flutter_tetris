# 俄罗斯方块游戏 🎮

一个使用 Flutter 开发的经典俄罗斯方块游戏，支持多平台运行，包括 Android、Windows、和 Web。

## 📱 项目简介

这是一个功能完整的俄罗斯方块游戏，采用现代化的 UI 设计，具有流畅的动画效果和响应式布局。游戏忠实还原了经典俄罗斯方块的核心玩法，同时增加了一些现代化的功能和视觉效果。

### ✨ 主要特性

- 🎯 **经典玩法**: 完整实现俄罗斯方块的核心游戏机制
- 📱 **多平台支持**: 支持 Android、iOS、Windows、Linux、macOS 和 Web
- 🎨 **现代化 UI**: 炫酷的视觉效果，包括发光边框和渐变背景
- 📐 **响应式设计**: 自适应桌面端和移动端不同屏幕尺寸
- 🎮 **多种控制方式**: 支持键盘、触屏和手势控制
- 👻 **幽灵方块**: 显示方块的预计落点位置
- 📊 **完整统计**: 分数、消除行数、游戏等级统计
- ⏸️ **游戏控制**: 暂停/继续、重新开始功能
- 🔄 **下一个方块预览**: 显示即将出现的方块类型
- 🎵 **流畅动画**: 平滑的方块移动和消除动画

## 🎮 游戏玩法

### 基本规则
1. **方块下落**: 7种不同形状的方块从顶部下落
2. **拼接消除**: 将方块拼接成完整的水平行即可消除
3. **累积分数**: 消除行数越多，获得分数越高
4. **等级提升**: 每消除10行升一级，方块下落速度加快
5. **游戏结束**: 当方块堆积到顶部时游戏结束

### 方块类型
游戏包含7种经典的俄罗斯方块：
- **I型** (青色): 4格直线方块
- **O型** (黄色): 2×2正方形方块  
- **T型** (紫色): T字形方块
- **S型** (绿色): S字形方块
- **Z型** (红色): Z字形方块
- **J型** (蓝色): J字形方块
- **L型** (橙色): L字形方块

### 操作说明

#### 键盘控制（桌面端）
- **← →**: 左右移动方块
- **↓**: 软降（加速下落）
- **↑ / 空格**: 旋转方块
- **Enter**: 硬降（瞬间落到底部）
- **P**: 暂停/继续游戏
- **R**: 重新开始游戏

#### 触屏控制（移动端）
- **滑动**: 手指滑动控制方块移动和下落
- **点击**: 点击屏幕旋转方块
- **控制按钮**: 使用屏幕下方的虚拟按钮

## 🏗️ 项目结构

```
lib/
├── main.dart                 # 应用程序入口
├── screens/
│   └── game_screen.dart      # 游戏主屏幕
├── game/
│   └── game_logic.dart       # 游戏核心逻辑
├── models/
│   └── tetromino.dart        # 方块模型定义
└── widgets/
    ├── game_board.dart       # 游戏板组件
    ├── info_panel.dart       # 信息面板组件
    └── game_controls.dart    # 控制按钮组件
```

### 核心文件说明

#### `main.dart`
- 应用程序入口点
- 定义应用主题和路由配置

#### `game_logic.dart`
- 实现游戏的核心逻辑
- 包含方块生成、移动、旋转、碰撞检测
- 行消除算法和分数计算
- 游戏状态管理

#### `tetromino.dart`
- 定义7种方块的形状数据
- 方块旋转状态管理
- 方块颜色配置

#### `game_screen.dart`
- 游戏主界面
- 处理用户输入（键盘/触屏）
- 管理游戏循环和定时器
- 响应式布局适配

#### `game_board.dart`
- 游戏板渲染组件
- 方块绘制和幽灵方块显示
- 视觉效果和动画

#### `info_panel.dart`
- 游戏信息显示面板
- 分数、等级、行数统计
- 下一个方块预览
- 控制按钮

#### `game_controls.dart`
- 移动端虚拟控制按钮
- 手势控制支持

## 🛠️ 技术实现

### 核心技术栈
- **Flutter**: 跨平台UI框架
- **Dart**: 编程语言
- **Material Design**: UI设计语言

### 关键技术点

#### 1. 游戏循环
```dart
Timer.periodic(Duration(milliseconds: speed), (timer) {
  if (gameState == GameState.playing) {
    dropTetromino();
  }
});
```

#### 2. 碰撞检测
- 边界检测：防止方块移出游戏区域
- 重叠检测：检测方块是否与已放置方块重叠
- 支持"墙踢"功能，提升操作手感

#### 3. 行消除算法
```dart
void _clearLines() {
  for (int row = boardHeight - 1; row >= 0; row--) {
    bool isLineFull = board[row].every((cell) => cell != null);
    if (isLineFull) {
      board.removeAt(row);
      board.insert(0, List.generate(boardWidth, (_) => null));
      linesCleared++;
      row++; // 重新检查同一行
    }
  }
}
```

#### 4. 响应式设计
- 使用 `MediaQuery` 检测屏幕尺寸
- 动态调整游戏板大小和控制界面
- 桌面端和移动端不同的布局策略

#### 5. 状态管理
- 使用 `StatefulWidget` 管理游戏状态
- 合理的状态更新和UI重绘策略

## 🚀 安装和运行

### 环境要求
- Flutter SDK (3.7.2 或更高版本)
- Dart SDK (已包含在 Flutter 中)
- 对应平台的开发环境（Android Studio、vscode）

## 🎯 游戏配置

### 可自定义参数

在 `game_logic.dart` 中可以调整以下游戏参数：

```dart
class GameLogic {
  static const int boardWidth = 10;    // 游戏板宽度
  static const int boardHeight = 20;   // 游戏板高度
  
  // 等级和速度设置
  int getDropSpeed() {
    return (1000 - (level - 1) * 50).clamp(100, 1000);
  }
  
  // 分数计算规则
  void _updateScore(int linesCleared) {
    int baseScore = 100;
    switch (linesCleared) {
      case 1: score += baseScore * level; break;
      case 2: score += baseScore * 3 * level; break;
      case 3: score += baseScore * 5 * level; break;
      case 4: score += baseScore * 8 * level; break; // 四消奖励
    }
  }
}
```

### 主题自定义

在 `main.dart` 中可以修改应用主题：

```dart
MaterialApp(
  title: '俄罗斯方块',
  theme: ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'monospace',
  ),
  // ...
)
```

## 🐛 常见问题

### 性能问题
**问题**: 游戏在某些设备上运行卡顿
**解决方案**: 
- 检查设备性能，降低游戏速度等级
- 在 `game_board.dart` 中调整 `cellSize` 参数
- 关闭调试模式，使用 `flutter run --release`

### 控制问题
**问题**: 键盘输入无响应
**解决方案**:
- 确保游戏界面获得焦点
- 检查 `RawKeyboardListener` 的 `focusNode` 设置
- 重新启动应用程序

### 布局问题
**问题**: 在某些屏幕尺寸下界面显示异常
**解决方案**:
- 调整 `game_screen.dart` 中的响应式布局参数
- 修改 `isMobile` 判断条件
- 调整各组件的 `flex` 值

## 🔧 开发指南

### 添加新功能

#### 1. 添加新的方块类型
在 `tetromino.dart` 中扩展 `TetrominoType` 枚举和 `shapes` 映射：

```dart
enum TetrominoType { I, O, T, S, Z, J, L, NewType }

static const Map<TetrominoType, List<List<List<int>>>> shapes = {
  // ... 现有方块
  TetrominoType.NewType: [
    [
      [1, 1, 1],
      [0, 1, 0],
      [0, 1, 0],
    ],
  ],
};
```

#### 2. 添加音效
1. 在 `pubspec.yaml` 中添加音频依赖
2. 在 `assets` 文件夹中添加音频文件
3. 在相应的游戏事件中播放音效

#### 3. 添加新的游戏模式
1. 扩展 `GameState` 枚举
2. 在 `game_logic.dart` 中实现新的游戏逻辑
3. 在 `game_screen.dart` 中添加相应的UI控制

### 代码规范

- 使用 Dart 官方代码风格
- 为公共方法添加文档注释
- 保持函数简洁，单一职责
- 合理使用 `const` 构造函数
- 定期运行 `flutter analyze` 检查代码质量

### 测试

运行单元测试：
```bash
flutter test
```

运行集成测试：
```bash
flutter drive --target=test_driver/app.dart
```

**enjoy the game! 🎮**
