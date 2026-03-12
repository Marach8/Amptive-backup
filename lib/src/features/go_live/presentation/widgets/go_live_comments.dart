import 'dart:ui';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_notification_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import '../../../../models/go_live_notification_model.dart';
import '../../go_live_export.dart';

class GoLiveComments extends StatefulWidget {
  const GoLiveComments({super.key});

  @override
  State<GoLiveComments> createState() => _GoLiveCommentsState();
}

class _GoLiveCommentsState extends State<GoLiveComments> {
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _scroll2BottomNotifier =
      ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bool isScrollable = _scrollController.position.maxScrollExtent > 0;
      _scroll2BottomNotifier.value = isScrollable;
    });
  }

  @override
  void dispose() {
    _scroll2BottomNotifier.dispose();
    _scrollController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _scroll2BottomNotifier.value = true;
    } else if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      _scroll2BottomNotifier.value = false;
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        NotificationListener<ScrollNotification>(
          onNotification: context
              .read<GoLiveControlsVisibilityBloc>()
              .ctrlModerationToolsVisibility,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
            itemCount: getCoHostList().length,
            itemBuilder: (_, int listIndex) {
              final ATCohost<bool> user = getCoHostList().elementAt(listIndex);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ATCircularImage(
                        diameter: 35, imagePath: user.profilePicture ?? ''),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.username ?? '',
                              style: context.textTheme.bodySmall?.copyWith(
                                  color: ATColors.hexC2C2C2, height: 0.78)),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                              'I love this show because it is very goo and I know when I know very well🎉🤗😅',
                              maxLines: 2,
                              style: context.textTheme.titleMedium?.copyWith(
                                  fontSize: ATSizes.size13, height: 1.38)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),

        // Positioned(
        //   top: 0,
        //   child: Container(
        //     height: 1, width: context.screenWidth,
        //     decoration: BoxDecoration(
        //       color: ATColors.hex0D0D0D,
        //       boxShadow: <BoxShadow>[
        //         BoxShadow(
        //           color: ATColors.black,
        //           spreadRadius: 10, blurRadius: 20,
        //           offset: const Offset(0, 1)
        //         )
        //       ],
        //     ),
        //   ),
        // ),

        // const Positioned(
        //   top: 0,
        //   child: _Notifications()
        // ),

        Positioned(
          bottom: 70,
          right: 15,
          child: ValueListenableBuilder<bool>(
              valueListenable: _scroll2BottomNotifier,
              builder: (_, bool showIcon, __) {
                return ATScalingSwitcher(
                  duration: 200,
                  child: showIcon
                      ? ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: ATContainer(
                              key: const ValueKey<int>(1),
                              onTap: () => _scrollToBottom(),
                              color: ATColors.white.withValues(alpha: 0.1),
                              height: 35,
                              width: 35,
                              boxShape: BoxShape.circle,
                              child:
                                  const Icon(Icons.keyboard_double_arrow_down),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey<int>(2)),
                );
              }),
        )
      ],
    );
  }
}

class _Notifications extends StatelessWidget {
  const _Notifications();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AmptiveGoLiveNotificationBloc,
            AmptiveGoLiveNotificationModel>(
        builder: (_, AmptiveGoLiveNotificationModel state) {
      if (state.notificationType == ATStrings.PINNED) {
        return Positioned(
            top: 260,
            child: Container(
                color: Colors.red,
                width: ATHelperFuncs.getScreenWidth(context),
                child: AmptiveGoLivePinnedMsgNtfctnWidget(state: state)));
      }

      return Positioned(
          top: 260,
          left: 15,
          child: Container(
              color: Colors.green,
              child: AmptiveGoLiveNotificationsWidget(state: state)));
    });
  }
}
