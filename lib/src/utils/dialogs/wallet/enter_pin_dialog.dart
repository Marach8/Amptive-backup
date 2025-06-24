import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/features/wallet/presentation/views/wallet_views_export.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_align_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/with_leading_image_nd_trailing_more_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/wallet/bloc/enter_pin_bloc.dart';
import '../../../views/widgets/common_widgets/circular_image.dart';
import '../../constants/font_weights.dart';

Future<bool?> inputTxnPinDialog({
  required BuildContext context,
  required Object? object
}) {
  ObjectWithNotifier<Host>? receipient; BankDetails? bankDetails;
  final isTransfer = object is ObjectWithNotifier<Host>;
  final isWithdrawal = object is BankDetails;

  if(isTransfer){
    receipient = object;
  }
  else if(isWithdrawal){
    bankDetails = object;
  }

  const digits = '123456789.0<';
  
  return showCupertinoModalPopup<bool>(
    context: context,
    barrierColor: ATColors.black,
    builder: (dialogContext) {
      return BlocProvider(
        create: (_) => EnterPinBloc(),
        child: Builder(
          builder: (blocContext) {
            return Material(
              color: ATColors.trsprnt,
              child: SizedBox(
                height: ATHelperFuncs.getScreenHeight(context),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(7, 40, 15, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const ATRoundedBackBtn(),
                          Text(
                            ATStrings.ENTER_PIN,
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
                          children: [
                            if(isTransfer)ATCircularImage(
                              imagePath: receipient?.obj.profilePicture ?? '',
                              diameter: 50,
                            ),
                            if(isWithdrawal) WidgetWithLeadingImageAndTrailingMoreIcon(
                              title: bankDetails?.bankName ?? '',
                              subtitle: '${bankDetails?.accountNo} - ${bankDetails?.accountName}',
                              leadingImgPath: ATImgStrings.WIRE_TRANSFER,
                              btnText: ATStrings.CHANGE_BANK_DETAILS,
                              btnOnTap: (){
                                dialogContext.pop(); context.pop();
                              },
                              trailingMoreOnTap: (){},
                              bottomTrailingText: bankDetails?.amount?.formatPrice(),
                              //bottomTrailingWidget: const SizedBox.shrink(),
                              imgSize: 40,
                            ),

                            const SizedBox(height: 50,),

                            BlocConsumer<EnterPinBloc, (String, bool?)>(                              
                              listener: (_, state){
                                if(state.$1.length == 4 && state.$2 == true){
                                  dialogContext.pop(true);
                                }
                              },
                              builder: (_, state) {
                                final pins = state.$1.characters;
                                return Column(
                                  spacing: 20,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      spacing: 20,
                                      children: List.generate(
                                        4,
                                        (index){
                                          final eachPin = pins.elementAtOrNull(index);
                                          return ATContainer(
                                            duration: 200,
                                            border: Border.all(
                                              width: 2,
                                              color: (state.$2 == false) ? ATColors.textRedColor : ATColors.white,
                                            ),
                                            height: 16, width: 16, radius: 10,
                                            color: (eachPin ?? '').isEmpty ? ATColors.trsprnt : ATColors.white,
                                          );
                                        }
                                      ),
                                    ),
                            
                                    if(state.$2 == false)Text(
                                      ATStrings.INCORRECT_PIN,
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
                                (digit){
                                  if(digit == '.') return const SizedBox.shrink();
                      
                                  if(digits.indexOf(digit) == 11){
                                    return BlocBuilder<EnterPinBloc, (String, bool?)>(                              
                                      builder: (_, state){
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
                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
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

                    FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 2)),
                      builder: (_, snapshot) {
                        final isDone = snapshot.connectionState == ConnectionState.done;
                        return ATAnimatedAlign(
                          condition: !isDone,
                          startAlignment: Alignment(-ATHelperFuncs.getScreenWidth(dialogContext) * 3, 0),
                          endAlignment: Alignment.center,
                          child: ATContainer(
                            radius: 14,
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            width: ATHelperFuncs.getScreenWidth(dialogContext) * 0.92,
                            color: ATColors.white.withValues(alpha: 0.05),
                            child: Row(
                              spacing: 10,
                              children: [
                                Icon(Icons.info_outline, color: ATColors.hexC2C2C2),
                                Flexible(
                                  child: Text(
                                    ATStrings.KEEPS_WALLET_SECURE, maxLines: 3,
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
                    const SizedBox(height: 10,)
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    //   child: BlocBuilder<EnterPinBloc, (String, bool)>(
                    //     builder: (_, state) {
                    //       return ATPlainElevatedBtn(
                    //         onPressed: (state.$1.isNotEmpty && state.$1 != '0' && state.$2 == true) 
                    //           ? () {} : null,
                    //         btnTitle: ATStrings.ENTER_PIN,
                    //       );
                    //     }
                    //   ),
                    // ),
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

