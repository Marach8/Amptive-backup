import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/discover/data/models/response/communities_response_model.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:flutter/foundation.dart';

class CommunityMembershipController extends ChangeNotifier {
  CommunityMembershipController._();

  static final CommunityMembershipController instance =
      CommunityMembershipController._();

  final DiscoverRepo _repository = DiscoverRepoImpl();
  final Set<String> _communityIds = <String>{};
  final Set<String> _pendingIds = <String>{};
  bool _hasLoaded = false;
  bool _isLoading = false;

  bool isFollowing(String communityId) => _communityIds.contains(communityId);
  bool isPending(String communityId) => _pendingIds.contains(communityId);

  Future<void> load() async {
    if (_hasLoaded || _isLoading) return;
    _isLoading = true;
    final ApiResponse<CommunitiesResponseModel> response =
        await _repository.fetchMyCommunities();
    response.when(
      successful: (Successful<CommunitiesResponseModel> result) {
        _communityIds
          ..clear()
          ..addAll(result.data?.communityIds ?? <String>[]);
        _hasLoaded = true;
      },
      unSuccessful: (_) {},
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> toggle(String communityId) async {
    if (_pendingIds.contains(communityId)) return false;

    final bool wasFollowing = isFollowing(communityId);
    _pendingIds.add(communityId);
    if (wasFollowing) {
      _communityIds.remove(communityId);
    } else {
      _communityIds.add(communityId);
    }
    notifyListeners();

    final ApiResponse<bool> response = wasFollowing
        ? await _repository.leaveCommunity(communityId: communityId)
        : await _repository.joinCommunity(communityId: communityId);
    bool succeeded = false;
    response.when(
      successful: (_) => succeeded = true,
      unSuccessful: (_) {
        if (wasFollowing) {
          _communityIds.add(communityId);
        } else {
          _communityIds.remove(communityId);
        }
      },
    );
    _pendingIds.remove(communityId);
    notifyListeners();
    return succeeded;
  }
}
