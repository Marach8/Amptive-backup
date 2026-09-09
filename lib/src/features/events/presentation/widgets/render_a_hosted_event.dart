import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/events/presentation/screens/list_hosted_events_screen.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenderHostedEvent extends StatelessWidget {
  const RenderHostedEvent({super.key, required this.hostedEvent});
  final HostedEvent hostedEvent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints kst) {
      return BlocBuilder<HostedEventSelectionCubit, HostedEvent?>(
          builder: (BuildContext blocContext, HostedEvent? selected) {
        final bool isSelected = hostedEvent.eventId == selected?.eventId;
        return ATContainer(
          duration: 200,
          onTap: () => blocContext
              .read<HostedEventSelectionCubit>()
              .setSelection(event: isSelected ? null : hostedEvent),
          radius: 5,
          border: Border.all(
            color: isSelected ? ATColors.hex307FE2 : ATColors.transparent,
            width: 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: hostedEvent.coverUrl ?? '',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ATImgLoader(
                    boxFit: BoxFit.fill,
                    height: kst.maxHeight * 0.65,
                    width: context.screenWidth,
                    imgPath: hostedEvent.coverUrl ?? '',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                color: isSelected ? ATColors.hex1F1F23 : ATColors.transparent,
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
                            fontSize: 13,
                            color: ATColors.hexA8A8A8,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CircleAvatar(
                            radius: 2.5,
                            backgroundColor: ATColors.hexA8A8A8,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            ATHelperFuncs.formatDateOrTime(
                                hostedEvent.createdAt ?? ''),
                            style: context.textTheme.titleSmall?.copyWith(
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
        );
      });
    });
  }
}
