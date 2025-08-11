import 'dart:async';

import 'package:amptive/src/bloc/authentication/email/email_auth_states.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/authentication/email/email_auth_bloc.dart';
import '../../bloc/authentication/email/email_auth_events.dart';
import '../../config/routing/route_strings.dart';
import '../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../views/widgets/common_widgets/common_widgets.dart';

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
                  ATStrings.UR_EMAIL,
                  style: Theme.of(context).textTheme.headlineMedium
                ),
                const SizedBox(height: 10),
                ATTextFormField(
                  controller: _emailCntrl,
                  hintText: ATStrings.ENTER_UR_EMAIL,
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
                  hintText: ATStrings.ENTER_UR_PSWRD,
                  validator: validatePassword,
                ),
              ],
            ),
          ),
        ),

        bottomSheet: Padding(
          padding: const EdgeInsets.all(15),
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
        )
      ),
    );
  }
}
