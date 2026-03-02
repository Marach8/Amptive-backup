import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';


Future<(int?, bool)?> viewCoHostInviteDetails({
  required String hostImg,
  required String hostUsername,
  required String progName,
  required bool isEvent,
  required BuildContext context,
  String? coHostFee
})async{
  return await showCupertinoModalPopup<(int, bool)>(
    context: context,
    builder: (BuildContext dialogContext) => BlocProvider(
      create: (_) => _PrivatBloc(),
      child: Builder(
        builder: (BuildContext blocContext) {
          return Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
            decoration: BoxDecoration(
              color: ATColors.hex202020,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14) 
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ATModalDismisser(),
                const SizedBox(height: 15),
                ATCircularImage(diameter: 40, imagePath: hostImg),
                const SizedBox(height: 15),
                Text(
                  ATStrings.COHOST_REQUEST,
                  style: Theme.of(context).textTheme.bodyLarge
                ),
                const SizedBox(height: 15),
                Text(
                  '$hostUsername ${ATStrings.INVITED_U_2_COHOST_IN_THE} ${isEvent ? ATStrings.EVENT : ATStrings.SHOW} $progName',
                  maxLines: 2, textAlign: TextAlign.center,
                  //style: Theme.of(context).textTheme.labelSmall
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                  )
                ),
          
                if(coHostFee != null)const SizedBox(height: 15),
                if(coHostFee != null)BlocSelector<_PrivatBloc, (int?, bool), int?>(
                  selector: ((int?, bool) st) => st.$1,
                  builder: (_, int? state) {
                    return _PrivateWidget(
                      onTapTitle: '${ATStrings.EDIT} ${ATStrings.COHOST_FEE}'.capitalize,
                      title: ATStrings.ACCEPT_WITH_FEE,
                      subtitle: ATStrings.ACCEPT_WITH_FEE_DESC,
                      isSelected: state == 0, amount: '5,000',
                      onSelected: () => blocContext.read<_PrivatBloc>().selectChoice(
                        state == 0 ? null : 0
                      ),
                      leadingOntap: (){},
                    );
                  }
                ),
          
                const SizedBox(height: 15),
                BlocSelector<_PrivatBloc, (int?, bool), int?>(
                  selector: ((int?, bool) st) => st.$1,
                  builder: (_, int? state) {
                    return _PrivateWidget(
                      onTapTitle: ATStrings.SETUP_COHOST_FEE,
                      title: ATStrings.ACCEPT_WITHOUT_FEE,
                      subtitle: ATStrings.ACCEPT_WITHOUT_FEE_DESC,
                      isSelected: state == 1,
                      onSelected: () => blocContext.read<_PrivatBloc>().selectChoice(
                        state == 1 ? null : 1
                      ),
                      leadingOntap: coHostFee == null ? () => dialogContext.pop((3, false)) : null,
                    );
                  }
                ),
          
                const SizedBox(height: 15),
                BlocSelector<_PrivatBloc, (int?, bool), int?>(
                  selector: ((int?, bool) st) => st.$1,
                  builder: (_, int? state) {
                    return _PrivateWidget(
                      title: ATStrings.DECLINE_REQUEST,
                      isSelected: state == 2, color: ATColors.textRedColor,
                      onSelected: () => blocContext.read<_PrivatBloc>().selectChoice(
                        state == 2 ? null : 2
                      ),
                    );
                  }
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: ATColors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () => blocContext.read<_PrivatBloc>().rememberChoice(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          BlocSelector<_PrivatBloc, (int?, bool), bool>(
                            selector: ((int?, bool) st) => st.$2,
                            builder: (_, bool state) {
                              return ATContainer(
                                duration: 0,
                                height: 15, width: 15, radius: 3,
                                border: Border.all(color: state ? ATColors.successColor : ATColors.white,),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Icon(
                                    CupertinoIcons.check_mark,
                                    color: state ? ATColors.successColor : ATColors.transparent
                                  ),
                                ),
                              );
                            }
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            ATStrings.REMEMBER_CHOICE_4_HOST, maxLines: 2,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: ATSizes.size11
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          
                const SizedBox(height: 80),
                Text(
                  ATStrings.AMPTIVE_CHARGES_4_CREATORS, maxLines: 2,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ATColors.white.withValues(alpha: 0.4),
                  )
                ),
                const SizedBox(height: 15),
                BlocBuilder<_PrivatBloc, (int?, bool)>(
                  builder: (_, (int?, bool) state) {
                    return ATPlainElevatedBtn(
                      fgColor: ATColors.black, bgColor: ATColors.white,
                      onPressed: state.$1 != null ? () => dialogContext.pop(state) : null,
                      btnTitle: ATStrings.SEND_RESPONSE
                    );
                  }
                ),
              ],
            ),
          );
        }
      ),
    )
  );
}


class _PrivatBloc extends Cubit<(int?, bool)>{
  _PrivatBloc(): super((null, false));

  void selectChoice(int? choice) => emit((choice, state.$2));

  void rememberChoice() => emit((state.$1, !state.$2));
}




class _PrivateWidget extends StatelessWidget {
  const _PrivateWidget({
    required this.title,
    this.subtitle, this.onTapTitle,
    required this.isSelected,
    required this.onSelected,
    this.amount, this.color,
    this.leadingOntap
  });

  final String title;
  final String? amount, subtitle, onTapTitle;
  final bool isSelected;
  final VoidCallback? leadingOntap;
  final VoidCallback onSelected;
  final Color? color;


  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onSelected,
      color: color ?? ATColors.hex9E9E9E.withValues(alpha: 0.3),
      radius: 14, alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      border: isSelected ? Border.all(color: ATColors.hex307FE2, width: 0.5) : null,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATSizes.size15
                      ),
                    ),
                    if(subtitle != null)Text(
                      subtitle!, maxLines: 3,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: ATSizes.size13
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
    
              ATRadioBtn(isSelected: isSelected)
            ],
          ),
          if(leadingOntap != null)const SizedBox(height: 10),
          if(leadingOntap != null)const ATDivider(),
          if(leadingOntap != null)Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ATContainer(
                  onTap: leadingOntap,
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  color: ATColors.white.withValues(alpha: 0.1),
                  radius: 5,
                  child: Text(
                    onTapTitle ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: ATSizes.size12,
                      color: ATColors.white.withValues(alpha: 0.7)
                    ),
                  ),
                ),

                if(amount != null) Flexible(
                  child: Text(
                    'N$amount', maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ATSizes.size14
                    )
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}

