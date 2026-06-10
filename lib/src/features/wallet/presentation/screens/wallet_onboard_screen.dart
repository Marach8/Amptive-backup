import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:go_router/go_router.dart';
import '../../wallet_export.dart';

class ATWalletOnboardScreen extends StatefulWidget {
  const ATWalletOnboardScreen({super.key});

  @override
  State<ATWalletOnboardScreen> createState() => _ATWalletOnboardScreenState();
}

class _ATWalletOnboardScreenState extends State<ATWalletOnboardScreen> {
  bool _shouldShow = false;

  @override
  void initState() {
    super.initState();
    _checkWalletSetup();
  }

  Future<void> _checkWalletSetup() async {
    final storage = FlutterSecureStorageServiceImpl();
    final hasPin = await storage.get('has_set_wallet_pin');
    if (hasPin == 'true' && mounted) {
      context.goNamed(ATRoutes.walletScreen);
    }
  }

  @override
  Widget build(_) {
    return Builder(builder: (BuildContext context) {
      return ATAnnotatedRegion(
          child: Scaffold(
        appBar: const ATAppBar(
          leading: ATRoundedBackBtn(),
          leadingWidth: 30,
          padding: EdgeInsets.only(left: 5),
        ),
        body: AnimatedPadding(
          duration: const Duration(milliseconds: 100),
          padding: EdgeInsets.fromLTRB(
              20, context.screenHeight * (_shouldShow ? 0.18 : 0.3), 20, 0),
          child: ATFadingSwitcher(
            child: _shouldShow
                ? const _WalletIconColumn()
                : UrWalletUrWayWidget(
                    onDone: () => Future<void>.delayed(
                          const Duration(seconds: 1),
                          () => setState(() => _shouldShow = true),
                        )),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 50),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _shouldShow ? 1.0 : 0.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: <Widget>[
                const WalletOnboardInfoWidget(),
                ATPlainElevatedBtn(
                  onPressed: () {
                    context.pushReplacementNamed(ATRoutes.WALLET_PIN_SETUP);
                  },
                  btnTitle: ATStrings.beginSetup,
                ),
              ],
            ),
          ),
        ),
      ));
    });
  }
}

class _WalletIconColumn extends StatelessWidget {
  const _WalletIconColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ATImgLoader(imgPath: ATImgStrings.BIG_WALLET_ICON),
        Text(
          ATStrings.SETUP_WALLET,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Text('${ATStrings.UR_WALLET}, ${ATStrings.UR_WAY}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: ATColors.hexC2C2C2)),
      ],
    );
  }
}
