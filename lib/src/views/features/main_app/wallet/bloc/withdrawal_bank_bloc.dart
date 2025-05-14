import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawalBanksBloc extends Bloc<WithdrawalBanksEvents, WithdrawalBanksState>{
  WithdrawalBanksBloc () : super(WithdrawalBanksInitial()){

    final banks = ['Access Bank', 'First Bank', 'Zenith Bank', 'GT Bank', 'UBA Bank', 'Fidelity Bank'];

    on<FetchBanksEvent>((event, emit)async{
      emit(FetchingBanks());
      await Future.delayed(const Duration(seconds: 5));
      emit(
        WithdrawalBanksData(
          banks: banks,
          selectedBank: null
        )
      );
    });

    on<SearchBanksEvent>((event, emit)async{
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
      final searchResult = banks.where(
        (bank) => bank.toLowerCase().contains(event.query.toLowerCase())
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

    on<SelectBankEvent>((event, emit)async{
      if(state is WithdrawalBanksData){
        final currentState = state as WithdrawalBanksData;
        emit(
          WithdrawalBanksData(
            banks: currentState.banks,
            selectedBank: event.bank
          )
        );
      }
    });

    on<ResetBanksSearchEvent>((_, emit){
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
  final List<String>? banks;
  final String? selectedBank;
  WithdrawalBanksData({
    required this.banks,
    required this.selectedBank
  });
}



abstract class WithdrawalBanksEvents{}

class SearchBanksEvent extends WithdrawalBanksEvents{
  final String query;
  SearchBanksEvent(this.query);
}

class SelectBankEvent extends WithdrawalBanksEvents{
  final String? bank;
  SelectBankEvent(this.bank);
}

class FetchBanksEvent extends WithdrawalBanksEvents{}

class ResetBanksSearchEvent extends WithdrawalBanksEvents{}