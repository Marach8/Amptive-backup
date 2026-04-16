import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/notifications/cubits/get_notifications_cubit.dart';
import 'package:amptive/src/features/notifications/data/models/get_notifications_response_model.dart';
import 'package:amptive/src/config/utils/dialogs/notification/view_cohost_invite.dart';
import 'package:amptive/src/features/notifications/presentation/widgets/notif_widgets_export.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationTabView extends StatelessWidget {
  const NotificationTabView({super.key, this.nestedKey, this.onScroll});

  final GlobalKey<NestedScrollViewState>? nestedKey;
  final VoidCallback? onScroll;

  @override
  Widget build(BuildContext context) {
    return _NotificationTabViewContent(
      nestedKey: nestedKey,
      onScroll: onScroll,
    );
  }
}

class _NotificationTabViewContent extends StatefulWidget {
  const _NotificationTabViewContent({this.nestedKey, this.onScroll});

  final GlobalKey<NestedScrollViewState>? nestedKey;
  final VoidCallback? onScroll;

  @override
  State<_NotificationTabViewContent> createState() =>
      _NotificationTabViewContentState();
}

class _NotificationTabViewContentState
    extends State<_NotificationTabViewContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ScrollController? controller =
          widget.nestedKey?.currentState?.innerController;
      if (controller != null && widget.onScroll != null) {
        controller.addListener(() {
          widget.onScroll!();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        return context.read<ATNavBarBloc>().ctrlNavVisibility(scrollInfo);
      },
      child: NestedScrollView(
        key: widget.nestedKey,
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) => <Widget>[
          const ATSliverAppBar(
            titleText: 'Notifications',
            leading: SizedBox.shrink(),
          ),
        ],
        body: BlocConsumer<GetNotificationsCubit,
            ATAppState<NotificationsResponseModel>>(
          listener: (BuildContext context,
              ATAppState<NotificationsResponseModel> state) {
            if (state is FailureState<NotificationsResponseModel>) {
              showAppNotification2(
                context: context,
                text: state.message,
                type: NotificationType.failure,
              );
            }
          },
          builder: (BuildContext context,
              ATAppState<NotificationsResponseModel> state) {
            return switch (state) {
              InitialState<NotificationsResponseModel>() =>
                const SizedBox.shrink(),
              LoadingState<NotificationsResponseModel>() ||
              FailureState<NotificationsResponseModel>() ||
              SuccessState<NotificationsResponseModel>() =>
                Builder(builder: (BuildContext context) {
                  final NotificationsResponseModel? notifications = context
                      .read<GetNotificationsCubit>()
                      .currentNotifications;
                  final List<Notifications> notificationsList =
                      notifications?.notifications ?? <Notifications>[];

                  if (notificationsList.isEmpty) {
                    if (state is LoadingState<NotificationsResponseModel>) {
                      return const _NotificationInitialLoadingShimmer();
                    }
                    if (state is FailureState<NotificationsResponseModel>) {
                      return Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => context
                              .read<GetNotificationsCubit>()
                              .fetchNotifications(refresh: true),
                        ),
                      );
                    }
                    return const Center(
                        child: Text('No notifications available'));
                  }

                  final bool hasMore = notifications?.hasMore ?? false;
                  final int count = notificationsList.length;

                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<GetNotificationsCubit>()
                        .fetchNotifications(refresh: true),
                    child: ListView.separated(
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 50),
                      itemCount: hasMore ? count + 1 : count,
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= count) {
                          if (state
                              is LoadingState<NotificationsResponseModel>) {
                            return const _NotificationShimmerItem();
                          }
                          return const SizedBox.shrink();
                        }

                        final Notifications item = notificationsList[index];

                        if (item.type == 'follower') {
                          return NewFollowerNotif(
                            follower: getHostList().first,
                            timeOfFollow: '20s',
                          );
                        }
                        if (item.type == 'reschedule') {
                          return const ProgramRescheduledNotif(
                            progName: 'Trump in Nigera',
                            progImg: ATImgStrings.JOE_POMP_SHOW,
                            timeOfReschedule: '1h',
                          );
                        }
                        if (item.type == 'program_ended') {
                          return const ProgramEndedNotif(
                            progName: 'We Can Do Hard Things',
                            progImg: ATImgStrings.JOE_POMP_SHOW,
                            timeOfEnd: '1m',
                          );
                        }
                        if (item.type == 'program_live' ||
                            item.type == 'live') {
                          return const ProgramIsLiveNotif(
                            progImg: ATImgStrings.jpeg1,
                            progName: 'Sports Wednessday',
                            startTime: '4h',
                            isEvent: false,
                          );
                        }
                        if (item.type == 'declined_cohost_request') {
                          return DeclinedCohostInviteNotif(
                            cohost: getHostList()[3],
                            timeOfDecline: '5h',
                          );
                        }
                        if (item.type == 'cohost_invite_payment') {
                          return const CohostInvitePaymentNotif(
                            progName: 'Football Weekly',
                            progImg: ATImgStrings.jpeg3,
                            inviteTime: '5h',
                          );
                        }
                        if (item.type == 'cohost_invite') {
                          return CohostInviteNotif(
                            progOwner: getHostList()[6],
                            progName: 'Sports Weekly',
                            inviteTime: '54m',
                            isEvent: false,
                            onResponse: () async {
                              await viewCoHostInviteDetails(
                                context: context,
                                coHostFee: '5,000',
                                hostImg:
                                    getHostList()[6].obj.profilePicture ?? '',
                                progName: 'Sports Weekly',
                                hostUsername:
                                    getHostList()[6].obj.username ?? '',
                                isEvent: false,
                              );
                            },
                          );
                        }
                        if (item.type == 'program_about_to_start') {
                          return const ProgramAbout2StartNotif(
                            notifTime: '10m',
                            progImg: ATImgStrings.techCard,
                            startTime: '1hour',
                            progName: 'Talks With Jozy',
                          );
                        }
                        if (item.type == 'subscriber') {
                          return NewSubscriberNotif(
                            subscriber: getHostList()[2],
                            timeOfSub: '56s',
                          );
                        }
                        if (item.type == 'attendees') {
                          return NewAttendeesNotif(
                            attendees: getHostList().take(3).toList(),
                            progName: 'Bitcoin Beach',
                            isEvent: true,
                            time: '23h',
                          );
                        }
                        if (item.type == 'gifters') {
                          return NewGiftersNotif(
                            gifters: getHostList().reversed.take(3).toList(),
                            progName: 'Trump Is Winning',
                            time: '4s',
                          );
                        }
                        if (item.type == 'withdrawal_processed') {
                          return const WithdrawalProcessedNotif(
                            amount: '500,000',
                            time: '26m',
                          );
                        }
                        if (item.type == 'deposit_success') {
                          return const DepositSuccessNotif(
                            amount: '1,000,000',
                            time: '35s',
                          );
                        }
                        if (item.type == 'money_received') {
                          return const MoneyReceivedNotif(
                            amount: '55,050',
                            time: '2h',
                            senderName: 'nnanna',
                          );
                        }

                        return GenericAppNotificationTile(
                          title: item.title ?? 'Update',
                          subtitle: item.message ?? '',
                          isRead: item.isRead ?? false,
                          time: item.createdAt?.toTimeAgo,
                        );
                      },
                    ),
                  );
                }),
            };
          },
        ),
      ),
    );
  }
}

class _NotificationInitialLoadingShimmer extends StatelessWidget {
  const _NotificationInitialLoadingShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemCount: 10,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 60),
      itemBuilder: (_, __) => const _NotificationShimmerItem(),
    );
  }
}

class _NotificationShimmerItem extends StatelessWidget {
  const _NotificationShimmerItem();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          ATShimmer(width: 40, height: 40, radius: 30),
          SizedBox(width: 10),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ATShimmer(height: 10, radius: 3, width: 80),
                SizedBox(width: 5),
                ATShimmer(height: 10, radius: 3, width: 120),
                SizedBox(width: 5),
                ATShimmer(width: 10, height: 10, radius: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
