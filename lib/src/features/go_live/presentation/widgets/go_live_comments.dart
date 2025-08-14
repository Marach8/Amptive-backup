import 'dart:ui';

import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/go_live_screen_title.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/go_live/host_moderation_tools_dialog.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/shared/animated_switcher.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/go_live_screen_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../models/go_live_notification_model.dart';
import '../../../../services/go_live_service/go_live_service.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/dialogs/go_live/go_live_add_cohost_dialog.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_host_view.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_notification_widget.dart';
import '../../go_live_export.dart';


class GoLiveComments extends StatelessWidget {
  const GoLiveComments({
    super.key,
    required ScrollController scrollController,
    required this.service,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final GoLiveService service;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
      itemCount: service.coHostsListData.length,
      itemBuilder: (_, int listIndex){
        final ObjectWithNotifier<Host> string = service.coHostsListData.elementAt(listIndex);
        return ListTile(
          horizontalTitleGap: 10,
          minTileHeight: 50,
          leading: ATCircularImage(
            diameter: 35.h,
            imagePath: ATImgStrings.CRIMINAL,
          ),
          title: Text(
            string.obj.name ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ATColors.hexC2C2C2
            )
          ),
          subtitle: Text(
            string.obj.username ?? '',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: ATFontSizes.size13
            )
          ),
        );
      },
    );
  }
}

