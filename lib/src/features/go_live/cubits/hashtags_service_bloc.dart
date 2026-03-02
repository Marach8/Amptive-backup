import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HashtagServiceBloc extends Cubit<(List<ATHashtag<bool>>, List<ATHashtag<bool>>)>{
  HashtagServiceBloc() : super((initialHashtags, <ATHashtag<bool>>[]));

  static List<ATHashtag<bool>> initialHashtags = getHashTagsList();

  void addHashtag(ATHashtag<bool> incomingHashtag) {
    final List<ATHashtag<bool>> currentHashtags = List<ATHashtag<bool>>.from(state.$2);

    if(currentHashtags.length == 5) return;

    currentHashtags.add(incomingHashtag);
    incomingHashtag.updateNotifier(true);
    
    emit((state.$1, currentHashtags));
  }


  void removeHashtag(ATHashtag<bool> outGoingHashtag){
    final List<ATHashtag<bool>> currentHashtags = List<ATHashtag<bool>>.from(state.$2);
    if(!currentHashtags.contains(outGoingHashtag)) return;

    currentHashtags.remove(outGoingHashtag);
    outGoingHashtag.updateNotifier(false);
    
    emit((state.$1, currentHashtags));
  }


  void searchHashtags(String searchKey){
    final List<ATHashtag<bool>> filterHashtags = initialHashtags.where(
      (ATHashtag<bool> hashtag) 
      => hashtag.title!.toLowerCase().contains(searchKey.toLowerCase()) 
    ).toList();

    emit((filterHashtags, state.$2));
  }

  void resetBloc() => emit((initialHashtags, <ATHashtag<bool>>[]));

  void resetHashtagsSearch() => emit((initialHashtags, state.$2));
}