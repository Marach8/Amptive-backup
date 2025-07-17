import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../widgets/wallets_widget_export.dart';

class ATWithdrwalLandingScreen extends StatelessWidget {
  const ATWithdrwalLandingScreen({super.key});

  static Map<String, List<String>> map = <String, List<String>>{
    ATImgStrings.WIRE_TRANSFER: <String>[ATStrings.WIRE_TRSF, ATStrings.WIRE_TRSF_DESC],
    ATImgStrings.PAYPAL_ICON: <String>[ATStrings.PAYPAL, ATStrings.PAYPAL_DESC],
  };

  @override
  Widget build(BuildContext _) {
    return ATAnnotatedRegion(
      child: BlocProvider(
        create: (_) => _PrivateBloc(),
        child: Builder(
          builder: (BuildContext context) {
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
                  children: <Widget>[
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
                        ((int, MapEntry<String, List<String>>) entry) {
                          return Expanded(
                            child: BlocBuilder<_PrivateBloc, int?>(
                              builder: (_, int? state) {
                                final bool isSelected = state == entry.$1;
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
                  builder: (_, int? state) {
                    return ATPlainElevatedBtn(
                      onPressed: state == null ? null : 
                        () => context.pushReplacementNamed(ATRoutes.SELECT_BANK_COUNTRY),
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
