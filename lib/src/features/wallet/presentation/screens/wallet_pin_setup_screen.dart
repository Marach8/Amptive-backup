import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/otp_fields_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ATWalletPinSetupScreen extends StatelessWidget {
  const ATWalletPinSetupScreen({super.key});

  @override
  Widget build(_) {
    return ATAnnotatedRegion(
      child: BlocProvider<_WalletPinsBloc>(
        create: (_) => _WalletPinsBloc(),
        child: Builder(
          builder: (BuildContext context) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => context.read<_WalletPinsBloc>().reset()
            );

            return Scaffold(
              appBar: const ATAppBar(
                leading: ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: EdgeInsets.only(left: 7),
                titleText: ATStrings.WALLET_SETUP,
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BlocBuilder<_WalletPinsBloc, List<String?>>(
                      builder: (_, List<String?> state) {
                        return Text(
                          state.isEmpty ? ATStrings.ENTER_4_DIGIT_PIN :
                            ATStrings.RE_ENTER_PIN,
                          style: Theme.of(context).textTheme.bodyMedium
                        );
                      }
                    ),
                    const SizedBox(height: 10,),
            
                    BlocBuilder<_WalletPinsBloc, List<String?>>(
                      builder: (_, List<String?> state) {
                        //Enter pin
                        if(state.isEmpty){
                          return ATOTPFieldsWidget(
                            key: const Key('1'),
                            onPinComplete: (String pin)async{
                              context.read<_WalletPinsBloc>().grabPin(pin);
                              return true;
                            }
                          );
                        }
                        //Re-enter pin
                        return ATOTPFieldsWidget(
                          key: const Key('2'),
                          onPinComplete: (String pin)async{
                            if(pin == state.first){
                              context.read<_WalletPinsBloc>().grabPin(pin);
                              return true;
                            }
                            return false;
                          }
                        );
                      }
                    ),
            
                    const SizedBox(height: 10,),
                    Text(
                      ATStrings.PIN_NEEDED_4_TXNS,
                      style: Theme.of(context).textTheme.titleSmall
                    )
                  ],
                ),
              ),
            
              bottomSheet: Builder(
                builder: (BuildContext context) {
                  final double bottom = MediaQuery.viewInsetsOf(context).bottom;
                  final double bottomPadd = bottom == 0 ? 50 : 15;
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, bottomPadd),
                    child: BlocBuilder<_WalletPinsBloc, List<String?>>(
                      builder: (_, List<String?> state) {
                        return Column(
                          spacing:10,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ATContainer(
                              radius: 14,
                              onTap: ()async{
                                final bool? result = await showConfirmationDialog(
                                  context: context,
                                  title: ATStrings.ALLOW_FACE_ID,
                                  content: ATStrings.ALLOW_FACE_ID_DESC,
                                  yesString: ATStrings.PROCEED,
                                  noString: ATStrings.cancel
                                );
                              },
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              color: ATColors.white.withValues(alpha: 0.05),
                              child: Row(
                                spacing: 10,
                                children: <Widget>[
                                  const Icon(Iconsax.scan_barcode),
                                  Expanded(
                                    child: Text(
                                      ATStrings.ENABLE_BIOMETRICS,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontSize: ATSizes.size15
                                      )
                                    )
                                  )
                                ],
                              )
                            ),
                            ATPlainElevatedBtn(
                              onPressed: state.length == 2 ? ()
                              => context.pushReplacementNamed(ATRoutes.securityQuestionScreen) : null,
                              btnTitle: ATStrings.ADD_SECURITY_QUESTION
                            )
                          ],
                        );
                      }
                    ),
                  );
                }
              ),
            );
          }
        ),
      ),
    );
  }
}



class _WalletPinsBloc extends Cubit<List<String?>>{
  _WalletPinsBloc() : super(<String?>[]);

  void grabPin(String pin) => emit(<String?>[...state, pin]);

  void reset() => emit(<String?>[]);
}