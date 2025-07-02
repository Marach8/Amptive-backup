import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class EditBioScreen extends StatefulWidget {
  const EditBioScreen({super.key, required this.initialBio});
  final String initialBio;

  @override
  State<EditBioScreen> createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  late final TextEditingController _cntrl;
  bool btnActive = false;

  @override 
  void initState(){
    super.initState();
    _cntrl = TextEditingController(text: widget.initialBio)
      ..addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final bool isDifferent = _cntrl.text.isNotEmpty && 
      (_cntrl.text.trim() != widget.initialBio);
    if (btnActive != isDifferent) {
      setState(() => btnActive = isDifferent);
    }
  }

  @override
  void dispose(){
    _cntrl.removeListener(_handleTextChange);
    _cntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leadingWidth: 30,
          padding: EdgeInsets.only(left: 7),
          leading: ATRoundedBackBtn(),
          titleText: ATStrings.BIO
        ),
        body: ATTextFormField(
          controller: _cntrl,
          maxLines: null, maxLength: 150,
          disableBlueBorder: true,
          fillColor: ATColors.trsprnt,
          buildCounter: (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) => Text(
            '${maxLength! - currentLength} remaining',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: ATFontSizes.size11
            )
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: ATPlainElevatedBtn(
            onPressed: btnActive ? () => context.pop(_cntrl.text.trim()) : null,
            btnTitle: ATStrings.ACCEPT_CHANGES,
          ),
        ),
      ),
    );
  }
}
