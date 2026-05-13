import 'package:amptive/src/config/utils/utils_export.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';

class ProgramDisplayShimmer extends StatelessWidget {
  const ProgramDisplayShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, 
      itemBuilder: (_, __) => const _ProgramDisplayTileShimmer(),
    );
  }
}

class _ProgramDisplayTileShimmer extends StatelessWidget {
  const _ProgramDisplayTileShimmer();

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      margin: const EdgeInsets.fromLTRB(15, 12, 15, 12),
      height: 80,
      radius: 0,
      child: Row(
        children: <Widget>[
          const ATShimmer(
            height: 77,
            width: 77,
            radius: 5,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                 
                  Row(
                    children: <Widget>[
                      const ATShimmer(height: 16, width: 16, radius: 2),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ATShimmer(
                          height: 12, 
                          width: ATHelperFuncs.getRandomNumber(constraints.maxWidth * 0.2), 
                          radius: 2,
                        ),
                      ),
                      
                    ],
                  ),
                  ATShimmer(
                    height: 30, 
                    width: ATHelperFuncs.getRandomNumber(constraints.maxWidth * 0.9),
                    radius: 2,
                  ),
                  
                  const Row(
                    children: <Widget>[
                      ATShimmer(height: 10, width: 10, radius: 1),
                      SizedBox(width: 5),
                      ATShimmer(
                        height: 12, 
                        width: 50,
                        radius: 2,
                      ),
                      
                      SizedBox(width: 3),
                      
                      ATShimmer(
                        height: 12, 
                        width: 50,
                        radius: 2,
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
