import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveSubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState>{
  AmptiveSubscriptionBloc(): super(InitialSubState()){
    on<UnSubscribeEvent>((_, emit) async{
      emit(SubscriptionLoadingState());
      await Future.delayed(const Duration(seconds: 2));
      emit(Ready2SubscribeState());
    });

    on<ReadyToSubscribeEvent>((_, emit) {
      emit(Ready2SubscribeState());
    });

    on<Restet2InitialSubStateEvent>((_, emit) {
      emit(InitialSubState());
    });

    // on<SubscribeEvent>((_, emit) async{
    //   emit(SubscriptionLoadingState());
    //   await Future.delayed(const Duration(seconds: 2));
    //   emit(SubscribedState());
    // });
  }

}


abstract class SubscriptionState{}

class SubscribedState extends SubscriptionState{}

class SubscriptionLoadingState extends SubscriptionState{}

class Ready2SubscribeState extends SubscriptionState{}

//This is the state that will be emitted initially when
//user has not yet followed the host. The subscription button will
//be hidden while in this state.
class InitialSubState extends SubscriptionState{}


abstract class SubscriptionEvent{}

class SubscribeEvent extends SubscriptionEvent{}

class UnSubscribeEvent extends SubscriptionEvent{}

class ReadyToSubscribeEvent extends SubscribeEvent{}

class Restet2InitialSubStateEvent extends SubscribeEvent{}