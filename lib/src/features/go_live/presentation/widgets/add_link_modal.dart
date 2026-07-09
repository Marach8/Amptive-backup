import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

Future<(String, String)?> addLinkModal({
  required BuildContext context,
  String? linkName,
  String? linkUrl,
}) async {
  return await showModalBottomSheet<(String, String)>(
    // Same treatment as the cover-picker sheet: transparent sheet, the corners
    // and fill come from the ClipRRect + Material inside the widget.
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    constraints: BoxConstraints(
        maxHeight: context.screenHeight, maxWidth: context.screenWidth),
    context: context,
    isScrollControlled: true,
    elevation: 0,
    builder: (_) => _AddLinkWidget(linkName: linkName, linkUrl: linkUrl),
  );
}

class _AddLinkWidget extends StatefulWidget {
  const _AddLinkWidget({this.linkName, this.linkUrl});

  final String? linkName, linkUrl;

  @override
  State<_AddLinkWidget> createState() => _AddLinkWidgetState();
}

class _AddLinkWidgetState extends State<_AddLinkWidget> with ATValidators {
  late final TextEditingController _linkNameCntrl, _linkUrlCntrl;
  late final ValueNotifier<bool> _activateBtn;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _linkNameCntrl = TextEditingController(text: widget.linkName)
      ..addListener(_handleBtnActivation);

    _linkUrlCntrl = TextEditingController(text: widget.linkUrl)
      ..addListener(_handleBtnActivation);

    _activateBtn =
        ValueNotifier<bool>(widget.linkName != null && widget.linkUrl != null);
  }

  void _handleBtnActivation() =>
      _activateBtn.value = _linkNameCntrl.text.trim().isNotEmpty &&
          _linkUrlCntrl.text.trim().isNotEmpty;

  /// Users don't have to type a scheme — we add https:// for them.
  String _normalizeUrl(String value) {
    final String v = value.trim();
    if (v.isEmpty || v.contains('://')) return v;
    return 'https://$v';
  }

  @override
  void dispose() {
    _linkNameCntrl.dispose();
    _linkUrlCntrl.dispose();
    _activateBtn.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Material(
        color: const Color(0xFF1C1C1E),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
              16, 10, 16, MediaQuery.viewInsetsOf(context).bottom + 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 38,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
              ATStrings.ADD_LINK,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.39,
              ),
            ),
            const SizedBox(height: 24),
            _label(ATStrings.TEXT),
            const SizedBox(height: 10),
            _field(
              controller: _linkNameCntrl,
              hintText: ATStrings.LINK_NAME,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 22),
            _label(ATStrings.LINK),
            const SizedBox(height: 10),
            _field(
              controller: _linkUrlCntrl,
              hintText: ATStrings.LINK_URL,
              keyboardType: TextInputType.url,
              // Validate against the normalized value so a scheme-less URL
              // like "example.com" is accepted.
              validator: (String? v) => validateUrl(_normalizeUrl(v ?? '')),
            ),
            const SizedBox(height: 40),
            ValueListenableBuilder<bool>(
              valueListenable: _activateBtn,
              builder: (_, bool shouldActivate, __) {
                return ATPlainElevatedBtn(
                  onPressed: shouldActivate
                      ? () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.pop((
                              _linkNameCntrl.text.trim(),
                              _normalizeUrl(_linkUrlCntrl.text),
                            ));
                          }
                        }
                      : null,
                  btnTitle: ATStrings.ADD_LINK.toLowerCase().capitalize,
                  fgColor: ATColors.black,
                  bgColor: ATColors.white,
                );
              },
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: context.textTheme.bodySmall?.copyWith(fontSize: ATSizes.size15),
      ),
    );
  }

  /// Squircle-cornered field matching the create-form inputs.
  Widget _field({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(cornerRadius: 14, cornerSmoothing: 0.8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        cursorColor: ATColors.white,
        cursorHeight: 20,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        style: TextStyle(
          fontWeight: ATFontWeights.w400,
          fontSize: ATSizes.size16,
          color: ATColors.white,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: ATColors.white.withValues(alpha: 0.1),
          hintText: hintText,
          hintStyle: context.textTheme.bodySmall?.copyWith(
            color: ATColors.white.withValues(alpha: 0.4),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          // Faint white ring, echoing the header's circle buttons; brightens
          // a touch on focus.
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: ATColors.white.withValues(alpha: 0.08)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: ATColors.white.withValues(alpha: 0.18)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ATColors.textRedColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ATColors.textRedColor),
          ),
        ),
      ),
    );
  }
}
