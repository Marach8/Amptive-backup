import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';

class WalletOnboardInfoWidget extends StatelessWidget {
  const WalletOnboardInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      radius: 14,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      width: ATHelperFuncs.getScreenWidth(context) * 0.92,
      color: ATColors.white.withValues(alpha: 0.05),
      child: Row(
        spacing: 10,
        children: <Widget>[
          const ATImgLoader(imgPath: ATImgStrings.WARNING_ICON),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.NO_WALLET_NO_EARNINGS,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: ATSizes.size15
                  ),
                ),
                Text(
                  ATStrings.SETUP_UR_WALLET, maxLines: 3,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATSizes.size13,
                    color: ATColors.hexC2C2C2
                  )
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}
