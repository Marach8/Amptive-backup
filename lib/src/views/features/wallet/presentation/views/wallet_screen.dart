import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/common_widgets/annotated_region__widget.dart';

class ATWalletScreen extends StatelessWidget {
  const ATWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          titleText: "Emmanuel's Account",
          leading: ATRoundedBackBtn(),
          padding: EdgeInsets.only(left: 7),
          leadingWidth: 30,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AvailableBalanceWidget(),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Text(
                    ATStrings.TXN_HISTORY,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ATColors.hexC2C2C2
                    )
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: (){
                      context.pushNamed(ATRoutes.WALLET_TXNS);
                    },
                    splashColor: ATColors.white,
                    borderRadius: BorderRadius.circular(5),
                    child: Row(
                      children: [
                        Text(
                          ATStrings.VIEW_ALL,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ATColors.hexC2C2C2
                          )
                        ),
                        Icon(Icons.keyboard_arrow_right_outlined, color: ATColors.hexC2C2C2)
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              
              RenderTxnWidget(
                time: 'Today, 5:50 PM',
                txnType: ATStrings.SUB_RECEIVED,
                amount: '+N5,000.00',
                color: ATColors.yellowColor,
                icon: Icons.favorite,
                imgPath: ATImgStrings.jpeg1,
              ),
              const SizedBox(height: 10,),
              RenderTxnWidget(
                time: 'Today, 7:00 PM',
                txnType: ATStrings.SUB_RECEIVED,
                amount: '+N1,000,000.00',
                color: ATColors.hex307FE2,
                icon: Icons.sync,
                imgPath: ATImgStrings.jpeg3,
              ),

              const SizedBox(height: 20,),
              Text(
                ATStrings.EVENT_ND_SHOW_VEST,
                style: Theme.of(context).textTheme.bodyLarge
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (_, kst){
                    return Row(
                      spacing: 10,
                      children: List.filled(
                        2,
                        Expanded(
                          child: ATContainer(
                            clipBehavior: Clip.hardEdge,
                            radius: 15,
                            height: kst.maxHeight,
                            child: const ATImgLoader(
                              boxFit: BoxFit.cover,
                              imgPath: ATImgStrings.jpeg1,
                            ),
                          ),
                        )
                      ).toList()
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

