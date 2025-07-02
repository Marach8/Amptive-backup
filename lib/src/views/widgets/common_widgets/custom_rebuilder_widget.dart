import 'package:flutter/material.dart';

class AmptiveRebuilderWidget<T> extends StatefulWidget {

  const AmptiveRebuilderWidget({
    super.key,
    required this.builder,
    required this.notifier,
    this.shouldDispose = false,
    this.child
  });
  final ValueNotifier<T> notifier;
  final bool shouldDispose;
  final Widget Function(BuildContext, T, Widget?) builder;
  final Widget? child;

  @override
  State<AmptiveRebuilderWidget<T>> createState() => _AmptiveRebuilderWidgetState<T>();
}

class _AmptiveRebuilderWidgetState<T> extends State<AmptiveRebuilderWidget<T>> {
  late ValueNotifier<T> notifier;

  @override
  void initState() {
    super.initState();
    notifier = widget.notifier;
  }

  @override
  void dispose() {
    widget.shouldDispose ? notifier.dispose() : <dynamic, dynamic>{};
    super.dispose();
  }

  @override
  Widget build(_) => ValueListenableBuilder<T>(
    valueListenable: notifier,
    builder: widget.builder,
    child: widget.child,
  );
}




// class ExampleUsageOfTheRebuilderWidgetAbove extends StatelessWidget {
//   const ExampleUsageOfTheRebuilderWidgetAbove({super.key});

//   @override
//   Widget build(BuildContext context) {
//     ValueNotifier<bool> isSelected = ValueNotifier(false);

//     return AmptiveRebuilderWidget(
//       notifier: isSelected,
//       builder: (_, value, __){
//         return GestureDetector(
//           onTap: (){
//             isSelected.value = !value;
//           },
//           child: Container(
//             color: value ? Colors.red : Colors.green,
//             height: 30,
//             width: AmptiveHelperFunctions.getScreenWidth(context),
//           ),
//         );
//       },
//     );
//   }
// }