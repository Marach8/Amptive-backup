import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import 'dart:developer';
import '../../../../../widgets/common_widgets/elevated_button_widget.dart';
import '../widgets/wallets_widget_export.dart';

class ATWithdrwalLandingScreen extends StatelessWidget {
  const ATWithdrwalLandingScreen({super.key});

  static Map<String, List<String>> map = {
    ATImgStrings.WIRE_TRANSFER: [ATStrings.WIRE_TRSF, ATStrings.WIRE_TRSF_DESC],
    ATImgStrings.PAYPAL_ICON: [ATStrings.PAYPAL, ATStrings.PAYPAL_DESC],
  };

  @override
  Widget build(BuildContext _) {
    return ATAnnotatedRegion(
      child: BlocProvider(
        create: (_) => _PrivateBloc(),
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: const ATAppBar(
                leading: ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: EdgeInsets.only(left: 7),
                titleText: ATStrings.WITHDRAW
              ),
            
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 2,
                      ATStrings.CHOOSE_WITHDRWAL_METHOD,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
            
                    const SizedBox(height: 20),
                    Row(
                      spacing: 10,
                      children: map.entries.indexed.map(
                        (entry) {
                          return Expanded(
                            child: BlocBuilder<_PrivateBloc, int?>(
                              builder: (_, state) {
                                final isSelected = state == entry.$1;
                                return ATScaleUpAndDownWidget(
                                  imgPath: entry.$2.key,
                                  title: entry.$2.value.first,
                                  subtitle: entry.$2.value.last,
                                  isSelected: isSelected,
                                  onTap: () => context.read<_PrivateBloc>().selectPaymentMethod(
                                    isSelected ? null : entry.$1,
                                  ),
                                );
                              }
                            ),
                          );
                        }
                      ).toList(),
                    )
                  ],
                ),
              ),

              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: BlocBuilder<_PrivateBloc, int?>(
                  builder: (_, state) {
                    return ATPlainElevatedBtn(
                      onPressed: state == null ? null : 
                        () => context.pushNamed(ATRoutes.SELECT_BANK_COUNTRY),
                      btnTitle: ATStrings.CONTINUE,
                    );
                  }
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}


class _PrivateBloc extends Cubit<int?>{
  _PrivateBloc() : super(null);

  void selectPaymentMethod(int? value) => emit(value);
}
