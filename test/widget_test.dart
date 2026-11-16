import 'package:flutter_test/flutter_test.dart';
import 'package:mobaile/main.dart';

void main() {
  testWidgets('Tetris app start screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TetrisApp());
    expect(find.text('NEON TETRIS'), findsOneWidget);
    expect(find.text('START GAME'), findsOneWidget);
  });
}
