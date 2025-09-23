import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/outlined_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../bloc/main_app/profile/profile_followers_bloc.dart';
import '../../../../models/host.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../../../shared/custom_container_widget.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../bloc/main_app/profile/profile_followers_bloc.dart';
import '../../../../models/host.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../../../shared/custom_container_widget.dart';

class ProfileSubscribersScreen extends StatelessWidget {
  const ProfileSubscribersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leading: const ATRoundedBackBtn(),
          leadingWidth: 30,
          title: Text(
            ATStrings.SUBSCRIBERS,
            style: context.textTheme.bodyMedium,
          ),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: ATTextFormField(
                controller: TextEditingController(),
                disableBlueBorder: true,
                hintText: ATStrings.SEARCH_4_SUBSCRIBERS,
                fillColor: ATColors.white.withValues(alpha:0.1),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ATImgLoader(
                    height: 20, width: 20,
                    imgPath: ATImgStrings.OUTLINED_SEARCH
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<AmptiveProfileFollowersBloc, List<ObjectWithNotifier<Host>>>(
                builder: (_, List<ObjectWithNotifier<Host>> state) {
                  return ListView.builder(
                    itemCount: state.length,
                    padding: const EdgeInsets.only(bottom: 50),
                    itemBuilder: (_, int index){
                      if(index == 0){
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 20),
                          child: Text(
                            ATStrings.ALL_SUBSCRIBERS,
                            style: context.textTheme.bodyMedium,
                          ),
                        );
                      }
                      final ObjectWithNotifier<Host> follower = state.elementAt(index - 1);
                      return _RenderASubscriber(
                        follower: follower,
                        onTap: (ObjectWithNotifier<Host> follower, bool isSelected){},
                      );
                    }
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}



class _RenderASubscriber extends StatelessWidget {

  const _RenderASubscriber({
    required this.onTap,
    required this.follower,
  });
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> follower;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: () => onTap(follower, follower.notifier.value),
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      radius: 0,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ATImgLoader(
              height: 50, width: 50, boxFit: BoxFit.cover,
              imgPath: follower.obj.profilePicture!
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              follower.obj.username ?? '',
              style: context.textTheme.titleMedium
            ),
          ),
    
          SizedBox(
            width: 84, height: 30,
            child: ATOutlinedBtn(
              onPressed: (){},
              padding: EdgeInsets.zero,
              btnTitle: ATStrings.MANAGE,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: ATSizes.size13,
              ),
            ),
          )
        ],
      ),
    );
  }
}
