import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/main_app/profile/profile_menu/language_bloc.dart';
import '../../config/utils/other_strings.dart';
import '../../views/widgets/common_widgets/circle_avatar.dart';



class ATSelectLanguageScreen extends StatelessWidget {
  const ATSelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 15),
              child: Row(
                children: <Widget>[
                  ATCircleAvatar(
                    onTap: () => context.pop(),
                    diameter: 30, color: ATColors.transparent,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const Spacer(),
                  Text(
                    ATStrings.LANGUAGE,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_left, color: ATColors.transparent),
                ],
              ),
            ),

            ATContainer(
              onTap: () => context.read<AmptiveLanguageBloc>().showLanguages(),
              margin: const EdgeInsets.all(15),
              color: ATColors.white.withValues(alpha: 0.1),
              radius: 14,
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Row(
                children: <Widget>[
                  Text(
                    ATStrings.APP_LANG,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  BlocBuilder<AmptiveLanguageBloc, List>(
                    builder: (_, List state) {
                      return Text(
                        state.first as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ATColors.white.withValues(alpha: 0.4)
                        ),
                      );
                    }
                  ),
                  Icon(Icons.keyboard_arrow_right, size: 20, color: ATColors.white.withValues(alpha: 0.4)),
                ],
              ),
            ),

            BlocBuilder<AmptiveLanguageBloc, List>(
              builder: (_, List state) {
                final bool showLangs = state.last as bool;
                if(!showLangs){
                  return const SizedBox.shrink();
                }
                return Column(
                  children: langs.map(
                    (String lang){
                      final bool isSelected = lang.toLowerCase() == (state.first as String).toLowerCase();
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                        child: GestureDetector(
                          onTap: () => context.read<AmptiveLanguageBloc>().selectLanguage(lang),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  lang,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: ATColors.hexC2C2C2
                                  )
                                ),
                              ),
                              ATRadioBtn(isSelected: isSelected)
                            ],
                          ),
                        ),
                      );
                    }
                  ).toList()
                );
              }
            )
          ],
        ),
      ),
    );
  }
}


final List<String> langs = <String>['English', 'China', 'Francais'];
