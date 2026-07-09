import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/features/shows/presentation/screens/list_hosted_shows_screen.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HostedProgramsGrid extends StatelessWidget {
  const HostedProgramsGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        const double horizontalPadding = 30;
        const double crossAxisSpacing = 20;
        const double mainAxisSpacing = 20;
        const double childAspectRatio = 0.7;
        const double bottomActionArea = 110;

        final double itemWidth =
            (constraints.maxWidth - horizontalPadding - crossAxisSpacing) / 2;
        final double itemHeight = itemWidth / childAspectRatio;
        final int rows = (itemCount / 2).ceil();
        final double contentHeight = rows == 0
            ? 0
            : (rows * itemHeight) + ((rows - 1) * mainAxisSpacing);
        final double usableHeight = constraints.maxHeight - bottomActionArea;
        final bool canScroll = contentHeight > usableHeight;

        return GridView.builder(
          physics: canScroll
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(15, 0, 15, canScroll ? 100 : 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}

class SelectableProgramCard extends StatelessWidget {
  const SelectableProgramCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const Color accent = Colors.white;
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: 5,
        cornerSmoothing: 0.8,
      ),
      child: Material(
        color: ATColors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: accent.withValues(alpha: 0.08),
          highlightColor: accent.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(2),
            decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 5,
                  cornerSmoothing: 0.8,
                ),
                side: BorderSide(
                  color: isSelected ? accent : ATColors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Stack(
              children: <Widget>[
                child,
                if (isSelected)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: accent.withValues(alpha: 0.07),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RenderHostedShow extends StatelessWidget {
  const RenderHostedShow({super.key, required this.hostedShow});
  final HostedShow hostedShow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints kst) {
      return BlocBuilder<HostedShowSelectionCubit, HostedShow?>(
          builder: (BuildContext blocContext, HostedShow? selected) {
        final bool isSelected = hostedShow.showId == selected?.showId;
        return Align(
          alignment: Alignment.topCenter,
          child: SelectableProgramCard(
            isSelected: isSelected,
            onTap: () {
              blocContext
                  .read<HostedShowSelectionCubit>()
                  .setSelection(show: isSelected ? null : hostedShow);
              if (isSelected) {
                blocContext.read<DominantColorCubit>().reset();
              } else {
                blocContext
                    .read<DominantColorCubit>()
                    .extractColor(hostedShow.coverUrl ?? '');
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
                  padding: const EdgeInsets.only(top: 8),
                  color: ATColors.transparent,
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
                                  hostedShow.createdAt ?? ''),
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
            ClipSmoothRect(
              radius: SmoothBorderRadius(
                cornerRadius: 5,
                cornerSmoothing: 0.8,
              ),
              child: ATShimmer(
                height: kst.maxHeight * 0.65,
                radius: 0,
              ),
            ),
            const SizedBox(height: 10),
            ATShimmer(
              height: 12,
              radius: 3,
              width: kst.maxWidth * 0.78,
            ),
            const SizedBox(
              height: 5,
            ),
            ATShimmer(
              height: 12,
              radius: 3,
              width: kst.maxWidth * 0.52,
            ),
            const SizedBox(height: 10),
            ATShimmer(
              height: 10,
              radius: 3,
              width: kst.maxWidth * 0.64,
            ),
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
        return Align(
          alignment: Alignment.topLeft,
          child: Semantics(
            button: true,
            label: label,
            child: Material(
              color: ATColors.transparent,
              child: InkWell(
                onTap: onTap,
                splashFactory: NoSplash.splashFactory,
                splashColor: ATColors.transparent,
                highlightColor: ATColors.transparent,
                borderRadius: BorderRadius.circular(5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipSmoothRect(
                      radius: SmoothBorderRadius(
                        cornerRadius: 5,
                        cornerSmoothing: 0.8,
                      ),
                      child: ATContainer(
                        radius: 0,
                        color: ATColors.white.withValues(alpha: 0.1),
                        alignment: Alignment.center,
                        width: kst.maxWidth,
                        height: kst.maxHeight * 0.65,
                        child: const ATImgLoader(
                          imgPath: ATImgStrings.createNewProgramPlus,
                          height: 56,
                          width: 56,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
