import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

class EditSocialsScreenParams {
  const EditSocialsScreenParams({
    required this.initialLink,
    required this.socialName,
  });

  final String? initialLink;
  final String socialName;
}

class EditSocialsScreen extends StatefulWidget {
  const EditSocialsScreen({super.key, required this.params});
  final EditSocialsScreenParams params;

  @override
  State<EditSocialsScreen> createState() => _EditSocialsScreenState();
}

class _EditSocialsScreenState extends State<EditSocialsScreen> {
  late final TextEditingController _cntrl;
  bool btnActive = false;

  @override
  void initState() {
    super.initState();
    _cntrl = TextEditingController(text: widget.params.initialLink)
      ..addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final bool isDifferent =
        _cntrl.text.isNotEmpty && (_cntrl.text.trim() != widget.params.initialLink);
    if (btnActive != isDifferent) {
      setState(() => btnActive = isDifferent);
    }
  }

  @override
  void dispose() {
    _cntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget prefix = const SizedBox.shrink();
    String hintText = '';

    if (widget.params.socialName == ATStrings.website) {
      hintText = ATStrings.enterLink(widget.params.socialName.toLowerCase());
    }
    hintText = ATStrings.enterLink(
        '${widget.params.socialName} ${ATStrings.PROFILE.toLowerCase()}');

    switch (widget.params.socialName) {
      case ATStrings.instagram:
        prefix = Icon(Iconsax.instagram, color: ATColors.white, size: 20);
      case ATStrings.x:
        prefix = const ATImgLoader(
          imgPath: ATImgStrings.xLogo,
          height: 20, width: 24,
        );
      case ATStrings.linkedIn:
        prefix =
            FaIcon(FontAwesomeIcons.linkedin, color: ATColors.white, size: 20);
      case ATStrings.website:
        prefix = Transform.rotate(
          angle: -0.9,
          child: Icon(Icons.insert_link, color: ATColors.white, size: 20),
        );
    }

    return BlocProvider<RemoteUserDataCubit>(
      create: (_) => RemoteUserDataCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: ATAppBar(
              leadingWidth: 30,
              padding: const EdgeInsets.only(left: 7),
              leading: const ATRoundedBackBtn(),
              titleText: widget.params.socialName),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: ATTextFormField(
              controller: _cntrl,
              maxLines: 1,
              maxLength: 150,
              disableBlueBorder: true,
              contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              fillColor: ATColors.transparent,
              filled: false,
              hintText: hintText,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: prefix,
              ),
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
              }) => Text(
                '${maxLength! - currentLength} remaining',
                style: context.textTheme.titleSmall
                  ?.copyWith(fontSize: 11)
              ),
            ),
          ),

          bottomSheet: BlocConsumer<RemoteUserDataCubit, ATAppState<ProfileData>>(
            listener: (_, ATAppState<ProfileData> state) {
              if (state is SuccessState<ProfileData>) {
                context.pop(_cntrl.text.trim());
              } else if (state is FailureState<ProfileData>) {
                showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure,
                );
              }
            },
            builder: (BuildContext context, ATAppState<ProfileData> state) {
              final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
              final double bottom = bottomInset == 0 ? 50.0 : 15.0;
              return Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 15, bottom),
                child: ATPlainElevatedBtn(
                  isLoading: state is LoadingState<ProfileData>,
                  onPressed: btnActive
                      ? () {
                          context.read<RemoteUserDataCubit>().updateRemoteUserProfile(
                              userProfileData: ProfileData(
                            instagramUrl: widget.params.socialName == ATStrings.instagram
                                ? _cntrl.text.trim() : null,
                            xUrl: widget.params.socialName == ATStrings.x
                                ? _cntrl.text.trim() : null,
                            linkedinUrl: widget.params.socialName == ATStrings.linkedIn
                                ? _cntrl.text.trim() : null,
                            websiteUrl: widget.params.socialName == ATStrings.website
                                ? _cntrl.text.trim() : null,
                          ));
                        }
                      : null,
                  btnTitle: widget.params.initialLink == null
                      ? ATStrings.addLink
                      : ATStrings.acceptChanges,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
