import 'package:flutter/material.dart';

class AmptiveRebuilderWidget<T> extends StatefulWidget {
  final ValueNotifier<T> notifier;
  final Widget Function(BuildContext, T, Widget?) builder;
  final Widget? child;

  const AmptiveRebuilderWidget({
    super.key,
    required this.builder,
    required this.notifier,
    this.child
  });

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
    //notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: widget.builder,
      child: widget.child,
    );
  }
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