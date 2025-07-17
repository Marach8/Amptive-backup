import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/security_question_bloc.dart';


class SecurityAnswerField extends StatelessWidget {
  const SecurityAnswerField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ATStrings.WHAT_IS_UR_ANSWER,
          style: Theme.of(context).textTheme.bodyMedium
        ),
        const SizedBox(height: 10,),
        ATTextFormField(
          hintText: ATStrings.ENTER_UR_ANS,
          fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
          onChanged: (String text){
            ATHelperFuncs.callDebouncer(
              1000,
              () => context.read<SecQuestionBloc>().setSecAnswer(text)
            );
          },
        ),
        const SizedBox(height: 10,),
        Text(
          ATStrings.ANS_IS_CASE_SENSITIVE,
          style: Theme.of(context).textTheme.titleSmall
        ),
        const SizedBox(height: 10,),
        Text(
          ATStrings.U_MUST_ANS_SECURITY_QUEST, maxLines: 2,
          style: Theme.of(context).textTheme.titleSmall
        ),
      ],
    );
  }
}