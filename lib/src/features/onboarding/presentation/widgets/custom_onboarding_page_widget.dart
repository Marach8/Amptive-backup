import 'package:amptive/src/global_export.dart';
import '../../../../shared/image_loader_widget.dart';

class CustomOnboardPageWidget extends StatelessWidget {
  const CustomOnboardPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.pictureBgColor,
  });

  final String title;
  final String description;
  final Color? pictureBgColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              color: pictureBgColor,
              width: context.screenWidth,
              height: context.screenHeight * 0.65,
              child: const ATImgLoader(
                imgPath: ATImgStrings.emptyImage,
                boxFit: BoxFit.scaleDown,
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: ATSizes.size24,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text(
              description,
              maxLines: 7,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: ATColors.hexC2C2C2,
                    height: 1.5,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
