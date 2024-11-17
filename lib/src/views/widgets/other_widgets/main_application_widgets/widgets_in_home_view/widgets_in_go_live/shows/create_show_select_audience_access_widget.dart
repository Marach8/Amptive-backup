import 'package:amptive/src/utils/dialogs/select_audience_access_for_shows_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../common_widgets/custom_container_widget.dart';
import '../../../../../common_widgets/custom_rebuilder_widget.dart';

class AmptiveCreateShowSelectAudienceAccessWidget extends StatelessWidget {
  const AmptiveCreateShowSelectAudienceAccessWidget({super.key});

  @override
  Widget build(context) {
    final selectAudienceAccessNotifier = ValueNotifier<String>('');
    return AmptiveCustomContainer(
      radius: 14,
      padding: const EdgeInsets.fromLTRB(17, 15, 17, 15),
      color: AmptiveColors.whiteColor.withOpacity(0.1),
      child: AmptiveRebuilderWidget(
        shouldDispose: true,
        notifier: selectAudienceAccessNotifier,
        builder: (_, selectedAudienceAccess, __){
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedAudienceAccess.isEmpty ? "Select who can access this show" 
                  : selectedAudienceAccess,
                style: selectedAudienceAccess.isEmpty ? Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AmptiveColors.whiteColor.withOpacity(0.4),
                ) : Theme.of(context).textTheme.bodySmall,
              ),
              GestureDetector(
                onTap: ()async{
                  final result = await showSelectAudienceAccessForShowsDialog(context);
                  selectAudienceAccessNotifier.value = result;
                },
                child: Icon(
                  Icons.arrow_forward_ios, size: 20.w,
                  color: AmptiveColors.whiteColor.withOpacity(0.4),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}