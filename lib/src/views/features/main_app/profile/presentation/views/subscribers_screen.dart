import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../bloc/main_app/profile/profile_followers_bloc.dart';
import '../../../../../../models/host.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../widgets/common_widgets/app_bar_widget.dart';
import '../../../../../widgets/common_widgets/custom_container_widget.dart';

class AmptiveProfileSubScribersScreen extends StatelessWidget {
  const AmptiveProfileSubScribersScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 15, 15),
              child: Icon(Icons.keyboard_arrow_left_outlined),
            ),
          ),
          leadingWidth: 30,
          title: Text(
            ATStrings.SUBSCRIBERS,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ATTextFormField(
                controller: TextEditingController(),
                disableBlueBorder: true,
                hintText: ATStrings.SEARCH_4_SUBSCRIBERS,
                fillColor: ATColors.white.withOpacity(0.1),
                prefixIcon: const ATImgLoader(
                  imgPath: ATImgStrings.filledSearch
                ),
              ),
              const Gap(20),
              Text(
                ATStrings.ALL_SUBSCRIBERS,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gap(20),
              Expanded(
                child: BlocBuilder<AmptiveProfileFollowersBloc, List<ObjectWithNotifier<Host>>>(
                  builder: (_, state) {
                    return ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (_, listIndex){
                        final subscriber = state.elementAt(listIndex);
                        return _AmptiveSubscriberWidget(
                          subscriber: subscriber,
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



class _AmptiveSubscriberWidget extends StatelessWidget {
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> subscriber;

  const _AmptiveSubscriberWidget({
    required this.onTap,
    required this.subscriber,
  });

  @override
  Widget build(context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () => onTap(subscriber, subscriber.notifier.value),
        child: Row(
          children: [
            ATContainer(
              clipBehavior: Clip.hardEdge,
              height: 50, width: 50, radius: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: ATImgLoader(imgPath: subscriber.obj.profilePicture!)
              ),
            ),
            const Gap(10),
            Expanded(
              child: Text(
                subscriber.obj.username ?? '',
                style: Theme.of(context).textTheme.titleMedium
              ),
            ),
            ATContainer(
              border: Border.all(color: ATColors.white),
              radius: 30, 
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Text(
                ATStrings.MANAGE,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATFontSizes.size13,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
