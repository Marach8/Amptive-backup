import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/wallet/presentation/screens/wallet_views_export.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_align_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/with_leading_image_nd_trailing_more_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/enter_pin_bloc.dart';
import '../../../../views/widgets/common_widgets/circular_image.dart';
import '../../../../config/utils/font_weights.dart';

class InputPinParams{
  const InputPinParams({
    this.bankDetails,
    this.recipientProfileUrl,
    required this.transactionType,
  });

  final BankDetails? bankDetails;
  final String? recipientProfileUrl;
  final TransactionType transactionType;
}


Future<bool?> inputTransactionPinDialog({
  required BuildContext context,
  required InputPinParams params,
}) {
  const String digits = '123456789.0<';
  
  return showCupertinoModalPopup<bool>(
    context: context,
    barrierColor: ATColors.black,
    builder: (BuildContext dialogContext) {
      return BlocProvider<EnterPinBloc>(
        create: (_) => EnterPinBloc(),
        child: Builder(
          builder: (BuildContext blocContext) {
            return Material(
              color: ATColors.transparent,
              child: SizedBox(
                height: context.screenHeight,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(7, 48, 15, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const ATRoundedBackBtn(),
                          Text(
                            ATStrings.enterPin,
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                          const SizedBox(width: 30,),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Column(
                          children: <Widget>[
                            if(params.transactionType == TransactionType.transfer)ATCircularImage(
                              imagePath: params.recipientProfileUrl ?? '',
                              diameter: 50,
                            ),

                            if(params.transactionType == TransactionType.withdraw) WidgetWithLeadingImageAndTrailingMoreIcon(
                              title: params.bankDetails?.bankName ?? '',
                              subtitle: '${params.bankDetails?.accountNo} - ${params.bankDetails?.accountName}',
                              leadingImgPath: ATImgStrings.WIRE_TRANSFER,
                              btnText: ATStrings.CHANGE_BANK_DETAILS,
                              btnOnTap: (){
                                dialogContext.pop(); context.pop();
                              },
                              trailingMoreOnTap: (){},
                              bottomTrailingText: params.bankDetails?.amount?.formatPrice(),
                              //bottomTrailingWidget: const SizedBox.shrink(),
                              imgSize: 40,
                            ),

                            const SizedBox(height: 50,),

                            BlocConsumer<EnterPinBloc, (String, bool?)>(                              
                              listener: (_, (String, bool?) state){
                                if(state.$1.length == 4 && state.$2 == true){
                                  dialogContext.pop(true);
                                }
                              },
                              builder: (_, (String, bool?) state) {
                                final Characters pins = state.$1.characters;
                                return Column(
                                  spacing: 20,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      spacing: 20,
                                      children: List.generate(
                                        4,
                                        (int index){
                                          final String? eachPin = pins.elementAtOrNull(index);
                                          return ATContainer(
                                            duration: 200,
                                            border: Border.all(
                                              width: 2,
                                              color: (state.$2 == false) ? ATColors.textRedColor : ATColors.white,
                                            ),
                                            height: 16, width: 16, radius: 10,
                                            color: (eachPin ?? '').isEmpty ? ATColors.transparent : ATColors.white,
                                          );
                                        }
                                      ),
                                    ),
                            
                                    if(state.$2 == false)Text(
                                      ATStrings.incorrectPin,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: ATColors.textRedColor
                                      ),
                                    ),
                                  ],
                                );
                              }
                            ),

                            const SizedBox(height: 20,),
              
                            GridView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.5
                              ),
                              
                              children: digits.characters.map(
                                (String digit){
                                  if(digit == '.') return const SizedBox.shrink();
                      
                                  if(digits.indexOf(digit) == 11){
                                    return BlocBuilder<EnterPinBloc, (String, bool?)>(                              
                                      builder: (_, (String, bool?) state){
                                        return InkWell(
                                          borderRadius: BorderRadius.circular(5),
                                          onTap: state.$1.isEmpty ? null : () => blocContext.read<EnterPinBloc>().deletePin(),                          
                                          child: Center(
                                            child: Icon(
                                              Icons.keyboard_arrow_left_outlined, size: 30,
                                              color: state.$1.isEmpty ? ATColors.white.withValues(alpha: 0.3) : null
                                            )
                                          ),
                                        );
                                      }
                                    );
                                  }
                                  
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () => blocContext.read<EnterPinBloc>().grabPin(digit),                            
                                    child: Center(
                                      child: Text(
                                        digit,
                                        style: context.textTheme.displayMedium?.copyWith(
                                          fontWeight: ATFontWeights.w500
                                        )
                                      ),
                                    ),
                                  );
                                }
                              ).toList()
                            ),

                            const SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    ),

                    ATContainer(
                      radius: 14,
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      color: ATColors.white.withValues(alpha: 0.05),
                      child: Row(
                        spacing: 10,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.info_outline, color: ATColors.hexC2C2C2),
                          Flexible(
                            child: Text(
                              ATStrings.keepsWalletSecure, maxLines: 3,
                              style: context.textTheme.titleSmall?.copyWith(
                                fontSize: ATSizes.size13,
                                color: ATColors.hexC2C2C2
                              )
                            ),
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 50,),
                  ],
                ),
              ),
            );
          }
        ),
      );
    },
  );
}

