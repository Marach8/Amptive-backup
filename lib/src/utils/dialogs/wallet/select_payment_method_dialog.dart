import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_align_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../views/features/main_app/wallet/bloc/enter_pin_bloc.dart';
import '../../../views/widgets/common_widgets/circular_image.dart';
import '../../constants/font_weights.dart';


Future<String?> selectPaymentMethodDialog({
  required BuildContext context,
  required String amount
}) {
  final paymentMethods = {
    ATImgStrings.APPLE_ICON : ATStrings.APPLE_PAY,
    ATImgStrings.FLUTTERWAVE: ATStrings.FLUTTERWAVE,
    ATImgStrings.GOOGLE_ICON: ATStrings.GOOGLE_PAY,
  };
  return showCupertinoModalPopup<String>(
    context: context,
    barrierColor: ATColors.black,
    builder: (dialogContext) {
      return BlocProvider(
        create: (_) => _PaymentMethodBloc(),
        child: Material(
          color: ATColors.trsprnt,
          child: Builder(
            builder: (context) {
              return SizedBox(
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
                            'Funding N${amount.formatPrice()}',
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
                          spacing: 15,
                          children: paymentMethods.entries.map(
                            (entry){
                              return InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () => context.read<_PaymentMethodBloc>().setPaymentMethod(entry.value),
                                child: ATContainer(
                                  color: ATColors.white.withValues(alpha: 0.05),
                                  radius: 50,
                                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  border: Border.all(color: ATColors.white.withValues(alpha: 0.2)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ATImgLoader(imgPath: entry.key, width: 30, height: 30),
                                      Text(
                                        'Pay with ${entry.value}',
                                        style: Theme.of(context).textTheme.bodyMedium
                                      ),
                                      BlocBuilder<_PaymentMethodBloc, String?>(
                                        builder: (_, state) {
                                          return ATRadioButton(isSelected: state == entry.value);
                                        }
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          ).toList()
                        ),
                      ),
                    ),
                  
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: BlocBuilder<_PaymentMethodBloc, String?>(
                        builder: (_, state) {
                          return ATPlainElevatedBtn(
                            onPressed: state == null ? null : () => dialogContext.pop(state),
                            btnTitle: ATStrings.CONTINUE,
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
    },
  );
}


class _PaymentMethodBloc extends Cubit<String?>{
  _PaymentMethodBloc() : super(null);

  void setPaymentMethod(String method) => emit(method);
}
