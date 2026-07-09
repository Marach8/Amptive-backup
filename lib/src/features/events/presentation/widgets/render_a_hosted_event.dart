import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/features/events/presentation/screens/list_hosted_events_screen.dart';
import 'package:amptive/src/features/shows/presentation/widgets/render_hosted_show.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenderHostedEvent extends StatelessWidget {
  const RenderHostedEvent({super.key, required this.hostedEvent});
  final HostedEvent hostedEvent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints kst) {
      return BlocBuilder<HostedEventSelectionCubit, HostedEvent?>(
          builder: (BuildContext blocContext, HostedEvent? selected) {
        final bool isSelected = hostedEvent.eventId == selected?.eventId;
        return Align(
          alignment: Alignment.topCenter,
          child: SelectableProgramCard(
            isSelected: isSelected,
            onTap: () {
              blocContext
                  .read<HostedEventSelectionCubit>()
                  .setSelection(event: isSelected ? null : hostedEvent);
              if (isSelected) {
                blocContext.read<DominantColorCubit>().reset();
              } else {
                blocContext
                    .read<DominantColorCubit>()
                    .extractColor(hostedEvent.coverUrl ?? '');
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipSmoothRect(
                  radius: SmoothBorderRadius(
                    cornerRadius: 5,
                    cornerSmoothing: 0.8,
                  ),
                  child: Hero(
                    tag: hostedEvent.eventId ?? '',
                    child: ATImgLoader(
                      boxFit: BoxFit.fill,
                      height: kst.maxHeight * 0.65,
                      width: context.screenWidth,
                      imgPath: hostedEvent.coverUrl ?? '',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  color: ATColors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        maxLines: 2,
                        hostedEvent.title ?? '',
                        textAlign: TextAlign.start,
                        style: context.textTheme.bodyMedium,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Created',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontSize: ATSizes.size13,
                              color: ATColors.hexA8A8A8,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 2,
                              backgroundColor: ATColors.hexA8A8A8,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              ATHelperFuncs.formatDate(
                                  hostedEvent.createdAt ?? ''),
                              style: context.textTheme.titleSmall?.copyWith(
                                fontSize: ATSizes.size13,
                                color: ATColors.hexA8A8A8,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
    });
  }
}
