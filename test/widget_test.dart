import 'package:flutter_test/flutter_test.dart';

import 'package:aplicacion_movil/main.dart';

void main() {
  testWidgets('shows client home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GymProApp());

    expect(find.text('Hola, Mauricio'), findsOneWidget);
    expect(find.text('Membresia activa'), findsOneWidget);
    expect(find.text('Accesos rapidos'), findsOneWidget);
  });
}
