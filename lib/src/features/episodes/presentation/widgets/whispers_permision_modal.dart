import 'package:amptive/src/features/go_live/presentation/widgets/hand_raising_permission_modal.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';


enum WhispersPermission {allow, dontAllow}

Future<WhispersPermission?> showWhispersPermissionModal({
  required BuildContext context,
  WhispersPermission? initialPermission,
  String? descriptionText1,
  String? descriptionText2,
}) async {
  return await showModalBottomSheet<WhispersPermission>(
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
            descriptionText: descriptionText1,
            descriptionText2: descriptionText2,
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
    this.descriptionText,
    this.descriptionText2,
  });

  final WhispersPermission? initialPermission;
  final ScrollController scrollController;
  final String? descriptionText, descriptionText2;

  @override
  State<_SubWidget> createState() => _SubWidgetState();
}

class _SubWidgetState extends State<_SubWidget> {
  WhispersPermission? _localPermission;

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
              const Icon(Iconsax.message),
              const SizedBox(width: 5),
              Text(
                ATStrings.whispers,
                style: context.textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                spacing: 15,
                children: <Widget>[
                  Text(
                    widget.descriptionText ?? ATStrings.whispersDesc,
                    maxLines: 5,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                  ),
                  Text(
                    widget.descriptionText2 ?? ATStrings.nonAttendeesEncouragedToJoin,
                    maxLines: 5,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                  ),
                  SelectionWidgetWithLeadinRadioBtn(
                    isSelected: _localPermission == WhispersPermission.allow,
                    title: ATStrings.turnOn,
                    subtitle: ATStrings.whispersEnabled,
                    onTap: (bool isSelected){
                      setState(() {
                        _localPermission = isSelected ? null 
                          : WhispersPermission.allow;
                      });
                    }
                  ),
                  SelectionWidgetWithLeadinRadioBtn(
                    isSelected: _localPermission == WhispersPermission.dontAllow,
                    title: ATStrings.turnOff,
                    subtitle: ATStrings.whispersDisabled,
                    onTap: (bool isSelected){
                      setState(() {
                        _localPermission = isSelected ? null 
                          : WhispersPermission.dontAllow;
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
