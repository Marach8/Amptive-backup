import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';


import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



Future<WhispersState?> controlWhispersModal({
  required BuildContext context,
  required String initialWhisper
}) async {
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
                  const Align(alignment: Alignment.center, child: ATModalDismisser()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Iconsax.message),
                      const SizedBox(width: 5,),
                      Text(
                        ATStrings.WHISPERS,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Text(
                    ATStrings.WHISPERS_DESC, maxLines: 5,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                    ),
                  ),

                  const SizedBox(height: 15,),
                  Text(
                    ATStrings.NON_ATTENDING_ENCOURAGED_2_JOIN, maxLines: 5,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                    ),
                  ),

                  const SizedBox(height: 15,),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: BlocBuilder<_WhispersBloc, WhispersState?>(
                        builder: (_, WhispersState? state) {
                          final bool whispersIsOn = state == WhispersState.turnedOn;
                          final bool whispersIsOff = state == WhispersState.turnedOff;

                          return Column(
                            children: <Widget>[
                              ATContainer(
                                duration: 100,
                                onTap: () => bContext.read<_WhispersBloc>().toggleWhispers(
                                  whispersIsOn ? null : WhispersState.turnedOn,
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
                                radius: 15, color: ATColors.hex2D2D2D,
                                border: Border.all(
                                  width: 2,
                                  color: whispersIsOn ? ATColors.hex307FE2 : ATColors.transparent
                                ),
                                child: Row(
                                  children: <Widget>[
                                    ATRadioBtn(isSelected: whispersIsOn),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            ATStrings.TURN_ON,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              fontSize: ATSizes.size15
                                            )
                                          ),
                                          Text(
                                            maxLines: 5,
                                            ATStrings.WHISPERS_ENABLED,
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: ATColors.hexC2C2C2, fontSize: ATSizes.size13
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 15,),

                              ATContainer(
                                onTap: () => bContext.read<_WhispersBloc>().toggleWhispers(
                                  whispersIsOff ? null : WhispersState.turnedOff,
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
                                radius: 15, duration: 100, color: ATColors.hex2D2D2D,
                                border: Border.all(
                                  width: 2,
                                  color: whispersIsOff ? ATColors.hex307FE2 : ATColors.transparent
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        ATRadioBtn(isSelected: whispersIsOff),
                                        const SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                ATStrings.TURN_OFF,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontSize: ATSizes.size15
                                                )
                                              ),
                                              Text(
                                                maxLines: 5,
                                                ATStrings.WHISPERS_DISABLED,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: ATColors.hexC2C2C2, fontSize: ATSizes.size13
                                                ),
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
                        }
                      ),
                    )
                  ),
                  const SizedBox(height: 15,),

                  BlocBuilder<_WhispersBloc, WhispersState?>(
                    builder: (_, WhispersState? state) {
                      return ATPlainElevatedBtn(
                        onPressed: state == null ? null : () => dContext.pop(state),
                        btnTitle: ATStrings.cContinue,
                      );
                    }
                  )
                ],
              )
            );
          },
        ),
      );
    },
  );
}



enum WhispersState{turnedOn, turnedOff}
class _WhispersBloc extends Cubit<WhispersState?>{
  _WhispersBloc(): super(null);

  void toggleWhispers(WhispersState? st)
    => emit(st);

  void initializeWhispers(String initialWhisper){
    if(initialWhisper == ATStrings.TOGGLE_WHISPERS){
      emit(null);
    }
    else{
      if(initialWhisper == ATStrings.TURNED_ON){
        emit(WhispersState.turnedOn);
      }
      else{
        emit(WhispersState.turnedOff);
      }
    }
  }
}