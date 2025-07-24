import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CohostServiceBloc extends Cubit<(List<ATCohost<bool>>, List<ATCohost<bool>>)>{
  CohostServiceBloc() : super((initialCohosts, initialSelectedCohosts));

  static List<ATCohost<bool>> initialCohosts = getCoHostList();
  static List<ATCohost<bool>> initialSelectedCohosts = List<ATCohost<bool>>.filled(
    5, ATCohost<bool>.empty());

  void addCohost(ATCohost<bool> incomingCohost) {
    final List<ATCohost<bool>> newCoHosts = List<ATCohost<bool>>.from(state.$2);

    final int noOfAddedCoHosts = newCoHosts.where(
      (ATCohost<bool> coHost) => coHost.profilePicture != null
    ).length;

    if(noOfAddedCoHosts == 5) return;
    
    final int firstEmptyIndex = newCoHosts.indexWhere(
      (ATCohost<bool> cohost) => cohost.profilePicture == null
    );
    
    if (firstEmptyIndex != -1) {
      incomingCohost.updateNotifier(true);
      newCoHosts[firstEmptyIndex] = incomingCohost;
      emit((state.$1, newCoHosts));
    }
  }

  void removeCohost(ATCohost<bool> outGoingCohost){
    final List<ATCohost<bool>> copyOfState = List<ATCohost<bool>>.from(state.$2);
    if(!copyOfState.contains(outGoingCohost)) return;

    final List<ATCohost<bool>> newCoHosts = copyOfState.where(
      (ATCohost<bool> cohost) => cohost.id != outGoingCohost.id,
    ).toList();

    newCoHosts.add(ATCohost<bool>.empty());
    outGoingCohost.updateNotifier(false);
    
    emit((state.$1, newCoHosts));
  }

  void searchCoHosts(String searchKey){
    final List<ATCohost<bool>> filterCoHosts = initialCohosts.where(
      (ATCohost<bool> coHost) 
      => coHost.name!.toLowerCase().contains(searchKey.toLowerCase()) 
      || coHost.username!.toLowerCase().contains(searchKey.toLowerCase())
    ).toList();

    emit((filterCoHosts, state.$2));
  }

  void resetBloc() => emit((initialCohosts, initialSelectedCohosts));

  void resetCohostSearch() => emit((initialCohosts, state.$2));
}