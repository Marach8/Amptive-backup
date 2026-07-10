import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          // Snappy reveal instead of the slow 500ms default.
          duration: 220,
          fadeCurve: Curves.easeOut,
          sizeCurve: Curves.easeOutCubic,
          secondChild: const SizedBox.shrink(),
          firstChild: Container(
            height: 48,
            margin: const EdgeInsets.all(20),
            // Center the slots when they fit; scroll horizontally if not.
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: buildSlots(selectedCohosts),
                ),
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
      margin: const EdgeInsets.only(right: 24),
      height: 48,
      width: 48,
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
      padding: const EdgeInsets.only(right: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ATImgLoader(
                height: 48,
                width: 48,
                boxFit: BoxFit.cover,
                imgPath: (cohost.profilePicture?.isNotEmpty ?? false)
                    ? cohost.profilePicture!
                    : ATImgStrings.noAvatarImage),
          ),
          Positioned(
            top: -2,
            right: -4,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  context.read<SelectedCohostsCubit>().removeCohost(cohost),
              child: SvgPicture.asset(
                ATImgStrings.removeCohostIcon,
                width: 24,
                height: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}

