import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';


class RowOfCustomFees extends StatelessWidget {
  const RowOfCustomFees({
    super.key,
    required this.selectedFee,
    required this.onFeeTap
  });

  final int? selectedFee;
  final void Function(int) onFeeTap;

  @override
  Widget build(BuildContext context) {
    final List<int> list = <int>[100, 500, 1000, 5000, 10000];

    return SizedBox(
      height: 30,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: list.map(
            (int item){
              return ATContainer(
                onTap: () => onFeeTap(item),
                duration: 50,
                key: ValueKey(item),
                radius: 10, alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                border: selectedFee == item ? Border.all(color: ATColors.white) : null,
                color: ATColors.white.withValues(alpha: 0.1),
                child: Center(
                  child: Text(
                    'N$item',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: ATSizes.size11,
                      color: selectedFee == item ? ATColors.white : ATColors.white.withValues(alpha: 0.7),
                    )
                  ),
                ),
              );
            }
          ).toList()
        ),
      ),
    );
  }
}
