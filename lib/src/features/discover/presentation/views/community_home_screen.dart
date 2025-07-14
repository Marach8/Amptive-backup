import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/features/discover/presentation/widgets/community_card_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/constants/strings/other_strings.dart';
import '../../../../utils/constants/strings/route_strings.dart';
import '../../../home/presentation/widgets/blurred_header.dart';

class ATCommunityScreen extends StatelessWidget {
  const ATCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprnt,
      child: Scaffold(
        body: BlocProvider<BlurredHeaderBloc>(
          create: (_) => BlurredHeaderBloc(),
          child: Builder(
            builder: (BuildContext blocContext) {
              return NotificationListener<ScrollNotification>(
                onNotification: blocContext.read<BlurredHeaderBloc>().onScrollNotification,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ATSliverHDelegate(
                        maxExt: kToolbarHeight + MediaQuery.paddingOf(context).top,
                        minExt: kToolbarHeight + MediaQuery.paddingOf(context).top,
                        child: ATBlurredHeaderWidget(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: ATRoundedBackBtn(bgColor: ATColors.trsprnt,),
                              ),
                              Text(
                                ATStrings.COMMUNITIES,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 30,)
                            ],
                          ),
                        )
                      ),
                    ),
                    
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          maxLines: 3,
                          ATStrings.DISCOVER_COMMUNITIES,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ATColors.hexA8A8A8
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10,)),
                    
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      sliver: SliverGrid(
                        delegate: SliverChildListDelegate.fixed(
                          List<Widget>.generate(
                            28,
                            (_) => CommunityCardWidget(
                              picture: ATImgStrings.COMMUNITY_CARD,
                              padding: EdgeInsets.zero,
                              onTap: () => context.pushNamed(ATRoutes.SOCIETY_SCREEN),
                            )
                          ).toList()
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1.28
                        )
                      ),
                    )
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
