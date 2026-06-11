import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditBioScreen extends StatefulWidget {
  const EditBioScreen({super.key, this.initialBio});
  final String? initialBio;

  @override
  State<EditBioScreen> createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  late final TextEditingController _cntrl;
  bool buttonIsActive = false;

  @override
  void initState() {
    super.initState();
    _cntrl = TextEditingController(text: widget.initialBio)
      ..addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final bool didAddNewBio =
        _cntrl.text.isNotEmpty && 
        (_cntrl.text.trim() != widget.initialBio);
    if (buttonIsActive != didAddNewBio) {
      setState(() => buttonIsActive = didAddNewBio);
    }
  }

  @override
  void dispose() {
    _cntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteUserDataCubit>(
      create: (_) => RemoteUserDataCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: const ATAppBar(
              leadingWidth: 30,
              padding: EdgeInsets.only(left: 7),
              leading: ATRoundedBackBtn(),
              titleText: ATStrings.bio),
          body: ATTextFormField(
            controller: _cntrl,
            maxLines: null,
            maxLength: 150,
            disableBlueBorder: true,
            contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            prefixIcon: const SizedBox(
              width: 15,
            ),
            fillColor: ATColors.transparent,
            filled: false,
            enabledBorder: UnderlineInputBorder(
               borderSide:
                   BorderSide(color: ATColors.white.withValues(alpha: 0.1))),
           focusedBorder: UnderlineInputBorder(
               borderSide:
                   BorderSide(color: ATColors.white.withValues(alpha: 0.1))),
           buildCounter: (
             BuildContext context, {
             required int currentLength,
             required bool isFocused,
             required int? maxLength,
           }) =>
               Text('${maxLength! - currentLength} remaining',
                   style: context
                       .textTheme
                       .titleSmall
                       ?.copyWith(fontSize: 11)),
         ),

         bottomSheet: BlocConsumer<RemoteUserDataCubit, ATAppState<UserProfileData>>(
             listener: (_, ATAppState<UserProfileData> state) {
               if (state is SuccessState<UserProfileData>) {
                 context.pop(_cntrl.text.trim());
               }
               else if (state is FailureState<UserProfileData>) {
                 showAppNotification2(
                   context: context,
                   text: state.message,
                   type: NotificationType.failure,
                 );
               }
             },
             builder: (BuildContext context, ATAppState<UserProfileData> state) {
               final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
               final double bottom = bottomInset == 0 ? 50.0 : 15.0;
               return Padding(
                 padding: EdgeInsets.fromLTRB(15, 5, 15, bottom),
                 child: ATPlainElevatedBtn(
                   isLoading: state is LoadingState<UserProfileData>,
                   onPressed: buttonIsActive
                       ? () {
                           context.read<RemoteUserDataCubit>()
                              .updateRemoteUserProfile(
                                userProfileData: UserProfileData(
                                  bio: _cntrl.text.trim()));
                         }
                       : null,
                   btnTitle: widget.initialBio == null
                      ? 'Add Bio' : ATStrings.acceptChanges,
                 ),
               );
             },
           ),
        ),
      ),
    );
  }
}
