import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';

class AvailableBalanceWidget extends StatelessWidget {
  const AvailableBalanceWidget({super.key});

  static const list = [ATStrings.FUND_WALLET, ATStrings.TRSF, ATStrings.WITHDRAW];

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      color: ATColors.white.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(15),
      radius: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    Text(
                      ATStrings.AVAILABLE_BAL,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      )
                    ),
                    const SizedBox(width: 5,),
                    Icon(Icons.visibility_outlined, color: ATColors.hexC2C2C2)
                  ],
                ),
              ),
              const Spacer(),
              const ATCircularImage(
                imagePath: ATImgStrings.jpeg2,
              )
            ],
          ),
          
          Text(
            'N 2,345,737.18',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: ATFontSizes.size30
            )
          ),
          const SizedBox(height: 5),
          Text(
            'Pending balance: N13,438.00',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ATColors.hexC2C2C2
            )
          ),
          const SizedBox(height: 10,),
    
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: list.map(
              (item){
                IconData icon;
                switch(item){
                  case ATStrings.FUND_WALLET:
                    icon = Icons.add;
                    break;
                  case ATStrings.TRSF:
                    icon = Icons.sync;
                    break;
                  case ATStrings.WITHDRAW:
                    icon = Icons.arrow_upward;
                    break;
                  default:
                    icon = Icons.add;
                }
                return ATContainer(
                  color: ATColors.white.withValues(alpha: 0.1),
                  radius: 20,
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Row(
                    children: [
                      Icon(icon, size: 15,),
                      Text(
                        item,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                );
              }
            ).toList()
          )
        ],
      )
    );
  }
}