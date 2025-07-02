import 'package:flutter_bloc/flutter_bloc.dart';

class AmptiveEndShowBloc extends Bloc<EndShowEvent, EndShowState>{
  AmptiveEndShowBloc(): super(ConfirmEndShowState()){
    on<Proceed2EndShowEvent>((_, Emitter<EndShowState> emit){
      emit(EndShowIsLoadingState());
    });

    on<ShowNoOfListenersEvent>((_, Emitter<EndShowState> emit){
      emit(ShowNoOfListenersState());
    });

    on<ShowNoOfGiftsEvent>((_, Emitter<EndShowState> emit){
      emit(ShowNoOfGiftsState());
    });

    on<ShowBlankScreenEvent>((_, Emitter<EndShowState> emit){
      emit(ShowBlankScreenState());
    });

    on<Reset2IntialStateEvent>((_, Emitter<EndShowState> emit){
      emit(ConfirmEndShowState());
    });
  }

}


abstract class EndShowState{}

class ConfirmEndShowState extends EndShowState{}

class EndShowIsLoadingState extends EndShowState{}

class ShowNoOfListenersState extends EndShowState{}

class ShowNoOfGiftsState extends EndShowState{}

class ShowBlankScreenState extends EndShowState{}




abstract class EndShowEvent{}

class Proceed2EndShowEvent extends EndShowEvent{}

class ShowNoOfListenersEvent extends EndShowEvent{}

class ShowNoOfGiftsEvent extends EndShowEvent{}

class ShowBlankScreenEvent extends EndShowEvent{}

class Reset2IntialStateEvent extends EndShowEvent{}

