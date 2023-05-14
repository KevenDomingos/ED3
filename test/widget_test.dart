import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paulo_app/main.dart';

void main() {
  testWidgets('Teste de alteração de cor de fundo', (WidgetTester tester) async {
    // Constrói o widget principal
    await tester.pumpWidget(const MyApp());

    // Verifica se a cor de fundo é branca inicialmente
    expect(find.byType(Container).first, findsOneWidget);
    expect(tester.widget<Container>(find.byType(Container).first).color, Colors.white);

    // Encontra e clica no botão personalizado
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verifica se a cor de fundo foi alterada para preto
    expect(tester.widget<Container>(find.byType(Container).first).color, Colors.black);

    // Clica novamente no botão personalizado
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verifica se a cor de fundo foi alterada de volta para branco
    expect(tester.widget<Container>(find.byType(Container).first).color, Colors.white);
  });
}
