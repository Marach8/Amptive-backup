import '../../../../global_export.dart';
import '../../../../shared/image_loader_widget.dart';

class NotifTile1 extends StatelessWidget {
  const NotifTile1({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rightPicSize,
    required this.timeFontSize,
    required this.subTitleFontSize,
    required this.titleFontSize,
    required this.horizMargin,
    required this.leftPicSize,
    required this.rightImgPath,
    required this.time,
  });

  final String title, subtitle, rightImgPath, time;
  final double rightPicSize,
      leftPicSize,
      titleFontSize,
      subTitleFontSize,
      timeFontSize,
      horizMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(horizMargin, 0, horizMargin, 8),
      decoration: BoxDecoration(
          color: ATColors.hex252525.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        spacing: 8,
        children: <Widget>[
          Container(
            height: leftPicSize,
            width: leftPicSize,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: ATColors.black, borderRadius: BorderRadius.circular(7)),
            child: const ATImgLoader(
              imgPath: ATImgStrings.AMPTIVE_LOGO,
              boxFit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: <Widget>[
                Expanded(
                  child: _TitleAndSubTitle(
                      key: ValueKey<String>(title),
                      title: title,
                      titleFontSize: titleFontSize,
                      subtitle: subtitle,
                      subTitleFontSize: subTitleFontSize),
                ),
                _TimeAndPicture(
                    key: ValueKey<String>(time),
                    time: time,
                    timeFontSize: timeFontSize,
                    rightPicSize: rightPicSize,
                    rightImgPath: rightImgPath)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeAndPicture extends StatelessWidget {
  const _TimeAndPicture({
    super.key,
    required this.time,
    required this.timeFontSize,
    required this.rightPicSize,
    required this.rightImgPath,
  });

  final String time;
  final double timeFontSize;
  final double rightPicSize;
  final String rightImgPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      spacing: 3,
      children: <Widget>[
        Text(
          time,
          style: context.textTheme.titleSmall!
              .copyWith(fontSize: timeFontSize, color: ATColors.hexC2C2C2),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: ATImgLoader(
            height: rightPicSize,
            width: rightPicSize,
            imgPath: rightImgPath,
            boxFit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class _TitleAndSubTitle extends StatelessWidget {
  const _TitleAndSubTitle({
    super.key,
    required this.title,
    required this.titleFontSize,
    required this.subtitle,
    required this.subTitleFontSize,
  });

  final String title;
  final double titleFontSize;
  final String subtitle;
  final double subTitleFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style:
              context.textTheme.bodyMedium!.copyWith(fontSize: titleFontSize),
        ),
        Text(
          subtitle,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleSmall!.copyWith(
            fontSize: subTitleFontSize,
          ),
        ),
      ],
    );
  }
}
