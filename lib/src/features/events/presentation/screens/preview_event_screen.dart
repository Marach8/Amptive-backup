import 'dart:ui';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PreviewEventScreen extends StatelessWidget {
  const PreviewEventScreen({
    super.key, 
    required this.hostedEvent,
  });
  final HostedEvent hostedEvent;

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top;
    final bool isLive = hostedEvent.isLive ?? false;
     
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: ATImgLoader(
                    boxFit: BoxFit.fill,
                    imgPath: hostedEvent.coverUrl ?? ''),
              ),
            ),
            Container(
              color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: ATColors.transparent,
                    pinned: true,
                    expandedHeight: blurredHeaderHeight + 300,
                    leading: const ATXBackBtn(),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          ATImgLoader(
                            boxFit: BoxFit.fill,
                            imgPath: hostedEvent.coverUrl ?? '',
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    ATColors.transparent,
                                    ATColors.hex0D0D0D.withValues(alpha: 0.75),
                                    ATColors.hex0D0D0D,
                                  ],
                                  stops: const <double>[0.0, 0.75, 1.0],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            left: 15,
                            right: 15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (isLive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.circle, size: 8, color: Colors.white),
                                        SizedBox(width: 5),
                                        Text(
                                          'LIVE',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Text(
                                  hostedEvent.title ?? '',
                                  style: context.textTheme.headlineSmall?.copyWith(
                                    color: ATColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundImage: hostedEvent.host?.profilePicture != null
                                          ? NetworkImage(hostedEvent.host!.profilePicture!)
                                          : null,
                                      child: hostedEvent.host?.profilePicture == null
                                          ? const Icon(Icons.person, size: 14)
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      hostedEvent.host?.name ?? '',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: ATColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Event Details
                          // _EventInfoRow(
                          //   icon: Icons.calendar_today,
                          //   label: 'Date',
                          //   value: hostedEvent.startTime ?? '',
                          // ),
                          // const SizedBox(height: 12),
                          // if (hostedEvent.location != null) ...[
                          //   _EventInfoRow(
                          //     icon: Icons.location_on,
                          //     label: 'Location',
                          //     value: hostedEvent.location ?? '',
                          //   ),
                          //   const SizedBox(height: 12),
                          // ],
                          _EventInfoRow(
                            icon: Icons.attach_money,
                            label: 'Price',
                            value: hostedEvent.price != null 
                                ? '\$${hostedEvent.price!.toStringAsFixed(2)}' 
                                : 'Free',
                          ),
                          const SizedBox(height: 20),
                          
                          // Description
                          Text(
                            'About this event',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: ATColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            hostedEvent.description ?? '',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: ATColors.hexC2C2C2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Tags
                          if (hostedEvent.tags?.isNotEmpty ?? false) ...[
                            Text(
                              'Tags',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: ATColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: hostedEvent.tags!
                                  .map((tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ATColors.hex1F1F23,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '#${tag.name}',
                                          style: context.textTheme.bodySmall?.copyWith(
                                            color: ATColors.hex307FE2,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
          child: ATBlurredBgBtn(
            btnTitle: isLive ? 'Go Live' : 'Start Event',
            onPressed: () {
              // Navigate to go live or start event
            },
          ),
        ),
      ),
    );
  }
}

class _EventInfoRow extends StatelessWidget {
  const _EventInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 20, color: ATColors.hexA8A8A8),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: context.textTheme.bodySmall?.copyWith(
            color: ATColors.hexA8A8A8,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(
              color: ATColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
