import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/features/home/cubits/mock_sub_feeds_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/colors.dart';
import '../../../../shared/back_button.dart';
import '../../../../shared/custom_container_widget.dart';
import '../widgets/subscribed_program.dart';
import '../widgets/unified_mock_program_card.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_card_shimmer.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';

class ATSubscribedPrograms extends StatefulWidget {
  const ATSubscribedPrograms({
    super.key,
  });

  @override
  State<ATSubscribedPrograms> createState() => _ATSubscribedProgramsState();
}

class _ATSubscribedProgramsState extends State<ATSubscribedPrograms> {
  @override
  void initState() {
    super.initState();
    context.read<SubscribedFeedCubit>().fetchFeed();
  }

  Future<void> _onRefresh() async {
    await context.read<SubscribedFeedCubit>().refreshFeed();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notif) {
              context.read<ATNavBarBloc>().ctrlNavVisibility(notif);
              return false;
            },
            child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (_, __) => <Widget>[
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        pinned: true,
                        expandedHeight: 56,
                        toolbarHeight: 0,
                        backgroundColor: ATColors.black,
                        flexibleSpace: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            final double statusBarHeight =
                                MediaQuery.of(context).padding.top;
                            final double currentHeight =
                                constraints.biggest.height;
                            final double shrinkOffset =
                                (56 - (currentHeight - statusBarHeight))
                                    .clamp(0.0, 56.0);
                            final double opacity =
                                (1.0 - (shrinkOffset / 35)).clamp(0.0, 1.0);
                            final double toolbarTop =
                                statusBarHeight - ((shrinkOffset / 56) * 35);

                            return Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Positioned(
                                  top: toolbarTop,
                                  left: 0,
                                  right: 0,
                                  height: 56,
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4),
                                                child: ATBackBtn(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  leadingText:
                                                      ATStrings.SUBSCRIBED,
                                                  leadingStyle: Theme.of(
                                                          context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontSize:
                                                              ATSizes.size23,
                                                          letterSpacing: -0.39),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: const Color(0xFF38383A),
                                          height: 0.5,
                                          width: double.infinity,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                body: BlocBuilder<SubscribedFeedCubit, MockFeedState>(
                    builder: (context, state) {
                  final bool isLoading =
                      state is MockFeedInitial || state is MockFeedLoading;
                  return ATRefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                      itemCount: 10,
                      separatorBuilder: (_, __) => const SizedBox(height: 30),
                      itemBuilder: (BuildContext _, int __) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: isLoading
                              ? const ProgramCardShimmer()
                              : const UnifiedMockProgramCard(
                                  itemId: 'fake_debug_card',
                                ),
                        );
                      },
                    ),
                  );
                })),
          ),
        ),
      ),
    );
  }
}
