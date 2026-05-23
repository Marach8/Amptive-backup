import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/gifting_notification.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_host_and_cohost.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/live_screen_notifications.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/global_export.dart';

class AnimatedChatMsgItem extends StatelessWidget {
  const AnimatedChatMsgItem({
    super.key,
    required this.message,
    required this.animation,
  });

  final ChatMessage message;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final bool msgFromHost = message.role
      == ParticipantRole.host;

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: -1,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.25),
          end: Offset.zero,
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: ATImgLoader(
                    imgPath: message.avatar ?? '',
                    boxFit: BoxFit.cover,
                    height: 35,
                    width: 35,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              message.senderName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    height: 0.78,
                                  ),
                            ),
                          ),
                          if (msgFromHost)
                            const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: HostIndicator(size: 6, radius: 3),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message.message ?? '',
                        maxLines: 2,
                        style: context
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontSize: 13,
                              height: 1.38,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
