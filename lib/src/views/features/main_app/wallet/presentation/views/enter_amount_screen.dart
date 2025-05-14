import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/dialogs/dialog_export.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/features/main_app/wallet/bloc/wallet_bloc_export.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_align_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../../widgets/common_widgets/app_bar_widget.dart';
import '../../../../../widgets/common_widgets/back_button.dart';
import '../../../../../widgets/common_widgets/custom_container_widget.dart';

class ATEnterAmountScreen extends StatelessWidget {
  const ATEnterAmountScreen({super.key, required this.receipient});
  final ObjectWithNotifier<Host>? receipient;

  static String digits = '123456789.0<';

  @override
  Widget build(BuildContext _) {
    return ATAnnotatedRegion(
      child: BlocProvider(
        create: (_) => EnterAmountBloc(),
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: ATAppBar(
                leading: const ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: const EdgeInsets.only(left: 7),
                titleText: receipient == null ? ATStrings.FUND_WALLET
                : '${ATStrings.TRANSFER_FUNDS} to ${receipient?.obj.name}',
              ),
              body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if(receipient != null)Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ATCircularImage(
                          imagePath: receipient?.obj.profilePicture ?? '',
                          diameter: 50,
                        ),
                      ),
                      BlocBuilder<EnterAmountBloc, (String, bool)>(
                        builder: (_, state) {
                          return Column(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.$1.isEmpty ? 'N 0' : 'N ${state.$1.formatPrice()}', maxLines: 2,
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: 50,
                                  color: state.$2 == false ? ATColors.textRedColor : null,
                                ),
                              ),
                              if(state.$2 == false)Text(
                                ATStrings.INSUFFICIENT_FUNDS,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ATColors.textRedColor
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                
                      const SizedBox(height: 50,),
                
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.5
                        ),
                        
                        children: digits.characters.map(
                          (digit){
                            if(digits.indexOf(digit) == 11){
                              return BlocBuilder<EnterAmountBloc, (String, bool)>(
                                builder: (_, state) {
                                  final shouldDisable = state.$1.isEmpty;
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () => shouldDisable ? null : context.read<EnterAmountBloc>().removeLast(),                          
                                    child: Center(
                                      child: Icon(
                                        Icons.keyboard_arrow_left_outlined, size: 30,
                                        color: shouldDisable ? ATColors.white.withValues(alpha: 0.3) : null,
                                      )
                                    ),
                                  );
                                }
                              );
                            }
                            return InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () => context.read<EnterAmountBloc>().grabInput(digit),                            
                              child: Center(
                                child: Text(
                                  digit,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontWeight: ATFontWeights.w500
                                  )
                                ),
                              ),
                            );
                          }
                        ).toList()
                      )
                    ],
                  ),
                ),
              ),
              
              bottomNavigationBar: Column(
                spacing:10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (_, snapshot) {
                      final isDone = snapshot.connectionState == ConnectionState.done;
                      return ATAnimatedAlign(
                        condition: !isDone,
                        startAlignment: Alignment(-ATHelperFuncs.getScreenWidth(context), 0),
                        endAlignment: Alignment.center,
                        child: ATContainer(
                          radius: 14,
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          width: ATHelperFuncs.getScreenWidth(context) * 0.92,
                          color: ATColors.white.withValues(alpha: 0.05),
                          child: Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.info_outline, color: ATColors.hexC2C2C2),
                              Flexible(
                                child: Text(
                                  receipient == null ? ATStrings.AMPTIVE_FUNDING_FEE 
                                    : ATStrings.AMPTIVE_TRNSF_CHARGES, maxLines: 3,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: ATFontSizes.size13,
                                    color: ATColors.hexC2C2C2
                                  )
                                ),
                              ),
                            ],
                          )
                        ),
                      );
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                    child: BlocBuilder<EnterAmountBloc, (String, bool)>(
                      builder: (_, state) {
                        return ATPlainElevatedBtn(
                          onPressed: (state.$1.isNotEmpty && state.$1 != '0' && state.$2 == true) 
                            ? () async{
                              if(receipient != null){
                                final shouldProceed = await inputTxnPinDialog(context: context, object: receipient);
                              }
                              else{
                                final selectMethod = await selectPaymentMethodDialog(context: context, amount: state.$1);
                              }
                            } : null,
                          btnTitle: receipient != null ? 
                            ATStrings.ENTER_PIN : ATStrings.SELECT_PAYMENT_METHOD
                        );
                      }
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
