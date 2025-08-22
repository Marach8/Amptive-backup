import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_notification_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import '../../../../models/go_live_notification_model.dart';


class GoLiveComments extends StatefulWidget {
  const GoLiveComments({super.key});

  @override
  State<GoLiveComments> createState() => _GoLiveCommentsState();
}

class _GoLiveCommentsState extends State<GoLiveComments> {
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _scroll2BottomNotifier = ValueNotifier<bool>(true);

  @override 
  void initState(){
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final bool isScrollable = _scrollController.position.maxScrollExtent > 0;
        _scroll2BottomNotifier.value = isScrollable;
      }
    );
  }

  @override 
  void dispose(){
    _scroll2BottomNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      _scroll2BottomNotifier.value = true;
    }
    
    else if (_scrollController.position.atEdge &&
      _scrollController.position.pixels != 0) {
      _scroll2BottomNotifier.value = false;
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
          itemCount: getCoHostList().length,
          itemBuilder: (_, int listIndex){
            final ATCohost<bool> user = getCoHostList().elementAt(listIndex);
            return ListTile(
              horizontalTitleGap: 10,
              minTileHeight: 50,
              leading: ATCircularImage(
                diameter: 35.h,
                imagePath: user.profilePicture ?? ''
              ),
              title: Text(
                user.name ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ATColors.hexC2C2C2
                )
              ),
              subtitle: Text(
                user.username ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: ATFontSizes.size13
                )
              ),
            );
          },
        ),

        // const Positioned(
        //   top: 0,
        //   child: _Notifications()
        // ),

        Positioned(
          bottom: 70, right: 15,
          child: ValueListenableBuilder<bool>(
            valueListenable: _scroll2BottomNotifier,
            builder: (_, bool showIcon, __) {
              return ATScalingSwitcher(
                duration: 500,
                child: showIcon ? ATContainer(
                  key: const ValueKey<int>(1),
                  onTap: () => _scrollToBottom(),
                  color: ATColors.white.withValues(alpha: 0.1),
                  height: 35, width: 35,
                  boxShape: BoxShape.circle,
                  child: const Icon(Icons.keyboard_double_arrow_down),
                ) : const SizedBox.shrink(key: ValueKey<int>(2)),
              );
            }
          ),
        )
      ],
    );
  }
}



class _Notifications extends StatelessWidget {
  const _Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AmptiveGoLiveNotificationBloc, AmptiveGoLiveNotificationModel>(
      builder: (_, AmptiveGoLiveNotificationModel state) {
        if(state.notificationType == ATStrings.PINNED){
          return Positioned(
            top: 260,
            child: Container(color: Colors.red,
              width: ATHelperFuncs.getScreenWidth(context),
              child: AmptiveGoLivePinnedMsgNtfctnWidget(state: state)
            )
          );
        }

        return Positioned(
          top: 260, left: 15,
          child: Container( color: Colors.green,
            child: AmptiveGoLiveNotificationsWidget(state: state))
        );
      }
    );
  }
}