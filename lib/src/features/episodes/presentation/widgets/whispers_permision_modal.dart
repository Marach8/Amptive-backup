import 'package:amptive/src/features/go_live/presentation/widgets/hand_raising_permission_modal.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<WhispersState?> controlWhispersModal(
    {required BuildContext context, required String initialWhisper}) async {
  return await showModalBottomSheet<WhispersState>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ATColors.black,
    builder: (BuildContext dContext) {
      return BlocProvider<_WhispersBloc>(
        create: (_) => _WhispersBloc()..initializeWhispers(initialWhisper),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 1,
          builder: (BuildContext bContext, _) {
            return Container(
                margin: const EdgeInsets.fromLTRB(8, kToolbarHeight, 8, 10),
                padding: const EdgeInsets.all(15),
                height: context.screenHeight,
                width: context.screenWidth,
                decoration: BoxDecoration(
                  color: ATColors.hex202020,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    const Align(
                        alignment: Alignment.center, child: ATModalDismisser()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Iconsax.message),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          ATStrings.whispers,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      ATStrings.whispersDesc,
                      maxLines: 5,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      ATStrings.nonAttendeesEncouragedToJoin,
                      maxLines: 5,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: BlocBuilder<_WhispersBloc, WhispersState?>(
                          builder: (_, WhispersState? state) {
                        final bool whispersIsOn =
                            state == WhispersState.turnedOn;
                        final bool whispersIsOff =
                            state == WhispersState.turnedOff;

                        return Column(
                          children: <Widget>[
                            ATContainer(
                              duration: 100,
                              onTap: () =>
                                  bContext.read<_WhispersBloc>().toggleWhispers(
                                        whispersIsOn
                                            ? null
                                            : WhispersState.turnedOn,
                                      ),
                              padding:
                                  const EdgeInsets.fromLTRB(10, 13, 15, 13),
                              radius: 15,
                              color: ATColors.hex2D2D2D,
                              border: Border.all(
                                  width: 2,
                                  color: whispersIsOn
                                      ? ATColors.hex307FE2
                                      : ATColors.transparent),
                              child: Row(
                                children: <Widget>[
                                  ATRadioBtn(isSelected: whispersIsOn),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(ATStrings.turnOn,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    fontSize: ATSizes.size15)),
                                        Text(
                                          maxLines: 5,
                                          ATStrings.whispersEnabled,
                                          style: Theme.of(context)
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
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ATContainer(
                              onTap: () =>
                                  bContext.read<_WhispersBloc>().toggleWhispers(
                                        whispersIsOff
                                            ? null
                                            : WhispersState.turnedOff,
                                      ),
                              padding:
                                  const EdgeInsets.fromLTRB(10, 13, 15, 13),
                              radius: 15,
                              duration: 100,
                              color: ATColors.hex2D2D2D,
                              border: Border.all(
                                  width: 2,
                                  color: whispersIsOff
                                      ? ATColors.hex307FE2
                                      : ATColors.transparent),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      ATRadioBtn(isSelected: whispersIsOff),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(ATStrings.turnOff,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        fontSize:
                                                            ATSizes.size15)),
                                            Text(
                                              maxLines: 5,
                                              ATStrings.whispersDisabled,
                                              style: Theme.of(context)
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
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    BlocBuilder<_WhispersBloc, WhispersState?>(
                        builder: (_, WhispersState? state) {
                      return ATPlainElevatedBtn(
                        onPressed:
                            state == null ? null : () => dContext.pop(state),
                        btnTitle: ATStrings.cContinue,
                      );
                    })
                  ],
                ));
          },
        ),
      );
    },
  );
}

enum WhispersState { turnedOn, turnedOff }

class _WhispersBloc extends Cubit<WhispersState?> {
  _WhispersBloc() : super(null);

  void toggleWhispers(WhispersState? st) => emit(st);

  void initializeWhispers(String initialWhisper) {
    if (initialWhisper == ATStrings.toggleWhispers) {
      emit(null);
    } else {
      if (initialWhisper == ATStrings.turnedOn) {
        emit(WhispersState.turnedOn);
      } else {
        emit(WhispersState.turnedOff);
      }
    }
  }
}






enum WhispersPermission {allow, dontAllow}

Future<WhispersPermission?> showWhispersPermissionModal({
  required BuildContext context,
  WhispersPermission? initialPermission,
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

  final WhispersPermission? initialPermission;
  final ScrollController scrollController;

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
                    ATStrings.whispersDesc,
                    maxLines: 5,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                  ),
                  Text(
                    ATStrings.nonAttendeesEncouragedToJoin,
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
