import 'dart:io';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/setup.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/views/features/auth/add_phone.dart';
import 'package:amptive/src/views/features/auth/dob_screen.dart';
import 'package:amptive/src/views/features/auth/email_auth_screen.dart';
import 'package:amptive/src/views/features/auth/name_auth_screen.dart';
import 'package:amptive/src/views/features/auth/otp_screen.dart';
import 'package:amptive/src/views/features/auth/password_auth_screen.dart';
import 'package:amptive/src/views/features/auth/post_registration.dart';
import 'package:amptive/src/views/features/auth/sign_in_or_sign_up_screen.dart';
import 'package:amptive/src/views/features/auth/username_auth_screen.dart';
import 'package:amptive/src/views/features/main_app/go_live/event/even_scheduled_screen.dart';
import 'package:amptive/src/views/features/main_app/go_live/show/create_show_form_screen.dart';
import 'package:amptive/src/views/features/main_app/dashboard_screen.dart';
import 'package:amptive/src/views/features/main_app/go_live/main_go_live_screen.dart';
import 'package:amptive/src/views/features/main_app/profile/presentation/views/profile_views_export.dart';
import 'package:amptive/src/views/features/main_app/scheduled_screen.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/enter_amount_screen.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/creating_wallet_anim_screen.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/security_question_screen.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/select_banks_country_screen.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/select_recipient_screen.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/wallet_onboard_screen.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/wallet_pin_setup_screen.dart';
import 'package:amptive/src/views/features/main_app/wallet/presentation/views/wallet_screen.dart';
import 'package:amptive/src/views/features/post_auth/crop_image_screen.dart';
import 'package:amptive/src/views/features/post_auth/pre_homepage.dart';
import 'package:amptive/src/views/features/post_auth/preference_screen.dart';
import 'package:amptive/src/views/features/onboarding/onboarding_page_view_screen.dart';
import 'package:amptive/src/views/features/onboarding/welcome_screen.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/widgets_in_go_live/shows/show_type_visibility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'views/features/main_app/discover/community_home_screen.dart';
import 'views/features/main_app/discover/hashtag_full_screen.dart';
import 'views/features/main_app/discover/society_screen.dart';
import 'views/features/main_app/discover/trending_hashtags_screen.dart';
import 'views/features/main_app/discover/trending_society_screen.dart';
import 'views/features/main_app/event_detailed_screen.dart';
import 'views/features/main_app/following_screen.dart';
import 'views/features/main_app/go_live/event/choose_event_screen.dart';
import 'views/features/main_app/go_live/show/choose_or_create_show_screen.dart';
import 'views/features/main_app/go_live/show/show_creation_success_screen.dart';
import 'views/features/main_app/show_detailed_screen.dart';
import 'views/features/main_app/subscribed_screen.dart';
import 'views/features/main_app/wallet/presentation/views/withdrawal_landing_screen.dart';

// The route configuration.
final GoRouter amptiveAppRouter = GoRouter(
  initialLocation: ATRoutes.index,
  //initialLocation: "/add-profile-pic",
  routes: <RouteBase>[
    GoRoute(
        path: ATRoutes.index,
        builder: (_, __) => const AmptiveDashboardScreen()),
    GoRoute(
      name: ATRoutes.welcome,
      path: "/welcome-route",
      builder: (_, __) => const AmptiveWelcomeScreen(),
    ),
    GoRoute(
      name: ATRoutes.onboarding,
      path: "/onboarding-route",
      builder: (_, __) => const AmptiveOnboardingScreen(),
    ),

    //AUTHENTICATION SCREENS
    GoRoute(
      name: ATRoutes.authScreen,
      path: "/auth-route",
      builder: (_, GoRouterState state) => AmptiveAuthScreen(
        userSignUp: state.extra as bool,
      ),
    ),
    GoRoute(
      name: ATRoutes.EMAIL_SCREEN,
      path: ATRoutes.EMAIL_SCREEN.addSlash,
      builder: (_, state) => ATEmailAuthScreen(title: state.extra as String?)
    ),
    GoRoute(
      name: ATRoutes.OTP_SCREEN,
      path: ATRoutes.OTP_SCREEN.addSlash,
      builder: (_, state) {
        final params = state.extra as List<String?>?;
        final emailOrPhone = params?.first;
        final title = params?.last;
        return ATOTPScreen(emailOrPhone: emailOrPhone ?? '', title: title ?? '');
      }
    ),
    GoRoute(
      name: ATRoutes.ADD_FONE_NO_SCREEN,
      path: ATRoutes.ADD_FONE_NO_SCREEN.addSlash,
      builder: (_, state) => AddPhoneScreen(title: state.extra as String?),
    ),
    GoRoute(
        name: ATRoutes.addProfilePic,
        path: "/add-profile-pic",
        builder: (_, __) => const PostRegistrationScreen(),
        routes: <RouteBase>[
          GoRoute(
              name: ATRoutes.cropImage,
              path: "crop-image",
              builder: (_, GoRouterState state) {
                File imageFile = state.extra as File;
                return CropPage(
                  title: "Cropper",
                  imageFile: imageFile,
                );
              }),
        ]),
    GoRoute(
      name: ATRoutes.passwordAuth,
      path: "/password",
      builder: (_, __) => const PasswordAuthScreen(),
    ),
    GoRoute(
      name: ATRoutes.dobAuth,
      path: "/dob",
      builder: (_, __) => const DateOfBirthScreen(),
    ),
    GoRoute(
      name: ATRoutes.addUsername,
      path: "/username-add",
      builder: (_, __) => const UserNameAuthScreen(),
    ),
    GoRoute(
      name: ATRoutes.addName,
      path: "/name-add",
      builder: (_, __) => const NameAuthScreen(),
    ),
    GoRoute(
      name: ATRoutes.preference,
      path: "/preference-route",
      builder: (_, __) => const AmptivePreferenceScreen(),
    ),

    GoRoute(
      name: ATRoutes.preHomepage,
      path: "/pre-homepage",
      builder: (_, __) => const PreHomePage(),
    ),

    //MAIN APPLICATION SCREENS
    GoRoute(
        name: ATRoutes.homeScreen,
        path: "/home-screen",
        builder: (_, __) => const AmptiveDashboardScreen(),
        routes: [
          GoRoute(
            name: ATRoutes.WALLET_LANDING,
            path: ATRoutes.WALLET_LANDING.addSlash,
            pageBuilder: (_, __) => ATRouteTransition(
              child: const ATWalletOnboardScreen()
            ),
            routes: [
              GoRoute(
                name: ATRoutes.WALLET_PIN_SETUP,
                path: ATRoutes.WALLET_PIN_SETUP.addSlash,
                pageBuilder: (_, __) => ATRouteTransition(
                  child: const ATWalletPinSetupScreen()
                ),
              ),
              GoRoute(
                name: ATRoutes.SECURITY_QUEST,
                path: ATRoutes.SECURITY_QUEST.addSlash,
                pageBuilder: (_, __) => ATRouteTransition(
                  child: const ATSecurityQuestionScreen()
                ),
              ),
              GoRoute(
                name: ATRoutes.WALLET_CREATION_ANIM,
                path: ATRoutes.WALLET_CREATION_ANIM.addSlash,
                pageBuilder: (_, __) => ATRouteTransition(
                  child: const ATWalletCreationAnimScreen()
                ),
              ),
              GoRoute(
                name: ATRoutes.WALLET,
                path: ATRoutes.WALLET.addSlash,
                pageBuilder: (_, __) => ATRouteTransition(
                  child: const ATWalletScreen(),
                ),
                routes: [
                  GoRoute(
                    name: ATRoutes.SELECT_RECIPIENT,
                    path: ATRoutes.SELECT_RECIPIENT.addSlash,
                    pageBuilder: (_, __) => ATRouteTransition(
                      child: const ATSelectRecipientScreen()
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.AMOUNT_2_TRSF,
                    path: ATRoutes.AMOUNT_2_TRSF.addSlash,
                    pageBuilder: (_, state) => ATRouteTransition(
                      child: ATEnterAmountScreen(
                        receipient: state.extra as ObjectWithNotifier<Host>?,
                      )
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.WITHDRAWAL,
                    path: ATRoutes.WITHDRAWAL.addSlash,
                    pageBuilder: (_, __) => ATRouteTransition(
                      child: const ATWithdrwalLandingScreen()
                    ),
                  ),

                  GoRoute(
                    name: ATRoutes.SELECT_BANK_COUNTRY,
                    path: ATRoutes.SELECT_BANK_COUNTRY.addSlash,
                    pageBuilder: (_, __) => ATRouteTransition(
                      child: const ATSelectBanksCountryScreen()
                    ),
                  ),
                ]
              ),
            ]
          ),
          
          GoRoute(
            name: ATRoutes.SHOW_DETAILED,
            path: ATRoutes.SHOW_DETAILED.addSlash,
            pageBuilder: (_, __) => ATRouteTransition(
              beginOffset: const Offset(0.0, 1.0),
              child: const ATShowDetailedScreen()
            )
          ),
          GoRoute(
              name: ATRoutes.EVENT_DETAILED_SCREEN,
              path: ATRoutes.EVENT_DETAILED_SCREEN,
              pageBuilder: (context, state) => CustomTransitionPage(
                    child: const AmptiveEventDetailedScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var tween =
                          Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                              .animate(
                        CurvedAnimation(
                            parent: animation, curve: Curves.easeIn),
                      );

                      return SlideTransition(
                        position: tween,
                        child: child,
                      );
                    },
                    reverseTransitionDuration:
                        const Duration(milliseconds: 700),
                    transitionDuration: const Duration(milliseconds: 700),
                  )),
          GoRoute(
            name: ATRoutes.CHOOSE_OR_CREATE_SHOW_SCREEN,
            path: ATRoutes.CHOOSE_OR_CREATE_SHOW_SCREEN,
            builder: (_, __) => const AmptiveChooseOrCreateShowScreen(),
          ),
          GoRoute(
            name: ATRoutes.CHOOSE_OR_CREATE_EVENT_SCREEN,
            path: ATRoutes.CHOOSE_OR_CREATE_EVENT_SCREEN,
            builder: (_, __) => const AmptiveChooseOrCreateEventScreen(),
          ),
          GoRoute(
              name: ATRoutes.CREATE_SHOW_FORM,
              path: ATRoutes.CREATE_SHOW_FORM,
              builder: (_, __) {
                return const CreateShowScreen(showType: ShowType.show);
              }),
          GoRoute(
              name: ATRoutes.CREATE_EVENT_FORM,
              path: ATRoutes.CREATE_EVENT_FORM,
              builder: (_, GoRouterState state) {
                return const CreateShowScreen(
                  showType: ShowType.event,
                );
              }),
          GoRoute(
              name: ATRoutes.CREATE_EPISODE_FORM,
              path: ATRoutes.CREATE_EPISODE_FORM,
              builder: (_, __) {
                return const CreateShowScreen(showType: ShowType.episode);
              }),
          GoRoute(
            name: ATRoutes.CREATE_SHOW_SUCCESS,
            path: ATRoutes.CREATE_SHOW_SUCCESS,
            builder: (_, GoRouterState state) {
              String imageFilePath = state.extra as String;
              return ATCreateShowSuccessScreen(
                imageFilePath: imageFilePath,
              );
            },
          ),

          GoRoute(
            name: ATRoutes.CREATOR_PROFILE_SCREEN,
            path: ATRoutes.CREATOR_PROFILE_SCREEN,
            builder: (_, __) => const AmptiveCreatorProfileScreen(),
          ),

          GoRoute(
            name: ATRoutes.EDIT_PROFILE,
            path: ATRoutes.EDIT_PROFILE.addSlash,
            builder: (_, __) => const EditProfileScreen(),
            routes: [
              GoRoute(
                name: ATRoutes.PROFILE_BG_CROP,
                path: ATRoutes.PROFILE_BG_CROP,
                builder: (_, state) => CropProfileBgImageScreen(file: state.extra as File)
              ),
              GoRoute(
                name: ATRoutes.EDIT_NAME,
                path: ATRoutes.EDIT_NAME,
                builder: (_, state) => EditNameScreen(initialName: state.extra as String),
              ),
              GoRoute(
                name: ATRoutes.EDIT_USERNAME,
                path: ATRoutes.EDIT_USERNAME,
                builder: (_, state) => EditUsernameScreen(initialUsername: state.extra as String),
              ),
              GoRoute(
                name: ATRoutes.EDIT_BIO,
                path: ATRoutes.EDIT_BIO,
                builder: (_, state) => EditBioScreen(initialBio: state.extra as String),
              ),
              GoRoute(
                name: ATRoutes.EDIT_SOCIALS,
                path: ATRoutes.EDIT_SOCIALS,
                builder: (_, state){
                  final params = state.extra as List<String?>;
                  return EditSocialsScreen(
                    initialLink: params.first,
                    socialName: params.last as String
                  );
                }
              ),
              GoRoute(
                name: ATRoutes.SELECT_ACCT_TYPE,
                path: ATRoutes.SELECT_ACCT_TYPE,
                builder: (_, state) => const SelectAcctTypeScreen(),
                routes: [
                  GoRoute(
                    name: ATRoutes.SELECTED_ACCT,
                    path: ATRoutes.SELECTED_ACCT,
                    builder: (_, state) => const SelectedAcctLandingScreen()
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
                builder: (_, __) => const CreatorSubPlanScreen()
              ),
              GoRoute(
                name: ATRoutes.CO_HOST_FEE_SETUP,
                path: ATRoutes.CO_HOST_FEE_SETUP,
                builder: (_, state) => const CoHostFeeSetupScreen()
              ),
              GoRoute(
                name: ATRoutes.CREATOR_SUCCESS,
                path: ATRoutes.CREATOR_SUCCESS,
                builder: (_, state) => const CreatorSuccessScreen()
              ),
            ]
          ),

          GoRoute(
            name: ATRoutes.PROFILE_MENU_SCREEN,
            path: ATRoutes.PROFILE_MENU_SCREEN,
            builder: (_, __) => const AmptiveProfileMenuScreen(),
            routes: [
              GoRoute(
                name: ATRoutes.CALENDER_SCREEN,
                path: ATRoutes.CALENDER_SCREEN,
                builder: (_, __) => const ATCalenderScreen(),
              ),

              GoRoute(
                name: ATRoutes.LANGUAGE_SCREEN,
                path: ATRoutes.LANGUAGE_SCREEN,
                builder: (_, __) => const ATSelectLanguageScreen(),
              ),

              GoRoute(
                name: ATRoutes.PRIVACY_SCREEN,
                path: ATRoutes.PRIVACY_SCREEN,
                builder: (_, __) => const AmptivePrivacyScreen(),
                routes: [
                  GoRoute(
                    name: ATRoutes.BLOCKED_ACCTS_SCREEN,
                    path: ATRoutes.BLOCKED_ACCTS_SCREEN,
                    builder: (_, __) => const AmptiveBlockedAcctsScreen(),
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
            name: ATRoutes.ACCT_SCREEN,
            path: ATRoutes.ACCT_SCREEN,
            builder: (_, __) => const ATAccountScreen(),
            routes: [
              GoRoute(
                name: ATRoutes.ACCT_INFO_SCREEN,
                path: ATRoutes.ACCT_INFO_SCREEN,
                builder: (_, state){
                  final params = state.extra as List<String?>?;
                  final email = params?.first;
                  final phone = params?.elementAtOrNull(1);
                  final country = params?.last;
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
                builder: (_, state){
                  final params = state.extra as List;
                  final countries = params.last as List<String>;
                  final selectedCountry = params.first as String;

                  return ATSelectCountryScreen(
                    countries: countries,
                    selectedCountry: selectedCountry,
                  );
                }
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
            builder: (_, state){
              final imgPath = state.extra as String;
              return AmptiveViewProfilePicScreen(imgPath: imgPath);
            }
          ),

          GoRoute(
            name: ATRoutes.PROFILE_SUBSCRIBERS_SCREEN,
            path: ATRoutes.PROFILE_SUBSCRIBERS_SCREEN,
            builder: (_, __) => const AmptiveProfileSubScribersScreen(),
          ),

          GoRoute(
            name: ATRoutes.USER_PROFILE_SCREEN,
            path: ATRoutes.USER_PROFILE_SCREEN,
            builder: (_, __) => const ATUserProfileScreen(),
          ),

          GoRoute(
            name: ATRoutes.GO_LIVE_SCREEN,
            path: ATRoutes.GO_LIVE_SCREEN,
            builder: (_, __) => const AmptiveGoLiveScreen(),
          ),
          GoRoute(
            name: ATRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN,
            path: ATRoutes.SCHEDULED_EVENTS_OR_SHOWS_SCREEN,
            builder: (_, __) => const AmptiveScheduledEventOrShowViewWidget(),
          ),
          GoRoute(
            name: ATRoutes.EVENT_SCHEDULED_SCREEN,
            path: ATRoutes.EVENT_SCHEDULED_SCREEN,
            builder: (_, GoRouterState state) {
              String imageFilePath = state.extra as String;
              return AmptiveShowScheduledScreen(
                showType: ShowType.event,
                imageFilePath: imageFilePath,
              );
            },
          ),
          GoRoute(
            name: ATRoutes.EPISODE_SCHEDULED_SCREEN,
            path: ATRoutes.EPISODE_SCHEDULED_SCREEN,
            builder: (_, GoRouterState state) {
              String imageFilePath = state.extra as String;
              return AmptiveShowScheduledScreen(
                showType: ShowType.episode,
                imageFilePath: imageFilePath,
              );
            },
          ),
          GoRoute(
            name: ATRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN,
            path: ATRoutes.SUBSCRIBED_EVENTS_OR_SHOWS_SCREEN,
            builder: (_, __) => const AmptiveSubscribedEventOrShowViewWidget(),
          ),
          GoRoute(
            name: ATRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN,
            path: ATRoutes.FOLLOWING_EVENTS_OR_SHOWS_SCREEN,
            builder: (_, __) => const AmptiveFollowingEvenstOrShowsViewWidget(),
          ),
          GoRoute(
            name: ATRoutes.COMMUNITY_SCREEN,
            path: ATRoutes.COMMUNITY_SCREEN,
            builder: (_, __) => const AmptiveCommunityScreen(),
          ),
          GoRoute(
              name: ATRoutes.SOCIETY_SCREEN,
              path: ATRoutes.SOCIETY_SCREEN,
              builder: (_, __) => const AmptiveSocietyScreen(),
              routes: [
                GoRoute(
                  name: ATRoutes.TRENDING_SOCIETY_SCREEN,
                  path: ATRoutes.TRENDING_SOCIETY_SCREEN,
                  builder: (_, __) => const AmptiveTrendingSocietyScreen(),
                ),
                GoRoute(
                  name: ATRoutes.TRENDING_HASHTAGS_SCREEN,
                  path: ATRoutes.TRENDING_HASHTAGS_SCREEN,
                  builder: (_, __) => const AmptiveTrendingHashTagsScreen(),
                ),
                GoRoute(
                  name: ATRoutes.TRENDING_HASHTAG_FULL_SCREEN,
                  path: ATRoutes.TRENDING_HASHTAG_FULL_SCREEN,
                  builder: (_, __) => const AmptiveTrendingHashTagFullScreen(),
                ),
              ]),
        ]),
  ],
  // observers: [LoggingNavigatorObserver()],
);
