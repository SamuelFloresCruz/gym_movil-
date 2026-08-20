import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:aplicacion_movil/features/client/presentation/pages/pantalla_cliente.dart';
import 'package:aplicacion_movil/main.dart';

void main() {
  Future<void> ensureMenuOpen(WidgetTester tester) async {
    final openMenuButton = find.byIcon(Icons.menu);
    if (tester.any(openMenuButton)) {
      await tester.tap(openMenuButton);
      await tester.pumpAndSettle();
    }
  }

  testWidgets('shows client home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GymProApp(home: ClientShellPage()));

    expect(find.text('Hola, Mauricio'), findsOneWidget);
    expect(find.text('Rutina activa'), findsOneWidget);
    expect(find.text('Accesos rapidos'), findsOneWidget);

    await ensureMenuOpen(tester);
    await tester.tap(find.text('Musculos').last);
    await tester.pumpAndSettle();

    expect(
      find.text('Explora cada grupo muscular y sus zonas de trabajo.'),
      findsOneWidget,
    );
    expect(find.text('Pecho'), findsOneWidget);

    await ensureMenuOpen(tester);
    await tester.tap(find.text('Rutinas').last);
    await tester.pumpAndSettle();

    expect(
      find.text('Organiza tus entrenamientos por dia y grupo muscular.'),
      findsOneWidget,
    );
    expect(find.text('Plan semanal'), findsOneWidget);
    expect(find.text('Musculos para Lunes'), findsOneWidget);

    await ensureMenuOpen(tester);
    await tester.tap(find.text('Seguimiento').last);
    await tester.pumpAndSettle();

    expect(find.text('Seguimiento muscular'), findsOneWidget);
    expect(find.text('Calendario de entrenamiento'), findsOneWidget);

    await ensureMenuOpen(tester);
    await tester.tap(find.text('Tiempo').last);
    await tester.pumpAndSettle();

    expect(find.text('Cronometro'), findsOneWidget);
    expect(find.text('Iniciar'), findsOneWidget);
    expect(find.text('Vueltas'), findsNothing);

    await ensureMenuOpen(tester);
    await tester.tap(find.text('Perfil').last);
    await tester.pumpAndSettle();

    expect(find.text('Perfil'), findsWidgets);
    expect(find.text('Mauricio Alvarez'), findsOneWidget);
    expect(find.text('4829157'), findsWidgets);
  });
}
