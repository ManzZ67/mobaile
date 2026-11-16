import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Tetris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFFA855F7),
        ),
      ),
      home: const TetrisStartScreen(),
    );
  }
}

// -------------------------------------------------------------
// Start Screen (Halaman Pertama / Menu Utama)
// -------------------------------------------------------------
class TetrisStartScreen extends StatefulWidget {
  const TetrisStartScreen({super.key});

  @override
  State<TetrisStartScreen> createState() => _TetrisStartScreenState();
}

class _TetrisStartScreenState extends State<TetrisStartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 4.0, end: 18.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
        ),
        title: const Row(
          children: [
            Icon(Icons.sports_esports_rounded, color: Color(0xFF38BDF8)),
            SizedBox(width: 8),
            Text(
              'CARA BERMAIN',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuideItem(Icons.arrow_back_rounded, 'Kiri / Kanan', 'Geser balok ke kiri/kanan'),
            _buildGuideItem(Icons.rotate_right_rounded, 'Rotasi', 'Putar balok searah jarum jam'),
            _buildGuideItem(Icons.arrow_downward_rounded, 'Turun (Soft)', 'Mempercepat balok turun'),
            _buildGuideItem(Icons.vertical_align_bottom_rounded, 'Jatuh (Hard)', 'Balok langsung jatuh ke dasar'),
            _buildGuideItem(Icons.swap_vert_rounded, 'Hold', 'Simpan balok untuk dipakai nanti'),
            const SizedBox(height: 8),
            const Text(
              '💡 Tips: Anda juga bisa swipe di layar papan game untuk bergerak cepat!',
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38BDF8),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('MENGERTI', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF38BDF8)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.3,
            colors: [Color(0xFF1E293B), Color(0xFF090D16)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Tetris Floating Logo Decoration
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFFA855F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.5),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  size: 54,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // Game Title with Neon Glow
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Text(
                    'NEON TETRIS',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4.0,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF38BDF8),
                          blurRadius: _glowAnimation.value,
                        ),
                        Shadow(
                          color: const Color(0xFFA855F7),
                          blurRadius: _glowAnimation.value * 1.5,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              const Text(
                'RETRO ARCADE PUZZLE',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3.0,
                  color: Color(0xFF94A3B8),
                ),
              ),

              const Spacer(flex: 3),

              // START BUTTON (Tombol Utama)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.45),
                            blurRadius: _glowAnimation.value,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TetrisGameScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: const Color(0xFF090D16),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 32),
                        SizedBox(width: 8),
                        Text(
                          'START GAME',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // HOW TO PLAY BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showHowToPlayDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE2E8F0),
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Color(0xFF334155), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.help_outline_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'CARA BERMAIN',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              const Text(
                'v1.0.0 • Made with Flutter',
                style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// Tetromino Definitions & Colors
// -------------------------------------------------------------
enum TetrominoType { i, j, l, o, s, t, z }

class TetrominoData {
  final TetrominoType type;
  final Color color;
  final Color glowColor;
  final List<Point<int>> relativeBlocks;

  const TetrominoData({
    required this.type,
    required this.color,
    required this.glowColor,
    required this.relativeBlocks,
  });

  static const Map<TetrominoType, TetrominoData> shapes = {
    TetrominoType.i: TetrominoData(
      type: TetrominoType.i,
      color: Color(0xFF06B6D4), // Cyan
      glowColor: Color(0xFF67E8F9),
      relativeBlocks: [Point(0, 0), Point(-1, 0), Point(1, 0), Point(2, 0)],
    ),
    TetrominoType.j: TetrominoData(
      type: TetrominoType.j,
      color: Color(0xFF3B82F6), // Blue
      glowColor: Color(0xFF93C5FD),
      relativeBlocks: [Point(0, 0), Point(-1, 0), Point(1, 0), Point(-1, -1)],
    ),
    TetrominoType.l: TetrominoData(
      type: TetrominoType.l,
      color: Color(0xFFF97316), // Orange
      glowColor: Color(0xFFFDBA74),
      relativeBlocks: [Point(0, 0), Point(-1, 0), Point(1, 0), Point(1, -1)],
    ),
    TetrominoType.o: TetrominoData(
      type: TetrominoType.o,
      color: Color(0xFFFBBF24), // Yellow
      glowColor: Color(0xFFFDE68A),
      relativeBlocks: [Point(0, 0), Point(1, 0), Point(0, 1), Point(1, 1)],
    ),
    TetrominoType.s: TetrominoData(
      type: TetrominoType.s,
      color: Color(0xFF10B981), // Emerald
      glowColor: Color(0xFF6EE7B7),
      relativeBlocks: [Point(0, 0), Point(1, 0), Point(0, 1), Point(-1, 1)],
    ),
    TetrominoType.t: TetrominoData(
      type: TetrominoType.t,
      color: Color(0xFFA855F7), // Purple
      glowColor: Color(0xFFD8B4FE),
      relativeBlocks: [Point(0, 0), Point(-1, 0), Point(1, 0), Point(0, -1)],
    ),
    TetrominoType.z: TetrominoData(
      type: TetrominoType.z,
      color: Color(0xFFEF4444), // Red
      glowColor: Color(0xFFFCA5A5),
      relativeBlocks: [Point(0, 0), Point(-1, 0), Point(0, 1), Point(1, 1)],
    ),
  };
}

class ActivePiece {
  final TetrominoType type;
  Point<int> position;
  List<Point<int>> blocks;

  ActivePiece({
    required this.type,
    required this.position,
    required this.blocks,
  });

  Color get color => TetrominoData.shapes[type]!.color;
  Color get glowColor => TetrominoData.shapes[type]!.glowColor;

  factory ActivePiece.spawn(TetrominoType type, int startCol) {
    final data = TetrominoData.shapes[type]!;
    return ActivePiece(
      type: type,
      position: Point(startCol, 1),
      blocks: List<Point<int>>.from(data.relativeBlocks),
    );
  }

  List<Point<int>> get absoluteBlocks {
    return blocks.map((b) => Point(position.x + b.x, position.y + b.y)).toList();
  }
}

// -------------------------------------------------------------
// Game Screen
// -------------------------------------------------------------
class TetrisGameScreen extends StatefulWidget {
  const TetrisGameScreen({super.key});

  @override
  State<TetrisGameScreen> createState() => _TetrisGameScreenState();
}

class _TetrisGameScreenState extends State<TetrisGameScreen> {
  static const int cols = 10;
  static const int rows = 20;

  // Board grid: null = empty, Color = locked block
  late List<List<Color?>> board;

  ActivePiece? currentPiece;
  TetrominoType? nextPieceType;
  TetrominoType? holdPieceType;
  bool canHold = true;

  Timer? gameTimer;
  bool isPlaying = false;
  bool isPaused = false;
  bool isGameOver = false;

  int score = 0;
  int lines = 0;
  int level = 1;
  int highScore = 0;

  final Random random = Random();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _resetBoard();
    _startNewGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _resetBoard() {
    board = List.generate(rows, (_) => List.generate(cols, (_) => null));
  }

  void _startNewGame() {
    gameTimer?.cancel();
    _resetBoard();
    score = 0;
    lines = 0;
    level = 1;
    isGameOver = false;
    isPaused = false;
    isPlaying = true;
    holdPieceType = null;
    canHold = true;

    nextPieceType = _randomType();
    _spawnNextPiece();
    _setupGameTicker();
    setState(() {});
  }

  TetrominoType _randomType() {
    final values = TetrominoType.values;
    return values[random.nextInt(values.length)];
  }

  void _setupGameTicker() {
    gameTimer?.cancel();
    final dropIntervalMs = max(90, 650 - (level - 1) * 55);
    gameTimer = Timer.periodic(Duration(milliseconds: dropIntervalMs), (timer) {
      if (isPlaying && !isPaused && !isGameOver) {
        _moveDown();
      }
    });
  }

  void _spawnNextPiece() {
    final typeToSpawn = nextPieceType ?? _randomType();
    nextPieceType = _randomType();

    final newPiece = ActivePiece.spawn(typeToSpawn, cols ~/ 2);

    if (_checkCollision(newPiece.position, newPiece.blocks)) {
      _triggerGameOver();
      return;
    }

    currentPiece = newPiece;
    canHold = true;
    setState(() {});
  }

  void _triggerGameOver() {
    gameTimer?.cancel();
    isPlaying = false;
    isGameOver = true;
    if (score > highScore) {
      highScore = score;
    }
    HapticFeedback.vibrate();
    setState(() {});
  }

  bool _checkCollision(Point<int> pos, List<Point<int>> pieceBlocks) {
    for (final b in pieceBlocks) {
      final x = pos.x + b.x;
      final y = pos.y + b.y;

      if (x < 0 || x >= cols || y >= rows) {
        return true;
      }

      if (y >= 0 && board[y][x] != null) {
        return true;
      }
    }
    return false;
  }

  void _moveLeft() {
    if (!isPlaying || isPaused || isGameOver || currentPiece == null) return;
    final newPos = Point(currentPiece!.position.x - 1, currentPiece!.position.y);
    if (!_checkCollision(newPos, currentPiece!.blocks)) {
      currentPiece!.position = newPos;
      HapticFeedback.selectionClick();
      setState(() {});
    }
  }

  void _moveRight() {
    if (!isPlaying || isPaused || isGameOver || currentPiece == null) return;
    final newPos = Point(currentPiece!.position.x + 1, currentPiece!.position.y);
    if (!_checkCollision(newPos, currentPiece!.blocks)) {
      currentPiece!.position = newPos;
      HapticFeedback.selectionClick();
      setState(() {});
    }
  }

  bool _moveDown() {
    if (!isPlaying || isPaused || isGameOver || currentPiece == null) return false;
    final newPos = Point(currentPiece!.position.x, currentPiece!.position.y + 1);

    if (!_checkCollision(newPos, currentPiece!.blocks)) {
      currentPiece!.position = newPos;
      setState(() {});
      return true;
    } else {
      _lockPiece();
      return false;
    }
  }

  void _softDrop() {
    if (_moveDown()) {
      score += 1;
      HapticFeedback.selectionClick();
      setState(() {});
    }
  }

  void _hardDrop() {
    if (!isPlaying || isPaused || isGameOver || currentPiece == null) return;
    int dropDistance = 0;
    while (true) {
      final nextPos = Point(currentPiece!.position.x, currentPiece!.position.y + 1);
      if (!_checkCollision(nextPos, currentPiece!.blocks)) {
        currentPiece!.position = nextPos;
        dropDistance++;
      } else {
        break;
      }
    }
    score += dropDistance * 2;
    HapticFeedback.mediumImpact();
    _lockPiece();
  }

  void _rotate({bool clockwise = true}) {
    if (!isPlaying || isPaused || isGameOver || currentPiece == null) return;
    if (currentPiece!.type == TetrominoType.o) return;

    final rotatedBlocks = currentPiece!.blocks.map((b) {
      return clockwise ? Point(-b.y, b.x) : Point(b.y, -b.x);
    }).toList();

    const kickOffsets = [
      Point(0, 0),
      Point(-1, 0),
      Point(1, 0),
      Point(-2, 0),
      Point(2, 0),
      Point(0, -1),
    ];

    for (final offset in kickOffsets) {
      final testPos = Point(
        currentPiece!.position.x + offset.x,
        currentPiece!.position.y + offset.y,
      );
      if (!_checkCollision(testPos, rotatedBlocks)) {
        currentPiece!.position = testPos;
        currentPiece!.blocks = rotatedBlocks;
        HapticFeedback.lightImpact();
        setState(() {});
        return;
      }
    }
  }

  void _hold() {
    if (!isPlaying || isPaused || isGameOver || !canHold || currentPiece == null) return;

    final currentType = currentPiece!.type;
    if (holdPieceType == null) {
      holdPieceType = currentType;
      _spawnNextPiece();
    } else {
      final swapType = holdPieceType!;
      holdPieceType = currentType;
      currentPiece = ActivePiece.spawn(swapType, cols ~/ 2);
    }
    canHold = false;
    HapticFeedback.lightImpact();
    setState(() {});
  }

  void _lockPiece() {
    if (currentPiece == null) return;

    for (final b in currentPiece!.absoluteBlocks) {
      if (b.y >= 0 && b.y < rows && b.x >= 0 && b.x < cols) {
        board[b.y][b.x] = currentPiece!.color;
      }
    }

    _clearLines();
    _spawnNextPiece();
  }

  void _clearLines() {
    int cleared = 0;

    for (int r = rows - 1; r >= 0; r--) {
      bool isFull = true;
      for (int c = 0; c < cols; c++) {
        if (board[r][c] == null) {
          isFull = false;
          break;
        }
      }

      if (isFull) {
        cleared++;
        for (int rowAbove = r; rowAbove > 0; rowAbove--) {
          board[rowAbove] = List<Color?>.from(board[rowAbove - 1]);
        }
        board[0] = List.generate(cols, (_) => null);
        r++;
      }
    }

    if (cleared > 0) {
      lines += cleared;
      const scoreTable = [0, 100, 300, 500, 800];
      score += (scoreTable[cleared] * level);

      final newLevel = (lines ~/ 10) + 1;
      if (newLevel != level) {
        level = newLevel;
        _setupGameTicker();
      }

      HapticFeedback.heavyImpact();
    }
  }

  int _calculateGhostY() {
    if (currentPiece == null) return 0;
    int ghostY = currentPiece!.position.y;
    while (!_checkCollision(Point(currentPiece!.position.x, ghostY + 1), currentPiece!.blocks)) {
      ghostY++;
    }
    return ghostY;
  }

  void _togglePause() {
    if (isGameOver) return;
    setState(() {
      isPaused = !isPaused;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    switch (event.logicalKey) {
      // Move Left
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.keyA:
        _moveLeft();
        break;

      // Move Right
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.keyD:
        _moveRight();
        break;

      // Soft Drop
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.keyS:
        _softDrop();
        break;

      // Rotate Clockwise (ROT R)
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.keyW:
      case LogicalKeyboardKey.keyR:
        _rotate(clockwise: true);
        break;

      // Rotate Counter-Clockwise (ROT L)
      case LogicalKeyboardKey.keyL:
      case LogicalKeyboardKey.keyQ:
        _rotate(clockwise: false);
        break;

      // Hard Drop
      case LogicalKeyboardKey.space:
        _hardDrop();
        break;

      // Hold Piece
      case LogicalKeyboardKey.keyC:
      case LogicalKeyboardKey.keyH:
      case LogicalKeyboardKey.shiftLeft:
      case LogicalKeyboardKey.shiftRight:
        _hold();
        break;

      // New Game (N)
      case LogicalKeyboardKey.keyN:
        _startNewGame();
        break;

      // Pause
      case LogicalKeyboardKey.keyP:
      case LogicalKeyboardKey.escape:
        _togglePause();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.4),
              radius: 1.2,
              colors: [Color(0xFF1E293B), Color(0xFF090D16)],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Top Bar
                    _buildHeader(),
                    const SizedBox(height: 6),

                    // Top Stats Bar (Score, Level, Lines, Next)
                    _buildTopStatsBar(),
                    const SizedBox(height: 8),

                    // Main Content: Centered Game Board
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _buildGameBoard(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // On-screen Controls
                    _buildArcadeControls(),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Header Bar with Home/Back Button
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                color: const Color(0xFF94A3B8),
                tooltip: 'Kembali ke Menu Utama',
                onPressed: () {
                  gameTimer?.cancel();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 4),
              const Text(
                'NEON TETRIS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Color(0xFF38BDF8), blurRadius: 10),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded),
                color: Colors.amberAccent,
                tooltip: 'Pause/Resume',
                onPressed: _togglePause,
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                color: Colors.cyanAccent,
                tooltip: 'Restart',
                onPressed: _startNewGame,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Top Info Banner above the Board
  Widget _buildTopStatsBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard('SCORE', '$score'),
          _buildStatCard('LEVEL', '$level'),
          _buildStatCard('LINES', '$lines'),
          _buildNextPieceCard(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155), width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF38BDF8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPieceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155), width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'NEXT',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 32,
            height: 22,
            child: _buildMiniPiecePreview(nextPieceType),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPiecePreview(TetrominoType? type) {
    if (type == null) {
      return const SizedBox(
        height: 52,
        child: Center(
          child: Text(
            '-',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 18),
          ),
        ),
      );
    }

    final data = TetrominoData.shapes[type]!;
    final blocks = data.relativeBlocks;

    return SizedBox(
      width: 52,
      height: 52,
      child: CustomPaint(
        painter: MiniPiecePainter(
          blocks: blocks,
          color: data.color,
          glowColor: data.glowColor,
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    final ghostY = _calculateGhostY();

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != null) {
          if (details.primaryDelta! > 10) {
            _moveRight();
          } else if (details.primaryDelta! < -10) {
            _moveLeft();
          }
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 12) {
          _softDrop();
        }
      },
      onTap: () => _rotate(),
      onDoubleTap: () => _hardDrop(),
      child: AspectRatio(
        aspectRatio: cols / rows,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF030712).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.18),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: BoardPainter(
                  board: board,
                  currentPiece: currentPiece,
                  ghostY: ghostY,
                ),
              ),

              if (isGameOver)
                Container(
                  color: Colors.black.withValues(alpha: 0.85),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'GAME OVER',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Color(0xFFEF4444),
                            shadows: [
                              Shadow(color: Color(0xFFEF4444), blurRadius: 12),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Score: $score',
                          style: const TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Color(0xFF475569)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.home_rounded, size: 18),
                              label: const Text('MENU'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: _startNewGame,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF38BDF8),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.replay_rounded, size: 18),
                              label: const Text(
                                'LAGI',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              if (isPaused && !isGameOver)
                Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'PAUSED',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            color: Colors.amberAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _togglePause,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('RESUME', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArcadeControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.swap_vert_rounded,
                label: 'HOLD',
                color: const Color(0xFFE2E8F0),
                bgColor: const Color(0xFF334155),
                onTap: _hold,
              ),
              _buildControlButton(
                icon: Icons.rotate_left_rounded,
                label: 'ROT L',
                color: const Color(0xFFA855F7),
                bgColor: const Color(0xFF581C87),
                onTap: () => _rotate(clockwise: false),
              ),
              _buildControlButton(
                icon: Icons.vertical_align_bottom_rounded,
                label: 'DROP',
                color: const Color(0xFFFBBF24),
                bgColor: const Color(0xFF78350F),
                isAction: true,
                onTap: _hardDrop,
              ),
              _buildControlButton(
                icon: Icons.rotate_right_rounded,
                label: 'ROT R',
                color: const Color(0xFF06B6D4),
                bgColor: const Color(0xFF164E63),
                onTap: () => _rotate(clockwise: true),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.arrow_back_rounded,
                label: 'LEFT',
                color: Colors.white,
                bgColor: const Color(0xFF1E293B),
                size: 58,
                onTap: _moveLeft,
              ),
              _buildControlButton(
                icon: Icons.arrow_downward_rounded,
                label: 'DOWN',
                color: Colors.white,
                bgColor: const Color(0xFF1E293B),
                size: 58,
                onTap: _softDrop,
              ),
              _buildControlButton(
                icon: Icons.arrow_forward_rounded,
                label: 'RIGHT',
                color: Colors.white,
                bgColor: const Color(0xFF1E293B),
                size: 58,
                onTap: _moveRight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
    double size = 50,
    bool isAction = false,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: isAction ? 0.9 : 0.4),
            width: isAction ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isAction ? 0.35 : 0.1),
              blurRadius: isAction ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: size * 0.48),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: color.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// Custom Board Painter (Neon Glow & Smooth Blocks)
// -------------------------------------------------------------
class BoardPainter extends CustomPainter {
  final List<List<Color?>> board;
  final ActivePiece? currentPiece;
  final int ghostY;

  BoardPainter({
    required this.board,
    required this.currentPiece,
    required this.ghostY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const int cols = 10;
    const int rows = 20;
    final double blockW = size.width / cols;
    final double blockH = size.height / rows;

    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.4)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int c = 1; c < cols; c++) {
      canvas.drawLine(Offset(c * blockW, 0), Offset(c * blockW, size.height), gridPaint);
    }
    for (int r = 1; r < rows; r++) {
      canvas.drawLine(Offset(0, r * blockH), Offset(size.width, r * blockH), gridPaint);
    }

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final color = board[r][c];
        if (color != null) {
          _drawBlock(canvas, c, r, blockW, blockH, color, isGhost: false);
        }
      }
    }

    if (currentPiece != null) {
      for (final b in currentPiece!.blocks) {
        final gx = currentPiece!.position.x + b.x;
        final gy = ghostY + b.y;
        if (gy >= 0 && gy < rows && gx >= 0 && gx < cols) {
          _drawBlock(canvas, gx, gy, blockW, blockH, currentPiece!.color, isGhost: true);
        }
      }
    }

    if (currentPiece != null) {
      for (final b in currentPiece!.absoluteBlocks) {
        if (b.y >= 0 && b.y < rows && b.x >= 0 && b.x < cols) {
          _drawBlock(canvas, b.x, b.y, blockW, blockH, currentPiece!.color, isGhost: false);
        }
      }
    }
  }

  void _drawBlock(
    Canvas canvas,
    int c,
    int r,
    double w,
    double h,
    Color color, {
    required bool isGhost,
  }) {
    final rect = Rect.fromLTWH(c * w + 1.2, r * h + 1.2, w - 2.4, h - 2.4);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

    if (isGhost) {
      final outlinePaint = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(rrect, outlinePaint);
      return;
    }

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(color, Colors.white, 0.35)!,
          color,
          Color.lerp(color, Colors.black, 0.3)!,
        ],
      ).createShader(rect);

    canvas.drawRRect(rrect, fillPaint);

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) => true;
}

// -------------------------------------------------------------
// Mini Piece Painter for Preview Boxes
// -------------------------------------------------------------
class MiniPiecePainter extends CustomPainter {
  final List<Point<int>> blocks;
  final Color color;
  final Color glowColor;

  MiniPiecePainter({
    required this.blocks,
    required this.color,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (blocks.isEmpty) return;

    int minX = blocks.first.x;
    int maxX = blocks.first.x;
    int minY = blocks.first.y;
    int maxY = blocks.first.y;

    for (final b in blocks) {
      if (b.x < minX) minX = b.x;
      if (b.x > maxX) maxX = b.x;
      if (b.y < minY) minY = b.y;
      if (b.y > maxY) maxY = b.y;
    }

    final pieceW = (maxX - minX + 1);
    final pieceH = (maxY - minY + 1);

    final double blockSize = min(size.width / (pieceW + 1.2), size.height / (pieceH + 1.2));
    final double startX = (size.width - pieceW * blockSize) / 2;
    final double startY = (size.height - pieceH * blockSize) / 2;

    for (final b in blocks) {
      final bx = startX + (b.x - minX) * blockSize;
      final by = startY + (b.y - minY) * blockSize;
      final rect = Rect.fromLTWH(bx + 1, by + 1, blockSize - 2, blockSize - 2);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(color, Colors.white, 0.4)!,
            color,
          ],
        ).createShader(rect);

      canvas.drawRRect(rrect, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MiniPiecePainter oldDelegate) => true;
}
