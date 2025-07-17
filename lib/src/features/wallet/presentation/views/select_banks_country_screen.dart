import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/wallet/select_withdrawal_bank_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../views/widgets/common_widgets/annotated_region__widget.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../../../views/widgets/common_widgets/back_button.dart';
import '../../../../views/widgets/common_widgets/elevated_button_widget.dart';

class ATSelectBanksCountryScreen extends StatelessWidget {
  const ATSelectBanksCountryScreen({super.key});

  static List<String> countries = <String>['Nigeria', 'Ghana', 'Kenya', 'South Africa', 'Tanzania'];

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
                titleText: ATStrings.SELECT_COUNTRY
              ),
            
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                      child: Text(
                        maxLines: 2,
                        ATStrings.SELECT_BANK_COUNTRY,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ATColors.hexC2C2C2
                        ),
                      ),
                    ),
        
                    ...countries.map(
                      (String country){
                        return InkWell(
                          onTap: (){
                            final bool isSelected = context.read<_PrivateBloc>().state == country;
                            context.read<_PrivateBloc>().selectCountry(
                              isSelected ? null : country,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    country,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: ATFontSizes.size15
                                    )
                                  ),
                                ),
                                BlocBuilder<_PrivateBloc, String?>(
                                  buildWhen: (String? prev, String? curr) => prev == country || curr == country,
                                  builder: (_, String? state) {
                                    return ATRadioBtn(isSelected: state == country);
                                  }
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    )
                  ],
                ),
              ),
        
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: BlocBuilder<_PrivateBloc, String?>(
                  builder: (_, String? state) {
                    return ATPlainElevatedBtn(
                      onPressed: state == null ? null : ()async{
                        final String? selectedBank = await selectWithdrawalBankDialog(context);
                        if(context.mounted && selectedBank != null){
                          context.pushReplacementNamed(ATRoutes.ENTER_ACCT_NO, extra: selectedBank);
                        }
                      },
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


class _PrivateBloc extends Cubit<String?> {
  _PrivateBloc() : super(null);

  void selectCountry(String? country) => emit(country);
}