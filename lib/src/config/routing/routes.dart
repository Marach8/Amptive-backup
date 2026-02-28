import 'dart:io';
import 'package:amptive/src/config/routing/routing_export.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_email_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/update_phone_no_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/create_new_password_screen.dart';
import 'package:amptive/src/features/auth/presentation/screens/forgot_password_email_screen.dart';
import 'package:amptive/src/features/auth/phone_login_screen.dart';
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
import 'package:amptive/src/features/home/cubits/followed_shows_cubit.dart';
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
import 'package:amptive/src/features/accounts/presentation/screens/account_info_screen.dart';
import 'package:amptive/src/features/accounts/presentation/screens/acounts_landing_screen.dart';
import 'package:amptive/src/features/switch_account/presentation/switch_acct/switch_acct_export.dart';
import 'package:amptive/src/features/wallet/presentation/screens/wallet_transactions_history_screen.dart';
import 'package:amptive/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:amptive/src/features/onboarding/presentation/screens/post_onboarding_screen.dart';
import 'package:custom_image_crop/custom_image_crop.dart' show Ratio, CustomCropShape;
import 'package:flutter/foundation.dart';
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
import '../../features/wallet/wallet_export.dart';

// The route configuration.
final GoRouter amptiveAppRouter = GoRouter(
  initialLocation: ATRoutes.mainAppShell.addSlash,
  //redirect: tempRedirect,
  //initialLocation: ATRoutes.temporaryLoginScreen.addSlash,
  routes: <RouteBase>[
    GoRoute(
      name: ATRoutes.POST_ONBOARDING_SCREEN,
      path: ATRoutes.POST_ONBOARDING_SCREEN.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const ATPostOnboardingScreen(),
      )
    ),
    GoRoute(
      name: ATRoutes.ONBOARDING_SCREEN,
      path: ATRoutes.ONBOARDING_SCREEN.addSlash,
      builder: (_, __) => const ATOnboardingScreen(),
    ),

    //AUTHENTICATION SCREENS
    GoRoute(
      name: ATRoutes.AUTH_OPTIONS_SCREEN,
      path: ATRoutes.AUTH_OPTIONS_SCREEN.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: ATAuthOptionsScreen(authType: st.extra as AuthType,)
      ),
    ),
    GoRoute(name: ATRoutes.FORGOT_PASSWORD_SCREEN,
      path: ATRoutes.FORGOT_PASSWORD_SCREEN.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child:  const ATForgotPasswordEmailScreen()),
      ),
    
    GoRoute(
      name: ATRoutes.temporaryLoginScreen,
      path: ATRoutes.temporaryLoginScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: const LoginScreen()
      )
    ),
     GoRoute(
      name: ATRoutes.emailScreen,
      path: ATRoutes.emailScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: ATEmailAuthScreen(title: st.extra as String?)
      )
    ),

    GoRoute(
      name: ATRoutes.ENTER_OTP_SCREEN,
      path: ATRoutes.ENTER_OTP_SCREEN.addSlash,
      pageBuilder: (_, GoRouterState state) {
        return ATSlidingRouteTransition<bool?>(
          child: ATOTPScreen(params: state.extra as VerifyOTPScreenParams,),
        );
      }
    ),
    GoRoute(
      name: ATRoutes.PASSWORD_RESET_OTP_SCREEN,
      path: ATRoutes.PASSWORD_RESET_OTP_SCREEN.addSlash,
      pageBuilder: (_, GoRouterState state) {
        return ATSlidingRouteTransition<bool?>(
          child: ResetPasswordOtpScreen(params: state.extra as VerifyPasswordResetOTPScreenParams,),
        );
      }
    ),

    
    GoRoute(
      name: ATRoutes.phoneAuthScreen,
      path: ATRoutes.phoneAuthScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: PhoneAuthScreen(title: st.extra as String?),
      )
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
        child:  CreateNewPasswordScreen(params: state.extra as CreateNewPasswordScreenParams,),
      )
    ),



    GoRoute(
      name: ATRoutes.addProfilePicScreen,
      path: ATRoutes.addProfilePicScreen.addSlash,
      pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
        child: const AddProfilePictureScreen(),
      )
    ),

    GoRoute(
      name: ATRoutes.createPasswordScreen,
      path: ATRoutes.createPasswordScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const PasswordAuthScreen(),
      )
    ),

    GoRoute(
      name: ATRoutes.dobAuthScreen,
      path: ATRoutes.dobAuthScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const AddDOBScreen(),
      )
    ),
    GoRoute(
      name: ATRoutes.addUserNameScreen,
      path: ATRoutes.addUserNameScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const AddUsernameScreen(),
      )
    ),
    GoRoute(
      name: ATRoutes.addNameAuthScreen,
      path: ATRoutes.addNameAuthScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const AddNameScreen(),
      )
    ),
    GoRoute(
      name: ATRoutes.select5CommunitiesScreen,
      path: ATRoutes.select5CommunitiesScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const Select5CommunitiesScreen(),
      )
    ),

    GoRoute(
      name: ATRoutes.allowNotificationsScreen,
      path: ATRoutes.allowNotificationsScreen.addSlash,
      pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
        child: const NotificationsPromptScreen(),
      )
    ),

    //MAIN APPLICATION SCREENS
    GoRoute(
        name: ATRoutes.mainAppShell,
        path: ATRoutes.mainAppShell.addSlash,
        builder: (_, __) => const ATMainAppShell(),
        routes: <RouteBase>[
          GoRoute(
            name: ATRoutes.SCHEDULE_DETAILED,
            path: ATRoutes.SCHEDULE_DETAILED.addSlash,
            pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const ATScheduleDetailedScreen()
            ),
          ),
          
          GoRoute(
            name: ATRoutes.WALLET_ONBOARDING,
            path: ATRoutes.WALLET_ONBOARDING.addSlash,
            pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const ATWalletOnboardScreen()
            ),
            routes: <RouteBase>[
              GoRoute(
                name: ATRoutes.WALLET_PIN_SETUP,
                path: ATRoutes.WALLET_PIN_SETUP.addSlash,
                pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                  child: const ATWalletPinSetupScreen()
                ),
              ),
              GoRoute(
                name: ATRoutes.securityQuestionScreen,
                path: ATRoutes.securityQuestionScreen.addSlash,
                pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                  child: const ATSecurityQuestionScreen()
                ),
              ),
              GoRoute(
                name: ATRoutes.walletCreationAnimationScreen,
                path: ATRoutes.walletCreationAnimationScreen.addSlash,
                pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                  child: const ATWalletCreationAnimScreen()
                ),
              ),
              GoRoute(
                name: ATRoutes.WALLET,
                path: ATRoutes.WALLET.addSlash,
                pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                  child: const WalletLandingScreen(),
                ),
                routes: <RouteBase>[
                  GoRoute(
                    name: ATRoutes.walletTransactionsHistoryScreen,
                    path: ATRoutes.walletTransactionsHistoryScreen.addSlash,
                    pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                      child: const ATWalletTxnsHistoryScreen()
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.SELECT_RECIPIENT,
                    path: ATRoutes.SELECT_RECIPIENT.addSlash,
                    pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                      child: const ATSelectRecipientScreen()
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.transactionAmountScreen,
                    path: ATRoutes.transactionAmountScreen.addSlash,
                    pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                      child: TransactionAmountScreen(
                        params: state.extra as TransactionAmountScreenParams
                      )
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.WITHDRAWAL_LANDING,
                    path: ATRoutes.WITHDRAWAL_LANDING.addSlash,
                    pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                      child: const ATWithdrwalLandingScreen()
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.SELECT_BANK_COUNTRY,
                    path: ATRoutes.SELECT_BANK_COUNTRY.addSlash,
                    pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
                      child: const ATSelectBanksCountryScreen()
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.ENTER_ACCT_NO,
                    path: ATRoutes.ENTER_ACCT_NO.addSlash,
                    pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                      child: ATEnterAccountNoScreen(bankName: state.extra as String,)
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.answerSecurityQuestionScreen,
                    path: ATRoutes.answerSecurityQuestionScreen.addSlash,
                    pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                      child: const ATAnswerSecurityQuestionScreen()
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.paperPlaneSuccessScreen,
                    path: ATRoutes.paperPlaneSuccessScreen.addSlash,
                    pageBuilder: (_, GoRouterState state){
                      final List<dynamic> params = state.extra as List<dynamic>;
                      return ATSlidingRouteTransition<void>(
                        child: ATPaperPlaneSuccessScreen(
                          title: params.first as String,
                          transactionType: params[1] as TransactionType,
                          subtitle: params.last as String,
                        )
                      );
                    },
                  ),
                ]
              ),
            ]
          ),
          
          GoRoute(
            name: ATRoutes.LIVE_SHOW_DETAILED,
            path: ATRoutes.LIVE_SHOW_DETAILED.addSlash,
            pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              beginOffset: const Offset(0.0, 1.0),
              child: const ATLiveShowDetailedScreen()
            )
          ),
          GoRoute(
            name: ATRoutes.LIVE_EVENT_DETAILED,
            path: ATRoutes.LIVE_EVENT_DETAILED.addSlash,
            pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              beginOffset: const Offset(0.0, 1.0),
              child: const ATLiveEventDetailedScreen(),
            )
          ),

          GoRoute(
            name: ATRoutes.GO_LIVE_ONBOARDING,
            path: ATRoutes.GO_LIVE_ONBOARDING.addSlash,
            pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const GoLiveOnboardingScreen()
            )
          ),

          GoRoute(
            name: ATRoutes.MAIN_GO_LIVE_PROGRAM,
            path: ATRoutes.MAIN_GO_LIVE_PROGRAM.addSlash,
            pageBuilder: (_, GoRouterState st){
              final GoLiveUserType? userType = st.extra as GoLiveUserType?;
              return ATFadingRouteTransition<void>(
                child: GoLiveScreen(userType: userType ?? GoLiveUserType.host)
              );
            }
          ),

          GoRoute(
            name: ATRoutes.GO_LIVE_TYPE_SELECTION,
            path: ATRoutes.GO_LIVE_TYPE_SELECTION,
            builder: (_, __) => const GoLiveTypeSelectionScreen(),
          ),

          GoRoute(
            name: ATRoutes.listHostedShowsScreen,
            path: ATRoutes.listHostedShowsScreen.addSlash,
            pageBuilder: (_, __) => ATSlidingRouteTransition<void>(
              child: const ListHostedShowsScreen(),
            )
          ),

          GoRoute(
            name: ATRoutes.CREATE_SHOW_FORM,
            path: ATRoutes.CREATE_SHOW_FORM,
            pageBuilder: (_, __) => ATSlidingRouteTransition<void>(child: const CreateShowFormScreen())
          ),
          GoRoute(
            name: ATRoutes.CREATE_EVENT_FORM,
            path: ATRoutes.CREATE_EVENT_FORM,
            pageBuilder: (_, __) => ATSlidingRouteTransition<void>(child: const CreateEventFormScreen(),)
          ),
          GoRoute(
            name: ATRoutes.CREATE_EPISODE_FORM,
            path: ATRoutes.CREATE_EPISODE_FORM,
            pageBuilder: (_, __) => ATSlidingRouteTransition<void>(child: const CreateEpisodeFormScreen())
          ),
          GoRoute(
            name: ATRoutes.GO_LIVE_PROGRAM_CREATION_SUCCESS,
            path: ATRoutes.GO_LIVE_PROGRAM_CREATION_SUCCESS,
            pageBuilder: (_, GoRouterState state) {
              final dynamic params = state.extra as ({
                Uint8List coverArtBytes,
                String title,
                String subtitle,
                String btnTitle,
                String txtBtnTitle,
                VoidCallback btnOnPressed,
                VoidCallback txtBtnOnPressed,
                Widget topLogo
              });
              return ATSlidingRouteTransition<void>(
                child: GoLiveProgramCreationSuccessScreen(params: params,),
              );
            },
          ),

          GoRoute(
            name: ATRoutes.CREATOR_PROFILE_SCREEN,
            path: ATRoutes.CREATOR_PROFILE_SCREEN,
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
                pageBuilder: (_, GoRouterState state){
                  final (File, Ratio?, CustomCropShape?) params = state.extra 
                    as (File, Ratio?, CustomCropShape?);
                  return ATSlidingRouteTransition<MemoryImage>(
                    child: RectImageCropperScreen(
                      imageFile: params.$1,
                      ratio: params.$2,
                      shape: params.$3 ?? CustomCropShape.Ratio,
                    )
                  );
                }
              ),
              GoRoute(
                name: ATRoutes.EDIT_NAME,
                path: ATRoutes.EDIT_NAME,
                builder: (_, GoRouterState state) => EditNameScreen(initialName: state.extra as String),
              ),
              GoRoute(
                name: ATRoutes.EDIT_USERNAME,
                path: ATRoutes.EDIT_USERNAME,
                builder: (_, GoRouterState state) => EditUsernameScreen(initialUsername: state.extra as String),
              ),
              GoRoute(
                name: ATRoutes.EDIT_BIO,
                path: ATRoutes.EDIT_BIO,
                builder: (_, GoRouterState state) => EditBioScreen(initialBio: state.extra as String),
              ),
              GoRoute(
                name: ATRoutes.EDIT_SOCIALS,
                path: ATRoutes.EDIT_SOCIALS,
                builder: (_, GoRouterState state){
                  final List<String?> params = state.extra as List<String?>;
                  return EditSocialsScreen(
                    initialLink: params.first,
                    socialName: params.last as String
                  );
                }
              ),
              GoRoute(
                name: ATRoutes.SELECT_ACCT_TYPE,
                path: ATRoutes.SELECT_ACCT_TYPE,
                builder: (_, GoRouterState state) => const SelectAcctTypeScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    name: ATRoutes.SELECTED_ACCT,
                    path: ATRoutes.SELECTED_ACCT,
                    builder: (_, GoRouterState state) => const SelectedAcctLandingScreen()
                  ),
                ]
              ),
              
              GoRoute(
                name: ATRoutes.SELECT_CAT,
                path: ATRoutes.SELECT_CAT,
                builder: (_, __) => const SelectCategoryScreen()
              ),
              GoRoute(
                name: ATRoutes.CREATOR_SUB_PLAN,
                path: ATRoutes.CREATOR_SUB_PLAN,
                pageBuilder: (_, GoRouterState st){
                  final SubPlanScreenEntryPoint? entryPoint = st.extra as SubPlanScreenEntryPoint?;
                  return ATSlidingRouteTransition<void>(child: CreatorSubPlanScreen(entryPoint: entryPoint));
                }
              ),
              GoRoute(
                name: ATRoutes.CO_HOST_FEE_SETUP,
                path: ATRoutes.CO_HOST_FEE_SETUP,
                builder: (_, GoRouterState state) => const CoHostFeeSetupScreen()
              ),
              GoRoute(
                name: ATRoutes.CREATOR_SUCCESS,
                path: ATRoutes.CREATOR_SUCCESS,
                builder: (_, GoRouterState state) => const CreatorOrBusinessSetupSuccessScreen()
              ),
            ]
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
                ]
              ),
            ]
          ),

          GoRoute(
            name: ATRoutes.accountLandingScreen,
            path: ATRoutes.accountLandingScreen.addSlash,
            builder: (_, __) => const ATAccountLandingScreen(),
            routes: <RouteBase>[
              GoRoute(
                name: ATRoutes.ACCT_INFO_SCREEN,
                path: ATRoutes.ACCT_INFO_SCREEN.addSlash,
                builder: (_, GoRouterState state){
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
                builder: (_, GoRouterState state){
                  final List params = state.extra as List;
                  final List<String> countries = params.last as List<String>;
                  final String selectedCountry = params.first as String;

                  return ATSelectCountryScreen(
                    countries: countries,
                    selectedCountry: selectedCountry,
                  );
                }
              ),

              GoRoute(
                name: ATRoutes.updateEmailScreen,
                path: ATRoutes.updateEmailScreen.addSlash,
                pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                  child: UpdateEmailScreen(title: state.extra as String,),
                ),
              ),
              GoRoute(
                name: ATRoutes.updatePhoneNoScreen,
                path: ATRoutes.updatePhoneNoScreen.addSlash,
                pageBuilder: (_, GoRouterState state) => ATSlidingRouteTransition<void>(
                  child: UpdatePhoneNoScreen(title: state.extra as String,),
                ),
              ),
            ]
          ),

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
            builder: (_, GoRouterState state){
              final String imgPath = state.extra as String;
              return AmptiveViewProfilePicScreen(imgPath: imgPath);
            }
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
            name: ATRoutes.SHOW_PREVIEW_SCREEN,
            path: ATRoutes.SHOW_PREVIEW_SCREEN,
            pageBuilder: (_, GoRouterState state) {
              String coverArt = state.extra as String;
              return ATSlidingRouteTransition<void>(
                child: PreviewShowScreen(coverArt: coverArt,)
              );
            },
          ),
          GoRoute(
            name: ATRoutes.EPISODE_PREVIEW_SCREEN,
            path: ATRoutes.EPISODE_PREVIEW_SCREEN,
            pageBuilder: (_, GoRouterState st) => ATSlidingRouteTransition<void>(
              child: EpisodeDetailPreviewScreen(coverArtBytes: st.extra as Uint8List,)
            ),
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
              ]),
        ]),
  ],
  // observers: [LoggingNavigatorObserver()],
);
