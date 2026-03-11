import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_home_feed_item.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/circular_image.dart';
import '../../../../shared/divider_widget.dart';
import '../../../../shared/image_loader_widget.dart';
import '../../../../shared/live_user_model_widget.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/appbar_drop_down.dart';
import '../widgets/go_live_widget_in_home.dart';

class RowOfLiveUsers extends StatelessWidget {
  const RowOfLiveUsers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 11, right: 14),
              child: GoLiveWidgetInHome(),
            ),
            ...Iterable<Widget>.generate(
                20,
                (_) => const Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: LiveUserWidget(),
                    )),
          ]),
    );
  }
}
