import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
class UnifiedSearchResponseModel  {
  const UnifiedSearchResponseModel({
    this.users,
    this.shows,
    //this.episodes,
    this.events,
    this.hashtags,
   
  });

  factory UnifiedSearchResponseModel.fromJson(Map<String, dynamic> json) {
    // Top level data map
    final Map<String, dynamic> data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    
    // Explicitly parse every resource list from the nested 'items' key
    return UnifiedSearchResponseModel(
       users: (data['users']?['items'] as List<dynamic>?)
          ?.map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
          
      shows: (data['shows']?['items'] as List<dynamic>?)
          ?.map((dynamic e) => HostedShow.fromJson(e as Map<String, dynamic>))
          .toList(),

      hashtags: (data['hashtags']?['items'] as List<dynamic>?)
          ?.map((dynamic e) => HashTag.fromJson(e as Map<String, dynamic>))
          .toList(),

      events: (data['events']?['items'] as List<dynamic>?)
          ?.map((dynamic e) => HostedShow.fromJson(e as Map<String, dynamic>))
          .toList(),

      // episodes: (data['episodes']?['items'] as List<dynamic>?)
      //     ?.map((dynamic e) => Episode.fromJson(e as Map<String, dynamic>))
      //     .toList(),
    );
  }

  final List<User>? users;
  final List<HostedShow>? shows;
  //final List<Episode>? episodes;
  final List<HostedShow>? events;
  final List<HashTag>? hashtags;

  
}
