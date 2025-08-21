
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../go_live_export.dart';



class HostViewHostNdCohostDisplay extends StatelessWidget {
  const HostViewHostNdCohostDisplay({super.key,});

  @override
  Widget build(BuildContext _) {
    return Builder(
      builder: (BuildContext context) {
        return ATContainer(
          height: 250,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          width: context.screenWidth,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ATColors.black,
              spreadRadius: 10, blurRadius: 40,
              offset: const Offset(0, 40)
            )
          ],
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              final double width = constraints.maxWidth;                  
              return BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
                builder: (_, List<ObjectWithNotifier<Host>> listOfCoHosts) {                
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      const GoLiveHostWidget(
                        top: 6,
                        hostName: 'Emmanuel Nnanna',
                        hostProfilePic: ATImgStrings.jpeg2
                      ),
                      
                      
                      BlocSelector<AddCohostsBloc, List<(ATCohost<bool>, int)>, (ATCohost<bool>, int)>(
                        selector: (List<(ATCohost<bool>, int)> state) => state.elementAt(0),
                        builder: (_, (ATCohost<bool>, int) cohost) {
                          return CohostWidget4HostView(
                            top: 35, left: 0, index: 0,
                            coHostName: cohost.$1.name,
                            coHostProfilePicture: cohost.$1.profilePicture,
                            onTap: () async => await _onCohostTap(cohost: cohost.$1, coHostNo: 0, context: context)
                          );
                        }
                      ),
        
                      BlocSelector<AddCohostsBloc, List<(ATCohost<bool>, int)>, (ATCohost<bool>, int)>(
                        selector: (List<(ATCohost<bool>, int)> state) => state.elementAt(1),
                        builder: (_, (ATCohost<bool>, int) cohost) {
                          return CohostWidget4HostView(
                            top: 35, right: 0, index: 1,
                            coHostName: cohost.$1.name,
                            coHostProfilePicture: cohost.$1.profilePicture,
                            onTap: () async => await _onCohostTap(cohost: cohost.$1, coHostNo: 1, context: context)
                          );
                        }
                      ),
        
                      BlocSelector<AddCohostsBloc, List<(ATCohost<bool>, int)>, (ATCohost<bool>, int)>(
                        selector: (List<(ATCohost<bool>, int)> state) => state.elementAt(2),
                        builder: (_, (ATCohost<bool>, int) cohost) {
                          return CohostWidget4HostView(
                            bottom: 30, right: width * 0.1, index: 2,
                            coHostName: cohost.$1.name,
                            coHostProfilePicture: cohost.$1.profilePicture,
                            onTap: () async => await _onCohostTap(cohost: cohost.$1, coHostNo: 2, context: context)
                          );
                        }
                      ),
        
                      BlocSelector<AddCohostsBloc, List<(ATCohost<bool>, int)>, (ATCohost<bool>, int)>(
                        selector: (List<(ATCohost<bool>, int)> state) => state.elementAt(3),
                        builder: (_, (ATCohost<bool>, int) cohost) {
                          return CohostWidget4HostView(
                            bottom: 30, left: width * 0.1, index: 3,
                            coHostName: cohost.$1.name,
                            coHostProfilePicture: cohost.$1.profilePicture,
                            onTap: () async => await _onCohostTap(cohost: cohost.$1, coHostNo: 3, context: context)
                          );
                        }
                      ),
        
                      BlocSelector<AddCohostsBloc, List<(ATCohost<bool>, int)>, (ATCohost<bool>, int)>(
                        selector: (List<(ATCohost<bool>, int)> state) => state.elementAt(4),
                        builder: (_, (ATCohost<bool>, int) cohost) {
                          return CohostWidget4HostView(
                            bottom: 5, index: 4,
                            coHostName: cohost.$1.name,
                            coHostProfilePicture: cohost.$1.profilePicture,
                            onTap: () async => await _onCohostTap(cohost: cohost.$1, coHostNo: 4, context: context)
                          );
                        }
                      ),
                    ],
                  );
                }
              );
            }
          )
        );
      }
    );
  }
}


Future<void> _onCohostTap({
  required ATCohost<bool> cohost,
  required int coHostNo,
  required BuildContext context,
}) async {
  if(cohost.profilePicture == null){
    final ATCohost<bool>? selectedCohost = 
      await showAvailableCoHostsModal(context: context, selectionMode: CohostSelectionMode.single);
    if (context.mounted && selectedCohost != null) {
      context.read<AddCohostsBloc>().addCohost(cohost: selectedCohost, cohostNo: coHostNo);
    }
  }
  else{
    final bool? removeCohost = await showConfirmationDialog(
      context: context,
      title: '${ATStrings.REMOVE} ${ATStrings.COHOST}',
      content: '${ATStrings.CONFIRM_COHOST_REMOVAL} ${cohost.name}?',
      yesString: ATStrings.REMOVE,
      noString: ATStrings.CANCEL,
    );
    if(context.mounted && removeCohost == true) {
      context.read<AddCohostsBloc>().removeCohost(cohostNo: coHostNo);
    }
  }
}



class AddCohostsBloc extends Cubit<List<(ATCohost<bool>, int)>> {
  AddCohostsBloc() : super(
    List<(ATCohost<bool>, int)>.generate(
      5,
      (int index) => (ATCohost<bool>.empty(), index),
    ),
  );

  void addCohost({required ATCohost<bool> cohost, required int cohostNo}) {
    final List<(ATCohost<bool>, int)> updatedCohosts = List<(ATCohost<bool>, int)>.from(state);

    if (cohostNo >= 0 && cohostNo < updatedCohosts.length) {
      updatedCohosts[cohostNo] = (cohost, cohostNo);
      emit(updatedCohosts);
    }
  }

  void removeCohost({required int cohostNo}) {
    final List<(ATCohost<bool>, int)> updatedCohosts = List<(ATCohost<bool>, int)>.from(state);

    if (cohostNo >= 0 && cohostNo < updatedCohosts.length) {
      updatedCohosts[cohostNo] = (ATCohost<bool>.empty(), cohostNo);
      emit(updatedCohosts);
    }
  }
}
