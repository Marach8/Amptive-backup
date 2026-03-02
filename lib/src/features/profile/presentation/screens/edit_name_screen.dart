import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
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
              ATTextFormField(
                controller: _cntrl,
                maxLines: 1,
                prefixIcon: const SizedBox(width: 15,),
              ),
              const SizedBox(height: 10),
              Text(
                ATStrings.THIS_WILL_APPEAR_ON_PROFILE,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: ATSizes.size11
                )
              )
            ],
          ),
        ),

        bottomSheet: Builder(
          builder: (BuildContext context) {
            final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
            final double bottom = bottomInset == 0 ? 50.0 : 15;
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, bottom),
              child: ATPlainElevatedBtn(
                onPressed: btnActive ? () => context.pop(_cntrl.text.trim()) : null,
                btnTitle: ATStrings.ACCEPT_CHANGES,
              ),
            );
          }
        ),
      ),
    );
  }
}
