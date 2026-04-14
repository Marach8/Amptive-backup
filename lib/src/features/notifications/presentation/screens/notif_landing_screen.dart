import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/notifications/cubits/get_notifications_cubit.dart';
import 'package:amptive/src/features/notifications/data/models/get_notifications_response_model.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/config/utils/dialogs/notification/view_cohost_invite.dart';
import 'package:amptive/src/features/notifications/presentation/widgets/notif_widgets_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationTabView extends StatelessWidget {
  const NotificationTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: context.read<ATNavBarBloc>().ctrlNavVisibility,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) => <Widget>[
          const ATSliverAppBar(
            titleText: 'Notifications',
            leading: SizedBox.shrink(),
          ),
        ],
        body: BlocConsumer<GetNotificationsCubit, ATAppState<NotificationsResponseModel>>(
          listener: (BuildContext context, ATAppState<NotificationsResponseModel> state) {
            if (state is FailureState<NotificationsResponseModel>) {
              showAppNotification2(
                context: context,
                text: state.message, 
                type: NotificationType.failure,
              );
            }
          },
          builder: (BuildContext context, ATAppState<NotificationsResponseModel> state) {
            return switch (state) {
              InitialState<NotificationsResponseModel>() => const SizedBox.shrink(),
              LoadingState<NotificationsResponseModel>() ||
              FailureState<NotificationsResponseModel>() ||
              SuccessState<NotificationsResponseModel>() =>
                Builder(builder: (BuildContext context) {
                  final NotificationsResponseModel? notifications = 
                      context.read<GetNotificationsCubit>().currentNotifications;
                      final List<Notifications> notificationsList = notifications?.notifications ?? <Notifications>[];

                  if (notificationsList.isEmpty) {
                    if (state is LoadingState<NotificationsResponseModel>) {
                      return const _NotificationInitialLoadingShimmer();
                    }
                    if (state is FailureState<NotificationsResponseModel>) {
                      return Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => context.read<GetNotificationsCubit>().fetchNotifications(),
                        ),
                      );
                    }
                    return const Center(child: Text('No notifications available'));
                  }

                  return RefreshIndicator(
                    onRefresh: () => context.read<GetNotificationsCubit>().fetchNotifications(),
                    child:  ListView.builder(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 50),
                      itemCount: notificationsList.length,
                      itemBuilder: (_, int index) {
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

                        if (item.type == 'program_live' || item.type == 'live') {
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
                                hostImg: getHostList()[6].obj.profilePicture ?? '',
                                progName: 'Sports Weekly',
                                hostUsername: getHostList()[6].obj.username ?? '',
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

                       if (item.type == 'info') { return AppNotificationTile(
                          title: item.title ?? 'Postman Test Success',
                          subtitle: item.message ?? 'FCM is working correctly!',
                          isRead: item.isRead ?? false,
                          time: item.createdAt?.toTimeAgo,
                        );
                       }
                      },
                    )
                  );
                  },
                ),
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
      itemBuilder: (_, __) => Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
