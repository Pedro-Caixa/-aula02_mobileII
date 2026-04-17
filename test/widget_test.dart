import 'package:flutter_test/flutter_test.dart';

import 'package:todo_refatoracao_baguncado/app/app_root.dart';

void main() {
  testWidgets('App inicia com tela de Produtos', (WidgetTester tester) async {
    await tester.pumpWidget(const AppRoot());

    expect(find.text('Produtos'), findsOneWidget);
  });
}
