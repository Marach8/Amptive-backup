import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import '../../../../models/host.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/available_cohosts_bloc.dart';
import '../../../../services/create_show/create_show_service.dart';



Future<ATCohost<bool>?> showListenersDialog({
  required BuildContext context,
  bool? enableKickOut
}) async {

  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  final ValueNotifier<bool> showSuffixIconNotifier = ValueNotifier(false);
    focusNode.addListener(
      () => focusNode.hasFocus
        ? showSuffixIconNotifier.value = true
        : showSuffixIconNotifier.value = false
    );

  return await showModalBottomSheet(
    context: context, isScrollControlled: true,
    backgroundColor: ATColors.hex202020,
    builder: (BuildContext dContext) {
      return BlocProvider<SearchkeyCubit>(
        create: (_) => SearchkeyCubit(),
        child: DraggableScrollableSheet(
          expand: false, initialChildSize: 0.7,
          builder: (BuildContext bContext, ScrollController scrollController) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Align(alignment: Alignment.center, child: ATModalDismisser()),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ATImgLoader(imgPath: ATImgStrings.USER_ICON),
                        const SizedBox(width: 5,),
                        Text(
                          ATStrings.LISTENERS,
                          style: context.textTheme.bodyLarge
                        ),
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Text(
                      ATStrings.TOP_LISTENERS_DESC, maxLines: 2,
                      style: context.textTheme.labelSmall!.copyWith(
                        color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
        
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: SearchFieldWithXSuffix(
                      hintText: ATStrings.SEARCH_4_LISTENERS,
                      onClear: (){
                        // bContext.read<SearchkeyBloc>().resetSearch();
                        // dContext.read<CohostServiceBloc>().resetCohostSearch();
                      },
                      onChanged: (String searchKey)=> ATHelperFuncs.callDebouncer(
                        200,
                        () => context.read<AmptiveGoLiveAvailableCoHostsBloc>().add(
                          SearchCohostEvent(searchKey: searchKey)
                        ),
                      ),
                    ),
                  ), 

                  Expanded(
                    child: ATScrollBar(
                      extScrollCntrl: scrollController,
                      child: ListView.builder(
                        primary: true, itemCount: getHostList().length + 1,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(15, 20, 10, 20),
                        itemBuilder: (_, int listIndex){
                          if(listIndex == 0){
                            return Text(
                              ATStrings.TOP_LISTENERS,
                              style: context.textTheme.bodyMedium
                            );
                          }

                          final ObjectWithNotifier<Host> listener = getHostList().elementAt(listIndex - 1);
                          return _ListenerWidget(
                            onTap: (_, __){},
                            listener: listener,
                            index: listIndex,
                            enableKickOut: enableKickOut,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            );
          },
        ),
      );
    },
  );
}



class _ListenerWidget extends StatelessWidget {

  const _ListenerWidget({
    required this.onTap,
    required this.listener,
    required this.index,
    this.enableKickOut
  });
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> listener;
  final bool? enableKickOut;
  final int index;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () => onTap(listener, listener.notifier.value),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: ATImgLoader(
                imgPath: listener.obj.profilePicture!,
                height: 50, width: 50, boxFit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                listener.obj.username ?? '',
                style: context.textTheme.titleMedium
              ),
            ),
            if(enableKickOut ?? true) ATContainer(
              onTap: ()async{
                final bool? shouldKickOut = await showKickOutConfirmationDialog(
                  context: context,
                  title: 'Are you kicking out ${listener.obj.name}?',
                  content: ATStrings.KICK_OUT_DESC,
                  listener: listener
                );

                if((shouldKickOut ?? false) && context.mounted){
                  showAppNotification(
                    context: context,
                    icon: const ATImgLoader(imgPath: ATImgStrings.KICK_USER_OUT),
                    text: '${listener.obj.name} has been kicked out!',
                    bgColor: ATColors.hexECO404,
                  );
                }
              },
              height: 35, width: 35, boxShape: BoxShape.circle,
              color: ATColors.white.withOpacity(0.1),
              child: const ATImgLoader(
                boxFit: BoxFit.scaleDown,
                imgPath: ATImgStrings.KICK_USER_OUT
              ),
            )
          ],
        ),
      ),
    );
  }
}
