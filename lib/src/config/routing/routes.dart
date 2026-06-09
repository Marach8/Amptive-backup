import 'dart:io';
import 'package:amptive/src/config/routing/routing_export.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_email_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_phone_no_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_name_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_username_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_dob_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/create_new_password_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/forgot_password_email_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/reset_password_otp_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/phone_auth_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/login_screen.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/features/auth/presentation/screens/dob_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/email_auth_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/name_auth_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/otp_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/password_auth_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/add_profile_pic_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/auth_options_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/username_auth_screen.dart';
import 'package:amptive/src/features/calender/presentation/screens/calender_landing_screen.dart';
import 'package:amptive/src/features/discover/presentation/views/society_screen.dart';
import 'package:amptive/src/features/discover/presentation/views/trending_hashtags_screen.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/presentation/screens/edit_episode_form_screen.dart';
import 'package:amptive/src/features/events/presentation/screens/edit_event_form_screen.dart';
import 'package:amptive/src/features/events/presentation/screens/select_schedule_date_screen.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/home/presentation/screens/following_screen.dart';
import 'package:amptive/src/features/home/presentation/screens/live_show_detailed_screen.dart';
import 'package:amptive/src/features/home/presentation/screens/schedule_detailed_screen.dart';
import 'package:amptive/src/features/home/presentation/screens/subscribed_screen.dart';
import 'package:amptive/src/features/main_app_shell.dart';
import 'package:amptive/src/features/post_auth/presentation/views/post_auth_prez_export.dart';
import 'package:amptive/src/features/profile/presentation/screens/edit_bio_screen.dart';
import 'package:amptive/src/features/profile/presentation/screens/edit_name_screen.dart';
import 'package:amptive/src/features/profile/presentation/screens/edit_username_screen.dart';
import 'package:amptive/src/features/profile/presentation/screens/profile_views_export.dart';
import 'package:amptive/src/features/home/presentation/screens/scheduled_screen.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/accounts/presentation/screens/account_info_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/acounts_landing_screen.dart';
import 'package:amptive/src/features/profile/presentation/screens/update_email_and_phone_no_otp_screen.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/events/presentation/screens/list_hosted_events_screen.dart';
import 'package:amptive/src/features/events/cubits/hosted_events_cubit.dart';
import 'package:amptive/src/features/events/presentation/screens/preview_event_screen.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/switch_account/presentation/switch_acct/switch_acct_export.dart';
import 'package:amptive/src/features/wallet/presentation/screens/wallet_transactions_history_screen.dart';
import 'package:amptive/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:amptive/src/features/onboarding/presentation/screens/post_onboarding_screen.dart';
import 'package:custom_image_crop/custom_image_crop.dart'
    show Ratio, CustomCropShape;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/discover/presentation/views/community_home_screen.dart';
import '../../features/discover/presentation/views/society_hashtag_screen.dart';
import '../../features/discover/presentation/views/trending_society_screen.dart';
import '../../features/go_live/go_live_export.dart';
import '../../features/home/presentation/screens/live_event_detailed_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_landing_screen.dart';
import '../../features/profile/presentation/screens/edit_socials_screen.dart';
import '../../features/accounts/presentation/screens/select_country_screen.dart';
import '../../features/shows/cubits/hosted_shows_cubit.dart' show HostedShowsCubit;
import '../../features/wallet/wallet_export.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter amptiveAppRouter = GoRouter(
  navigatorKey: navigatorKey,
   initialLocation: ATRoutes.dashboard.addSlash,
  //redirect: tempRedirect,
  //initialLocation: ATRoutes.temporaryLoginScreen.addSlash,
  //initialLocation: ATRoutes.onboardingScreen.addSlash,

  routes: <RouteBase>[

    GoRoute(
      name: ATRoutes.postOnboardingScreen,
      path: ATRoutes.postOnboardingScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const ATPostOnboardingScreen(),
      ),
    ),

    GoRoute(
      name: ATRoutes.onboardingScreen,
      path: ATRoutes.onboardingScreen.addSlash,
      builder: (_, __) => const ATOnboardingScreen(),
    ),

    // ─── Authentication screens ───────────────────────────────────────────────

    GoRoute(
      name: ATRoutes.authOptionsScreen,
      path: ATRoutes.authOptionsScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: ATAuthOptionsScreen(authType: st.extra as AuthType),
      ),
    ),

    GoRoute(
      name: ATRoutes.FORGOT_PASSWORD_SCREEN,
      path: ATRoutes.FORGOT_PASSWORD_SCREEN.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const ATForgotPasswordEmailScreen(),
      ),
    ),

    GoRoute(
      name: ATRoutes.temporaryLoginScreen,
      path: ATRoutes.temporaryLoginScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: LoginScreen(params: st.extra as LoginScreenEntryParams?),
      ),
    ),

    GoRoute(
      name: ATRoutes.emailScreen,
      path: ATRoutes.emailScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: ATEmailAuthScreen(title: st.extra as String?),
      ),
    ),

    GoRoute(
      name: ATRoutes.ENTER_OTP_SCREEN,
      path: ATRoutes.ENTER_OTP_SCREEN.addSlash,
      pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<bool?>(
        child: ATOTPScreen(params: state.extra as VerifyOTPScreenParams),
      ),
    ),

    GoRoute(
      name: ATRoutes.PASSWORD_RESET_OTP_SCREEN,
      path: ATRoutes.PASSWORD_RESET_OTP_SCREEN.addSlash,
      pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<bool?>(
        child: ResetPasswordOtpScreen(
          params: state.extra as VerifyPasswordResetOTPScreenParams,
        ),
      ),
    ),

    GoRoute(
      name: ATRoutes.phoneAuthScreen,
      path: ATRoutes.phoneAuthScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: PhoneAuthScreen(title: st.extra as String?),
      ),
    ),

    GoRoute(
      name: ATRoutes.phoneLoginScreen,
      path: ATRoutes.phoneLoginScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: PhoneLoginScreen(title: st.extra as String?),
      ),
    ),

    GoRoute(
      name: ATRoutes.createNewPAsswordScreen,
      path: ATRoutes.createNewPAsswordScreen.addSlash,
      pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
        child: CreateNewPasswordScreen(
          params: state.extra as CreateNewPasswordScreenParams,
        ),
      ),
    ),

    GoRoute(
      name: ATRoutes.addProfilePicScreen,
      path: ATRoutes.addProfilePicScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const AddProfilePictureScreen(),
      ),
    ),

    GoRoute(
      name: ATRoutes.createPasswordScreen,
      path: ATRoutes.createPasswordScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const PasswordAuthScreen(),
      ),
    ),

    GoRoute(
      name: ATRoutes.dobAuthScreen,
      path: ATRoutes.dobAuthScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const AddDOBScreen(),
      ),
    ),

    GoRoute(
      name: ATRoutes.addUserNameScreen,
      path: ATRoutes.addUserNameScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const AddUsernameScreen(),
      ),
    ),

    GoRoute(
      name: ATRoutes.addNameAuthScreen,
      path: ATRoutes.addNameAuthScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const AddNameScreen(),
      ),
    ),

    GoRoute(
      name: ATRoutes.select5CommunitiesScreen,
      path: ATRoutes.select5CommunitiesScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const Select5CommunitiesScreen(),
      ),
    ),

    GoRoute(
      name: ATRoutes.allowNotificationsScreen,
      path: ATRoutes.allowNotificationsScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const NotificationsPromptScreen(),
      ),
    ),

    // ─── Main application screens ─────────────────────────────────────────────

    GoRoute(
      name: ATRoutes.dashboard,
      path: ATRoutes.dashboard.addSlash,
      builder: (_, __) => const ATMainAppShell(),
      routes: <RouteBase>[

        GoRoute(
          name: ATRoutes.scheduleDetailed,
          path: ATRoutes.scheduleDetailed.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: ATScheduleDetailedScreen(
              homeFeedItem: state.extra as HomeFeedItem?,
            ),
          ),
        ),

        // ─── Wallet onboarding flow ─────────────────────────────────────────
        // Navigated to when user has NOT yet set up a wallet PIN.
        GoRoute(
          name: ATRoutes.WALLET_ONBOARDING,
          path: ATRoutes.WALLET_ONBOARDING.addSlash,
          pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
            child: const ATWalletOnboardScreen(),
          ),
          routes: <RouteBase>[
            GoRoute(
              name: ATRoutes.WALLET_PIN_SETUP,
              path: ATRoutes.WALLET_PIN_SETUP.addSlash,
              pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                child: const ATWalletPinSetupScreen(),
              ),
            ),
            GoRoute(
              name: ATRoutes.securityQuestionScreen,
              path: ATRoutes.securityQuestionScreen.addSlash,
              pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                child: const ATSecurityQuestionScreen(),
              ),
            ),
            GoRoute(
              name: ATRoutes.walletCreationAnimationScreen,
              path: ATRoutes.walletCreationAnimationScreen.addSlash,
              pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                child: const ATWalletCreationAnimScreen(),
              ),
            ),
          ],
        ),

        // ─── Wallet landing ─────────────────────────────────────────────────
        // Navigated to when user HAS already set up a wallet PIN.
        GoRoute(
          name: ATRoutes.walletScreen,
          path: ATRoutes.walletScreen.addSlash,
          pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
            child: const ATWalletLandingScreenWrapper(),
          ),
          routes: <RouteBase>[
            GoRoute(
              name: ATRoutes.walletTransactionsHistoryScreen,
              path: ATRoutes.walletTransactionsHistoryScreen.addSlash,
              pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                child: const ATWalletTxnsHistoryScreen(),
              ),
            ),
          ],
        ),

        // ─── Wallet sub-screens (siblings under dashboard) ──────────────────
        GoRoute(
          name: ATRoutes.SELECT_RECIPIENT,
          path: ATRoutes.SELECT_RECIPIENT.addSlash,
          pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
            child: const ATSelectRecipientScreen(),
          ),
        ),

        GoRoute(
          name: ATRoutes.transactionAmountScreen,
          path: ATRoutes.transactionAmountScreen.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: TransactionAmountScreen(
              params: state.extra as TransactionAmountScreenParams,
            ),
          ),
        ),

        GoRoute(
          name: ATRoutes.WITHDRAWAL_LANDING,
          path: ATRoutes.WITHDRAWAL_LANDING.addSlash,
          pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
            child: const ATWithdrwalLandingScreen(),
          ),
        ),

        GoRoute(
          name: ATRoutes.SELECT_BANK_COUNTRY,
          path: ATRoutes.SELECT_BANK_COUNTRY.addSlash,
          pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
            child: const ATSelectBanksCountryScreen(),
          ),
        ),

        GoRoute(
          name: ATRoutes.ENTER_ACCT_NO,
          path: ATRoutes.ENTER_ACCT_NO.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: ATEnterAccountNoScreen(bankName: state.extra as String),
          ),
        ),

        GoRoute(
          name: ATRoutes.answerSecurityQuestionScreen,
          path: ATRoutes.answerSecurityQuestionScreen.addSlash,
          pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
            child: const ATAnswerSecurityQuestionScreen(),
          ),
        ),

        GoRoute(
          name: ATRoutes.paperPlaneSuccessScreen,
          path: ATRoutes.paperPlaneSuccessScreen.addSlash,
          pageBuilder: (_, GoRouterState state) {
            final List<dynamic> params = state.extra as List<dynamic>;
            return ATSlidingRouteTransition<void>(
              child: ATPaperPlaneSuccessScreen(
                title: params.first as String,
                transactionType: params[1] as TransactionType,
                subtitle: params.last as String,
              ),
            );
          },
        ),

        // ─── Live / Go-live screens ─────────────────────────────────────────
        GoRoute(
          name: ATRoutes.liveShowDetailed,
          path: ATRoutes.liveShowDetailed.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            beginOffset: const Offset(0.0, 1.0),
            child: ATLiveShowDetailedScreen(
              homeFeedItem: state.extra as HomeFeedItem?,
            ),
          ),
        ),

        GoRoute(
          name: ATRoutes.liveEventDetailed,
          path: ATRoutes.liveEventDetailed.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            beginOffset: const Offset(0.0, 1.0),
            child: ATLiveEventDetailedScreen(
              homeFeedItem: state.extra as HomeFeedItem?,
            ),
          ),
        ),

        GoRoute(
          name: ATRoutes.goLiveOnboarding,
          path: ATRoutes.goLiveOnboarding.addSlash,
          pageBuilder: (_, GoRouterState state) {
            final LiveProgramData? liveProgramEntryParams =
                state.extra as LiveProgramData?;
            return ATSlidingRouteTransition<void>(
              child: GoLiveOnboardingScreen(
                liveProgramEntryParams: liveProgramEntryParams,
              ),
            );
          },
        ),

        GoRoute(
          name: ATRoutes.liveProgramScreen,
          path: ATRoutes.liveProgramScreen.addSlash,
          pageBuilder: (_, GoRouterState st) => ATFadingRouteTransition<void>(
            child: LiveProgramScreen(
              liveScreenEntryParams: st.extra as LiveProgramData?,
            ),
          ),
        ),

        GoRoute(
          name: ATRoutes.chooseEventOrShowScreen,
          path: ATRoutes.chooseEventOrShowScreen,
          builder: (_, __) => const GoLiveTypeSelectionScreen(),
        ),

        // ─── Shows & episodes ───────────────────────────────────────────────
        GoRoute(
          name: ATRoutes.listHostedShowsScreen,
          path: ATRoutes.listHostedShowsScreen.addSlash,
          pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
            child: const ListHostedShowsScreen(),
          ),
        ),

        GoRoute(
          name: ATRoutes.listHostedEventsScreen,
          path: ATRoutes.listHostedEventsScreen.addSlash,
          pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
            child: const ListHostedEventsScreen(),
          ),
        ),

        GoRoute(
          name: ATRoutes.createShowFormScreen,
          path: ATRoutes.createShowFormScreen.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: CreateShowFormScreen(
              hostedShowsCubit: state.extra as HostedShowsCubit,
            ),
          ),
        ),

        GoRoute(
          name: ATRoutes.createEventFormScreen,
          path: ATRoutes.createEventFormScreen.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: CreateEventFormScreen(
              hostedEventsCubit: state.extra as HostedEventsCubit,
            ),
          ),
        ),

        GoRoute(
          name: ATRoutes.createEpisodeForm,
          path: ATRoutes.createEpisodeForm.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: CreateEpisodeFormScreen(showId: state.extra as String),
          ),
        ),

        GoRoute(
          name: ATRoutes.programCreationSuccessScreen,
          path: ATRoutes.programCreationSuccessScreen,
          pageBuilder: (_, GoRouterState state) {
            final ProgramCreationSuccessScreenParams params =
                state.extra as ProgramCreationSuccessScreenParams;
            return ATSlidingRouteTransition<void>(
              child: ProgramCreationSuccessScreen(params: params),
            );
          },
        ),

        GoRoute(
          name: ATRoutes.showPreviewScreen,
          path: ATRoutes.showPreviewScreen,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: PreviewShowScreen(hostedShow: state.extra as HostedShow),
          ),
        ),

        GoRoute(
          name: ATRoutes.eventPreviewScreen,
          path: ATRoutes.eventPreviewScreen.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: PreviewEventScreen(hostedEvent: state.extra as HostedEvent),
          ),
        ),

        GoRoute(
          name: ATRoutes.editEventScreen,
          path: ATRoutes.editEventScreen.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: EditEventFormScreen(editableEvent: state.extra as HostedEvent),
          ),
        ),

        GoRoute(
          name: ATRoutes.editEpisodeScreen,
          path: ATRoutes.editEpisodeScreen.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: EditEpisodeFormScreen(
              editableEpisode: state.extra as Episode,
            ),
          ),
        ),

        GoRoute(
          name: ATRoutes.selectScheduleDateScreen,
          path: ATRoutes.selectScheduleDateScreen.addSlash,
          pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
            child: SelectScheduleDateScreen(
              params: state.extra as SelectScheduleDataScreenEntryParams,
            ),
          ),
        ),

        GoRoute(
          name: ATRoutes.previewEpisodeScreen,
          path: ATRoutes.previewEpisodeScreen.addSlash,
          pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
            child: PreviewEpisodeScreen(episode: st.extra as Episode),
          ),
        ),

        // ─── Profile ────────────────────────────────────────────────────────
        GoRoute(
          name: ATRoutes.creatorProfileScreen,
          path: ATRoutes.creatorProfileScreen,
          builder: (_, __) => const CreatorProfileScreen(),
        ),

        GoRoute(
          name: ATRoutes.EDIT_PROFILE,
          path: ATRoutes.EDIT_PROFILE.addSlash,
          builder: (_, __) => const EditProfileScreen(),
          routes: <RouteBase>[
            GoRoute(
              name: ATRoutes.rectImageCropperScreen,
              path: ATRoutes.rectImageCropperScreen.addSlash,
              pageBuilder: (_, GoRouterState state) {
                final (File, Ratio?, CustomCropShape?) params =
                    state.extra as (File, Ratio?, CustomCropShape?);
                return ATSlidingRouteTransition<MemoryImage>(
                  child: RectImageCropperScreen(
                    imageFile: params.$1,
                    ratio: params.$2,
                    shape: params.$3 ?? CustomCropShape.Ratio,
                  ),
                );
              },
            ),
            GoRoute(
              name: ATRoutes.EDIT_NAME,
              path: ATRoutes.EDIT_NAME,
              builder: (_, GoRouterState state) =>
                  EditNameScreen(initialName: state.extra as String),
            ),
            GoRoute(
              name: ATRoutes.EDIT_USERNAME,
              path: ATRoutes.EDIT_USERNAME,
              builder: (_, GoRouterState state) =>
                  EditUsernameScreen(initialUsername: state.extra as String),
            ),
            GoRoute(
              name: ATRoutes.EDIT_BIO,
              path: ATRoutes.EDIT_BIO,
              builder: (_, GoRouterState state) =>
                  EditBioScreen(initialBio: state.extra as String),
            ),
            GoRoute(
              name: ATRoutes.EDIT_SOCIALS,
              path: ATRoutes.EDIT_SOCIALS,
              builder: (_, GoRouterState state) {
                final List<String?> params = state.extra as List<String?>;
                return EditSocialsScreen(
                  initialLink: params.first,
                  socialName: params.last as String,
                );
              },
            ),
            GoRoute(
              name: ATRoutes.enterEmailAndPhoneNoOtpScreen,
              path: ATRoutes.enterEmailAndPhoneNoOtpScreen.addSlash,
              pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<bool?>(
                child: UpdateEmailAndPhoneNoOtpScreen(
                  params: state.extra as EmailAndPhoneNoOTPScreenParams,
                ),
              ),
            ),
            GoRoute(
              name: ATRoutes.SELECT_ACCT_TYPE,
              path: ATRoutes.SELECT_ACCT_TYPE,
              builder: (_, __) => const SelectAcctTypeScreen(),
              routes: <RouteBase>[
                GoRoute(
                  name: ATRoutes.SELECTED_ACCT,
                  path: ATRoutes.SELECTED_ACCT,
                  builder: (_, __) => const SelectedAcctLandingScreen(),
                ),
              ],
            ),
            GoRoute(
              name: ATRoutes.SELECT_CAT,
              path: ATRoutes.SELECT_CAT,
              builder: (_, __) => const SelectCategoryScreen(),
            ),
            GoRoute(
              name: ATRoutes.creatorSubPlanSetup,
              path: ATRoutes.creatorSubPlanSetup,
              pageBuilder: (_, GoRouterState st) {
                final SubscriptionPlanData subPlanData =
                    st.extra as SubscriptionPlanData;
                return ATSlidingRouteTransition<SubscriptionPlanData?>(
                  child: CreatorSubPlanScreen(incomingSubPlan: subPlanData),
                );
              },
            ),
            GoRoute(
              name: ATRoutes.cohostFeeSetup,
              path: ATRoutes.cohostFeeSetup,
              builder: (_, __) => const CoHostFeeSetupScreen(),
            ),
            GoRoute(
              name: ATRoutes.CREATOR_SUCCESS,
              path: ATRoutes.CREATOR_SUCCESS,
              builder: (_, __) => const CreatorOrBusinessSetupSuccessScreen(),
            ),
          ],
        ),

        GoRoute(
          name: ATRoutes.PROFILE_MENU_SCREEN,
          path: ATRoutes.PROFILE_MENU_SCREEN,
          builder: (_, __) => const AmptiveProfileMenuScreen(),
          routes: <RouteBase>[
            GoRoute(
              name: ATRoutes.CALENDER_SCREEN,
              path: ATRoutes.CALENDER_SCREEN,
              builder: (_, __) => const ATCalenderLandingScreen(),
            ),
            GoRoute(
              name: ATRoutes.LANGUAGE_SCREEN,
              path: ATRoutes.LANGUAGE_SCREEN,
              builder: (_, __) => const ATSelectLanguageScreen(),
            ),
            GoRoute(
              name: ATRoutes.PRIVACY_SCREEN,
              path: ATRoutes.PRIVACY_SCREEN,
              builder: (_, __) => const ATPrivacyScreen(),
              routes: <RouteBase>[
                GoRoute(
                  name: ATRoutes.BLOCKED_ACCTS_SCREEN,
                  path: ATRoutes.BLOCKED_ACCTS_SCREEN,
                  builder: (_, __) => const ATBlockedAcctsScreen(),
                ),
                GoRoute(
                  name: ATRoutes.MUTED_ACCTS_SCREEN,
                  path: ATRoutes.MUTED_ACCTS_SCREEN,
                  builder: (_, __) => const AmptiveMutedAcctsScreen(),
                ),
              ],
            ),
          ],
        ),

        // ─── Account screens ────────────────────────────────────────────────
        GoRoute(
          name: ATRoutes.accountLandingScreen,
          path: ATRoutes.accountLandingScreen.addSlash,
          builder: (_, __) => const ATAccountLandingScreen(),
          routes: <RouteBase>[
            GoRoute(
              name: ATRoutes.ACCT_INFO_SCREEN,
              path: ATRoutes.ACCT_INFO_SCREEN.addSlash,
              builder: (_, GoRouterState state) {
                final List<String?>? params = state.extra as List<String?>?;
                return ATAccountInfoScreen(
                  email: params?.first,
                  phone: params?.elementAtOrNull(1),
                  country: params?.last,
                );
              },
            ),
            GoRoute(
              name: ATRoutes.SELECT_COUNTRY_SCREEN,
              path: ATRoutes.SELECT_COUNTRY_SCREEN,
              builder: (_, GoRouterState state) {
                final List params = state.extra as List;
                return ATSelectCountryScreen(
                  selectedCountry: params.first as String,
                  countries: params.last as List<String>,
                );
              },
            ),
            GoRoute(
              name: ATRoutes.updateEmailScreen,
              path: ATRoutes.updateEmailScreen.addSlash,
              pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                child: UpdateEmailScreen(title: state.extra as String),
              ),
            ),
            GoRoute(
              name: ATRoutes.updatePhoneNoScreen,
              path: ATRoutes.updatePhoneNoScreen.addSlash,
              pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                child: UpdatePhoneNoScreen(title: state.extra as String),
              ),
            ),
            GoRoute(
              name: ATRoutes.updateNameScreen,
              path: ATRoutes.updateNameScreen.addSlash,
              pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                child: UpdateNameScreen(title: state.extra as String),
              ),
            ),
            GoRoute(
              name: ATRoutes.updateUsernameScreen,
              path: ATRoutes.updateUsernameScreen.addSlash,
              pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                child: UpdateUsernameScreen(title: state.extra as String),
              ),
            ),
            GoRoute(
              name: ATRoutes.updateDOBScreen,
              path: ATRoutes.updateDOBScreen.addSlash,
              pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                child: UpdateDOBScreen(title: state.extra as String),
              ),
            ),
          ],
        ),

        // ─── Other profile / community screens ──────────────────────────────
        GoRoute(
          name: ATRoutes.PROFILE_FOLLOWING_SCREEN,
          path: ATRoutes.PROFILE_FOLLOWING_SCREEN,
          builder: (_, __) => const ATProfileFollowersScreen(),
        ),

        GoRoute(
          name: ATRoutes.COMMUNITY_TASK_SCREEN,
          path: ATRoutes.COMMUNITY_TASK_SCREEN,
          builder: (_, __) => const AmptiveCommunityTaskScreen(),
        ),

        GoRoute(
          name: ATRoutes.PROFILE_PIC_SCREEN,
          path: ATRoutes.PROFILE_PIC_SCREEN,
          builder: (_, GoRouterState state) =>
              AmptiveViewProfilePicScreen(imgPath: state.extra as String),
        ),

        GoRoute(
          name: ATRoutes.PROFILE_SUBSCRIBERS_SCREEN,
          path: ATRoutes.PROFILE_SUBSCRIBERS_SCREEN,
          builder: (_, __) => const ProfileSubscribersScreen(),
        ),

        GoRoute(
          name: ATRoutes.USER_PROFILE_SCREEN,
          path: ATRoutes.USER_PROFILE_SCREEN,
          builder: (_, __) => const ATUserProfileScreen(),
        ),

        GoRoute(
          name: ATRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN,
          path: ATRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN,
          builder: (_, __) => const ATScheduledPrograms(),
        ),

        GoRoute(
          name: ATRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN,
          path: ATRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN,
          builder: (_, __) => const ATSubscribedPrograms(),
        ),

        GoRoute(
          name: ATRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN,
          path: ATRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN,
          builder: (_, __) => const ATFollowedPrograms(),
        ),

        GoRoute(
          name: ATRoutes.COMMUNITY_SCREEN,
          path: ATRoutes.COMMUNITY_SCREEN,
          builder: (_, __) => const ATCommunityScreen(),
        ),

        GoRoute(
          name: ATRoutes.SOCIETY_SCREEN,
          path: ATRoutes.SOCIETY_SCREEN,
          builder: (_, __) => const DiscoverSocietyScreen(),
          routes: <RouteBase>[
            GoRoute(
              name: ATRoutes.TRENDING_SOCIETY_SCREEN,
              path: ATRoutes.TRENDING_SOCIETY_SCREEN,
              builder: (_, __) => const TrendingSocietyScreen(),
            ),
            GoRoute(
              name: ATRoutes.TRENDING_HASHTAGS_SCREEN,
              path: ATRoutes.TRENDING_HASHTAGS_SCREEN,
              builder: (_, __) => const TrendingHashTagsScreen(),
            ),
            GoRoute(
              name: ATRoutes.SOCIETY_HASHTAG_SCREEN,
              path: ATRoutes.SOCIETY_HASHTAG_SCREEN,
              builder: (_, __) => const SocietyHastagScreen(),
            ),
          ],
        ),

      ], 
    ),

  ],
);
