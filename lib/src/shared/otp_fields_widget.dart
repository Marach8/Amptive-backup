import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import '../config/utils/font_weights.dart';
import '../config/utils/other_strings.dart';

class ATOTPFieldsWidget extends StatefulWidget {
  const ATOTPFieldsWidget(
      {super.key,
      required this.onPinComplete,
      this.spacing = 10,
      this.noOfFields = 4,
      this.height = 50,
      this.width = 57,
      this.onPinFieldChanged,
      this.mainAxisAlignment = MainAxisAlignment.start});

  final Future<bool> Function(String pin) onPinComplete;
  final void Function(String pin)? onPinFieldChanged;
  final double spacing, height, width;
  final int noOfFields;
  final MainAxisAlignment mainAxisAlignment;

  @override
  State<ATOTPFieldsWidget> createState() => _ATOTPFieldsWidgetState();
}

class _ATOTPFieldsWidgetState extends State<ATOTPFieldsWidget> {
  List<String> pins = <String>[];
  bool isValidated = true;

  @override
  void initState() {
    super.initState();
    pins = List<String>.filled(widget.noOfFields, '');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.mainAxisAlignment,
      spacing: widget.spacing,
      children: List<Widget>.generate(widget.noOfFields, (int index) {
        return StatefulBuilder(builder: (_, StateSetter setter) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: _OTPField(
              isValidated: isValidated,
              onChanged: (String value) async {
                final int? parsedValue = int.tryParse(value);
                if (parsedValue != null) {
                  pins[index] = value;
                } else {
                  pins[index] = '';
                }
                widget.onPinFieldChanged?.call(value);

                if (pins.every((String pin) => pin.isNotEmpty)) {
                  FocusScope.of(context).unfocus();
                  final bool result = await widget.onPinComplete(pins.join());
                  setter(() => isValidated = result);
                } else if (value.isNotEmpty && index != 3) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index != 0) {
                  FocusScope.of(context).previousFocus();
                }
              },
            ),
          );
        });
      }),
    );
  }
}

class _OTPField extends StatelessWidget {
  const _OTPField({required this.onChanged, required this.isValidated});

  final void Function(String)? onChanged;
  final bool isValidated;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      maxLength: 1,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        counterText: ATStrings.empty,
        error: isValidated ? null : const SizedBox.shrink(),
        label: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 15),
          child: const Text(ATStrings.hyphen),
        ),
        labelStyle: context.textTheme.headlineMedium?.copyWith(
          fontWeight: ATFontWeights.w400,
        ),
        filled: true,
        fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: ATColors.transparent,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: ATColors.textRedColor,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ATColors.textRedColor),
          borderRadius: BorderRadius.circular(14),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ATColors.transparent),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      style: context.textTheme.headlineMedium?.copyWith(
        fontWeight: ATFontWeights.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}
