import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/wallet/cubits/transaction_history_cubit.dart';
import 'package:amptive/src/features/wallet/data/models/models_export.dart';
import 'package:amptive/src/features/wallet/data/models/response/transaction_history_response_model.dart';
import 'package:amptive/src/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../../../shared/annotated_region__widget.dart';

class ATWalletTxnsHistoryScreen extends StatelessWidget {
  const ATWalletTxnsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionHistoryCubit>(
        create: (_) => TransactionHistoryCubit()..fetchTransactionHistory(),
        child: ATAnnotatedRegion(
            child: Scaffold(
          appBar: ATAppBar(
            titleText: ATStrings.transactionHistory,
            leading: const ATRoundedBackBtn(),
            padding: const EdgeInsets.only(left: 8),
            leadingWidth: 30,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
                child: ATTextFormField(
                  fillColor: ATColors.white.withValues(alpha: 0.1),
                  hintText: 'Search for Transactions',
                  maxLines: 1,
                  disableBlueBorder: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ATImgLoader(
                      imgPath: ATImgStrings.outlinedSearch,
                    ),
                  ),
                  onChanged: (String text) {},
                ),
              ),
            ),
          ),
          body: BlocBuilder<TransactionHistoryCubit,
                  ATAppState<TransactionHistoryResponseModel>>(
              builder: (BuildContext context,
                  ATAppState<TransactionHistoryResponseModel> state) {
            return switch (state) {
              InitialState<TransactionHistoryResponseModel>() =>
                const SizedBox.shrink(),
              LoadingState<TransactionHistoryResponseModel>() ||
              FailureState<TransactionHistoryResponseModel>() ||
              SuccessState<TransactionHistoryResponseModel>() =>
                Builder(builder: (_) {
                  final TransactionHistoryResponseModel? transactionHistory =
                      context
                          .read<TransactionHistoryCubit>()
                          .currentTransactionHistoryData;
                  final List<TransactionModel> transactions =
                      transactionHistory?.transactions ?? <TransactionModel>[];

                  if (transactions.isEmpty) {
                    if (state
                        is LoadingState<TransactionHistoryResponseModel>) {
                      return const TransactionHistoryShimmer();
                    }
                    if (state
                        is FailureState<TransactionHistoryResponseModel>) {
                      return const Center(
                        child: Text(
                            'Failed to load transactions. Please try again.'),
                      );
                    }
                    return const Center(
                      child: Text('No transactions found.'),
                    );
                  }
                  final bool hasMore = transactionHistory?.hasMore ?? false;
                  final int count = transactions.length;

                  return ListView.builder(
                    itemCount: hasMore ? count + 1 : count,
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, int index) {
                      if (index < count) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final TransactionModel transaction = transactions[index];
                      return StickyHeaderBuilder(
                        builder: (_, __) {
                          return Container(
                            width: context.screenWidth,
                            color: ATColors.black,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: Text(
                                '${index + 1} April 2025',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: ATColors.hexC2C2C2),
                              ),
                            ),
                          );
                        },
                        content: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 30),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 15,
                              children: List<Widget>.filled(
                                5,
                                RenderATransaction(
                                  tileColor: ATColors.transparent,
                                  time: transaction.createdAt?.toLocalTime ?? '',
                                  txnType: transaction.category ??
                                      ATStrings.SUB_RECEIVED,
                                  amount:
                                      '+${ATStrings.nairaText}${transaction.amount}' ??
                                          '',
                                  color: ATColors.yellowColor,
                                  icon: Icons.favorite,
                                  imgPath: ATImgStrings.jpeg1,
                                ),
                              )),
                        ),
                      );
                    },
                  );
                }),
            };
          }),
        )));
  }
}


class TransactionHistoryShimmer extends StatelessWidget{
  const TransactionHistoryShimmer({super.key});

 @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, int index) =>
      const TransactionHistoryItem(),
    );
}
}

class TransactionHistoryItem extends StatelessWidget {
  const TransactionHistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      color: ATColors.white.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(15), 
      radius: 15,                        
      margin: const EdgeInsets.only(bottom: 10),
      child: const Row(
        children: <Widget>[
          ATShimmer(
            height: 35,
            width: 35,
            radius: 17.5, // Perfect circle to match ATCircularImage
          ),
          SizedBox(width: 10),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ATShimmer(
                  width: 150, 
                  height: 12,
                ),
                SizedBox(height: 6),
                ATShimmer(
                  width: 70, 
                  height: 10,
                ),
              ],
            ),
          ),
          
          SizedBox(width: 20),
          
          ATShimmer(
            width: 100,
            height: 16,
          ),
        ],
      ),
    );
  }
}
