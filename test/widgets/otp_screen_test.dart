import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/presentation/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ATOTPScreen', () {
    testWidgets('renders the OTP input fields and resend button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ATOTPScreen(
            params: VerifyOTPScreenParams(
              dataToVerify: 'user@example.com',
              verificationType: OTPVerificationType.email,
            ),
          ),
        ),
      );

      // Allow the widget tree to build.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Four OTP text fields should be present (one per digit).
      expect(find.byType(TextFormField), findsNWidgets(4));

      // The "Didn't get the code?" prompt should be visible.
      expect(find.text(ATStrings.didNotGetCode), findsOneWidget);

      // The resend action label should be visible.
      expect(find.text(ATStrings.sendAgain), findsOneWidget);

      // The "Next" button should be present (disabled until a complete OTP).
      expect(find.text(ATStrings.next), findsOneWidget);
    });

    testWidgets('enables the Next button once a complete OTP is entered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ATOTPScreen(
            params: VerifyOTPScreenParams(
              dataToVerify: 'user@example.com',
              verificationType: OTPVerificationType.email,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Type a digit into each of the four OTP fields.
      for (int i = 0; i < 4; i++) {
        await tester.enterText(find.byType(TextFormField).at(i), '$i');
        await tester.pump();
      }

      // The Next button should now be tappable (its onPressed callback is set).
      final ElevatedButton nextButton =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(nextButton.onPressed, isNotNull);
    });
  });
}