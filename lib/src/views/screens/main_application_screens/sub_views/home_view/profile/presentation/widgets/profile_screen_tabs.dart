import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/profile/show_top_creator_societies.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../utils/constants/font_weights.dart';
import '../../../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../../../utils/helpers/helper_functions/other_functions.dart';
import '../../../../../../../widgets/common_widgets/custom_container_widget.dart';
import '../../../../../../../widgets/common_widgets/image_loader_widget.dart';
import '../../bloc/profile_bloc_export.dart';

class ProfileScreenTabs extends StatelessWidget {
  const ProfileScreenTabs({
    super.key,
    required this.tabs
  });

  final List<String> tabs;

  @override
  Widget build(context) {
    return ATContainer(
      color: ATColors.black,             
      child: BlocBuilder<ProfileTabViewBloc, int>(
        builder: (_, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(        
              mainAxisAlignment: MainAxisAlignment.spaceBetween,            
              children: [
                const SizedBox(width: 15,),
                ...tabs.map(
                  (string){
                    final index = tabs.indexOf(string);
                    final isSelected = index == state;
                    return ATContainer(
                      curve: Curves.decelerate,
                      alignment: Alignment.center, radius: 50,
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      margin: const EdgeInsets.fromLTRB(0, 10, 10, 20),
                      color: isSelected ? ATColors.white : ATColors.black,
                      border: !isSelected ? Border.all(
                        color: ATColors.white.withOpacity(0.1),
                        width: 2
                      ) : null,
                      onTap: () => context.read<ProfileTabViewBloc>().goToPage(index),
                      child: Text(
                        string,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: ATFontSizes.size13,
                          color: isSelected ? ATColors.black : ATColors.white
                        ),
                      ),
                    );
                  }
                )
              ]
            ),
          );
        }
      ),
    );
  }
}
