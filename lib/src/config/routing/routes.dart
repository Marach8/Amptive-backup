import 'dart:io';
import 'package:amptive/src/config/routing/redirect.dart';
import 'package:amptive/src/config/routing/routing_export.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_email_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_phone_no_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_name_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_username_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_dob_screen.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/auth/presentation/screens/create_new_password_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/forgot_password_email_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/reset_password_otp_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/phone_sign_up_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/login_screen.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/features/auth/presentation/screens/dob_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/email_sign_up_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/add_name_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/otp_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/create_password_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/add_profile_pic_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/auth_options_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/add_username_screen.dart';
import 'package:amptive/src/features/calender/presentation/screens/calender_landing_screen.dart';
import 'package:amptive/src/features/discover/presentation/views/society_screen.dart';
import 'package:amptive/src/features/discover/presentation/views/trending_hashtags_screen.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/presentation/screens/edit_episode_form_screen.dart';
import 'package:amptive/src/features/events/cubits/event_detail_cubit.dart';
import 'package:amptive/src/features/events/presentation/screens/edit_event_form_screen.dart';
import 'package:amptive/src/features/events/presentation/screens/select_schedule_date_screen.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/home/cubits/live_listeners_cubit.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/cubits/validate_ticket_cubit.dart';
import 'package:amptive/src/features/home/cubits/whispers_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/presentation/screens/following_screen.dart';
import 'package:amptive/src/features/home/presentation/screens/live_show_detailed_screen.dart';
import 'package:amptive/src/features/home/presentation/screens/schedule_detailed_screen.dart';
import 'package:amptive/src/features/home/presentation/screens/subscribed_screen.dart';
import 'package:amptive/src/features/dashboard.dart';
import 'package:amptive/src/features/post_auth/presentation/views/post_auth_prez_export.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
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
import 'package:amptive/src/features/upgrade_account/cubits/select_category_cubit.dart';
import 'package:amptive/src/features/upgrade_account/cubits/upgrade_account_cubit.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/account_upgrade_success_screen.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/co_host_fee_setup_screen.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/select_acct_type_screen.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/select_category_screen.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/selected_acct_onboard_screen.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/subscription_plan_screen.dart';
import 'package:amptive/src/features/wallet/presentation/screens/wallet_transactions_history_screen.dart';
import 'package:amptive/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:amptive/src/features/onboarding/presentation/screens/post_onboarding_screen.dart';
import 'package:amptive/src/shared/blurred_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../features/discover/presentation/views/community_home_screen.dart';
import '../../features/discover/presentation/views/society_hashtag_screen.dart';
import '../../features/discover/presentation/views/trending_society_screen.dart';
import '../../features/go_live/go_live_export.dart';
import '../../features/home/presentation/screens/live_event_detailed_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_landing_screen.dart';
import '../../features/profile/presentation/screens/edit_socials_screen.dart';
import '../../features/accounts/presentation/screens/select_country_screen.dart';
import '../../features/shows/cubits/hosted_shows_cubit.dart'
    show HostedShowsCubit;
import '../../features/wallet/wallet_export.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter amptiveAppRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: ATRoutes.onboardingScreen.addSlash,
  redirect: tgRedirect,

  routes: <RouteBase>[
    GoRoute(
        name: ATRoutes.postOnboardingScreen,
        path: ATRoutes.postOnboardingScreen.addSlash,
        pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const ATPostOnboardingScreen(),
            )),
    GoRoute(
      name: ATRoutes.onboardingScreen,
      path: ATRoutes.onboardingScreen.addSlash,
      builder: (_, __) => const ATOnboardingScreen(),
    ),

    //AUTHENTICATION SCREENS
    GoRoute(
      name: ATRoutes.authOptionsScreen,
      path: ATRoutes.authOptionsScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
          child: ATAuthOptionsScreen(
        authType: st.extra as AuthType,
      )),
    ),
    GoRoute(
      name: ATRoutes.FORGOT_PASSWORD_SCREEN,
      path: ATRoutes.FORGOT_PASSWORD_SCREEN.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
          child: const ATForgotPasswordEmailScreen()),
    ),

    GoRoute(
        name: ATRoutes.temporaryLoginScreen,
        path: ATRoutes.temporaryLoginScreen.addSlash,
        pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
              child: LoginScreen(
                params: st.extra as LoginScreenEntryParams?,
              ),
            )),
    GoRoute(
        name: ATRoutes.emailScreen,
        path: ATRoutes.emailScreen.addSlash,
        pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
            child: ATEmailSignUpScreen(title: st.extra as String?))),

    GoRoute(
        name: ATRoutes.ENTER_OTP_SCREEN,
        path: ATRoutes.ENTER_OTP_SCREEN.addSlash,
        pageBuilder: (_, GoRouterState state) {
          return ATSlidingRouteTransition<bool?>(
            child: ATOTPScreen(
              params: state.extra as VerifyOTPScreenParams,
            ),
          );
        }),
    GoRoute(
        name: ATRoutes.PASSWORD_RESET_OTP_SCREEN,
        path: ATRoutes.PASSWORD_RESET_OTP_SCREEN.addSlash,
        pageBuilder: (_, GoRouterState state) {
          return ATSlidingRouteTransition<bool?>(
            child: ResetPasswordOtpScreen(
              params: state.extra as VerifyPasswordResetOTPScreenParams,
            ),
          );
        }),

    GoRoute(
        name: ATRoutes.phoneAuthScreen,
        path: ATRoutes.phoneAuthScreen.addSlash,
        pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
              child: PhoneAuthScreen(appBarTitle: st.extra as String?),
            )),
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
            )),

    GoRoute(
        name: ATRoutes.addProfilePicScreen,
        path: ATRoutes.addProfilePicScreen.addSlash,
        pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
              child: const AddProfilePictureScreen(),
            )),

    GoRoute(
        name: ATRoutes.createPasswordScreen,
        path: ATRoutes.createPasswordScreen.addSlash,
        pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const PasswordAuthScreen(),
            )),

    GoRoute(
        name: ATRoutes.dobAuthScreen,
        path: ATRoutes.dobAuthScreen.addSlash,
        pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const AddDOBScreen(),
            )),
    GoRoute(
        name: ATRoutes.addUserNameScreen,
        path: ATRoutes.addUserNameScreen.addSlash,
        pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const AddUsernameScreen(),
            )),
    GoRoute(
        name: ATRoutes.addNameAuthScreen,
        path: ATRoutes.addNameAuthScreen.addSlash,
        pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const AddNameScreen(),
            )),
    GoRoute(
        name: ATRoutes.select5CommunitiesScreen,
        path: ATRoutes.select5CommunitiesScreen.addSlash,
        pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const Select5CommunitiesScreen(),
            )),

    GoRoute(
        name: ATRoutes.allowNotificationsScreen,
        path: ATRoutes.allowNotificationsScreen.addSlash,
        pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const NotificationsPromptScreen(),
            )),

    //MAIN APPLICATION SCREENS
    GoRoute(
        name: ATRoutes.dashboard,
        path: ATRoutes.dashboard.addSlash,
        builder: (_, __) => const ATDashboard(),
        routes: <RouteBase>[
          GoRoute(
            name: ATRoutes.scheduleDetailed,
            path: ATRoutes.scheduleDetailed.addSlash,
            pageBuilder: (_, GoRouterState state) =>
                ATSlidingRouteTransition<void>(
              child: ATScheduleDetailedScreen(
                homeFeedItem: state.extra as HomeFeedItem?,
              ),
            ),
          ),
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
            pageBuilder: (_, GoRouterState state) =>
                ATSlidingRouteTransition<void>(
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
            pageBuilder: (_, GoRouterState state) =>
                ATSlidingRouteTransition<void>(
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
          GoRoute(
            name: ATRoutes.liveShowDetailedScreen,
            path: ATRoutes.liveShowDetailedScreen.addSlash,
            pageBuilder: (_, GoRouterState state) =>
              ATSlidingRouteTransition<void>(
                beginOffset: const Offset(0.0, 1.0),
                child: MultiBlocProvider(
                  providers: <SingleChildWidget>[
                    BlocProvider<BlurredHeaderCubit>(
                      create: (_) => BlurredHeaderCubit()),
                    BlocProvider<GetLiveProgramEntryTokenCubit>(
                      create: (_) => GetLiveProgramEntryTokenCubit()),
                    BlocProvider<LiveWhispersCubit>(
                      create: (_) => LiveWhispersCubit()),
                    BlocProvider<LiveListenersCubit>(
                      create: (_) => LiveListenersCubit())
                  ],
                  child: LiveShowDetailedScreen(
                    homeFeedItem: state.extra as HomeFeedItem?,
                  ),
                )
              )
            ),
          GoRoute(
            name: ATRoutes.liveEventDetailedScreen,
            path: ATRoutes.liveEventDetailedScreen.addSlash,
            pageBuilder: (_, GoRouterState state) =>
              ATSlidingRouteTransition<void>(
                beginOffset: const Offset(0.0, 1.0),
                child: MultiBlocProvider(
                  providers: <SingleChildWidget>[
                    BlocProvider<GetLiveProgramEntryTokenCubit>(
                      create: (_) => GetLiveProgramEntryTokenCubit()),
                    BlocProvider<BlurredHeaderCubit>(
                      create: (_) => BlurredHeaderCubit()),
                    BlocProvider<ValidateTicketCubit>(
                      create: (_) => ValidateTicketCubit()),
                    BlocProvider<LiveWhispersCubit>(
                      create: (_) => LiveWhispersCubit()),
                    BlocProvider<LiveListenersCubit>(
                      create: (_) => LiveListenersCubit())
                  ],
                  child: LiveEventDetailedScreen(
                    homeFeedItem: state.extra as HomeFeedItem?,
                  ),
                ),
              )),
          GoRoute(
              name: ATRoutes.goLiveOnboarding,
              path: ATRoutes.goLiveOnboarding.addSlash,
              pageBuilder: (_, GoRouterState state) {
                final LiveProgramData? liveProgramEntryParams =
                    state.extra as LiveProgramData?;
                return ATSlidingRouteTransition<void>(
                    child: GoLiveOnboardingScreen(
                        liveProgramEntryParams: liveProgramEntryParams));
              }),
          GoRoute(
            name: ATRoutes.chooseEventOrShowScreen,
            path: ATRoutes.chooseEventOrShowScreen,
            builder: (_, __) => const GoLiveTypeSelectionScreen(),
          ),
          GoRoute(
              name: ATRoutes.listHostedShowsScreen,
              path: ATRoutes.listHostedShowsScreen.addSlash,
              pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                    child: const ListHostedShowsScreen(),
                  )),
          GoRoute(
              name: ATRoutes.listHostedEventsScreen,
              path: ATRoutes.listHostedEventsScreen.addSlash,
              pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                    child: MultiBlocProvider(
                      providers: <SingleChildWidget>[
                        BlocProvider<BlurredHeaderCubit>(
                          create: (_) => BlurredHeaderCubit(),
                        ),
                        BlocProvider<HostedEventSelectionCubit>(
                            create: (_) => HostedEventSelectionCubit()),
                        BlocProvider<HostedEventsCubit>(create: (_) => HostedEventsCubit())
                      ],
                      child: const ListHostedEventsScreen(),
                    ),
                  )),
          GoRoute(
              name: ATRoutes.createShowFormScreen,
              path: ATRoutes.createShowFormScreen.addSlash,
              pageBuilder: (_, GoRouterState state) =>
                  ATSlidingRouteTransition<void>(
                      child: CreateShowFormScreen(
                    hostedShowsCubit: state.extra as HostedShowsCubit,
                  ))),
          GoRoute(
              name: ATRoutes.createEventFormScreen,
              path: ATRoutes.createEventFormScreen.addSlash,
              pageBuilder: (_, GoRouterState state) =>
                  ATSlidingRouteTransition<void>(
                    child: CreateEventFormScreen(
                      hostedEventsCubit: state.extra as HostedEventsCubit,
                    ),
                  )),
          GoRoute(
              name: ATRoutes.createEpisodeForm,
              path: ATRoutes.createEpisodeForm.addSlash,
              pageBuilder: (_, GoRouterState state) =>
                  ATSlidingRouteTransition<void>(
                      child: CreateEpisodeFormScreen(
                    showId: state.extra as String,
                  ))),
          GoRoute(
            name: ATRoutes.programCreationSuccessScreen,
            path: ATRoutes.programCreationSuccessScreen,
            pageBuilder: (_, GoRouterState state) {
              final ProgramCreationSuccessScreenParams params =
                  state.extra as ProgramCreationSuccessScreenParams;
              return ATSlidingRouteTransition<void>(
                child: ProgramCreationSuccessScreen(
                  params: params,
                ),
              );
            },
          ),
          GoRoute(
            name: ATRoutes.mainProfileScreen,
            path: ATRoutes.mainProfileScreen.addSlash,
            pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
              name: st.name,
              child: const MainProfileScreen(),
            ),
          ),
          GoRoute(
              name: ATRoutes.editProfile,
              path: ATRoutes.editProfile.addSlash,
              pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                child: MultiBlocProvider(
                  providers: <SingleChildWidget>[
                    BlocProvider<RemoteUserDataCubit>(
                      create: (_) => RemoteUserDataCubit()),
                    BlocProvider<UploadImageCubit>(
                      create: (_) => UploadImageCubit())
                  ],
                  child: const EditProfileLandingScreen(),
                ),
              ),
              routes: <RouteBase>[
                GoRoute(
                    name: ATRoutes.imageCropperScreen,
                    path: ATRoutes.imageCropperScreen.addSlash,
                    pageBuilder: (_, GoRouterState state) {
                      final ImageCroppingParams params =
                          state.extra as ImageCroppingParams;
                      return ATSlidingRouteTransition<MemoryImage>(
                        child: ImageCropperScreen(params: params)
                      );
                    }),
                GoRoute(
                  name: ATRoutes.editNameScreen,
                  path: ATRoutes.editNameScreen,
                  pageBuilder: (_, GoRouterState state) =>
                    ATSlidingRouteTransition<String?>(
                      child: EditNameScreen(initialName: state.extra as String?)),
                ),
                GoRoute(
                  name: ATRoutes.editUsername,
                  path: ATRoutes.editUsername,
                  builder: (_, GoRouterState state) => EditUsernameScreen(
                      initialUsername: state.extra as String?),
                ),
                GoRoute(
                  name: ATRoutes.editBio,
                  path: ATRoutes.editBio,
                  pageBuilder: (_, GoRouterState state) =>
                      ATSlidingRouteTransition<String?>(
                        child: EditBioScreen(initialBio: state.extra as String?)),
                ),
                GoRoute(
                    name: ATRoutes.editSocials,
                    path: ATRoutes.editSocials,
                    pageBuilder: (_, GoRouterState state) => 
                      ATSlidingRouteTransition<String?>(
                        child: EditSocialsScreen(
                          params: state.extra as EditSocialsScreenParams),
                      )),
                GoRoute(
                    name: ATRoutes.enterEmailAndPhoneNoOtpScreen,
                    path: ATRoutes.enterEmailAndPhoneNoOtpScreen.addSlash,
                    pageBuilder: (_, GoRouterState state) {
                      return ATSlidingRouteTransition<bool?>(
                        child: UpdateEmailAndPhoneNoOtpScreen(
                          params: state.extra as EmailAndPhoneNoOTPScreenParams,
                        ),
                      );
                    }),
                GoRoute(
                    name: ATRoutes.selectAcctTypeScreen,
                    path: ATRoutes.selectAcctTypeScreen,
                    builder: (_, GoRouterState state) =>
                        const SelectAcctTypeScreen(),
                    routes: <RouteBase>[
                      GoRoute(
                          name: ATRoutes.selectedAcctOnboardScreen,
                          path: ATRoutes.selectedAcctOnboardScreen,
                          pageBuilder: (_, GoRouterState state) =>
                            ATSlidingRouteTransition<AccountType>(
                              beginOffset: const Offset(0, 1),
                              child: SelectedAcctOnboardScreen(
                                acctType: state.extra as AccountType,
                              ),
                            )),
                    ]),
                GoRoute(
                  name: ATRoutes.selectCategoriesScreen,
                  path: ATRoutes.selectCategoriesScreen.addSlash,
                  pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                    child: BlocProvider<SelectCategoryCubit>(
                      create: (_) => SelectCategoryCubit(),
                      child: SelectCategoryScreen(
                        acctType: state.extra as AccountType),
                    ),
                  )),
                GoRoute(
                  name: ATRoutes.subPlanSetupScreen,
                  path: ATRoutes.subPlanSetupScreen.addSlash,
                  pageBuilder: (_, GoRouterState st) {
                    final SubscriptionPlanData subPlanData =
                        st.extra as SubscriptionPlanData;
                    return ATSlidingRouteTransition<SubscriptionPlanData?>(
                        child: SubPlanSetupScreen(
                            incomingSubPlan: subPlanData));
                  }),
                GoRoute(
                  name: ATRoutes.cohostFeeSetupScreen,
                  path: ATRoutes.cohostFeeSetupScreen.addSlash,
                  pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                    child: BlocProvider<UpgradeAccountCubit>(
                      create: (_) => UpgradeAccountCubit(),
                      child: const CoHostFeeSetupScreen(),
                    ),
                  )),
                GoRoute(
                    name: ATRoutes.accountUpgradeSuccessScreen,
                    path: ATRoutes.accountUpgradeSuccessScreen,
                    pageBuilder: (_, GoRouterState state) => 
                      ATSlidingRouteTransition<void>(
                        child: AccountUpgradeSuccessScreen(
                          accountType: state.extra as AccountType))
                    ),
              ]),
          GoRoute(
              name: ATRoutes.profileMenuScreen,
              path: ATRoutes.profileMenuScreen,
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
                    ]),
              ]),
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
                    final String? email = params?.first;
                    final String? phone = params?.elementAtOrNull(1);
                    final String? country = params?.last;
                    return ATAccountInfoScreen(
                      country: country,
                      email: email,
                      phone: phone,
                    );
                  },
                ),
                GoRoute(
                    name: ATRoutes.SELECT_COUNTRY_SCREEN,
                    path: ATRoutes.SELECT_COUNTRY_SCREEN,
                    builder: (_, GoRouterState state) {
                      final List params = state.extra as List;
                      final List<String> countries =
                          params.last as List<String>;
                      final String selectedCountry = params.first as String;

                      return ATSelectCountryScreen(
                        countries: countries,
                        selectedCountry: selectedCountry,
                      );
                    }),
                GoRoute(
                  name: ATRoutes.updateEmailScreen,
                  path: ATRoutes.updateEmailScreen.addSlash,
                  pageBuilder: (_, GoRouterState state) =>
                      ATSlidingRouteTransition<void>(
                    child: UpdateEmailScreen(
                      title: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  name: ATRoutes.updatePhoneNoScreen,
                  path: ATRoutes.updatePhoneNoScreen.addSlash,
                  pageBuilder: (_, GoRouterState state) =>
                      ATSlidingRouteTransition<void>(
                    child: UpdatePhoneNoScreen(
                      title: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  name: ATRoutes.updateNameScreen,
                  path: ATRoutes.updateNameScreen.addSlash,
                  pageBuilder: (_, GoRouterState state) =>
                      ATSlidingRouteTransition<void>(
                    child: UpdateNameScreen(
                      title: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  name: ATRoutes.updateUsernameScreen,
                  path: ATRoutes.updateUsernameScreen.addSlash,
                  pageBuilder: (_, GoRouterState state) =>
                      ATSlidingRouteTransition<void>(
                    child: UpdateUsernameScreen(
                      title: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  name: ATRoutes.updateDOBScreen,
                  path: ATRoutes.updateDOBScreen.addSlash,
                  pageBuilder: (_, GoRouterState state) =>
                      ATSlidingRouteTransition<void>(
                    child: UpdateDOBScreen(
                      title: state.extra as String,
                    ),
                  ),
                ),
              ]),
          GoRoute(
            name: ATRoutes.profileFollowersScreen,
            path: ATRoutes.profileFollowersScreen,
            builder: (_, __) => const ATProfileFollowersScreen(),
          ),
          GoRoute(
            name: ATRoutes.communityTaskScreen,
            path: ATRoutes.communityTaskScreen,
            builder: (_, __) => const AmptiveCommunityTaskScreen(),
          ),
          GoRoute(
              name: ATRoutes.profilePicFullViewScreen,
              path: ATRoutes.profilePicFullViewScreen,
              builder: (_, GoRouterState state) {
                final String imgPath = state.extra as String;
                return AmptiveViewProfilePicScreen(imgPath: imgPath);
              }),
          GoRoute(
            name: ATRoutes.profileSubscribersScreen,
            path: ATRoutes.profileSubscribersScreen,
            builder: (_, __) => const ProfileSubscribersScreen(),
          ),
          GoRoute(
            name: ATRoutes.scheduledProgramsScreen,
            path: ATRoutes.scheduledProgramsScreen,
            builder: (_, __) => const ATScheduledPrograms(),
          ),
          GoRoute(
            name: ATRoutes.showPreviewScreen,
            path: ATRoutes.showPreviewScreen,
            pageBuilder: (_, GoRouterState state) {
              HostedShow hostedShow = state.extra as HostedShow;
              return ATSlidingRouteTransition<void>(
                  child: PreviewShowScreen(
                hostedShow: hostedShow,
              ));
            },
          ),
          GoRoute(
            name: ATRoutes.eventPreviewScreen,
            path: ATRoutes.eventPreviewScreen.addSlash,
            pageBuilder: (_, GoRouterState state) {
              HostedEvent hostedEvent = state.extra as HostedEvent;
              return ATSlidingRouteTransition<void>(
                  child: MultiBlocProvider(
                    providers: <SingleChildWidget>[
                      BlocProvider<EventDetailCubit>(
                        create: (_) => EventDetailCubit(
                          initialEvent: hostedEvent,
                        ),
                      ),
                      BlocProvider<BlurredHeaderCubit>(
                          create: (_) => BlurredHeaderCubit()),
                      BlocProvider<ToggleFollowingCubit>(
                          create: (_) => ToggleFollowingCubit(
                            initialStatus: FollowingStatus(
                            isFollowing: true,
                            followerCount: hostedEvent.followerCount ?? 0,
                          )
                        )
                      ),
                      BlocProvider<StartLiveProgramCubit>(
                        create: (_) => StartLiveProgramCubit()),
                    ],
                    child: PreviewEventScreen(
                      hostedEvent: hostedEvent,
                    ),
                  )
                );
            },
          ),

          GoRoute(
            name: ATRoutes.editEventScreen,
            path: ATRoutes.editEventScreen.addSlash,
            pageBuilder: (_, GoRouterState state) {
              HostedEvent eventToEdit = state.extra as HostedEvent;
              return ATSlidingRouteTransition<void>(
                  child: EditEventFormScreen(
                editableEvent: eventToEdit,
              ));
            },
          ),
          GoRoute(
            name: ATRoutes.editEpisodeScreen,
            path: ATRoutes.editEpisodeScreen.addSlash,
            pageBuilder: (_, GoRouterState state) {
              return ATSlidingRouteTransition<void>(
                  child: EditEpisodeFormScreen(
                editableEpisode: state.extra as Episode,
              ));
            },
          ),
          GoRoute(
            name: ATRoutes.selectScheduleDateScreen,
            path: ATRoutes.selectScheduleDateScreen.addSlash,
            pageBuilder: (_, GoRouterState state) {
              final SelectScheduleDataScreenEntryParams params =
                  state.extra as SelectScheduleDataScreenEntryParams;
              return ATSlidingRouteTransition<void>(
                  child: SelectScheduleDateScreen(params: params));
            },
          ),
          GoRoute(
            name: ATRoutes.previewEpisodeScreen,
            path: ATRoutes.previewEpisodeScreen.addSlash,
            pageBuilder: (_, GoRouterState st) =>
                ATSlidingRouteTransition<void>(
                    child: PreviewEpisodeScreen(
              episode: st.extra as Episode,
            )),
          ),
          GoRoute(
            name: ATRoutes.subscribedProgramsScreen,
            path: ATRoutes.subscribedProgramsScreen,
            builder: (_, __) => const ATSubscribedPrograms(),
          ),
          GoRoute(
            name: ATRoutes.followingProgramsScreen,
            path: ATRoutes.followingProgramsScreen,
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
              builder: (_, GoRouterState state) {
                final Object? extra = state.extra;
                String? communityId;
                if (extra is Map<String, dynamic>) {
                  communityId = extra['communityId'] as String?;
                } else if (extra is Map<String, String>) {
                  communityId = extra['communityId'];
                }
                return DiscoverSocietyScreen(communityId: communityId);
              },
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
              ]),
        ]),
  ],
  // observers: [LoggingNavigatorObserver()],
);