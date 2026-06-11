import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/image_loader_widget.dart';

class SelectedCohostsRow extends StatelessWidget {
  const SelectedCohostsRow({super.key});

  static const int maxSlots = 5;

  List<Widget> buildSlots(List<User> cohosts) {
    final List<Widget> slots = <Widget>[];

    for (int i = 0; i < maxSlots; i++) {
      if (i < cohosts.length) {
        slots.add(_FilledCohostSlot(cohost: cohosts[i]));
      } else {
        slots.add(_EmptyCohostSlot(number: i + 1));
      }
    }

    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedCohostsCubit, List<User>>(
      builder: (_, List<User> selectedCohosts) {
        return ATAnimatedXFade(
          condition: selectedCohosts.isNotEmpty,
          secondChild: const SizedBox.shrink(),
          firstChild: Container(
            height: 43,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buildSlots(selectedCohosts),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyCohostSlot extends StatelessWidget {
  const _EmptyCohostSlot({
    required this.number,
  });

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 15),
      height: 43,
      width: 43,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: ATColors.white.withValues(alpha: 0.4)),
      ),
      child: Text(
        number.toString(),
        style: context.textTheme.bodySmall?.copyWith(fontSize: ATSizes.size12),
      ),
    );
  }
}

class _FilledCohostSlot extends StatelessWidget {
  const _FilledCohostSlot({required this.cohost});
  final User cohost;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ATImgLoader(
                height: 43,
                width: 43,
                boxFit: BoxFit.cover,
                imgPath: cohost.profilePicture ?? ''),
          ),
          Positioned(
            top: 0,
            right: -4,
            child: ATContainer(
              onTap: () =>
                  context.read<SelectedCohostsCubit>().removeCohost(cohost),
              color: ATColors.textRedColor,
              height: 17,
              width: 17,
              boxShape: BoxShape.circle,
              child: const FittedBox(
                  fit: BoxFit.scaleDown, child: Icon(Icons.close)),
            ),
          )
        ],
      ),
    );
  }
}

