import 'package:amptive/src/config/exception.dart';


//API RESPONSE
abstract class ApiResponse<T> {
  const ApiResponse();

  R when<R>({
    required R Function(Successful<T> _) successful,
    required R Function(Unsuccessful<T> _) unSuccessful,
  });
}

class Successful<T> extends ApiResponse<T> {
  Successful({this.data});
  final T? data;

  @override
  R when<R>({
    required R Function(Successful<T> _) successful,
    required R Function(Unsuccessful<T> _) unSuccessful,
  }) => successful(this);
}

class Unsuccessful<T> extends ApiResponse<T> {
  Unsuccessful({required this.error});
  final ATException error;

  @override
  R when<R>({
    required R Function(Successful<T> _) successful,
    required R Function(Unsuccessful<T> _) unSuccessful,
  }) => unSuccessful(this);
}



//APP STATES
sealed class AEAppState<T> {
  const AEAppState();
}

class InitialState<T> extends AEAppState<T> {
  const InitialState({this.initialData});
  final T? initialData;
}

class LoadingState<T> extends AEAppState<T> {
  const LoadingState({this.currentData});
  final T? currentData;
}

class SuccessState<T> extends AEAppState<T> {
  const SuccessState({this.newData, this.message});
  final T? newData;
  final String? message;
}

class FailureState<T> extends AEAppState<T> {
  const FailureState(
    this.message, {
    this.oldData,
    this.failureType = FailureType.apiCallFailure,
  });

  final String message;
  final T? oldData;
  final FailureType failureType;
}

enum FailureType { apiCallFailure, searchFailure, unknownFailure }
