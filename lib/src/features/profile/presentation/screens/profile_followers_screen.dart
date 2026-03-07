import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/profile/cubits/followers_cubit.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ATProfileFollowersScreen extends StatelessWidget {
  const ATProfileFollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowersCubit>(
      create: (context) => FollowersCubit()..fetchFollowers(),
      child: const _ATProfileFollowersScreenContent(),
    );
  }
}

class _ATProfileFollowersScreenContent extends StatelessWidget {
  const _ATProfileFollowersScreenContent();

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: ATAppBar(
          leading: const ATRoundedBackBtn(),
          leadingWidth: 30,
          title: Text(
            ATStrings.followers,
            style: context.textTheme.bodyMedium,
          ),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: ATTextFormField(
                controller: TextEditingController(),
                disableBlueBorder: true,
                hintText: ATStrings.SEARCH_4_FOLLOWERS,
                fillColor: ATColors.white.withValues(alpha:0.1),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: ATImgLoader(
                    height: 20, width: 20,
                    imgPath: ATImgStrings.outlinedSearch
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<FollowersCubit, ATAppState<dynamic>>(
                listener: (_, ATAppState<dynamic> state){
                  if(state is FailureState<dynamic>){
                    showAppNotification2(
                      context: context,
                      text: state.message,
                      type: NotificationType.failure,
                    );
                  }
                },
                builder: (_, ATAppState<dynamic> state) {
                  return switch(state){
                    InitialState<dynamic>() => const SizedBox.shrink(),
                    LoadingState<dynamic>() ||
                    FailureState<dynamic>() ||
                    SuccessState<dynamic>() => Builder(
                      builder: (_){
                        final dynamic followerData = context.read<FollowersCubit>().currentFollowers;
                        final List followers = (followerData is Map ? followerData['data'] : followerData) ?? [];

                        if(followers.isEmpty){
                          if(state is LoadingState<dynamic>){
                            return const Center(child: CircularProgressIndicator());
                          }
                          if(state is FailureState<dynamic>){
                            return Center(
                              child: IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () => context.read<FollowersCubit>().fetchFollowers(),
                              ),
                            );
                          }
                          return const Center(
                            child: Text('No followers yet'),
                          );
                        }

                        final int count = followers.length;

                        return ListView.builder(
                          itemCount: count + 1,
                          padding: const EdgeInsets.only(bottom: 50),
                          itemBuilder: (_, int index){
                            if(index == 0){
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(15, 5, 15, 20),
                                child: Text(
                                  ATStrings.ALL_FOLLOWERS,
                                  style: context.textTheme.bodyMedium,
                                ),
                              );
                            }
                            final dynamic follower = followers[index - 1];
                            return _RenderAFollower(
                              follower: follower,
                              onTap: (dynamic follower, bool isSelected){},
                            );
                          }
                        );
                      },
                    )
                  };
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}



class _RenderAFollower extends StatelessWidget {

  const _RenderAFollower({
    required this.onTap,
    required this.follower,
  });
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> follower;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: () => onTap(follower, follower.notifier.value),
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      radius: 0,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ATImgLoader(
              height: 50, width: 50, boxFit: BoxFit.cover,
              imgPath: follower.obj.profilePicture!
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              follower.obj.username ?? '',
              style: context.textTheme.titleMedium
            ),
          ),
    
          SizedBox(
            width: 84, height: 30,
            child: ATPlainElevatedBtn(
              onPressed: (){},
              padding: EdgeInsets.zero, bgColor: ATColors.white,
              btnTitle: ATStrings.REMOVE,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: ATSizes.size13,
                color: ATColors.black
              ),
            ),
          )
        ],
      ),
    );
  }
}
