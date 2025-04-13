import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../../../bloc/main_app/profile/profile_menu/language_bloc.dart';
import '../../../../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../../../widgets/common_widgets/circle_avatar.dart';



class ATSelectLanguageScreen extends StatelessWidget {
  const ATSelectLanguageScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 15),
              child: Row(
                children: [
                  ATCircleAvatar(
                    onTap: () => context.pop(),
                    diameter: 30, color: ATColors.trsprnt,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const Spacer(),
                  Text(
                    ATStrings.LANGUAGE,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_left, color: ATColors.trsprnt),
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
                children: [
                  Text(
                    ATStrings.APP_LANG,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  BlocBuilder<AmptiveLanguageBloc, List>(
                    builder: (_, state) {
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
              builder: (_, state) {
                final showLangs = state.last as bool;
                if(!showLangs){
                  return const SizedBox.shrink();
                }
                return Column(
                  children: langs.map(
                    (lang){
                      final isSelected = lang.toLowerCase() == (state.first as String).toLowerCase();
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                        child: GestureDetector(
                          onTap: () => context.read<AmptiveLanguageBloc>().selectLanguage(lang),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  lang,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: ATColors.hexC2C2C2
                                  )
                                ),
                              ),
                              ATRadioButton(isSelected: isSelected)
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


final langs = ['English', 'China', 'Francais'];
