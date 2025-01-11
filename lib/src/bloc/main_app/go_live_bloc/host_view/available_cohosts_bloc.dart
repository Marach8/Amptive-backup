import 'package:amptive/src/models/host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveGoLiveAvailableCoHostsBloc extends Bloc<AmptiveCohostsEvent, AmptiveCohostsState> {
  final List<HostWithNotifier> hostList;

  AmptiveGoLiveAvailableCoHostsBloc({required this.hostList})
      : super(AmptiveInitialCohosts(initialCohosts: hostList)) {
        
    on<AmptiveSearchCohostEvent>((event, emit) {
      emit(AmptiveCohostsLoadingState());
      final searchKey = event.searchKey.trim().toLowerCase();

      if (searchKey.isEmpty) {
        emit(AmptiveInitialCohosts(initialCohosts: hostList));
      } else {
        final filteredCohosts = hostList.where((coHost) {
          final name = coHost.host.name?.toLowerCase() ?? '';
          final username = coHost.host.username?.toLowerCase() ?? '';
          return name.contains(searchKey) || username.contains(searchKey);
        }).toList();

        emit(AmptiveFilteredCohosts(filteredCohosts: filteredCohosts));
      }
    });
  }
}



abstract class AmptiveCohostsEvent {}

class AmptiveSearchCohostEvent extends AmptiveCohostsEvent {
  final String searchKey;

  AmptiveSearchCohostEvent({this.searchKey = ''});
}


abstract class AmptiveCohostsState {
  final bool isLooading;
  final List<HostWithNotifier>? cohosts;
  
  AmptiveCohostsState(this.isLooading, this.cohosts);
}

class AmptiveInitialCohosts extends AmptiveCohostsState {
  final List<HostWithNotifier> initialCohosts;
  AmptiveInitialCohosts({required this.initialCohosts}):super(
    false, initialCohosts
  );
}

class AmptiveCohostsLoadingState extends AmptiveCohostsState{
  AmptiveCohostsLoadingState(): super(true, null);
}

class AmptiveFilteredCohosts extends AmptiveCohostsState {
  final List<HostWithNotifier> filteredCohosts;
  AmptiveFilteredCohosts({required this.filteredCohosts}): super(
    false, filteredCohosts
  );
}
