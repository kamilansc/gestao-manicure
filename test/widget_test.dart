import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestao_manicure/views/custos_page.dart';

void main() {
  testWidgets('Custos exibe resumo e despesas de exemplo sem erros de layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CustosPage())),
    );

    expect(find.text('Gastos & Materiais'), findsOneWidget);
    expect(find.text('R\$ 151,00'), findsOneWidget);
    expect(find.text('4 itens'), findsOneWidget);
    expect(find.text('Luvas de Nitrilo Rosa (Caixa 100 un)'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Alicate Mundial 722 Inox'), 200);
    expect(find.text('Alicate Mundial 722 Inox'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Adicionar despesa informa que o cadastro ainda não está disponível',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustosPage())),
      );

      await tester.tap(find.byTooltip('Adicionar despesa'));
      await tester.pump();

      expect(find.text('Cadastro ainda não implementado.'), findsOneWidget);
    },
  );
}
