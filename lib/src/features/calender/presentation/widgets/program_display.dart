import 'package:amptive/src/features/calender/v_model/calender_programs_bloc.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/show_event_nd_paid_icons.dart';
import 'package:flutter/material.dart';


class CalenderProgramDisplay extends StatelessWidget {
  const CalenderProgramDisplay({
    super.key,
    required this.program
  });
  final CalenderProgram program;

  @override
  Widget build(BuildContext context) {
    final String title = program.name;
    final bool isEvent = program.isEvent;
    final bool isPaid = program.isPaid;
    final String type = program.eventType;
    final Iterable<String> hostsImgs = program.hosts.map((ObjectWithNotifier host) => (host.obj as Host).profilePicture ?? '');

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
            children: <Widget>[
              Row(
                children: <Widget>[
                  isEvent ? const EventIcon() : const ATShowIcon(),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ATSizes.size13,
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
                children: <Widget>[
                  if(isPaid) const ATPaidIndicatorIcon(),
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

  LeftBorderPainter({required this.color, this.width = 3.0});
  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}