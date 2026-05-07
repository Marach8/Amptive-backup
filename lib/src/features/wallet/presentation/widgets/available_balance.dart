import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/wallet/presentation/screens/transaction_amount_screen.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer';

class AvailableBalanceWidget extends StatelessWidget {
  const AvailableBalanceWidget({super.key, this.balance});

  final WalletBalance? balance;

  static const List<String> list = <String>[
    ATStrings.fundWallet,
    ATStrings.transfer,
    ATStrings.withdraw
  ];

  @override
  Widget build(BuildContext context) {
    return ATContainer(
        color: ATColors.white.withValues(alpha: 0.05),
        padding: const EdgeInsets.all(15),
        radius: 15,
        child: BlocProvider<_VisibilityBloc>(
          create: (_) => _VisibilityBloc(),
          child: Builder(builder: (BuildContext context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () => context
                          .read<_VisibilityBloc>()
                          .toggleBalanceVisibility(),
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: <Widget>[
                          Text(ATStrings.AVAILABLE_BAL,
                              style: context.textTheme.bodySmall
                                  ?.copyWith(color: ATColors.hexC2C2C2)),
                          const SizedBox(
                            width: 5,
                          ),
                          BlocBuilder<_VisibilityBloc, bool>(
                              builder: (_, bool state) {
                            return Icon(
                                state
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: ATColors.hexC2C2C2);
                          })
                        ],
                      ),
                    ),
                    const Spacer(),
                     const ATCircularImage(
                      imagePath: ATImgStrings.jpeg2, 
                    )
                  ],
                ),
                BlocBuilder<_VisibilityBloc, bool>(
                    builder: (_, bool shouldShow) {
                      final String balanceText = balance?.availableBalance != null 
      ? '${ATStrings.nairaText}${balance!.availableBalance!.toStringAsFixed(2)}' 
      : '${ATStrings.nairaText}0.00';
                  return Text(
                      shouldShow? 
                           balanceText
                          : '******',
                      style: context.textTheme.displaySmall
                          ?.copyWith(fontSize: ATSizes.size30));
                }),
                const SizedBox(height: 5),
                BlocBuilder<_VisibilityBloc, bool>(builder: (_, bool state) {
                  final String pendingText = balance?.pendingBalance != null 
      ? '${ATStrings.nairaText}${balance!.pendingBalance!.toStringAsFixed(2)}' 
      : '${ATStrings.nairaText}0.00';
                  return Text(
                      'Pending balance: ${state ? pendingText : '******'}',
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: ATColors.hexC2C2C2));
                }),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: list.map((String item) {
                      IconData icon;
                      switch (item) {
                        case ATStrings.fundWallet:
                          icon = Icons.add;
                          break;
                        case ATStrings.transfer:
                          icon = Icons.sync;
                          break;
                        case ATStrings.withdraw:
                          icon = Icons.arrow_upward;
                          break;
                        default:
                          icon = Icons.add;
                      }
                      return ATContainer(
                        onTap: () async {
                          if (item == ATStrings.fundWallet) {
                            context.pushNamed(ATRoutes.transactionAmountScreen,
                                extra: TransactionAmountScreenParams(
                                    transactionType: TransactionType.fundWallet,
                                    title: ATStrings.fundWallet,
                                    slidingNotif:
                                        ATStrings.AMPTIVE_FUNDING_CHARGES,
                                    btnTitle: ATStrings.SELECT_PAYMENT_METHOD));
                          } else if (item == ATStrings.transfer) {
                            final String? recipientName = await context
                                    .pushNamed(ATRoutes.SELECT_RECIPIENT)
                                as String?;
                            if (recipientName != null && context.mounted) {
                              context.pushNamed(
                                  ATRoutes.paperPlaneSuccessScreen,
                                  extra: <String>[
                                    ATStrings.TRSF_SUCCESS,
                                    '${ATStrings.TRSF_SUCCESS_DESC}$recipientName'
                                  ]);
                            }
                          } else if (item == ATStrings.withdraw) {
                            final bool? result = await context.pushNamed(
                                ATRoutes.WITHDRAWAL_LANDING) as bool?;
                            log(result.toString());
                          }
                        },
                        color: ATColors.white.withValues(alpha: 0.1),
                        radius: 20,
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              icon,
                              size: 15,
                            ),
                            Text(
                              item,
                              style: context.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      );
                    }).toList())
              ],
            );
          }),
        ));
  }
}

class _VisibilityBloc extends Cubit<bool> {
  _VisibilityBloc() : super(false);

  void toggleBalanceVisibility() => emit(!state);
}
