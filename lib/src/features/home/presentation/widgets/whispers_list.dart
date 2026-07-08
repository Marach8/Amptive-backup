import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/home/cubits/whispers_cubit.dart';
import 'package:amptive/src/features/home/data/models/response/whispers_response_model.dart';
import 'package:amptive/src/shared/empty_state_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../shared/list_tile_with_leading_picture_widget.dart';

class WhispersWidget extends StatelessWidget {
  const WhispersWidget({
    super.key,
    this.emptyStateDescription,
  });

  final String? emptyStateDescription;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveWhispersCubit, ATAppState<List<Whisper>>>(
      listener: (_, ATAppState<List<Whisper>> state){
        if(state is FailureState<List<Whisper>>){
          showAppNotification2(
            context: context,
            text: state.message,
            type: NotificationType.failure,
          );
        }
      },
      builder: (_, ATAppState<List<Whisper>> state) {
        return switch(state){
          InitialState<List<Whisper>>() ||
          LoadingState<List<Whisper>>() => const _WhispersLoading(),
          FailureState<List<Whisper>>() => Center(
            child: IconButton(
              onPressed: (){},
              icon: const Icon(Icons.refresh),
            )
          ),
          SuccessState<List<Whisper>>(:final List<Whisper>? newData)
            => Builder(
              builder: (_){
                final bool hasWhispers = (newData ?? <Whisper>[]).isNotEmpty;
                if(!hasWhispers){
                  return Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ATStrings.whispers,
                          style: context.textTheme.bodySmall
                              ?.copyWith(fontSize: 17),
                        ),
                      ),
                      Divider(
                        color: ATColors.white.withValues(alpha: 0.1),
                      ),
                      EmptyStateWidget(
                        description: emptyStateDescription ??
                          'Random comments from this live event will appear here.',
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Text(
                      ATStrings.whispers,
                      style: context.textTheme.bodySmall
                          ?.copyWith(fontSize: 17),
                    ),
                    Divider(
                      color: ATColors.white.withValues(alpha: 0.1),
                    ),
                    SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newData?.length,
                        itemBuilder: (_, int index){
                          final Whisper? whisper = newData?[index];
                          return Container(
                            margin: const EdgeInsets.only(left: 15),
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                            height: 230,
                            width: 326,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ATColors.white.withValues(alpha: 0.1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const TileWithLeadingImage(
                                  title: 'kankabir',
                                  subtitle: 'Listener',
                                  diameter: 48,
                                  leadingImagePath: ATImgStrings.jpeg1,
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    maxLines: 100,
                                    whisper?.message ?? '',
                                    style: context.textTheme.labelMedium
                                      ?.copyWith(color: ATColors.white, height: 1.5)),
                                ),
                    
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    ATHelperFuncs.formatDateOrTime(
                                      whisper?.timestamp ?? '',
                                      formatString: 'HH:mm'
                                    ),
                                    maxLines: 2,
                                    style: context.textTheme.titleLarge?.copyWith(
                                        color: ATColors.hexC2C2C2,
                                        fontSize: 12,
                                        height: 1.5),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                );
              },
            )
        };
      }
    );
  }
}



class _WhispersLoading extends StatelessWidget {
  const _WhispersLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 30),
        Text(
          ATStrings.whispers,
          style: context.textTheme.bodySmall
              ?.copyWith(fontSize: 17),
        ),
        Divider(
          color: ATColors.white.withValues(alpha: 0.1),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (_, __){
              return Container(
                margin: const EdgeInsets.only(left: 15),
                padding: const EdgeInsets.all(15),
                height: 230,
                width: 326,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ATColors.white.withValues(alpha: 0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      spacing: 12,
                      children: <Widget>[
                        const ATShimmer(height: 40, width: 40, radius: 20),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (_, BoxConstraints kst) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: <Widget>[
                                  ATShimmer(
                                    height: 12, radius: 3,
                                    width: ATHelperFuncs.getRandomNumber(kst.maxWidth),
                                  ),
                                  const ATShimmer(
                                    height: 9, radius: 2,
                                    width: 60
                                  ),
                                ],
                              );
                            }
                          ),
                        )
                      ],
                    ),
        
                    const SizedBox(height: 20),
                    ...List<Widget>.generate(
                      4,
                      (_) => ATShimmer(
                        height: 12, radius: 3, 
                        margin: const EdgeInsets.only(bottom: 8),
                        width: ATHelperFuncs.getRandomNumber(
                          context.screenWidth * 0.9),
                      ),
                    ),
                    const Spacer(),
        
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: ATShimmer(
                        height: 8, radius: 3,
                        width: 80
                      ),
                    )
                  ],
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}
