import 'package:amptive/src/bloc/main_app/profile/profile_menu/calender/calender_programs_bloc.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/show_event_nd_paid_icons.dart';
import 'package:flutter/material.dart';
import '../../../../../../../widgets/common_widgets/overlapping_images.dart';

class CalenderProgramDisplay extends StatelessWidget {
  final CalenderProgram program;
  const CalenderProgramDisplay({
    super.key,
    required this.program
  });

  @override
  Widget build(context) {
    final title = program.name;
    final isEvent = program.isEvent;
    final isPaid = program.isPaid;
    final type = program.eventType;
    final hostsImgs = program.hosts.map((host) => (host.obj as Host).profilePicture ?? '');

    return ATContainer(
      margin: const EdgeInsets.only(left: 55),
      radius: 5, clipBehavior: Clip.hardEdge,
      color: isEvent ? ATColors.hex27E8DB.withValues(alpha: 0.2) 
        : ATColors.hexF79E1E.withValues(alpha: 0.2),
      child: CustomPaint(
        painter:LeftBorderPainter(
          color: isEvent ? ATColors.hex27E8DB : ATColors.hexF79E1E,
          width: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 2, 0, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  isEvent ? const EventIcon() : const ShowIcon(),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ATFontSizes.size13,
                        color: isEvent ? ATColors.hex27E8DB : ATColors.hexF79E1E
                      )
                    ),
                  ),
    
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                    child: ATOverlappingImages(imgPaths: hostsImgs.toList()),
                  )
                ],
              ),
                              
              Row(
                children: [
                  if(isPaid) const PaidIndicatorIcon(),
                  if(isPaid) const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      type,
                      style: Theme.of(context).textTheme.titleSmall
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class LeftBorderPainter extends CustomPainter {
  final Color color;
  final double width;

  LeftBorderPainter({required this.color, this.width = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}