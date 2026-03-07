import 'package:amptive/src/models/host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveGoLiveAvailableCoHostsBloc
    extends Bloc<AmptiveCohostsEvent, AmptiveCohostsState> {
  AmptiveGoLiveAvailableCoHostsBloc({required this.hostList})
      : super(InitialCohostsState(initialCohosts: hostList)) {
    on<SearchCohostEvent>(
        (SearchCohostEvent event, Emitter<AmptiveCohostsState> emit) {
      emit(CohostsLoadingState());
      final String searchKey = event.searchKey.trim().toLowerCase();

      if (searchKey.isEmpty) {
        emit(InitialCohostsState(initialCohosts: hostList));
      } else {
        final List<ObjectWithNotifier<Host>> filteredCohosts =
            hostList.where((ObjectWithNotifier<Host> coHost) {
          final String name = coHost.obj.name?.toLowerCase() ?? '';
          final String username = coHost.obj.username?.toLowerCase() ?? '';
          return name.contains(searchKey) || username.contains(searchKey);
        }).toList();

        emit(FilteredCohostsState(filteredCohosts: filteredCohosts));
      }
    });
  }
  final List<ObjectWithNotifier<Host>> hostList;
}

abstract class AmptiveCohostsEvent {}

class SearchCohostEvent extends AmptiveCohostsEvent {
  SearchCohostEvent({this.searchKey = ''});
  final String searchKey;
}

abstract class AmptiveCohostsState {
  AmptiveCohostsState(this.isLooading, this.cohosts);
  final bool isLooading;
  final List<ObjectWithNotifier<Host>>? cohosts;
}

class InitialCohostsState extends AmptiveCohostsState {
  InitialCohostsState({required this.initialCohosts})
      : super(false, initialCohosts);
  final List<ObjectWithNotifier<Host>> initialCohosts;
}

class CohostsLoadingState extends AmptiveCohostsState {
  CohostsLoadingState() : super(true, null);
}

class FilteredCohostsState extends AmptiveCohostsState {
  FilteredCohostsState({required this.filteredCohosts})
      : super(false, filteredCohosts);
  final List<ObjectWithNotifier<Host>> filteredCohosts;
}
