import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../../../shared/annotated_region__widget.dart';

class ATWalletTxnsHistoryScreen extends StatelessWidget {
  const ATWalletTxnsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
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
        body: ListView.builder(
          itemCount: 20,
          padding: EdgeInsets.zero,
          itemBuilder: (_, int index) {
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
                        time: 'Today, 5:50 PM',
                        txnType: ATStrings.SUB_RECEIVED,
                        amount: '+${ATStrings.nairaText}5,000.00',
                        color: ATColors.yellowColor,
                        icon: Icons.favorite,
                        imgPath: ATImgStrings.jpeg1,
                      ),
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
