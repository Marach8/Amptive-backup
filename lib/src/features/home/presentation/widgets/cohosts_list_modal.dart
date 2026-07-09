import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter/material.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> showCohostsModal({
  required BuildContext context,
  required List<CoHost> coHosts,
}) async =>
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      barrierColor: ATColors.black.withValues(alpha: 0.5),
      backgroundColor: const Color(0xFF1C1C1E), // Apple Music modal background
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 12),
                const ATModalDismisser(),
                const SizedBox(height: 24),
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Co-hosts',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF3A3A3C),
                        ),
                        child: const Icon(Icons.close, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // List of CoHosts
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: coHosts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final CoHost coHost = coHosts[index];
                    final String title = coHost.username ?? 'unknown';
                    final String description = (coHost.bio != null && coHost.bio!.isNotEmpty)
                        ? coHost.bio!
                        : (coHost.name ?? '');
                    final String? avatar = coHost.profilePicture;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Navigate to profile
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (avatar != null && avatar.isNotEmpty)
                                ClipOval(
                                  child: ATImgLoader(
                                    imgPath: avatar,
                                    width: 56,
                                    height: 56,
                                    boxFit: BoxFit.cover,
                                  ),
                                )
                              else
                                ClipOval(
                                  child: SvgPicture.string(
                                    ATImgStrings.defaultAvatarSvg,
                                    height: 56,
                                    width: 56,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: context.textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (description.isNotEmpty)
                                      const SizedBox(height: 4),
                                    if (description.isNotEmpty)
                                      Text(
                                        description,
                                        style: context.textTheme.bodyMedium?.copyWith(
                                          color: Colors.white.withValues(alpha: 0.7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 1, // Ensure bio does not pass one line
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Follow Button
                              Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () {
                                    // Follow logic
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      'Follow',
                                      style: context.textTheme.labelLarge?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
