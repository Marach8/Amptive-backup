import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import '../../../../views/widgets/common_widgets/circle_avatar.dart';

class CohostWidget4HostView extends StatelessWidget {
  const CohostWidget4HostView({
    super.key,
    this.top, this.bottom,
    this.left, this.right,
    this.coHostName,
    this.coHostProfilePicture,
    required this.index,
    required this.onTap,
  });

  final double? top, bottom, left, right;
  final String? coHostName, coHostProfilePicture;
  final int index;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    final bool showAddIcon = coHostProfilePicture == null;
    return Positioned(
      top: top, left: left, right: right, bottom: bottom,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            showAddIcon ? ATContainer(
              height: 64, width: 64, radius: 40,
              border: Border.all(color: ATColors.white.withValues(alpha: 0.2), width: 2),
              child: const Icon(Icons.add, size: 40)) 
            : Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                ATCircularImage(
                  diameter: 64, addBorder: true,
                  borderColor: ATColors.white,
                  borderWidth: 1, picturePadding: 2,
                  imagePath: coHostProfilePicture!,
                ),
                Positioned(
                  bottom: 0, right: 5,
                  child: ATCircleAvatar(
                    diameter: 20,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Icon(
                        Icons.mic_off, size: 15,
                        color: ATColors.hex0D0D0D,
                      )
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 5,),
            SizedBox(
              width: 80,
              child: Text(
                coHostName ?? ATStrings.ADD_CO_HOST.toLowerCase(),
                textAlign: TextAlign.center,
                style: context.textTheme.titleSmall?.copyWith(
                  height: 0.8
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}




class GoLiveHostWidget extends StatelessWidget {
  const GoLiveHostWidget({
    super.key,
    this.top, this.bottom,
    this.left, this.right,
    required this.hostName,
    required this.hostProfilePic
  });

  final double? top, bottom, left, right;
  final String hostName, hostProfilePic;


  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, left: left, right: right, bottom: bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              ATCircularImage(
                diameter: 94, addBorder: true,
                borderColor: ATColors.white,
                borderWidth: 2, picturePadding: 2,
                imagePath: hostProfilePic
              ),
              Positioned(
                bottom: 0, right: 5,
                child: ATCircleAvatar(
                  diameter: 20,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.mic_off, size: 15,
                      color: ATColors.hex0D0D0D,
                    )
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          SizedBox(
            width: 100,
            child: Text(
              hostName,
              textAlign: TextAlign.center,
              style: context.textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 5,),
          ATContainer(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            radius: 5, 
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                ATColors.hexF91880,
                ATColors.orangeGradientColorB
              ]
            ),
            child: Text(
              ATStrings.HOST.toUpperCase(),
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: ATFontSizes.size10,
              )
            ),
          ),
        ],
      )
    );
  }
}
