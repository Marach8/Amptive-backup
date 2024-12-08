import 'dart:io';
import 'dart:math';

import 'package:amptive/src/models/hashtag.dart';
import 'package:flutter/material.dart';

import '../../models/community.dart';
import '../../models/host.dart';
import '../../utils/constants/strings/image_strings.dart';

class CreateShowService {
  // Class Initializer
  static final CreateShowService _instance = CreateShowService._();

  factory CreateShowService() => _instance;

  // constructorÏ
  CreateShowService._();

  double userEventFee = 2000.0;
  File? selectedShowImage;

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

  late ValueNotifier<File?> selectedImage;

  DateTime? eventDateTime;

  initFormControl() {
    coHostSelected = ValueNotifier(false);
    hashTagSelected = ValueNotifier(false);
    hashtags = ValueNotifier([]);
    titleCharLength = ValueNotifier(0);
    descCharactersLength = ValueNotifier(0);
    selectedCoHostLength = ValueNotifier(0);
    selectedHashtagLength = ValueNotifier(0);
    selectedCoHosts = ValueNotifier({});
    selectedHashtags = ValueNotifier({});
    selectedImage = ValueNotifier(null);
    coHostsListData = getHostList();
    hashTagListData = getHashTags();

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
  }

  dispose() {
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

    for (var coHostNotifier in coHostsListData) {
      coHostNotifier.notifier.dispose();
    }

    for (var hashtag in hashTagListData) {
      hashtag.notifier.dispose();
    }
  }

  bool formIsValid() {
    return selectedImage.value != null;
  }

  onSubmit() {
    selectedShowImage = selectedImage.value;
  }

  List<Community> generateCommunities() {
    final random = Random();

    final names = [
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

    final pics = generateCorrespondingPics(names);

    int index = -1;

    return names.map((name) {
      int id = random.nextInt(1000);
      index++;

      return Community(
        id: id,
        name: name,
        coverPic: pics[index],
      );
    }).toList();
  }

  generateCorrespondingPics(List<String> names) {
    final temp = [
      AmptiveImageStrings.COMMUNITY_CARD,
      AmptiveImageStrings.artCard,
      AmptiveImageStrings.societyCard,
      AmptiveImageStrings.techCard,
    ];

    if (temp.length >= names.length) {
      return temp.sublist(0, names.length);
    }

    List result = [];
    int index = 0;

    while (result.length < names.length) {
      result.add(temp[index]);
      index = (index + 1) % temp.length;
    }

    return result;
  }

  removeSelectedCoHost(ObjectWithNotifier<Host> selCoHost) {
    final currentSet = selectedCoHosts.value;

    if (currentSet.contains(selCoHost)) {
      currentSet.remove(selCoHost);
      selectedCoHosts.value = currentSet;
      selectedCoHostLength.value = currentSet.length;
      selCoHost.notifier.value = false;
    }
  }

  addSelectedCoHost(ObjectWithNotifier<Host> selCoHost) {
    final currentSet = selectedCoHosts.value;

    if (!currentSet.contains(selCoHost)) {
      currentSet.add(selCoHost);
      selectedCoHosts.value = currentSet;
      selectedCoHostLength.value = currentSet.length;
      selCoHost.notifier.value = true;
    }
  }


  removeSelectedHashtags(ObjectWithNotifier<Hashtag> selHashtag) {
    final currentSet = selectedHashtags.value;

    if (currentSet.contains(selHashtag)) {
      currentSet.remove(selHashtag);
      selectedHashtags.value = currentSet;
      selectedHashtagLength.value = currentSet.length;
      selHashtag.notifier.value = false;
    }
  }

  addSelectedHashtags(ObjectWithNotifier<Hashtag> selHashtag) {
    final currentSet = selectedHashtags.value;

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
}

List<ObjectWithNotifier<Host>> getHostList() {
  List<ObjectWithNotifier<Host>> hostsList = [];

  final coHostsData = <String, List<String>>{
    AmptiveImageStrings.jpeg1: ['Emmanuel Ajah', 'nnanna😍💕'],
    AmptiveImageStrings.jpeg2: ['Tochukwu Iwuzed', 'tobaby'],
    AmptiveImageStrings.jpeg3: ['Ekene Okoro', 'kendo boss🦋'],
    AmptiveImageStrings.discoverPic1: ['Rita Waltson', 'rita4life🐎'],
    AmptiveImageStrings.OFFICE_LADIES: ['Lee Parker', 'therealguy'],
    AmptiveImageStrings.MAN_PHOTO: ['Daniel Adesua', 'myownbrother'],
    AmptiveImageStrings.COMMUNITY_CARD: ['Erica Nwosu', 'ricababygirl'],
    AmptiveImageStrings.CRIMINAL: ['Peter Nwokeji', 'sirpee'],
    AmptiveImageStrings.createShowPlaceholderImage: [
      'Arlan Walker',
      'walkerboss'
    ],
    AmptiveImageStrings.JOE_POMP_SHOW: ['Man Drone', 'ikennegodadi'],
  };

  coHostsData.forEach((pics, details) {
    if (details.length >= 2) {
      String name = details[0];
      String username = details[1];
      Host host = Host(
          id: 0,
          name: name,
          username: username,
          email: '',
          profilePicture: pics);

      hostsList.add(ObjectWithNotifier<Host>(obj: host));
    }
  });

  return hostsList;
}

List<ObjectWithNotifier<Hashtag>> getHashTags() {
  List<ObjectWithNotifier<Hashtag>> hashTagList = [];

  final availableHashtags = <List<String>>[
    ['Emmanuel Ajah', 'Hashtag'],
    ['Tochukwu Iwuzed', 'Hashtag'],
    ['Ekene Okoro', 'Hashtag'],
    ['Rita Waltson', 'Hashtag'],
    ['Lee Parker', 'Hashtag'],
    ['Daniel Adesua', 'Hashtag'],
    ['Erica Nwosu', 'Hashtag'],
    ['Peter Nwokeji', 'Hashtag'],
    ['Arlan Walker', 'Hashtag'],
    ['Man Drone', 'Hashtag'],
  ];

  for (var element in availableHashtags) {
    String name = element[0];
    Hashtag hashTag = Hashtag(name: name);
    hashTagList.add(ObjectWithNotifier<Hashtag>(obj: hashTag));
  }

  return hashTagList;
}
