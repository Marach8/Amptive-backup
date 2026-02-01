import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


Future<String?> selectPaymentMethodDialog({
  required BuildContext context,
  required String amount
}) {
  final Map<String, String> paymentMethods = <String, String>{
    ATImgStrings.appleIcon : ATStrings.applePay,
    ATImgStrings.flutterWaveIcon: ATStrings.flutterWave,
    ATImgStrings.googleIcon: ATStrings.googlePay,
  };
  return showCupertinoModalPopup<String>(
    context: context,
    barrierColor: ATColors.black,
    builder: (BuildContext dialogContext) {
      return BlocProvider<_PaymentMethodBloc>(
        create: (_) => _PaymentMethodBloc(),
        child: Material(
          color: ATColors.transparent,
          child: Builder(
            builder: (BuildContext context) {
              return SizedBox(
                height: ATHelperFuncs.getScreenHeight(context),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(7, 40, 15, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const ATRoundedBackBtn(),
                          Text(
                            'Funding ${ATStrings.nairaText}${amount.formatPrice()}',
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
                          children: paymentMethods.entries.indexed.map(
                            ((int, MapEntry<String, String>) entry){
                              return InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () => context.read<_PaymentMethodBloc>().setPaymentMethod(entry.$2.value),
                                child: ATContainer(
                                  color: ATColors.white.withValues(alpha: 0.05),
                                  radius: 50,
                                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  border: Border.all(color: ATColors.white.withValues(alpha: 0.2)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ATImgLoader(
                                        imgPath: entry.$2.key,
                                        width: entry.$1 == 2 ? 30 : 20, 
                                        height: entry.$1 == 2 ? 30 : 20,
                                        boxFit: BoxFit.cover,
                                      ),
                                      Text(
                                        'Pay with ${entry.$2.value}',
                                        style: Theme.of(context).textTheme.bodyMedium
                                      ),
                                      BlocBuilder<_PaymentMethodBloc, String?>(
                                        builder: (_, String? state) {
                                          return ATRadioBtn(
                                            duration: 300,
                                            isSelected: state == entry.$2.value);
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
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 60),
                      child: BlocBuilder<_PaymentMethodBloc, String?>(
                        builder: (_, String? state) {
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
