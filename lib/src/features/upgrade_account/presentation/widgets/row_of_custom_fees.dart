import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart'
    show ContextExt;
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';

class RowOfCustomFees extends StatefulWidget {
  const RowOfCustomFees({
    super.key,
    required this.onFeeTap,
    this.initialSelectedFee,
  });

  final void Function(int) onFeeTap;
  final int? initialSelectedFee;

  @override
  State<RowOfCustomFees> createState() => _RowOfCustomFeesState();
}

class _RowOfCustomFeesState extends State<RowOfCustomFees> {
  int? _selectedFee;

  @override
  void initState() {
    super.initState();
    _selectedFee = widget.initialSelectedFee;
  }

  @override
  Widget build(BuildContext context) {
    final List<int> list = <int>[100, 500, 1000, 5000, 10000];

    return SizedBox(
      height: 30,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: list.map((int item) {
              return ATContainer(
                onTap: () => setState(() {
                  _selectedFee = item;
                  widget.onFeeTap(item);
                }),
                duration: 50,
                key: ValueKey<int>(item),
                radius: 10,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                border: _selectedFee == item
                    ? Border.all(color: ATColors.white)
                    : null,
                color: ATColors.white.withValues(alpha: 0.1),
                child: Center(
                  child: Text('N$item',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: ATSizes.size11,
                        color: _selectedFee == item
                            ? ATColors.white
                            : ATColors.white.withValues(alpha: 0.7),
                      )),
                ),
              );
            }).toList()),
      ),
    );
  }
}
