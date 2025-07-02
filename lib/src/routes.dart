import 'dart:io';
import 'package:amptive/src/setup.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/features/auth/add_phone.dart';
import 'package:amptive/src/features/auth/dob_screen.dart';
import 'package:amptive/src/features/auth/email_auth_screen.dart';
import 'package:amptive/src/features/auth/name_auth_screen.dart';
import 'package:amptive/src/features/auth/otp_screen.dart';
import 'package:amptive/src/features/auth/password_auth_screen.dart';
import 'package:amptive/src/features/auth/post_registration.dart';
import 'package:amptive/src/features/auth/sign_in_or_sign_up_screen.dart';
import 'package:amptive/src/features/auth/username_auth_screen.dart';
import 'package:amptive/src/features/discover/presentation/views/society_screen.dart';
import 'package:amptive/src/features/discover/presentation/views/trending_hashtags_screen.dart';
import 'package:amptive/src/features/go_live/event/even_scheduled_screen.dart';
import 'package:amptive/src/features/go_live/show/create_show_form_screen.dart';
import 'package:amptive/src/features/home/home_export.dart';
import 'package:amptive/src/features/main_app_shell.dart';
import 'package:amptive/src/features/go_live/main_go_live_screen.dart';
import 'package:amptive/src/features/profile/presentation/views/profile_views_export.dart';
import 'package:amptive/src/features/home/presentation/views/scheduled_screen.dart';
import 'package:amptive/src/features/wallet/presentation/views/wallet_txns_screen.dart';
import 'package:amptive/src/features/post_auth/crop_image_screen.dart';
import 'package:amptive/src/features/post_auth/pre_homepage.dart';
import 'package:amptive/src/features/post_auth/preference_screen.dart';
import 'package:amptive/src/features/onboarding/onboarding_page_view_screen.dart';
import 'package:amptive/src/features/onboarding/welcome_screen.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/widgets_in_go_live/shows/show_type_visibility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/discover/presentation/views/community_home_screen.dart';
import 'features/discover/presentation/views/society_hashtag_screen.dart';
import 'features/discover/presentation/views/trending_society_screen.dart';
import 'features/go_live/event/choose_event_screen.dart';
import 'features/go_live/show/choose_or_create_show_screen.dart';
import 'features/go_live/show/create_show_success_screen.dart';
import 'features/wallet/wallet_export.dart';

// The route configuration.
final GoRouter amptiveAppRouter = GoRouter(
  initialLocation: ATRoutes.index,
  //initialLocation: "/add-profile-pic",
  routes: <RouteBase>[
    GoRoute(
        path: ATRoutes.index,
        builder: (_, __) => const ATMainAppShell()),
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
      builder: (_, GoRouterState state) => ATEmailAuthScreen(title: state.extra as String?)
    ),
    GoRoute(
      name: ATRoutes.OTP_SCREEN,
      path: ATRoutes.OTP_SCREEN.addSlash,
      builder: (_, GoRouterState state) {
        final List<String?>? params = state.extra as List<String?>?;
        final String? emailOrPhone = params?.first;
        final String? title = params?.last;
        return ATOTPScreen(emailOrPhone: emailOrPhone ?? '', title: title ?? '');
      }
    ),
    GoRoute(
      name: ATRoutes.ADD_FONE_NO_SCREEN,
      path: ATRoutes.ADD_FONE_NO_SCREEN.addSlash,
      builder: (_, GoRouterState state) => AddPhoneScreen(title: state.extra as String?),
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
              }
            ),
        ]
      ),
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
        builder: (_, __) => const ATMainAppShell(),
        routes: <RouteBase>[
          GoRoute(
            name: ATRoutes.SCHEDULE_DETAILED,
            path: ATRoutes.SCHEDULE_DETAILED.addSlash,
            pageBuilder: (_, __) => ATRouteTransition(
              child: const ATScheduleDetailedScreen()
            ),
          ),
          
          GoRoute(
            name: ATRoutes.WALLET_LANDING,
            path: ATRoutes.WALLET_LANDING.addSlash,
            pageBuilder: (_, __) => ATRouteTransition(
              child: const ATWalletOnboardScreen()
            ),
            routes: <RouteBase>[
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
                routes: <RouteBase>[
                  GoRoute(
                    name: ATRoutes.WALLET_TXNS,
                    path: ATRoutes.WALLET_TXNS.addSlash,
                    pageBuilder: (_, __) => ATRouteTransition(
                      child: const ATWalletTxnsScreen()
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.SELECT_RECIPIENT,
                    path: ATRoutes.SELECT_RECIPIENT.addSlash,
                    pageBuilder: (_, __) => ATRouteTransition(
                      child: const ATSelectRecipientScreen()
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.ENTER_AMOUNT_2_TRSF,
                    path: ATRoutes.ENTER_AMOUNT_2_TRSF.addSlash,
                    pageBuilder: (_, GoRouterState state) => ATRouteTransition(
                      child: ATEnterAmountScreen(
                        params: state.extra as EnterAmountScreenParams
                      )
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.WITHDRAWAL_LANDING,
                    path: ATRoutes.WITHDRAWAL_LANDING.addSlash,
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
                  GoRoute(
                    name: ATRoutes.ENTER_ACCT_NO,
                    path: ATRoutes.ENTER_ACCT_NO.addSlash,
                    pageBuilder: (_, GoRouterState state) => ATRouteTransition(
                      child: ATEnterAccountNoScreen(bankName: state.extra as String,)
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.PASS_SECURITY_QUEST,
                    path: ATRoutes.PASS_SECURITY_QUEST.addSlash,
                    pageBuilder: (_, GoRouterState state) => ATRouteTransition(
                      child: const ATPassSecurityQuestionScreen()
                    ),
                  ),
                  GoRoute(
                    name: ATRoutes.PAPER_PLANE_SUCCESS,
                    path: ATRoutes.PAPER_PLANE_SUCCESS.addSlash,
                    pageBuilder: (_, GoRouterState state){
                      final List<String> params = state.extra as List<String>;
                      return ATRouteTransition(
                        child: ATPaperPlaneSuccessScreen(
                          title: params.first,
                          subtitle: params.last,
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
            pageBuilder: (_, __) => ATRouteTransition(
              beginOffset: const Offset(0.0, 1.0),
              child: const ATLiveShowDetailedScreen()
            )
          ),
          GoRoute(
              name: ATRoutes.LIVE_EVENT_DETAILED,
              path: ATRoutes.LIVE_EVENT_DETAILED,
              pageBuilder: (BuildContext context, GoRouterState state) => CustomTransitionPage(
                    child: const ATLiveEventDetailedScreen(),
                    transitionsBuilder:
                        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                      Animation<Offset> tween =
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
            routes: <RouteBase>[
              GoRoute(
                name: ATRoutes.PROFILE_BG_CROP,
                path: ATRoutes.PROFILE_BG_CROP,
                builder: (_, GoRouterState state) => CropProfileBgImageScreen(file: state.extra as File)
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
                builder: (_, __) => const CreatorSubPlanScreen()
              ),
              GoRoute(
                name: ATRoutes.CO_HOST_FEE_SETUP,
                path: ATRoutes.CO_HOST_FEE_SETUP,
                builder: (_, GoRouterState state) => const CoHostFeeSetupScreen()
              ),
              GoRoute(
                name: ATRoutes.CREATOR_SUCCESS,
                path: ATRoutes.CREATOR_SUCCESS,
                builder: (_, GoRouterState state) => const CreatorSuccessScreen()
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
                routes: <RouteBase>[
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
            routes: <RouteBase>[
              GoRoute(
                name: ATRoutes.ACCT_INFO_SCREEN,
                path: ATRoutes.ACCT_INFO_SCREEN,
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
            builder: (_, __) => const ATScheduledPrograms(),
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
                  builder: (_, __) => const AmptiveTrendingSocietyScreen(),
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
