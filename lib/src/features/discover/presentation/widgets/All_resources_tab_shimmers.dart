import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';

class UnifiedSearchShimmer extends StatelessWidget {
  const UnifiedSearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
        _ShowTileShimmer(),   
        _UserTileShimmer(),     
        _HashtagsTileShimmer(), 
        _ShowTileShimmer(),
        _UserTileShimmer(),
        _HashtagsTileShimmer(),
      ],
    );
  }
}
class UsersListShimmer extends StatelessWidget {
  const UsersListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 10, // Number of shimmer items to show
      itemBuilder: (_, __) => const _UserTileShimmer(),
    );
  }
}

class _UserTileShimmer extends StatelessWidget {
  const _UserTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            const ATShimmer(
              height: 50,
              width: 50,
              radius: 25, // Circular
            ),
            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ATShimmer(
                    height: 14,
                    width: ATHelperFuncs.getRandomNumber(
                        constraints.maxWidth * 0.8),
                    radius: 3,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      // ATShimmer(
                      //   height: 13,
                      //   width: 50,
                      //   radius: 2,
                      // ),
                      // SizedBox(width: 5),
                      // ATShimmer(
                      //   height: 3,
                      //   width: 3,
                      //   radius: 1.5,
                      // ),
                      const SizedBox(width: 5),
                      ATShimmer(
                        height: 13,
                        width: ATHelperFuncs.getRandomNumber(
                            constraints.maxWidth * 0.5),
                        radius: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 15),

            // Trailing icon shimmer
            const ATShimmer(
              height: 24,
              width: 24,
              radius: 4,
            ),
          ],
        );
      }),
    );
  }
}
class HashtagsListShimmer extends StatelessWidget {
  const HashtagsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 10,
      itemBuilder: (_, __) => const _HashtagsTileShimmer(),
    );
  }
}

class _HashtagsTileShimmer extends StatelessWidget {
  const _HashtagsTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            const ATShimmer(height: 50, width: 50, radius: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ATShimmer(
                      height: 12,
                      width: ATHelperFuncs.getRandomNumber(
                          constraints.maxWidth * 0.5),
                      radius: 4),
                  const SizedBox(height: 8),
                  const ATShimmer(height: 10, width: 70, radius: 2),
                ],
              ),
            ),
            const SizedBox(width: 15),
            const ATShimmer(
              height: 24,
              width: 24,
              radius: 4,
            ),
          ],
        );
      }),
    );
  }
}
class ShowsListShimmer extends StatelessWidget {
  const ShowsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 10,
      itemBuilder: (_, __) => const _ShowTileShimmer(),
    );
  }
}
class _ShowTileShimmer extends StatelessWidget {
  const _ShowTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          // Rectangular image for Shows/Events
          const ATShimmer(
            height: 50,
            width: 50,
            radius: 8, 
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ATShimmer(
                  height: 14,
                  width: ATHelperFuncs.getRandomNumber(150),
                  radius: 3,
                ),
                const SizedBox(height: 5),
                const ATShimmer(
                  height: 12,
                  width: 80,
                  radius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          // Play button circle shimmer
          const ATShimmer(
            height: 24,
            width: 24,
            radius: 12,
          ),
        ],
      ),
    );
  }
}
