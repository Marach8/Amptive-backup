import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/wallet/cubits/transaction_history_cubit.dart';
import 'package:amptive/src/features/wallet/data/models/models_export.dart';
import 'package:amptive/src/features/wallet/data/models/response/transaction_history_response_model.dart';
import 'package:amptive/src/features/wallet/presentation/screens/wallet_transactions_history_screen.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/wallet/cubits/wallet_balance_cubit.dart';
import 'package:amptive/src/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../../../shared/annotated_region__widget.dart';


class WalletLandingScreen extends StatelessWidget {
  const WalletLandingScreen({super.key, this.userData});

  final CachedUserData? userData;

  @override
  Widget build(BuildContext context) {
    bool shouldShowCommingSoon = false;
    return MultiBlocProvider(providers: <SingleChildWidget>[
      BlocProvider<WalletBalanceCubit>(
        create: (_) => WalletBalanceCubit()..fetchWalletBalance(),
      ),  
      BlocProvider<TransactionHistoryCubit>(
        create: (_) => TransactionHistoryCubit()..fetchTransactionHistory(),
      ),
      ],
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: const ATAppBar(
            titleText: "Emmanuel's Account",
            leading: ATRoundedBackBtn(),
            padding: EdgeInsets.only(left: 7),
   
            leadingWidth: 30,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const AvailableBalanceWidget(),
                const SizedBox(height: 20),
                
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
                const SizedBox(height: 10),
                
                BlocBuilder<TransactionHistoryCubit, ATAppState<TransactionHistoryResponseModel>>(
                  builder: (BuildContext context, ATAppState<TransactionHistoryResponseModel> state) {
                    return switch (state) {
                      InitialState<TransactionHistoryResponseModel>() ||
                      LoadingState<TransactionHistoryResponseModel>() || 
                      FailureState<TransactionHistoryResponseModel>() ||
                       SuccessState<TransactionHistoryResponseModel>() => 
                        Builder(builder: (BuildContext context) {
                          final TransactionHistoryCubit cubit = context.read<TransactionHistoryCubit>();
                          final List<TransactionModel> transactions = cubit.currentTransactionHistoryData?.transactions ?? <TransactionModel>[];

                          if (transactions.isEmpty) {
                            if (state is InitialState<TransactionHistoryResponseModel> || state is LoadingState<TransactionHistoryResponseModel>) {
                              return const TransactionHistoryShimmer();
                            }
                            if (state is FailureState<TransactionHistoryResponseModel>) {
                              return Center(
                                child: IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () => cubit.fetchTransactionHistory(),
                                ),
                              );
                            }
                            return const Center(child: Text('No transactions found.'));
                          }

                          final List<TransactionModel> latestTwo = transactions.take(2).toList();

                          return Column(
                            children: latestTwo.map((TransactionModel txn) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: RenderATransaction(
                                  // Map dynamic data from txn model
                                  time: txn.createdAt?.toLocalTime ?? 'N/A',
                                  txnType: txn.transactionType ?? ATStrings.SUB_RECEIVED,
                                  amount: '${ATStrings.nairaText}${txn.amount ?? "0.00"}',
                                  color: ATColors.yellowColor,
                                  icon: Icons.favorite,
                                  imgPath: ATImgStrings.jpeg1,
                                ),
                              );
                            }).toList(),
                          );
                        }),
                    };
                  },
                ),

                const SizedBox(height: 20),
                Text(ATStrings.EVENT_ND_SHOW_VEST, style: context.textTheme.bodyLarge),
                const SizedBox(height: 20),
                StatefulBuilder(builder: (_, StateSetter setter) {
                  return InkWell(
                    onTap: () => setter(() => shouldShowCommingSoon = true),
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
