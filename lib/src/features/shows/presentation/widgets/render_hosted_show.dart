import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/presentation/screens/list_hosted_shows_screen.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenderHostedShow extends StatelessWidget {
  const RenderHostedShow({super.key, required this.hostedShow});
  final HostedShow hostedShow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints kst) {
      return BlocBuilder<HostedShowSelectionCubit, HostedShow?>(
          builder: (BuildContext blocContext, HostedShow? selected) {
        final bool isSelected = hostedShow.showId == selected?.showId;
        return ATContainer(
          duration: 200,
          onTap: () => blocContext
              .read<HostedShowSelectionCubit>()
              .setSelection(show: isSelected ? null : hostedShow),
          radius: 5,
          border: Border.all(
            color: isSelected ? ATColors.hex307FE2 : ATColors.transparent,
            width: 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Hero(
                  tag: hostedShow.showId ?? '',
                  child: ATImgLoader(
                    boxFit: BoxFit.fill,
                    height: kst.maxHeight * 0.65,
                    width: context.screenWidth,
                    imgPath: hostedShow.coverUrl ?? '',
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
                      hostedShow.title ?? '',
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
                                hostedShow.createdAt ?? ''),
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

class RenderAHostedEventOrShowShimmer extends StatelessWidget {
  const RenderAHostedEventOrShowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints kst) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: ATColors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ATShimmer(
              height: kst.maxHeight * 0.65,
              radius: 8,
            ),
            const SizedBox(height: 10),
            ATShimmer(
              height: 12,
              radius: 3,
              width: ATHelperFuncs.getRandomNumber(kst.maxWidth),
            ),
            const SizedBox(
              height: 5,
            ),
            ATShimmer(
              height: 12,
              radius: 3,
              width: ATHelperFuncs.getRandomNumber(kst.maxWidth),
            ),
            const SizedBox(height: 10),
            const ATShimmer(height: 10, radius: 3),
          ],
        ),
      );
    });
  }
}




class CreateNewEventOrShowWidget extends StatelessWidget {
  const CreateNewEventOrShowWidget({
    super.key,
    required this.onTap,
    required this.label,
  });

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints kst) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ATContainer(
            onTap: onTap,
            radius: 5,
            color: ATColors.hex2D2D2D,
            width: context.screenWidth,
            height: kst.maxHeight * 0.65,
            child: const Icon(Icons.add, size: 100),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: context.textTheme.bodyMedium,
          ),
        ],
      );
    });
  }
}

