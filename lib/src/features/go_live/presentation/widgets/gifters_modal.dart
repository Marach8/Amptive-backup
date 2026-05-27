import 'dart:ui';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/search_cohost_field.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/search_filter_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

// Future<void> showHostViewOfTopGiftersDialog({
//   required BuildContext context,
//   required bool enableKickOut,
//   required LiveStreamCubit1 liveStreamCubit,
// }) async {
//   return await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: ATColors.hex202020.withValues(alpha: 0.9),
//       builder: (BuildContext context) {
//         return DraggableScrollableSheet(
//             expand: false,
//             initialChildSize: 0.7,
//             builder: (_, ScrollController controller) {
//               return Container(
//                 padding: const EdgeInsets.only(top: 20),
//                 clipBehavior: Clip.hardEdge,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         const Align(
//                             alignment: Alignment.center,
//                             child: ATModalDismisser()),
//                         const SizedBox(height: 10),
//                         Expanded(
//                           child: ATScrollBar(
//                             extScrollCntrl: controller,
//                             child: ListView.builder(
//                               padding: const EdgeInsets.fromLTRB(15, 0, 10, 20),
//                               physics: const BouncingScrollPhysics(),
//                               primary: true,
//                               itemCount: getHostList().length + 1,
//                               itemBuilder: (_, int listIndex) {
//                                 if (listIndex == 0) {
//                                   return const _GiftsDescColumn();
//                                 }

//                                 final ObjectWithNotifier<Host> gifter =
//                                     getHostList().elementAt(listIndex - 1);

//                                 return _GifterWidget(
//                                   onTap: (_, __) {},
//                                   gifter: gifter,
//                                   index: listIndex,
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ]),
//                 ),
//               );
//             });
//       });
// }

Future<bool?> showGiftersModal({
  required BuildContext context,
  required bool canSendGift,
  required LiveStreamCubit1 liveStreamCubit,
}) async {
  return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ATColors.hex202020.withValues(alpha: 0.9),
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<LiveStreamCubit1>.value(value: liveStreamCubit),
            BlocProvider<SearchkeyCubit>(create: (_) => SearchkeyCubit())
          ],
          child: Stack(
            children: <Widget>[
              DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.7,
                  builder: (_, ScrollController controller) {
                    return Container(
                      padding: const EdgeInsets.only(top: 20),
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: _GiftersModal(
                          scrollController: controller,
                          canKickListener: canSendGift,
                        ),
                      ),
                    );
                  }),
              if(canSendGift) const Positioned(
                bottom: 0,
                child: _SendGiftWidget(),
              ),
            ],
          ),
        );
      });
}


class _GiftersModal extends StatefulWidget {
  const _GiftersModal({
    required this.scrollController,
    required this.canKickListener,
  });

  final ScrollController scrollController;
  final bool canKickListener;

  @override
  State<_GiftersModal> createState() => _GiftersModalState();
}

class _GiftersModalState extends State<_GiftersModal> {
  @override 
  void initState(){
    super.initState();
    widget.scrollController.addListener(_onCohostsScrollToEnd);
  }

  void _onCohostsScrollToEnd() {
    const double threshHold = 50;
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent + threshHold) {
      //context.read<AllUsersCubit>().fetchAllUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const ATModalDismisser(),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ATImgLoader(
                imgPath: ATImgStrings.hostGiftingIcon,
                width: 24, height: 24
              ),
              const SizedBox(width: 5),
              Text(ATStrings.gifts,
                  style: context.textTheme.bodyLarge),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            ATStrings.topGiftersDesc,
            maxLines: 2,
            style: context.textTheme.labelSmall!
                .copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: BlocSelector<LiveStreamCubit1, LiveStreamState1, 
            Map<String, Gift>?>(
            selector: (LiveStreamState1 state) => state.gifts,
              builder: (_, Map<String, Gift>? gifts) {
            final bool disableTextfield = gifts == null
              || gifts.isEmpty;

            return AbsorbPointer(
              absorbing: disableTextfield,
              child: SearchFieldWithXSuffix(
                hintText: 'Search for gifter',
                onClear: () {
                  context.read<SearchkeyCubit>().resetSearch();
                  //context.read<AllUsersCubit>().resetSearch();
                },
                onChanged: (String searchKey) {
                  ATHelperFuncs.callDebouncer(500, () {
                    //context.read<AllUsersCubit>().searchUsers(searchKey);
                    context.read<SearchkeyCubit>().updateSearchKey(searchKey);
                  });
                },
              ),
            );
          }),
        ),

        Expanded(
          child: _GiftersList(
            canKickListener: widget.canKickListener,
            scrollController: widget.scrollController,
          )
        ),
      ],
    );
  }
}


class _GiftersList extends StatelessWidget {
  const _GiftersList({
    required this.scrollController,
    required this.canKickListener,
  });

  final bool canKickListener;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    
    final List<String> gifts =
      context.select<LiveStreamCubit1, List<String>>(
      (LiveStreamCubit1 cubit) => cubit.state.giftIds ?? <String>[]);

    final Map<String, Gift> giftsMap =
      context.read<LiveStreamCubit1>().state.gifts ?? <String, Gift>{};

    if (gifts.isEmpty || giftsMap.isEmpty) {
      return Center(
        child: Text(
          'No gifts yet',
          style: context.textTheme.bodyMedium?.copyWith(
            color: ATColors.hexC2C2C2,
          ),
        ),
      );
    }

    return ATScrollBar(
      extScrollCntrl: scrollController,
      child: ListView.builder(
        itemCount: gifts.length + 1,
        primary: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(15, 20, 10, 20),
        itemBuilder: (_, int listIndex) {
          if (listIndex == 0) {
            return Text(
              ATStrings.topGifters,
              style: context.textTheme.bodyMedium
            );
          }
      
          final int adjustedIndex = listIndex - 1;
          final String id = gifts[adjustedIndex];
          final Gift? gift = giftsMap[id];
      
          return _GifterWidget(
            gift: gift,
            index: adjustedIndex,
          );
        },
      ),
    );
  }
}

class _GifterWidget extends StatelessWidget {
  const _GifterWidget({
    required this.gift,
    required this.index
  });

  final Gift? gift;
  final int index;

  @override
  Widget build(BuildContext context) {
    String? userName = gift?.gifter?.username ?? '';
    final int amountGifted = gift?.quantity ?? 0;
    final bool isInTop3Gifter = index == 0 
      || index == 1 || index == 2;
      
    final String? userId = context
      .read<LocalUserDataCubit>().currentUserData?.userId;
    if(userId == gift?.gifter?.userId){
      userName = 'You';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          isInTop3Gifter
              ? Text(
                  (index + 1).toString(),
                  style: context.textTheme.bodyMedium?.copyWith(
                      color: ATColors.yellowColor, fontSize: ATSizes.size14),
                )
              : ATCircleAvatar(
                  diameter: 5,
                  color: ATColors.white.withValues(alpha: 0.4),
                  child: const SizedBox.shrink(),
                ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(25),
            child: ATImgLoader(
              imgPath: gift?.gifter?.profilePicture ?? '',
              boxFit: BoxFit.cover,
              height: 50,
              width: 50,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              userName,
              style: context.textTheme.titleMedium),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
              '${ATStrings.nairaText}${amountGifted.toString().formatPrice()}',
              style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SendGiftWidget extends StatelessWidget {
  const _SendGiftWidget();

  @override
  Widget build(BuildContext context) {
    final CachedUserData? currUserData = context
      .read<LocalUserDataCubit>().currentUserData;

    
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.fromLTRB(30, 15, 15, 20),
      width: context.screenWidth,
      decoration: const BoxDecoration(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(25),
              child: ATImgLoader(
                imgPath: currUserData?.pictureUrl ?? '',
                boxFit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'You',
                      style: context.textTheme.bodySmall
                          ?.copyWith(fontSize: ATSizes.size15)),
                  Text(ATStrings.sendGiftToHost,
                      style: context.textTheme.titleMedium
                          ?.copyWith(color: ATColors.hexC2C2C2))
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            ATContainer(
              onTap: () => context.pop(true),
              radius: 40,
              color: ATColors.hex307FE2,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(
                ATStrings.sendGift,
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontSize: ATSizes.size15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
