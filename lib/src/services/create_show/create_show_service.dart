import 'dart:math' hide log;
import 'dart:typed_data';

import 'package:amptive/src/models/hashtag.dart';
import 'package:flutter/material.dart';

import '../../models/community.dart';
import '../../models/host.dart';
import '../../config/utils/image_strings.dart';

class CreateShowService {

  factory CreateShowService() => _instance;

  // constructorÏ
  CreateShowService._();
  // Class Initializer
  static final CreateShowService _instance = CreateShowService._();

  double userEventFee = 2000.0;
  Uint8List? selectedShowImage;

  late ValueNotifier<bool> coHostSelectionStarted;
  late List<ObjectWithNotifier<Host>> coHostsListData;
  late List<ObjectWithNotifier<Hashtag>> hashTagListData;
  late TextEditingController descController;
  late TextEditingController audienceAccessController;
  late TextEditingController handRaisingController;
  late TextEditingController capacityController;
  late TextEditingController whisperController;
  late TextEditingController eventPaymentController;
  late TextEditingController titleController;

  late ValueNotifier<bool> coHostSelected;
  late ValueNotifier<bool> hashTagSelected;
  late ValueNotifier<List<String>> hashtags;
  late ValueNotifier<int> titleCharLength;
  late ValueNotifier<int> descCharactersLength;
  late ValueNotifier<int> selectedCoHostLength;
  late ValueNotifier<int> selectedHashtagLength;
  late ValueNotifier<Set<ObjectWithNotifier<Host>>> selectedCoHosts;
  late ValueNotifier<Set<ObjectWithNotifier<Hashtag>>> selectedHashtags;
  late ValueNotifier<Set<ObjectWithNotifier<Host>>> goLiveHostListNotifier;


  late ValueNotifier<Uint8List?> selectedImage;

  DateTime? eventDateTime;

  void initFormControl() {
    coHostSelectionStarted = ValueNotifier(false);
    coHostSelected = ValueNotifier(false);
    hashTagSelected = ValueNotifier(false);
    hashtags = ValueNotifier(<String>[]);
    titleCharLength = ValueNotifier(0);
    descCharactersLength = ValueNotifier(0);
    selectedCoHostLength = ValueNotifier(0);
    selectedHashtagLength = ValueNotifier(0);
    // selectedCoHosts = ValueNotifier({});
    selectedHashtags = ValueNotifier(<ObjectWithNotifier<Hashtag>>{});
    selectedImage = ValueNotifier(null);
    selectedCoHosts = ValueNotifier(
      List.generate(
        5,
        (_) => ObjectWithNotifier<Host>(obj: Host.empty())
      ).toSet()
    );
    coHostsListData = getHostList();
    hashTagListData = getHashTags();
    goLiveHostListNotifier = ValueNotifier(
      getHostList().take(1).toSet()..addAll(
        List.generate(
          5,
          (_) => ObjectWithNotifier<Host>(obj: Host.empty())
        )
      )
    );

    // init controllers
    titleController = TextEditingController();
    coHostsListData = getHostList();
    descController = TextEditingController();
    audienceAccessController = TextEditingController();
    handRaisingController = TextEditingController();
    capacityController = TextEditingController(text: '10');
    whisperController = TextEditingController();
    eventPaymentController =
        TextEditingController(text: userEventFee.toString());

    eventDateTime = null;
    eventPaymentController = TextEditingController(text: userEventFee.toString());
  }

  void dispose() {
    coHostSelected.dispose();
    hashTagSelected.dispose();
    hashtags.dispose();
    titleCharLength.dispose();
    descCharactersLength.dispose();
    selectedCoHostLength.dispose();
    selectedHashtagLength.dispose();
    selectedCoHosts.dispose();
    selectedHashtags.dispose();
    selectedImage.dispose();

    titleController.dispose();
    descController.dispose();
    audienceAccessController.dispose();
    handRaisingController.dispose();
    capacityController.dispose();
    whisperController.dispose();
    eventPaymentController.dispose();

    eventDateTime = null;

    for (ObjectWithNotifier<Host> coHostNotifier in coHostsListData) {
      coHostNotifier.notifier.dispose();
    }

    for (ObjectWithNotifier<Hashtag> hashtag in hashTagListData) {
      hashtag.notifier.dispose();
    }
  }

  bool formIsValid() {
    return selectedImage.value != null;
  }

  void onSubmit() {
    selectedShowImage = selectedImage.value;
  }

  List<Community> generateCommunities() {
    final Random random = Random();

    final List<String> names = <String>[
      'Music',
      'Art',
      'Society',
      'Technology',
      'Sports',
      'True Crime',
      'Business',
      'Society',
      'Technology',
      'Sports',
      'True Crime',
      'Business'
    ];

    final List pics = generateCorrespondingPics(names);

    int index = -1;

    return names.map((String name) {
      int id = random.nextInt(1000);
      index++;

      return Community(
        id: id,
        name: name,
        coverPic: pics[index],
      );
    }).toList();
  }

  List generateCorrespondingPics(List<String> names) {
    final List<String> temp = <String>[
      ATImgStrings.COMMUNITY_CARD,
      ATImgStrings.artCard,
      ATImgStrings.societyCard,
      ATImgStrings.techCard,
    ];

    if (temp.length >= names.length) {
      return temp.sublist(0, names.length);
    }

    List result = <dynamic>[];
    int index = 0;

    while (result.length < names.length) {
      result.add(temp[index]);
      index = (index + 1) % temp.length;
    }

    return result;
  }

  void removeSelectedCoHost(ObjectWithNotifier<Host> selectedCoHost) {
    // final currentSet = selectedCoHosts.value;
    final List<ObjectWithNotifier<Host>> currentList = selectedCoHosts.value.toList();
    currentList.remove(selectedCoHost);
    currentList.insert((selectedCoHostLength.value - 1), ObjectWithNotifier<Host>(obj: Host.empty()));
    selectedCoHostLength.value = selectedCoHostLength.value - 1;
    selectedCoHosts.value = currentList.toSet();
    selectedCoHost.notifier.value = false;

    if(selectedCoHostLength.value == 0){
      coHostSelectionStarted.value = false;
    }
    else{coHostSelectionStarted.value = true;}
  }

  void addSelectedCoHost(ObjectWithNotifier<Host> selectedCoHost) {
    // final currentSet = selectedCoHosts.value;
    if(selectedCoHostLength.value < 5){
      final List<ObjectWithNotifier<Host>> currentSet = selectedCoHosts.value.toList();
      currentSet[selectedCoHostLength.value] = selectedCoHost;
      selectedCoHostLength.value = selectedCoHostLength.value + 1;
      selectedCoHosts.value = currentSet.toSet();
      selectedCoHost.notifier.value = true;

      if(selectedCoHostLength.value == 0){
        coHostSelectionStarted.value = false;
      }
      else{coHostSelectionStarted.value = true;}
    }
  }


  void removeSelectedHashtags(ObjectWithNotifier<Hashtag> selHashtag) {
    final Set<ObjectWithNotifier<Hashtag>> currentSet = selectedHashtags.value;

    if (currentSet.contains(selHashtag)) {
      currentSet.remove(selHashtag);
      selectedHashtags.value = currentSet;
      selectedHashtagLength.value = currentSet.length;
      selHashtag.notifier.value = false;
    }
  }

  void addSelectedHashtags(ObjectWithNotifier<Hashtag> selHashtag) {
    final Set<ObjectWithNotifier<Hashtag>> currentSet = selectedHashtags.value;

    if (!currentSet.contains(selHashtag)) {
      currentSet.add(selHashtag);
      selectedHashtags.value = currentSet;
      selectedHashtagLength.value = currentSet.length;
      selHashtag.notifier.value = true;
    }
  }

  bool isValidEventDateTime() {
    if (eventDateTime == null) return false;

    return eventDateTime!.isAfter(DateTime.now());
  }

  void hostAddCohost(ObjectWithNotifier<Host> host, int index){
    final List<ObjectWithNotifier<Host>> newList = List<ObjectWithNotifier<Host>>.from(goLiveHostListNotifier.value);
    newList[index] = host;
    goLiveHostListNotifier.value = newList.toSet();
  }

  void hostRemoveCohost(ObjectWithNotifier<Host> host, int index){
    final List<ObjectWithNotifier<Host>> newList = List<ObjectWithNotifier<Host>>.from(goLiveHostListNotifier.value);
    newList[index] = ObjectWithNotifier<Host>(obj: Host.empty());
    goLiveHostListNotifier.value = newList.toSet();
  }
}


List<ObjectWithNotifier<Host>> getHostList() {
  List<ObjectWithNotifier<Host>> hostsList = <ObjectWithNotifier<Host>>[];

  final Map<String, List<String>> coHostsData = <String, List<String>>{
    ATImgStrings.jpeg1: <String>['Emmanuel Ajah', 'nnanna😍💕'],
    ATImgStrings.jpeg2: <String>['Tochukwu Iwuzed', 'tobaby'],
    ATImgStrings.jpeg3: <String>['Ekene Okoro', 'kendo boss🦋'],
    ATImgStrings.discoverPic1: <String>['Rita Waltson', 'rita4life🐎'],
    ATImgStrings.OFFICE_LADIES: <String>['Lee Parker', 'therealguy'],
    ATImgStrings.MAN_PHOTO: <String>['Daniel Adesua', 'myownbrother'],
    ATImgStrings.COMMUNITY_CARD: <String>['Erica Nwosu', 'ricababygirl'],
    ATImgStrings.CRIMINAL: <String>['Peter Nwokeji', 'sirpee'],
    ATImgStrings.CREATE_SHOW_PLACEHOLDER: <String>[
      'Arlan Walker',
      'walkerboss'
    ],
    ATImgStrings.JOE_POMP_SHOW: <String>['Man Drone', 'ikennegodadi'],
  };

  for (int i = 0; i < coHostsData.entries.length; i++){
    final MapEntry<String, List<String>> item = coHostsData.entries.elementAt(i);
    String name = item.value[0];
    String username = item.value[1];
    Host host = Host(
      id: i, name: name,
      username: username,
      email: '',
      profilePicture: item.key
    );

    hostsList.add(ObjectWithNotifier<Host>(obj: host));
  }

  return hostsList;
}


List<ATCohost<bool>> getCoHostList() {
  List<ATCohost<bool>> coHostsList = <ATCohost<bool>>[];

  final Map<String, List<String>> coHostsData = <String, List<String>>{
    ATImgStrings.jpeg1: <String>['Emmanuel Ajah', 'nnanna😍💕'],
    ATImgStrings.jpeg2: <String>['Tochukwu Iwuzed', 'tobaby'],
    ATImgStrings.jpeg3: <String>['Ekene Okoro', 'kendo boss🦋'],
    ATImgStrings.discoverPic1: <String>['Rita Waltson', 'rita4life🐎'],
    ATImgStrings.OFFICE_LADIES: <String>['Lee Parker', 'therealguy'],
    ATImgStrings.MAN_PHOTO: <String>['Daniel Adesua', 'myownbrother'],
    ATImgStrings.COMMUNITY_CARD: <String>['Erica Nwosu', 'ricababygirl'],
    ATImgStrings.CRIMINAL: <String>['Peter Nwokeji', 'sirpee'],
    ATImgStrings.CREATE_SHOW_PLACEHOLDER: <String>[
      'Arlan Walker',
      'walkerboss'
    ],
    ATImgStrings.JOE_POMP_SHOW: <String>['Man Drone', 'ikennegodadi'],
  };

  for (int i = 0; i < coHostsData.entries.length; i++){
    final MapEntry<String, List<String>> item = coHostsData.entries.elementAt(i);
    String name = item.value[0];
    String username = item.value[1];
    ATCohost<bool> coHost = ATCohost<bool>(
      id: i, name: name,
      username: username,
      email: '',
      profilePicture: item.key,
      intialNotifierValue: false,
    );

    coHostsList.add(coHost);
  }

  return coHostsList;
}

List<ATHashtag<bool>> getHashTagsList(){
  List<ATHashtag<bool>> hashTagsList = <ATHashtag<bool>>[];

  final List<String> stringTags = <String>[
    'wecandohardthings', 'society', 'trumpisdead',
    'documentary', 'amptiveliveshow', 'heavenisgood',
    'theworldsfirstjet', 'everythingyouwant', 'buggati',
    'thingsfallapart'
  ];

  for (int i = 0; i < stringTags.length; i++){
    final String stringTag = stringTags.elementAt(i);
    final ATHashtag<bool> hashtag = ATHashtag<bool>(
      title: stringTag,
      id: i,
      intialNotifierValue: false,
    );

    hashTagsList.add(hashtag);
  }
  return hashTagsList;
}


List<ObjectWithNotifier<Hashtag>> getHashTags() {
  List<ObjectWithNotifier<Hashtag>> hashTagList = <ObjectWithNotifier<Hashtag>>[];

  final List<List<String>> availableHashtags = <List<String>>[
    <String>['Emmanuel Ajah', 'Hashtag'],
    <String>['Tochukwu Iwuzed', 'Hashtag'],
    <String>['Ekene Okoro', 'Hashtag'],
    <String>['Rita Waltson', 'Hashtag'],
    <String>['Lee Parker', 'Hashtag'],
    <String>['Daniel Adesua', 'Hashtag'],
    <String>['Erica Nwosu', 'Hashtag'],
    <String>['Peter Nwokeji', 'Hashtag'],
    <String>['Arlan Walker', 'Hashtag'],
    <String>['Man Drone', 'Hashtag'],
  ];

  for (List<String> element in availableHashtags) {
    String name = element[0];
    Hashtag hashTag = Hashtag(name: name);
    hashTagList.add(ObjectWithNotifier<Hashtag>(obj: hashTag));
  }

  return hashTagList;
}
