import 'package:amptive/src/features/main_app_shell.dart';

class GoLiveProgramParams {
  const GoLiveProgramParams({
    required this.streamId,
    required this.userType,
    this.contentId,
  });

  final String streamId;
  final GoLiveUserType userType;
  final String? contentId;

  bool get isHost => userType == GoLiveUserType.host;
  bool get isCohost => userType == GoLiveUserType.cohost;
  bool get isAudience => userType == GoLiveUserType.audience;
}
