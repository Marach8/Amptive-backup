import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/features/wallet/presentation/widgets/wallets_widget_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/search_filter_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/common_widgets/annotated_region__widget.dart';

class ATWalletTxnsScreen extends StatelessWidget {
  const ATWalletTxnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (_, __) => [
              const ATSliverAppBar(titleText: ATStrings.TXN_HISTORY,),
              SliverPersistentHeader(
                pinned: true,
                delegate: ATSliverHDelegate(
                  maxExt: 70, minExt: 70, 
                  child: Container(
                    height: 70,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                    child: ATTextFormField(
                      fillColor: ATColors.white.withValues(alpha: 0.1),
                      onChanged: (text){},
                    ),
                  )
                ),
              )
            ],
          
            body: ListView.builder(
              itemCount: 20,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 40),
              itemBuilder: (_, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1} April 2025',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ATColors.hexC2C2C2
                        ),
                      ),
                      ...List.filled(
                        5,
                        RenderTxnWidget(
                          time: 'Today, 5:50 PM',
                          txnType: ATStrings.SUB_RECEIVED,
                          amount: '+N5,000.00',
                          color: ATColors.yellowColor,
                          icon: Icons.favorite,
                          imgPath: ATImgStrings.jpeg1,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}