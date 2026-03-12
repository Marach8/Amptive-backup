import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';

class CohostWithCheckIconWidget extends StatelessWidget {
  const CohostWithCheckIconWidget({
    super.key,
    required this.cohost,
    required this.isSelected,
    required this.onTap,
  });

  final User cohost;
  final bool isSelected;
  final ValueChanged<bool> onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      radius: 10,
      onTap: () => onTap(isSelected),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ATImgLoader(
              height: 50,
              width: 50,
              boxFit: BoxFit.cover,
              imgPath: cohost.profilePicture ?? ATImgStrings.jpeg1,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ATFilterWidget<SearchkeyCubit>(
                    title: cohost.name ?? '',
                    style: context.textTheme.bodySmall
                        ?.copyWith(fontSize: ATSizes.size15)),
                ATFilterWidget<SearchkeyCubit>(
                  title: cohost.username ?? '',
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: ATColors.hexC2C2C2),
                ),
              ],
            ),
          ),
          AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? ATColors.white : ATColors.transparent,
                border: Border.all(color: ATColors.white),
                shape: BoxShape.circle,
              ),
              height: 24,
              width: 24,
              child: Icon(Icons.check,
                  size: 20,
                  color:
                      isSelected ? ATColors.hex0D0D0D : ATColors.transparent))
        ],
      ),
    );
  }
}

class CohostWithCheckIconShimmer extends StatelessWidget {
  const CohostWithCheckIconShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: LayoutBuilder(builder: (_, BoxConstraints kst) {
        return Row(
          children: <Widget>[
            const ATShimmer(
              height: 50,
              width: 50,
              radius: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: <Widget>[
                  ATShimmer(
                    height: 12,
                    radius: 4,
                    width: ATHelperFuncs.getRandomNumber(kst.maxWidth * 0.7),
                  ),
                  ATShimmer(
                    height: 10,
                    radius: 2,
                    width: ATHelperFuncs.getRandomNumber(kst.maxWidth * 0.7),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const ATShimmer(
              height: 24,
              width: 24,
              radius: 12,
            ),
          ],
        );
      }),
    );
  }
}
