import 'package:amptive/src/bloc/authentication/general/auth_bloc.dart';
import 'package:amptive/src/bloc/authentication/general/auth_events.dart';
import 'package:amptive/src/bloc/authentication/general/auth_states.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key, required this.initialUsername});
  final String initialUsername;

  @override
  State<EditUsernameScreen> createState() => _EditNameScreen();
}

class _EditNameScreen extends State<EditUsernameScreen> {
  late final TextEditingController _cntrl;

  @override 
  void initState(){
    super.initState();
    _cntrl = TextEditingController(text: widget.initialUsername.toLowerCase())
      ..addListener(_handleTextChange);
  }

  void _handleTextChange() {
    ATHelperFuncs.callDebouncer(
      1000,
      () => context.read<AmptiveAuthBloc>().add(UsernameChangedEvent(_cntrl.text.trim()))
    );
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
          titleText: ATStrings.username
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ATTextFormField(
                controller: _cntrl, maxLines: 1,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    ATStrings.AT_SIGN,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                    builder: (_, AmptiveAuthState state) {
                      if(state is VerifyingUsernameState) return const ATLoadingIndicator(size: 20,);
                      if(state is UsernameVerifiedState) return Icon(Icons.check, color: ATColors.hex54C981);
                      return const SizedBox.shrink();
                    }
                  ),
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                builder: (_, AmptiveAuthState state) {
                  return Text(
                    (state is VerifyingUsernameState) ? ATStrings.checker_loading 
                      : (state is UsernameVerifiedState) ? ATStrings.username_available : '',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: ATSizes.size11,
                      color: state is UsernameVerifiedState ? ATColors.hex54C981 : null
                    )
                  );
                }
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
              child: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
                builder: (_, AmptiveAuthState state) {
                  return ATPlainElevatedBtn(
                    onPressed: (state is UsernameVerifiedState) ? () => context.pop(_cntrl.text.trim()) : null,
                    btnTitle: ATStrings.ACCEPT_CHANGES,
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
