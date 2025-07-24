import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawalBanksBloc extends Bloc<WithdrawalBanksEvents, WithdrawalBanksState>{
  WithdrawalBanksBloc () : super(WithdrawalBanksInitial()){

    final List<String> banks = <String>['Access Bank', 'First Bank', 'Zenith Bank', 'GT Bank', 'UBA Bank', 'Fidelity Bank'];

    on<FetchBanksEvent>((FetchBanksEvent event, Emitter<WithdrawalBanksState> emit)async{
      emit(FetchingBanks());
      await Future.delayed(const Duration(seconds: 5));
      emit(
        WithdrawalBanksData(
          banks: banks,
          selectedBank: null
        )
      );
    });

    on<SearchBanksEvent>((SearchBanksEvent event, Emitter<WithdrawalBanksState> emit)async{
      if(event.query.isEmpty){
        emit(
          WithdrawalBanksData(
            banks: banks,
            selectedBank: null
          )
        );
        return;
      }

      emit(SearchingBanks());
      await Future.delayed(const Duration(seconds: 3));
      final List<String> searchResult = banks.where(
        (String bank) => bank.toLowerCase().contains(event.query.toLowerCase())
      ).toList();
      
      if(searchResult.isEmpty){
        emit(WithdrawalBanksInitial());
        return;
      }

      emit(
        WithdrawalBanksData(
          banks: searchResult,
          selectedBank: null
        )
      );
    });

    on<SelectBankEvent>((SelectBankEvent event, Emitter<WithdrawalBanksState> emit)async{
      if(state is WithdrawalBanksData){
        final WithdrawalBanksData currentState = state as WithdrawalBanksData;
        emit(
          WithdrawalBanksData(
            banks: currentState.banks,
            selectedBank: event.bank
          )
        );
      }
    });

    on<ResetBanksSearchEvent>((_, Emitter<WithdrawalBanksState> emit){
      emit(
        WithdrawalBanksData(
          banks: banks,
          selectedBank: null
        )
      );
    });
  }
}


abstract class WithdrawalBanksState{}

class WithdrawalBanksInitial extends WithdrawalBanksState{}

class SearchingBanks extends WithdrawalBanksState{}

class FetchingBanks extends WithdrawalBanksState{}

class WithdrawalBanksData extends WithdrawalBanksState{
  WithdrawalBanksData({
    required this.banks,
    required this.selectedBank
  });
  final List<String>? banks;
  final String? selectedBank;
}



abstract class WithdrawalBanksEvents{}

class SearchBanksEvent extends WithdrawalBanksEvents{
  SearchBanksEvent(this.query);
  final String query;
}

class SelectBankEvent extends WithdrawalBanksEvents{
  SelectBankEvent(this.bank);
  final String? bank;
}

class FetchBanksEvent extends WithdrawalBanksEvents{}

class ResetBanksSearchEvent extends WithdrawalBanksEvents{}