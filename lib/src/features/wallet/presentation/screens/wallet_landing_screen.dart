import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/features/wallet/cubits/transaction_history_cubit.dart';
import 'package:amptive/src/features/wallet/cubits/wallet_balance_cubit.dart';
import 'package:amptive/src/features/wallet/data/models/models_export.dart';
import 'package:amptive/src/features/wallet/data/models/response/transaction_history_response_model.dart';
import 'package:amptive/src/features/wallet/presentation/screens/wallet_transactions_history_screen.dart';
import 'package:amptive/src/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

import '../../../../shared/annotated_region_widget.dart';

class ATWalletLandingScreenWrapper extends StatelessWidget {
  const ATWalletLandingScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<WalletBalanceCubit>(
          create: (_) => WalletBalanceCubit(),
        ),
        BlocProvider<TransactionHistoryCubit>(
          create: (_) => TransactionHistoryCubit(),
        ),
      ],
      child:  const _WalletLandingScreen()
      );
    

  }
}
class _WalletLandingScreen extends StatefulWidget {
  const _WalletLandingScreen();


  @override
  State<_WalletLandingScreen> createState() => _WalletLandingScreenState();
}

class _WalletLandingScreenState extends State<_WalletLandingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletBalanceCubit>().fetchWalletBalance();
      context.read<TransactionHistoryCubit>().fetchTransactionHistory();
    });
  }


  
    
  @override
  Widget build(BuildContext context) {
    bool shouldShowCommingSoon = false;
     final ProfileData? userData =
        context.read<LocalUserDataCubit>().currentUserData;

     return ATAnnotatedRegion(
        child: Scaffold(
          appBar: ATAppBar(
            titleText:
                 "${userData?.name}'s Account",
                
            leading: const ATRoundedBackBtn(),
            padding: const EdgeInsets.only(left: 7),
            leadingWidth: 30,
          ),
          body: RefreshIndicator(
            onRefresh: () {
              context.read<WalletBalanceCubit>().fetchWalletBalance();
              return context.read<TransactionHistoryCubit>().refreshTransactionHistory();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const AvailableBalanceWidget(),
                  const SizedBox(height: 20),
            
                  // Transaction header
                  Row(
                    children: <Widget>[
                      Text(
                        ATStrings.transactionHistory,
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: ATColors.hexC2C2C2),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => context
                            .pushNamed(ATRoutes.walletTransactionsHistoryScreen),
                        splashColor: ATColors.white,
                        borderRadius: BorderRadius.circular(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              ATStrings.VIEW_ALL,
                              style: context.textTheme.bodySmall
                                  ?.copyWith(color: ATColors.hexC2C2C2),
                            ),
                            Icon(Icons.keyboard_arrow_right_outlined,
                                color: ATColors.hexC2C2C2),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
            
                  
             BlocBuilder<TransactionHistoryCubit,
                ATAppState<TransactionHistoryResponseModel>>(
              builder: (_, ATAppState<TransactionHistoryResponseModel> state) {
                return switch (state) {
                  InitialState<TransactionHistoryResponseModel>() =>
                    const SizedBox.shrink(),
            
                  LoadingState<TransactionHistoryResponseModel>() ||
                  FailureState<TransactionHistoryResponseModel>() ||
                  SuccessState<TransactionHistoryResponseModel>() =>
                    Builder(builder: (_) {
            final TransactionHistoryCubit cubit =
                context.read<TransactionHistoryCubit>();
            
            final List<TransactionModel> latest = cubit
                .groupedTransactions.values
                .expand((List<TransactionModel> txns) => txns)
                .take(2)
                .toList();
            
            if (latest.isEmpty) {
              if (state is LoadingState<TransactionHistoryResponseModel>) {
               return Column(
                  children: List.generate(2, (_) => const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TransactionHistoryItem(), // â† the single tile shimmer, not the full ListView
                  )),
                );
              }
              if (state is FailureState<TransactionHistoryResponseModel>) {
                return   Text(
                              'Please check your connection or try again',
                              style: 
                              Theme.of(context).textTheme.bodySmall?.copyWith(color: ATColors.hexC2C2C2) 
                            );
              }
              return const Center(child: Text('No transactions yet.'));
            }
            
            return Column(
              children: latest.map((TransactionModel txn) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: RenderATransaction(
                    time: txn.createdAt?.toLocalTime ?? 'N/A',
                    txnType: txn.transactionType ?? ATStrings.SUB_RECEIVED,
                    amount: '+${ATStrings.nairaText}${txn.amount ?? '0.00'}',
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
                  Text(ATStrings.EVENT_ND_SHOW_VEST,
                      style: context.textTheme.bodyLarge),
                  const SizedBox(height: 20),
            
                  StatefulBuilder(builder: (_, StateSetter setter) {
                    return InkWell(
                      onTap: () => setter(() => shouldShowCommingSoon = true),
                      child: Row(
                        children: <Widget>[
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
                        ],
                      ),
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

