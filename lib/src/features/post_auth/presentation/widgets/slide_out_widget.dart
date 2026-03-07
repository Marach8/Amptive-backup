import 'package:amptive/src/features/post_auth/presentation/widgets/notification_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SlideOutWidget extends StatelessWidget {
  const SlideOutWidget({
    super.key,
    required this.duration,
  });

  final int duration;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
            SlideOutBloc,
            ({NotifParams notifParams, bool shouldSlide, bool shouldShow}),
            bool>(
        selector: (({
                  NotifParams notifParams,
                  bool shouldSlide,
                  bool shouldShow
                }) state) =>
            state.shouldSlide,
        builder: (_, bool shouldSlide) {
          return AnimatedPositioned(
            top: shouldSlide ? -100 : 130,
            left: 0,
            right: 0,
            onEnd: () => context.read<SlideOutBloc>().resetSliding(),
            duration: Duration(milliseconds: shouldSlide ? duration : 0),
            child: AnimatedScale(
              duration: Duration(milliseconds: shouldSlide ? duration : 0),
              onEnd: () => context.read<SlideOutBloc>().hideItem(),
              scale: shouldSlide ? 0.7 : 1.0,
              child: const _OpacityBuilder(),
            ),
          );
        });
  }
}

class _OpacityBuilder extends StatelessWidget {
  const _OpacityBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
            SlideOutBloc,
            ({NotifParams notifParams, bool shouldSlide, bool shouldShow}),
            bool>(
        selector: (({
                  NotifParams notifParams,
                  bool shouldSlide,
                  bool shouldShow
                }) state) =>
            state.shouldShow,
        builder: (_, bool shouldShow) {
          return Opacity(
              opacity: shouldShow ? 1.0 : 0.0,
              child: const _NotifTileBuilder());
        });
  }
}

class _NotifTileBuilder extends StatelessWidget {
  const _NotifTileBuilder();

  static const double _rightPicSize = 25;
  static const double _leftPicSize = 30;
  static const double _normalTitleFontSize = 12;
  static const double _normalTrailingFontSize = 10;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
            SlideOutBloc,
            ({NotifParams notifParams, bool shouldSlide, bool shouldShow}),
            NotifParams>(
        selector: (({
                  NotifParams notifParams,
                  bool shouldSlide,
                  bool shouldShow
                }) state) =>
            state.notifParams,
        builder: (_, NotifParams notifParams) {
          return NotifTile1(
            horizMargin: 10,
            leftPicSize: _leftPicSize,
            rightPicSize: _rightPicSize,
            titleFontSize: _normalTitleFontSize,
            subTitleFontSize: _normalTitleFontSize,
            timeFontSize: _normalTrailingFontSize,
            title: notifParams.title,
            subtitle: notifParams.desc,
            rightImgPath: notifParams.trailingPic,
            time: notifParams.time,
          );
        });
  }
}

class SlideOutBloc extends Cubit<
    ({NotifParams notifParams, bool shouldSlide, bool shouldShow})> {
  SlideOutBloc()
      : super(
          (
            notifParams: NotifParams.initial(),
            shouldSlide: false,
            shouldShow: true
          ),
        );

  void addNotification(NotifParams params) => emit((
        notifParams: params,
        shouldSlide: state.shouldSlide,
        shouldShow: state.shouldShow
      ));

  void showItem() => emit((
        notifParams: state.notifParams,
        shouldSlide: state.shouldSlide,
        shouldShow: true
      ));

  void hideItem() => emit((
        notifParams: state.notifParams,
        shouldSlide: state.shouldSlide,
        shouldShow: false
      ));

  void kickOffSliding() => emit((
        notifParams: state.notifParams,
        shouldSlide: true,
        shouldShow: state.shouldShow
      ));

  void resetSliding() => emit((
        notifParams: state.notifParams,
        shouldSlide: false,
        shouldShow: state.shouldShow
      ));
}

class NotifParams {
  const NotifParams({
    required this.title,
    required this.desc,
    required this.trailingPic,
    required this.time,
  });

  factory NotifParams.initial() =>
      const NotifParams(title: '', time: '', trailingPic: '', desc: '');

  final String title, desc, time, trailingPic;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotifParams &&
        other.title == title &&
        other.trailingPic == trailingPic &&
        other.desc == desc &&
        other.time == time;
  }

  @override
  int get hashCode =>
      title.hashCode ^ desc.hashCode ^ trailingPic.hashCode ^ time.hashCode;
}
