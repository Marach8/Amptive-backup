import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../views/widgets/common_widgets/annotated_region__widget.dart';

class WalletLandingScreen extends StatelessWidget {
  const WalletLandingScreen({super.key});

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
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const AvailableBalanceWidget(),
              const SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Text(
                    ATStrings.TXN_HISTORY,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: ATColors.hexC2C2C2
                    )
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: (){
                      context.pushNamed(ATRoutes.WALLET_TXNS_HISTORY_SCREEN);
                    },
                    splashColor: ATColors.white,
                    borderRadius: BorderRadius.circular(5),
                    child: Row(
                      children: <Widget>[
                        Text(
                          ATStrings.VIEW_ALL,
                          style: context.textTheme.bodySmall?.copyWith(
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
                amount: '+${ATStrings.nairaText}5,000.00',
                color: ATColors.yellowColor,
                icon: Icons.favorite,
                imgPath: ATImgStrings.jpeg1,
              ),
              const SizedBox(height: 10,),
              RenderTxnWidget(
                time: 'Today, 7:00 PM',
                txnType: ATStrings.SUB_RECEIVED,
                amount: '+${ATStrings.nairaText}1,000,000.00',
                color: ATColors.hex307FE2,
                icon: Icons.sync,
                descriptionIconColor: ATColors.white,
                imgPath: ATImgStrings.jpeg3,
              ),

              const SizedBox(height: 20,),
              Text(
                ATStrings.EVENT_ND_SHOW_VEST,
                style: context.textTheme.bodyLarge
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  ATImgLoader(
                    imgPath: ,
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}

