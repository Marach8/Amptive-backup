import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen ({super.key, required this.initialName});
  final String initialName;

  @override
  State<EditNameScreen> createState() => _EditNameScreen();
}

class _EditNameScreen extends State<EditNameScreen > {
  late final TextEditingController _cntrl;
  bool btnActive = false;

  @override 
  void initState(){
    super.initState();
    _cntrl = TextEditingController(text: widget.initialName)
      ..addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final bool isDifferent = _cntrl.text.isNotEmpty && 
      (_cntrl.text.trim() != widget.initialName);
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
          titleText: ATStrings.NAME,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ATTextFormField(controller: _cntrl),
              const SizedBox(height: 10),
              Text(
                ATStrings.THIS_WILL_APPEAR_ON_PROFILE,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: ATFontSizes.size11
                )
              )
            ],
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
