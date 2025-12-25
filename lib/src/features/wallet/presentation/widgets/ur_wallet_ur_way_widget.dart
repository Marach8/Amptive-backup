import 'package:amptive/src/config/config_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UrWalletUrWayWidget extends StatelessWidget {
  const UrWalletUrWayWidget({
    super.key,
    required this.onDone,
  });

  final VoidCallback onDone;

  static const List<String> _list = <String>[ATStrings.UR_WALLET, ATStrings.UR_WAY];
  @override
  Widget build(BuildContext context) {
    return BlocProvider<_PrivateBloc>(
      create: (_) => _PrivateBloc(),
      child: Builder(
        builder: (BuildContext ctx) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_){
              Future<void>.delayed(
                const Duration(milliseconds: 1500),
                (){
                  if(ctx.mounted){
                    ctx.read<_PrivateBloc>().triggerNext(0);
                  }
                }
              );
            }
          );

          return BlocListener<_PrivateBloc, List<bool>>(
            listener: (_, List<bool> state){
              if(state.elementAt(1)){
                onDone();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: _list.indexed.map(
                ((int, String) item) => _CustomWidget(text: item.$2, index: item.$1)
              ).toList(),
            ),
          );
        }
      ),
    );
  }
}

class _CustomWidget extends StatelessWidget {
  const _CustomWidget({
    required this.text,
    required this.index
  });
  final String text;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<_PrivateBloc, List<bool>, bool>(
      selector: (List<bool> state) => state.elementAt(index),
      builder: (_, bool isVisible) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isVisible ? 1 : 0, curve: Curves.decelerate,
          onEnd: () => isVisible ? context.read<_PrivateBloc>().triggerNext(index + 1): null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              text.toUpperCase(),
              style: context.textTheme.displayMedium?.copyWith(
                color: ATColors.hexC2C2C2,
                fontSize: 38, height: 1,
                fontWeight: ATFontWeights.w800
              ),
            )
          ),
        );
      }
    );
  }
}



class _PrivateBloc extends Cubit<List<bool>>{
  _PrivateBloc(): super(List<bool>.generate(2,(_) => false));
  
  void triggerNext(int newIndex)async{
    final List<bool> currentState = List<bool>.from(state);
    currentState[newIndex] = true;
    emit(currentState);
  }
}