import 'package:amptive/src/bloc/authentication_bloc/auth_bloc.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_events.dart';
import 'package:amptive/src/bloc/authentication_bloc/auth_states.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:developer' as marach show log;



class AmptiveCreatePasswordScreen extends StatefulWidget {
  const AmptiveCreatePasswordScreen({super.key});

  
  @override
  State<AmptiveCreatePasswordScreen> createState() => _AmptiveCreatePasswordScreenState();
}

class _AmptiveCreatePasswordScreenState extends State<AmptiveCreatePasswordScreen> {
  late TextEditingController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override 
  void initState(){
    super.initState();
    _controller = TextEditingController();
  }

  @override 
  void dispose(){
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: const AmptiveAppBar(),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AmptiveOtherStrings.createPasswordForYourAccount,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                
                Gap(10.h),
                Form(
                  key: _formKey,
                  child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                    buildWhen: (previous, current) => previous.hidePassword != current.hidePassword,
                    builder: (_, state) {
                      final hidePassword = state.hidePassword ?? false;
                      return AmptiveTextFormFieldWidget(
                        controller: _controller,
                        onChanged: (value) => context.read<AmptiveAuthBloc>().add(
                          GetTheCurrentTextOnThePaaswordFieldAuthEvent(currentTextOnThePasswordField: value)
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => context.read<AmptiveAuthBloc>().add(HideOrShowPasswordAuthEvent()),
                          child: hidePassword ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                        ),
                        hintText: AmptiveOtherStrings.enterYourPassword,
                        obscureText: hidePassword,
                      );
                    }
                  ),
                ),
                Gap(10.h),
            
                Text(
                  AmptiveOtherStrings.passwordMustBeAtleast8,
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            ),
          ),
        ),

        bottomSheet: Padding(
          padding: const EdgeInsets.only(bottom: 20).r,
          child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
            buildWhen: (previous, current) => previous.userPassword != current.userPassword,
            builder: (_, state) {
              final userPassword = state.userPassword;
              marach.log(userPassword.toString());
              final passwordIsValid = userPassword != null && userPassword.length >= 8;
              return AmptiveElevatedButtonWidget(
                buttonTitle: AmptiveOtherStrings.next,
                onPressed: passwordIsValid ? (){} : null
              );
            }
          ),
        ),
      ),
    );
  }
}
