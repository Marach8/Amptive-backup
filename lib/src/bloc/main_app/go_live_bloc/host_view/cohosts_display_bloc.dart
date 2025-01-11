import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/host.dart';


class AmptiveGoLiveSelectCoHostBloc extends Cubit<List<HostWithNotifier>>{
  AmptiveGoLiveSelectCoHostBloc(): super(
    List.generate(
      maxCoHost,
      (_) => HostWithNotifier(host: Host.empty())
    )
  );

  static const maxCoHost = 5;

  void hostAddCohost(HostWithNotifier coHost){
    final newState = List<HostWithNotifier>.from(state).where(
      (member) => (member.host.profilePicture ?? '').isNotEmpty
    ).toList();

    if(newState.length < 5 && !newState.contains(coHost)){
      newState.add(coHost);

      final difference = maxCoHost - newState.length;
      newState.addAll(
        List.generate(
          difference,
          (_) => HostWithNotifier(host: Host.empty())
        )
      );

      coHost.notifier.value = true;
      emit(newState);
    }
  }

  void hostAddCohostWithIndex(HostWithNotifier coHost, int index){
    coHost.notifier.value = true;
    final newState = List<HostWithNotifier>.from(state);
    newState[index] = coHost;
    emit(newState);
  }

  void hostRemoveCohost(HostWithNotifier? coHost){
    coHost?.notifier.value = false;
    final newState = List<HostWithNotifier>.from(state);
    newState.remove(coHost);
    newState.add(HostWithNotifier(host: Host.empty()));
    emit(newState);
  }

  void hostRemoveCohostWithIndex(HostWithNotifier? coHost, int index){
    coHost?.notifier.value = false;
    final newState = List<HostWithNotifier>.from(state);
    newState[index] = HostWithNotifier(host: Host.empty());
    emit(newState);
  }
}


