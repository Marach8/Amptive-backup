import 'package:go_router/go_router.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import '../../../../shared/rich_text.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';

enum HandRaisingPermission {allow, dontAllow}

Future<HandRaisingPermission?> showHandRaisingPermissionModal({
  required BuildContext context,
  HandRaisingPermission? initialPermission,
}) async {
  return await showModalBottomSheet<HandRaisingPermission>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    builder: (BuildContext dContext) {
      return Stack(
        children: <Widget>[
          DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            builder: (_, ScrollController scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                child: Material(
                  color: const Color(0xFF1C1C1E),
                  child: _SubWidget(
                    initialPermission: initialPermission,
                    scrollController: scrollController,
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}


class _SubWidget extends StatefulWidget {
  const _SubWidget({
    this.initialPermission,
    required this.scrollController,
  });

  final HandRaisingPermission? initialPermission;
  final ScrollController scrollController;

  @override
  State<_SubWidget> createState() => _SubWidgetState();
}

class _SubWidgetState extends State<_SubWidget> {
  HandRaisingPermission? _localPermission;

  @override 
  void initState(){
    super.initState();
    _localPermission = widget.initialPermission;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 38,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ATImgLoader(imgPath: ATImgStrings.handRaising, height: 18, width: 18),
                    const SizedBox(width: 5),
                    Text(
                      ATStrings.handRaising,
                      style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: ATSizes.size18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: ATRichText(
                items: <String, TextStyle>{
                  ATStrings.youWillHaveAccessToModerationTools:
                    context.textTheme.labelSmall!.copyWith(
                        color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                  ' ${ATStrings.learnMore}': context.textTheme.labelSmall!
                },
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
                child: Column(
                  spacing: 15,
                  children: <Widget>[
                    SelectionWidgetWithLeadinRadioBtn(
                      isSelected: _localPermission == HandRaisingPermission.allow,
                      title: ATStrings.allow,
                      subtitle: ATStrings.audienceCanRaiseHand,
                      onTap: (bool isSelected){
                        setState(() {
                          _localPermission = isSelected ? null 
                            : HandRaisingPermission.allow;
                        });
                      }
                    ),
                    SelectionWidgetWithLeadinRadioBtn(
                      isSelected: _localPermission == HandRaisingPermission.dontAllow,
                      title: ATStrings.dontAllow,
                      subtitle: ATStrings.audienceCannotRaiseHand,
                      onTap: (bool isSelected){
                        setState(() {
                          _localPermission = isSelected ? null 
                            : HandRaisingPermission.dontAllow;
                        });
                      }
                    ),
                  ],
                )
              )
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ATBlurredBgBtn(
            onPressed: _localPermission != null ? (){
              context.pop(_localPermission);
            } : null,
            btnTitle: ATStrings.cContinue,
          ),
        ),
      ],
    );
  }
}

class SelectionWidgetWithLeadinRadioBtn extends StatelessWidget {
  const SelectionWidgetWithLeadinRadioBtn({
    super.key,
    required this.isSelected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool isSelected;
  final String title, subtitle;
  final ValueChanged<bool> onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      duration: 100,
      onTap: () => onTap(isSelected),
      padding: const EdgeInsets.fromLTRB(18, 13, 15, 13),
      radius: 15,
      color: ATColors.hex2D2D2D,
      border: Border.all(
          width: 2,
          color: isSelected
              ? ATColors.white.withValues(alpha: 0.1)
              : ATColors.transparent),
      child: Row(
        children: <Widget>[
          AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? ATColors.white : ATColors.transparent,
                border: Border.all(color: ATColors.white, width: 2),
                shape: BoxShape.circle,
              ),
              height: 24,
              width: 24,
              child: Icon(Icons.check,
                  size: 20,
                  color: isSelected ? ATColors.hex0D0D0D 
                      : ATColors.transparent)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: context
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                            fontSize: ATSizes.size15)),
                Text(
                  maxLines: 5,
                  subtitle,
                  style: context
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                          color: ATColors.hexC2C2C2,
                          fontSize: ATSizes.size13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
