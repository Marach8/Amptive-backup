import 'package:go_router/go_router.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import '../../../../shared/rich_text.dart';

enum HandRaisingPermission {allow, dontAllow}

Future<HandRaisingPermission?> showHandRaisingPermissionModal({
  required BuildContext context,
  HandRaisingPermission? initialPermission,
}) async {
  return await showModalBottomSheet<HandRaisingPermission>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: ATColors.hex202020,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (BuildContext dContext) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (_, ScrollController scrollController) {
          return _SubWidget(
            initialPermission: initialPermission,
            scrollController: scrollController,
          );
        },
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      child: Column(
        children: <Widget>[
          const ATModalDismisser(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.front_hand_outlined),
              const SizedBox(width: 5),
              Text(
                ATStrings.handRaising,
                style: context.textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 15),
          ATRichText(
            items: <String, TextStyle>{
              ATStrings.youWillHaveAccessToModerationTools:
                context.textTheme.labelSmall!.copyWith(
                    color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
              ' ${ATStrings.learnMore}': context.textTheme.labelSmall!
            },
          ),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                spacing: 15,
                children: <Widget>[
                  _SelectionWidget(
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
                  _SelectionWidget(
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
      
          ATPlainElevatedBtn(
            onPressed:_localPermission != null ? (){
              context.pop(_localPermission);
            } : null,
            btnTitle: ATStrings.cContinue,
          ),
          const SizedBox(height: 56),
        ],
      ),
    );
  }
}

class _SelectionWidget extends StatelessWidget {
  const _SelectionWidget({
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
      padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
      radius: 15,
      color: ATColors.hex2D2D2D,
      border: Border.all(
          width: 2,
          color: isSelected
              ? ATColors.hex307FE2
              : ATColors.transparent),
      child: Row(
        children: <Widget>[
          ATRadioBtn(isSelected: isSelected),
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
