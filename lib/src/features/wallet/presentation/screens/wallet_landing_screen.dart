import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/wallet/cubits/wallet_balance_cubit.dart';
import 'package:amptive/src/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/annotated_region__widget.dart';

class WalletLandingScreen extends StatelessWidget {
  const WalletLandingScreen({super.key, this.userData});

  final CachedUserData? userData;

  @override
  Widget build(BuildContext context) {
    bool shouldShowCommingSoon = false;
    return BlocProvider<WalletBalanceCubit>(create: (_) => WalletBalanceCubit()..fetchWalletBalance(),
    lazy: false,
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar:  ATAppBar(
            titleText: '${userData?.name}\'s Account' ?? "Emmanuel's Account",
            leading: const ATRoundedBackBtn(),
            padding: const EdgeInsets.only(left: 7),
            leadingWidth: 30,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 const AvailableBalanceWidget(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Text(ATStrings.transactionHistory,
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: ATColors.hexC2C2C2)),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        context
                            .pushNamed(ATRoutes.walletTransactionsHistoryScreen);
                      },
                      splashColor: ATColors.white,
                      borderRadius: BorderRadius.circular(5),
                      child: Row(
                        children: <Widget>[
                          Text(ATStrings.VIEW_ALL,
                              style: context.textTheme.bodySmall
                                  ?.copyWith(color: ATColors.hexC2C2C2)),
                          Icon(Icons.keyboard_arrow_right_outlined,
                              color: ATColors.hexC2C2C2)
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                RenderATransaction(
                  time: 'Today, 5:50 PM',
                  txnType: ATStrings.SUB_RECEIVED,
                  amount: '+${ATStrings.nairaText}5,000.00',
                  color: ATColors.yellowColor,
                  icon: Icons.favorite,
                  imgPath: ATImgStrings.jpeg1,
                ),
                const SizedBox(
                  height: 10,
                ),
                RenderATransaction(
                  time: 'Today, 7:00 PM',
                  txnType: ATStrings.SUB_RECEIVED,
                  amount: '+${ATStrings.nairaText}1,000,000.00',
                  color: ATColors.hex307FE2,
                  icon: Icons.sync,
                  descriptionIconColor: ATColors.white,
                  imgPath: ATImgStrings.jpeg3,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(ATStrings.EVENT_ND_SHOW_VEST,
                    style: context.textTheme.bodyLarge),
                const SizedBox(height: 20),
                StatefulBuilder(builder: (_, StateSetter setter) {
                  return InkWell(
                    onTap: () {
                      setter(() => shouldShowCommingSoon = true);
                    },
                    child: Row(children: <Widget>[
                      Expanded(
                        child: ATImgLoader(
                          imgPath: shouldShowCommingSoon
                              ? ATImgStrings.comingSoonImage2
                              : ATImgStrings.vestingOverviewImage,
                          height: 240,
                        ),
                      ),
                      Expanded(
                        child: ATImgLoader(
                          imgPath: shouldShowCommingSoon
                              ? ATImgStrings.comingSoonImage1
                              : ATImgStrings.exploreListingsImage,
                          height: 240,
                        ),
                      ),
                    ]),
                  );
                }),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
