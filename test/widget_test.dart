import 'package:flutter_test/flutter_test.dart';
import 'package:saimpexwater_vendorapp/main.dart';

void main() {
  testWidgets('Login design renders', (tester) async {
    await tester.pumpWidget(const SaimpexVendorApp());
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Saimpex Vendor!'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
