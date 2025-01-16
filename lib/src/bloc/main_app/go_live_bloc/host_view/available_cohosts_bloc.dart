import 'package:amptive/src/models/host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveGoLiveAvailableCoHostsBloc extends Bloc<AmptiveCohostsEvent, AmptiveCohostsState> {
  final List<HostWithNotifier> hostList;

  AmptiveGoLiveAvailableCoHostsBloc({required this.hostList})
      : super(InitialCohostsState(initialCohosts: hostList)) {
        
    on<SearchCohostEvent>((event, emit) {
      emit(CohostsLoadingState());
      final searchKey = event.searchKey.trim().toLowerCase();

      if (searchKey.isEmpty) {
        emit(InitialCohostsState(initialCohosts: hostList));
      } else {
        final filteredCohosts = hostList.where((coHost) {
          final name = coHost.host.name?.toLowerCase() ?? '';
          final username = coHost.host.username?.toLowerCase() ?? '';
          return name.contains(searchKey) || username.contains(searchKey);
        }).toList();

        emit(FilteredCohostsState(filteredCohosts: filteredCohosts));
      }
    });
  }
}



abstract class AmptiveCohostsEvent {}

class SearchCohostEvent extends AmptiveCohostsEvent {
  final String searchKey;

  SearchCohostEvent({this.searchKey = ''});
}


abstract class AmptiveCohostsState {
  final bool isLooading;
  final List<HostWithNotifier>? cohosts;
  
  AmptiveCohostsState(this.isLooading, this.cohosts);
}

class InitialCohostsState extends AmptiveCohostsState {
  final List<HostWithNotifier> initialCohosts;
  InitialCohostsState({required this.initialCohosts}):super(
    false, initialCohosts
  );
}

class CohostsLoadingState extends AmptiveCohostsState{
  CohostsLoadingState(): super(true, null);
}

class FilteredCohostsState extends AmptiveCohostsState {
  final List<HostWithNotifier> filteredCohosts;
  FilteredCohostsState({required this.filteredCohosts}): super(
    false, filteredCohosts
  );
}
