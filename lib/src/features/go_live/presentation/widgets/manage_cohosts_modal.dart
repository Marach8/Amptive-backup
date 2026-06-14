import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'dart:ui';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/manage_cohost_tabs.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/search_cohost_field.dart';
import 'package:amptive/src/features/profile/presentation/widgets/profile_screen_tabs.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

Future<void> showManageCohostsModal({
  required BuildContext context,
  required LiveStreamCubit1 liveStreamCubit,
  required LocalUserDataCubit localUserDataCubit,
}) async {
  return await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: ATColors.hex202020.withValues(alpha: 0.9),
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<LiveStreamCubit1>.value(value: liveStreamCubit),
            BlocProvider<LocalUserDataCubit>.value(value: localUserDataCubit),
          ],
          child: const _ManageCohosts(),
        );
      });
}


class _ManageCohosts extends StatefulWidget {
  const _ManageCohosts();

  @override
  State<_ManageCohosts> createState() => _ManageCohostsState();
}

class _ManageCohostsState extends State<_ManageCohosts> {

  final ValueNotifier<List<String>> _idsForResendingNotifier
    = ValueNotifier<List<String>>(<String>[]);

  final List<String> _tabs = <String>[
    'All', 'Accepted', 'Declined', 'Ignored',
  ];

  @override 
  void dispose(){
    _idsForResendingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          builder: (_, __) {
            return Container(
              padding: const EdgeInsets.only(top: 10),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: DefaultTabController(
                  length: _tabs.length,
                  child: Column(
                    children: <Widget>[
                      const ATModalDismisser(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text('Manage Co-hosts',
                          style: context.textTheme.bodyLarge),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text(
                          'Easily add or remove co-hosts. New co-hosts must accept your invitation before they can join.',
                          maxLines: 2,
                          style: context.textTheme.labelSmall!
                              .copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(height: 30,
                        child: ProfileScreenTabs(tabs: _tabs)),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Co-hosts',
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                      ),

                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            InvitedCohostsTab(
                              invitedCohosts: [],
                            ),
                            AcceptedCohostsTab(
                              acceptedCohosts: [],
                            ),
                            DeclinedCohostsTab(
                              declinedCohosts: [],
                            ),
                            IgnoredCohostsTab(
                              ignoredCohosts: [],
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ValueListenableBuilder<List<String>>(
          valueListenable: _idsForResendingNotifier,
          child: const _ResendInviteWidget(),
          builder: (_, List<String> value, Widget? child) {
            final bool showWidget = value.isNotEmpty;
            return AnimatedPositioned(
              bottom: !showWidget ? 0 : -100,
              duration: const Duration(milliseconds: 500),
              child: child!
            );
          }
        ),
      ],
    );
  }
}



class _ResendInviteWidget extends StatelessWidget {
  const _ResendInviteWidget();

  @override
  Widget build(BuildContext context) {
    final ProfileData? currUserData = context
      .read<LocalUserDataCubit>().currentUserData;

    
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(16),
      width: context.screenWidth,
      decoration: const BoxDecoration(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Row(
          children: <Widget>[
            Container(
              height: 46.4, width: 46.4,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(25),
                color: ATColors.white.withValues(alpha: 0.1),
              ),
              child: const ATImgLoader(
                imgPath: ATImgStrings.manageCohostsIcon,
                height: 28, width: 28,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Spice things up',
                      style: context.textTheme.bodySmall
                          ?.copyWith(fontSize: ATSizes.size15)),
                  Text(
                    'Resend invite(s) to cohosts',
                    style: context.textTheme.titleMedium
                      ?.copyWith(color: ATColors.hexC2C2C2))
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            ATContainer(
              onTap: (){},
              radius: 40,
              color: ATColors.hex307FE2,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(
                'Re-send invite',
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontSize: ATSizes.size15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
