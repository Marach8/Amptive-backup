import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/profile/cubits/followers_cubit.dart';
import 'package:amptive/src/features/profile/data/models/followers_response_model.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/app_bar_widget.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../config/api_response_and_app_state.dart';

class ATProfileFollowersScreen extends StatefulWidget {
  const ATProfileFollowersScreen({super.key});

  @override
  State<ATProfileFollowersScreen> createState() => _ATProfileFollowersScreenState();
}

class _ATProfileFollowersScreenState extends State<ATProfileFollowersScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowersCubit>(
      create: (BuildContext context) => FollowersCubit()..fetchFollowers(),
      child: ATAnnotatedRegion(
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
                  controller: _searchController,
                  disableBlueBorder: true,
                  hintText: ATStrings.SEARCH_4_FOLLOWERS,
                  fillColor: ATColors.white.withValues(alpha: 0.1),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ATImgLoader(
                      height: 20,
                      width: 20,
                      imgPath: ATImgStrings.outlinedSearch,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocConsumer<FollowersCubit, ATAppState<FollowersResponseModel>>(
                  listener: (BuildContext context, ATAppState<FollowersResponseModel> state) {
                    if (state is FailureState<FollowersResponseModel>) {
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                  builder: (BuildContext context, ATAppState<FollowersResponseModel> state) {
                    return switch (state) {
                      InitialState<FollowersResponseModel>() => const SizedBox.shrink(),
                      
                      LoadingState<FollowersResponseModel>() ||
                      FailureState<FollowersResponseModel>() ||
                      SuccessState<FollowersResponseModel>() => Builder(
                          builder: (_) {
                            final FollowersResponseModel? followersData = context.read<FollowersCubit>().currentFollowers;
                            final List<Followers> followers = followersData?.followers?? <Followers>[];

                            if (followers.isEmpty) {
                              if (state is LoadingState) return const _InitialLoadingShimmer();
                              if (state is FailureState) {
                                return Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () => context.read<FollowersCubit>().fetchFollowers(),
                                  ),
                                );
                              }
                              return const Center(child: Text('No followers available'));
                            }

                            return ListView.builder(
                              itemCount: followers.length + 1,
                              padding: const EdgeInsets.only(bottom: 50),
                              itemBuilder: (_, int index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 20),
                                    child: Text(
                                      ATStrings.ALL_FOLLOWERS,
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  );
                                }

                                return _RenderAFollower(
                                  followers: followers[index - 1],
                                  onRemove: (Followers followers) {},
                                );
                              },
                            );
                          },
                        ),
                    };
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _RenderAFollower extends StatelessWidget {
  const _RenderAFollower({required this.followers, required this.onRemove});
  final Followers followers;
  final void Function(Followers) onRemove;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      radius: 0,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ATImgLoader(
              height: 50,
              width: 50,
              boxFit: BoxFit.cover,
              imgPath: followers.profilePicture ?? '',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(followers.username ?? '', style: context.textTheme.titleMedium),
          ),
          SizedBox(
            width: 84,
            height: 30,
            child: ATPlainElevatedBtn(
              onPressed: () => onRemove(followers),
              padding: EdgeInsets.zero,
              bgColor: ATColors.white,
              btnTitle: ATStrings.remove,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: ATSizes.size13, 
                color: ATColors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _InitialLoadingShimmer extends StatelessWidget {
  const _InitialLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 50),
      itemCount: 5, 
      itemBuilder: (_, int index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: <Widget>[
             ATShimmer(
                height: 25,
                width: 25,
                radius: 25, 
              ),
             SizedBox(width: 20),
             Expanded(
                child: ATShimmer(
                  height: 20,
                  width: 120,
                  radius: 4,
                ),
              ),
               SizedBox(width: 10),
              ATShimmer(
                height: 20,
                width: 84,
                radius: 4,
              ),
            ],
          ),
        );
      },
    );
  }
}

