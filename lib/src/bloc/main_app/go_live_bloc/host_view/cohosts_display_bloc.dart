import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/host.dart';


class AmptiveGoLiveSelectCoHostBloc extends Cubit<List<ObjectWithNotifier<Host>>>{
  AmptiveGoLiveSelectCoHostBloc(): super(
    List.generate(
      maxCoHost,
      (_) => ObjectWithNotifier(obj: Host.empty())
    )
  );

  static const maxCoHost = 5;

  void hostAddCohost(ObjectWithNotifier<Host> coHost){
    final newState = List<ObjectWithNotifier<Host>>.from(state).where(
      (member) => (member.obj.profilePicture ?? '').isNotEmpty
    ).toList();

    if(newState.length < 5 && !newState.contains(coHost)){
      newState.add(coHost);

      final difference = maxCoHost - newState.length;
      newState.addAll(
        List.generate(
          difference,
          (_) => ObjectWithNotifier(obj: Host.empty())
        )
      );

      coHost.notifier.value = true;
      emit(newState);
    }
  }

  void hostAddCohostWithIndex(ObjectWithNotifier<Host> coHost, int index){
    coHost.notifier.value = true;
    final newState = List<ObjectWithNotifier<Host>>.from(state);
    newState[index] = coHost;
    emit(newState);
  }

  void hostRemoveCohost(ObjectWithNotifier<Host>? coHost){
    coHost?.notifier.value = false;
    final newState = List<ObjectWithNotifier<Host>>.from(state);
    newState.remove(coHost);
    newState.add(ObjectWithNotifier(obj: Host.empty()));
    emit(newState);
  }

  void hostRemoveCohostWithIndex(ObjectWithNotifier<Host>? coHost, int index){
    coHost?.notifier.value = false;
    final newState = List<ObjectWithNotifier<Host>>.from(state);
    newState[index] = ObjectWithNotifier(obj: Host.empty());
    emit(newState);
  }
}


