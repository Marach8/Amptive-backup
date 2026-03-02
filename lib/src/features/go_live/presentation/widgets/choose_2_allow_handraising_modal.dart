import 'package:go_router/go_router.dart';

import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/rich_text.dart';


Future<String?> choose2AllowHandRaisingModal({
  required BuildContext context,
  required String initialHandRaising
}) async {
  return await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ATColors.black,
    builder: (BuildContext dContext) {
      return BlocProvider<_HandRaisingBloc>(
        create: (_) => _HandRaisingBloc()..initializeHandRaising(initialHandRaising),
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
                      const Icon(Icons.front_hand_outlined),
                      const SizedBox(width: 5,),
                      Text(
                        ATStrings.handRaising,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  
                  ATRichText(
                    items: <String, TextStyle>{
                      ATStrings.U_WILL_HAVE_ACCESS_2_MODERATION_TOOLS: context.textTheme.labelSmall!.copyWith(
                        color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                      ),
                      ' ${ATStrings.learnMore}': context.textTheme.labelSmall!
                    },
                  ),

                  const SizedBox(height: 15,),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: BlocBuilder<_HandRaisingBloc, String?>(
                        builder: (_, String? state) {
                          final bool shouldAllow = state == ATStrings.ALLOW;
                          final bool shouldNotAllow = state == ATStrings.DONT_ALLOW;

                          return Column(
                            children: <Widget>[
                              ATContainer(
                                duration: 100,
                                onTap: () => bContext.read<_HandRaisingBloc>().chooseHandRaising(
                                  shouldAllow ? null : ATStrings.ALLOW,
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
                                radius: 15, color: ATColors.hex2D2D2D,
                                border: Border.all(
                                  width: 2,
                                  color: shouldAllow ? ATColors.hex307FE2 : ATColors.transparent
                                ),
                                child: Row(
                                  children: <Widget>[
                                    ATRadioBtn(isSelected: shouldAllow),
                                    const SizedBox(width: 15,),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            ATStrings.ALLOW,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              fontSize: ATSizes.size15
                                            )
                                          ),
                                          Text(
                                            maxLines: 5,
                                            ATStrings.AUDIENCE_CAN_RAISE_HAND,
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
                                onTap: () => bContext.read<_HandRaisingBloc>().chooseHandRaising(
                                  shouldNotAllow ? null : ATStrings.DONT_ALLOW,
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
                                radius: 15, duration: 100, color: ATColors.hex2D2D2D,
                                border: Border.all(
                                  width: 2,
                                  color: shouldNotAllow ? ATColors.hex307FE2 : ATColors.transparent
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        ATRadioBtn(isSelected: shouldNotAllow),
                                        const SizedBox(width: 15,),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                ATStrings.DONT_ALLOW,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontSize: ATSizes.size15
                                                )
                                              ),
                                              Text(
                                                maxLines: 5,
                                                ATStrings.AUDIENCE_CANNOT_RAISE_HAND,
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

                  BlocBuilder<_HandRaisingBloc, String?>(
                    builder: (_, String? state) {
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



class _HandRaisingBloc extends Cubit<String?>{
  _HandRaisingBloc(): super(null);

  void chooseHandRaising(String? type)
    => emit(type);

  void initializeHandRaising(String initialHandRasing){
    if(initialHandRasing == ATStrings.choose2AllowHandRasing){
      emit(null);
    }
    else{
      emit(initialHandRasing);
    }
  }
}