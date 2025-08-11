import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/wallet/bloc/wallet_bloc_export.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_align_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../../../views/widgets/common_widgets/back_button.dart';
import '../../../../views/widgets/common_widgets/custom_container_widget.dart';

class ATEnterAmountScreen extends StatelessWidget {
  const ATEnterAmountScreen({super.key, required this.params});

  final EnterAmountScreenParams params;

  static String digits = '123456789.0<';

  @override
  Widget build(BuildContext context) {
    if(params.flushBarNotif != null){
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => showAppNotification(context: context, text: params.flushBarNotif!)
      );
    }

    return ATAnnotatedRegion(
      child: BlocProvider(
        create: (_) => EnterAmountBloc(),
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: ATAppBar(
                leading: const ATRoundedBackBtn(),
                leadingWidth: 30,
                padding: const EdgeInsets.only(left: 7),
                titleText: params.title,
              ),
              body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      if(params.imgPath != null)Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ATCircularImage(
                          imagePath: params.imgPath!,
                          diameter: 50,
                        ),
                      ),

                      BlocBuilder<EnterAmountBloc, (String, bool)>(
                        builder: (_, (String, bool) state) {
                          return Column(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
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
                          (String digit){
                            if(digits.indexOf(digit) == 11){
                              return BlocBuilder<EnterAmountBloc, (String, bool)>(
                                builder: (_, (String, bool) state) {
                                  final bool shouldDisable = state.$1.isEmpty;
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
                children: <Widget>[
                  FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (_, AsyncSnapshot snapshot) {
                      final bool isDone = snapshot.connectionState == ConnectionState.done;
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
                            children: <Widget>[
                              Icon(Icons.info_outline, color: ATColors.hexC2C2C2),
                              Flexible(
                                child: Text(
                                  params.slidingNotif, maxLines: 3,
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
                      builder: (_, (String, bool) state) {
                        return ATPlainElevatedBtn(
                          onPressed: (state.$1.isNotEmpty && state.$1 != '0' && state.$2 == true) 
                            ? () => context.pop(state.$1) : null,
                          btnTitle: params.btnTitle
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


class EnterAmountScreenParams{

  EnterAmountScreenParams({
    required this.title,
    required this.slidingNotif,
    required this.btnTitle,
    this.flushBarNotif,
    this.imgPath
  });
  final String title, slidingNotif,
  btnTitle;
  final String? imgPath, flushBarNotif;
}