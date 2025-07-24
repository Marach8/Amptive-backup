import 'package:amptive/src/features/go_live/presentation/widgets/audience_access_4_shows_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../config/utils/colors.dart';
import '../../../../../common_widgets/custom_container_widget.dart';
import '../../../../../common_widgets/custom_rebuilder_widget.dart';

class AmptiveCreateShowSelectAudienceAccessWidget extends StatelessWidget {
  const AmptiveCreateShowSelectAudienceAccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> selectAudienceAccessNotifier = ValueNotifier<String>('');
    return ATContainer(
      radius: 14,
      padding: const EdgeInsets.fromLTRB(17, 15, 17, 15),
      color: ATColors.white.withOpacity(0.1),
      child: AmptiveRebuilderWidget(
        shouldDispose: true,
        notifier: selectAudienceAccessNotifier,
        builder: (_, String selectedAudienceAccess, __){
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                selectedAudienceAccess.isEmpty ? "Select who can access this show" 
                  : selectedAudienceAccess,
                style: selectedAudienceAccess.isEmpty ? Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ATColors.white.withOpacity(0.4),
                ) : Theme.of(context).textTheme.bodySmall,
              ),
              GestureDetector(
                onTap: ()async{
                  final String result = await chooseAudienceAccess4ShowModal(context);
                  selectAudienceAccessNotifier.value = result;
                },
                child: Icon(
                  Icons.arrow_forward_ios, size: 20.w,
                  color: ATColors.white.withOpacity(0.4),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}