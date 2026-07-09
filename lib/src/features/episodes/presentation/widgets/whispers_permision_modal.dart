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
                    descriptionText: descriptionText1,
                    descriptionText2: descriptionText2,
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
    return Stack(
      children: <Widget>[
        Column(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Iconsax.message, size: 18),
                const SizedBox(width: 5),
                Text(
                  ATStrings.whispers,
                  style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: ATSizes.size18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
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
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ATBlurredBgBtn(
            onPressed:_localPermission != null ? (){
              context.pop(_localPermission);
            } : null,
            btnTitle: ATStrings.cContinue,
          ),
        ),
      ],
    );
  }
}
