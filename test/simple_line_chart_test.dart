import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tp_charts/tp_charts.dart';

void main() {
  group('SimpleLineChart Tests', () {
    testWidgets('SimpleLineChart should render without error', (
      WidgetTester tester,
    ) async {
      // Dados de teste
      final dates = [
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 2),
        DateTime(2024, 1, 3),
        DateTime(2024, 1, 4),
        DateTime(2024, 1, 5),
      ];

      final values = [100.0, 120.0, 80.0, 150.0, 110.0];

      // Construir o widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: SimpleLineChart(
                dates: dates,
                yValues: values,
                color: Colors.blue,
                lineWidth: 3.0,
                animationDuration:
                    Duration.zero, // Desabilitar animação para teste
              ),
            ),
          ),
        ),
      );

      // Aguardar renderização
      await tester.pumpAndSettle();

      // Verificar se o widget foi renderizado sem erros
      expect(find.byType(SimpleLineChart), findsOneWidget);
      // Não vamos verificar CustomPaint específico pois pode haver múltiplos
    });

    testWidgets('SimpleLineChart with date filtering', (
      WidgetTester tester,
    ) async {
      final dates = [
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 2),
        DateTime(2024, 1, 3),
        DateTime(2024, 1, 4),
        DateTime(2024, 1, 5),
      ];

      final values = [100.0, 120.0, 80.0, 150.0, 110.0];

      // Testar com filtro de data
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: SimpleLineChart(
                dates: dates,
                yValues: values,
                startDate: DateTime(2024, 1, 2),
                endDate: DateTime(2024, 1, 4),
                color: Colors.red,
                animationDuration: Duration.zero,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SimpleLineChart), findsOneWidget);
    });

    testWidgets('SimpleLineChart with string labels', (
      WidgetTester tester,
    ) async {
      final labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
      final values = [100.0, 120.0, 80.0, 150.0, 110.0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: SimpleLineChart(
                xValues: labels,
                yValues: values,
                color: Colors.green,
                animationDuration: Duration.zero,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SimpleLineChart), findsOneWidget);
    });

    testWidgets('SimpleLineChart empty state', (WidgetTester tester) async {
      final dates = [DateTime(2024, 1, 1), DateTime(2024, 1, 2)];
      final values = [100.0, 120.0];

      // Testar com filtro que não retorna dados
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: SimpleLineChart(
                dates: dates,
                yValues: values,
                startDate: DateTime(2024, 2, 1), // Data futura
                endDate: DateTime(2024, 2, 2), // Data futura
                color: Colors.purple,
                animationDuration: Duration.zero,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Deve mostrar mensagem de estado vazio
      expect(
        find.text('Não existem valores no período especificado.'),
        findsOneWidget,
      );
    });

    testWidgets('SimpleLineChart customization options', (
      WidgetTester tester,
    ) async {
      final dates = [
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 2),
        DateTime(2024, 1, 3),
      ];
      final values = [100.0, 120.0, 80.0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: SimpleLineChart(
                dates: dates,
                yValues: values,
                color: Colors.orange,
                lineWidth: 5.0,
                pointRadius: 10.0,
                gridCount: 8,
                autoGridCount: true,
                maxXLabels: 5,
                rotateLabels: true,
                gridLineOpacity: 0.2,
                animationDuration: Duration.zero,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SimpleLineChart), findsOneWidget);
    });
  });

  group('SimpleLineChart Widget Tests', () {
    test('SimpleLineChart constructor assertions', () {
      // Teste de assertions do construtor
      expect(
        () => SimpleLineChart(
          yValues: [], // Lista vazia deve falhar
        ),
        throwsAssertionError,
      );

      expect(
        () => SimpleLineChart(
          yValues: [100.0], // Sem dates nem xValues
        ),
        throwsAssertionError,
      );

      expect(
        () => SimpleLineChart(
          dates: [DateTime.now()],
          yValues: [100.0, 200.0], // Tamanhos diferentes
        ),
        throwsAssertionError,
      );
    });
  });
}
