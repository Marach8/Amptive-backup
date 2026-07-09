import 'package:amptive/src/config/utils/dialogs/added_or_removed_from_calender_dialog.dart';
import 'package:amptive/src/features/discover/data/community_membership_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _NativeContextMenuBridge {
  static const MethodChannel _channel =
      MethodChannel('amptive/native_context_menu');
  static final Map<String, void Function(String)> _callbacks =
      <String, void Function(String)>{};
  static bool _initialized = false;

  static void register(
    String requestId,
    void Function(String) onSelected,
  ) {
    if (!_initialized) {
      _initialized = true;
      _channel.setMethodCallHandler((MethodCall call) async {
        if (call.method != 'selected') return;
        final Map<Object?, Object?> arguments =
            (call.arguments as Map<Object?, Object?>?) ?? <Object?, Object?>{};
        final String requestId = arguments['requestId'] as String? ?? '';
        final String action = arguments['action'] as String? ?? '';
        _callbacks[requestId]?.call(action);
      });
    }
    _callbacks[requestId] = onSelected;
  }

  static void unregister(String requestId) => _callbacks.remove(requestId);
}

class FollowUnfollowDropDown extends StatefulWidget {
  const FollowUnfollowDropDown({
    super.key,
    required this.child,
    required this.onSelected,
    required this.text,
    required this.popUpTrailingIcon,
    required this.communityName,
    this.communityId,
  });

  final Widget child, popUpTrailingIcon;
  final String text, communityName;
  final String? communityId;
  final void Function(String)? onSelected;

  @override
  State<FollowUnfollowDropDown> createState() => _FollowUnfollowDropDownState();
}

class _FollowUnfollowDropDownState extends State<FollowUnfollowDropDown> {
  final CommunityMembershipController _membership =
      CommunityMembershipController.instance;
  late final String _requestId =
      '${widget.communityName}_${identityHashCode(this)}';
  late String _actionText;

  @override
  void initState() {
    super.initState();
    _actionText = widget.text;
    _membership.addListener(_syncMembershipState);
    _membership.load();
    _syncMembershipState();
    _registerCallback();
  }

  void _syncMembershipState() {
    final String? communityId = widget.communityId;
    if (communityId == null) return;
    final String nextAction =
        _membership.isFollowing(communityId) ? 'Unfollow' : 'Follow';
    if (_actionText != nextAction && mounted) {
      setState(() => _actionText = nextAction);
    }
  }

  @override
  void didUpdateWidget(covariant FollowUnfollowDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _actionText = widget.text;
    }
    _registerCallback();
  }

  void _registerCallback() {
    _NativeContextMenuBridge.register(
      _requestId,
      (String action) async {
        if (action == _actionText) {
          final bool isFollowing = action.toLowerCase() == 'follow';
          final String? communityId = widget.communityId;
          if (communityId != null) {
            final bool succeeded = await _membership.toggle(communityId);
            if (!mounted || !succeeded) return;
          } else {
            setState(() {
              _actionText = isFollowing ? 'Unfollow' : 'Follow';
            });
          }
          showCommunityFollowSnackbar(
            context: context,
            communityName: widget.communityName,
            isFollowing: isFollowing,
          );
        }
        widget.onSelected?.call(action);
      },
    );
  }

  @override
  void dispose() {
    _membership.removeListener(_syncMembershipState);
    _NativeContextMenuBridge.unregister(_requestId);
    super.dispose();
  }

  Map<String, Object> get _creationParams => <String, Object>{
        'requestId': _requestId,
        'title': widget.communityName,
        'action': _actionText,
        'destructive': _actionText.toLowerCase() == 'unfollow',
      };

  Widget _nativeTouchSurface() {
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => UiKitView(
          key: ValueKey<String>(_actionText),
          viewType: 'amptive/native_context_menu_button',
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      TargetPlatform.android => AndroidView(
          key: ValueKey<String>(_actionText),
          viewType: 'amptive/native_context_menu_button',
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Options for ${widget.communityName}',
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(child: Center(child: widget.child)),
            Positioned(
              top: 0,
              left: 0,
              width: 48,
              height: 48,
              child: _nativeTouchSurface(),
            ),
          ],
        ),
      ),
    );
  }
}
