import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../bloc/main_app/profile/profile_followers_bloc.dart';
import '../../../../../../../models/host.dart';
import '../../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../widgets/common_widgets/app_bar_widget.dart';
import '../../../../../../widgets/common_widgets/custom_container_widget.dart';

class AmptiveProfileFollowersScreen extends StatelessWidget {
  const AmptiveProfileFollowersScreen({super.key});

  @override
  Widget build(context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 15, 15),
              child: Icon(Icons.keyboard_arrow_left_outlined),
            ),
          ),
          leadingWidth: 30,
          title: Text(
            AmptiveStrings.FOLLOWERS,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AmptiveTextFormFieldWidget(
                controller: TextEditingController(),
                disableBlueBorder: true,
                hintText: AmptiveStrings.SEARCH_4_FOLLOWERS,
                fillColor: AmptiveColors.whiteColor.withOpacity(0.1),
                prefixIcon: const AmptiveImageLoaderWidget(
                  imagePath: AmptiveImageStrings.filledSearch
                ),
              ),
              const Gap(20),
              Text(
                AmptiveStrings.ALL_FOLLOWERS,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gap(20),
              Expanded(
                child: BlocBuilder<AmptiveProfileFollowersBloc, List<ObjectWithNotifier<Host>>>(
                  builder: (_, state) {
                    return ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (_, listIndex){
                        final follower = state.elementAt(listIndex);
                        return _AmptiveFollowerWidget(
                          follower: follower,
                          onTap: (follower, isSelected){},
                        );
                      }
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



class _AmptiveFollowerWidget extends StatelessWidget {
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> follower;

  const _AmptiveFollowerWidget({
    required this.onTap,
    required this.follower,
  });

  @override
  Widget build(context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () => onTap(follower, follower.notifier.value),
        child: Row(
          children: [
            AmptiveCustomContainer(
              clipBehavior: Clip.hardEdge,
              height: 50, width: 50, radius: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: AmptiveImageLoaderWidget(imagePath: follower.obj.profilePicture!)
              ),
            ),
            const Gap(10),
            Expanded(
              child: Text(
                follower.obj.username ?? '',
                style: Theme.of(context).textTheme.titleMedium
              ),
            ),

            AmptiveCustomContainer(
              radius: 30, color: AmptiveColors.whiteColor,
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Text(
                AmptiveStrings.REMOVE,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: AmptiveFontSizes.size13,
                  color: AmptiveColors.black
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
