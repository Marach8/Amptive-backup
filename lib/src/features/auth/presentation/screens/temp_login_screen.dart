
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';

class TempLoginScreen extends StatefulWidget {
  const TempLoginScreen({super.key, this.title});
  final String? title;

  @override
  State<TempLoginScreen> createState() => _TempLoginScreenState();
}

class _TempLoginScreenState extends State<TempLoginScreen> with ATValidators{
  final TextEditingController _emailCntrl = TextEditingController();
  final TextEditingController _pswrdCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<(bool, bool)> _btnNotifier = ValueNotifier<(bool, bool)>((false, false));

  @override 
  void initState(){
    super.initState();
    _emailCntrl.addListener(
      (){
        if(_emailCntrl.text.length >= 5){
          _btnNotifier.value = (true, _btnNotifier.value.$2);
        }
        else{
          _btnNotifier.value = (false, _btnNotifier.value.$2);
        }
      }
    );

    _pswrdCntrl.addListener(
      (){
        if(_pswrdCntrl.text.length >= 5){
          _btnNotifier.value = (_btnNotifier.value.$1, true);
        }
        else{
          _btnNotifier.value = (_btnNotifier.value.$1, false);
        }
      }
    );
  }

  @override
  void dispose() {
    _emailCntrl.dispose();
    _pswrdCntrl.dispose();
    _btnNotifier.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leading: const ATBackBtn(),
          titleText: widget.title ?? ''
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.whatIsYourEmail,
                  style: Theme.of(context).textTheme.headlineMedium
                ),
                const SizedBox(height: 10),
                ATTextFormField(
                  controller: _emailCntrl,
                  hintText: ATStrings.enterYourEmail,
                  validator: validateEmail,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(Icons.email_outlined,),
                  ),
                ),
            
                const SizedBox(height: 30,),
                Text(
                  ATStrings.UR_PSWRD,
                  style: Theme.of(context).textTheme.headlineMedium
                ),
                const SizedBox(height: 10),
                ATTextFormField(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(Icons.key_outlined),
                  ),
                  controller: _pswrdCntrl,
                  hintText: ATStrings.enterYourPassword,
                  validator: validatePassword,
                ),
              ],
            ),
          ),
        ),

        bottomSheet: Builder(
          builder: (BuildContext context) {
            final double bottom = MediaQuery.viewInsetsOf(context).bottom;
            final double bottomPadding = bottom == 0 ? 50 : 10;
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
              child: ValueListenableBuilder<(bool, bool)>(
                valueListenable: _btnNotifier,
                builder: (_, (bool, bool) value, __) {
                  final bool enable = value.$1 && value.$2;
                  return ATPlainElevatedBtn(
                    onPressed: enable ? (){
                      if(_formKey.currentState?.validate() ?? false){
                        context.goNamed(ATRoutes.MAIN_APP_SHELL);
                      }
                    } : null,
                    btnTitle: ATStrings.SIGN_IN,
                  );
                }
              ),
            );
          }
        )
      ),
    );
  }
}
