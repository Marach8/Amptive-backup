import 'package:amptive/src/bloc/authentication/general/auth_events.dart';
import 'package:amptive/src/bloc/authentication/password/password_auth_states.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../../../shared/elevated_button_widget.dart';

class PasswordAuthScreen extends StatefulWidget {
  const PasswordAuthScreen({super.key});

  @override
  State<PasswordAuthScreen> createState() => _PasswordAuthScreenState();
}

class _PasswordAuthScreenState extends State<PasswordAuthScreen> with ATValidators{
  bool _passwordVisible = false;
  bool _showDescription = false;

  final TextEditingController _passwordCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override 
  void dispose(){
    _formKey.currentState?.dispose();
    _passwordCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(leading: ATBackBtn(),),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15),
            child: Column(
              spacing: 11,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.createPasswordForAccount,
                  style: context.textTheme.headlineMedium,
                ),
                ATTextFormField(
                  controller: _passwordCntrl,
                  maxLines: 1,
                  obscureText: !_passwordVisible,
                  hintText: ATStrings.enterYourPassword,
                  fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                  prefixIcon: const SizedBox(width: 10,),
                  keyboardType: TextInputType.visiblePassword,
                  autoValidateMode: AutovalidateMode.disabled,
                  validator: validatePassword,
                  suffixConstraints: const BoxConstraints(maxWidth: 45),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                    icon: Icon(_passwordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                  ),
                  onChanged: (String text){
                    if(text.isEmpty && _showDescription){
                      setState(() => _showDescription = false);
                    }
                    else if(text.isNotEmpty && !_showDescription){
                      setState(() => _showDescription = true);
                    }
                  },
                ),
                if(_showDescription)Text(
                  'Your password should be at least 8 characters, must contain at least one upper case letter',
                  style: context.textTheme.titleSmall,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),

        bottomSheet: Builder(
          builder: (BuildContext context) {
            final double bottom = MediaQuery.viewInsetsOf(context).bottom;
            final double bottomPad = bottom > 0 ? 10 : 50;
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPad),
              child: AnimatedBuilder(
                animation: _passwordCntrl,
                builder: (_, __) {
                  final bool activate = _passwordCntrl.text.trim().length >= 8;
                  return ATPlainElevatedBtn(
                    onPressed: activate ? (){
                      if(_formKey.currentState?.validate() == true){
                        RegistrationData().copyWith(password: _passwordCntrl.text.trim());
                        context.pushNamed(ATRoutes.dobAuthScreen);
                      }
                    } : null,
                    btnTitle: ATStrings.next,
                  );
                }
              ),
            );
          }
        ),
      ),
    );
  }
}
