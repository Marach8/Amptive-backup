import 'package:amptive/src/shared/global_model_objects.dart';

/// Temporary design data used while the Discover hashtag experience is built.
const List<HashTag> mockTrendingHashtags = <HashTag>[
  HashTag(id: 'mock-1', name: 'wecandohardthings', usageCount: 24800),
  HashTag(id: 'mock-2', name: 'society', usageCount: 19300),
  HashTag(id: 'mock-3', name: 'trumpisdead', usageCount: 17200),
  HashTag(id: 'mock-4', name: 'documentary', usageCount: 14100),
  HashTag(id: 'mock-5', name: 'amptiveliveshow', usageCount: 12800),
  HashTag(id: 'mock-6', name: 'heavenisgood', usageCount: 9600),
  HashTag(id: 'mock-7', name: 'theworldsfirstjet', usageCount: 8200),
  HashTag(id: 'mock-8', name: 'everythingyouwant', usageCount: 7100),
  HashTag(id: 'mock-9', name: 'buggati', usageCount: 5400),
  HashTag(id: 'mock-10', name: 'thingsfallapart', usageCount: 4300),
];

const Map<String, String> _mockLiveActivityByHashtag = <String, String>{
  'wecandohardthings': 'ankria22, gledonnor, and 15k others are live',
  'society': 'mayaelise, chineduoko, and 12k others are live',
  'trumpisdead': 'newsroomdaily, theo_james, and 9.8k others are live',
  'documentary': 'lensbyada, filmwithnoah, and 8.4k others are live',
  'amptiveliveshow': 'ammybach, rita_w, and 7.2k others are live',
  'heavenisgood': 'faithwithami, joelane, and 5.6k others are live',
  'theworldsfirstjet': 'aviationmax, skylarj, and 4.9k others are live',
  'everythingyouwant': 'noracreates, danieladesua, and 4.1k others are live',
  'buggati': 'autobyken, motorsdaily, and 3.2k others are live',
  'thingsfallapart': 'booktalkada, litwithsam, and 2.7k others are live',
};

String mockTrendingActivityTextFor(HashTag hashtag) {
  return _mockLiveActivityByHashtag[hashtag.name] ??
      'Creators using this hashtag are live';
}
