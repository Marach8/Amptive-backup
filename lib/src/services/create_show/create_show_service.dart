import 'dart:math';

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

  late List<HostWithNotifier> coHostsListData;
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
  late ValueNotifier<Set<HostWithNotifier>> selectedCoHosts;


  initFormControl() {
    coHostSelected = ValueNotifier(false);
    hashTagSelected = ValueNotifier(false);
    hashtags = ValueNotifier([]);
    titleCharLength = ValueNotifier(0);
    descCharactersLength = ValueNotifier(0);
    selectedCoHostLength = ValueNotifier(0);
    selectedCoHosts = ValueNotifier({});
    coHostsListData = getHostList();

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
  }

  dispose() {
    coHostSelected.dispose();
    hashTagSelected.dispose();
    hashtags.dispose();
    titleCharLength.dispose();
    descCharactersLength.dispose();
    selectedCoHostLength.dispose();
    selectedCoHosts.dispose();

    titleController.dispose();
    descController.dispose();
    audienceAccessController.dispose();
    handRaisingController.dispose();
    capacityController.dispose();
    whisperController.dispose();
    eventPaymentController.dispose();

    for (var coHostNotifier in coHostsListData) {
      coHostNotifier.notifier.dispose();
    }
  }

  bool formIsValid(){
    return audienceAccessController.text != "";
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

  removeSelectedCoHost(HostWithNotifier selCoHost) {
    final currentSet = selectedCoHosts.value;

    if (currentSet.contains(selCoHost)) {
      currentSet.remove(selCoHost);
      selectedCoHosts.value = currentSet;
      selectedCoHostLength.value = currentSet.length;
      selCoHost.notifier.value = false;
    }
  }

  addSelectedCoHost(HostWithNotifier selCoHost) {
    final currentSet = selectedCoHosts.value;

    if (!currentSet.contains(selCoHost)) {
      currentSet.add(selCoHost);
      selectedCoHosts.value = currentSet;
      selectedCoHostLength.value = currentSet.length;
      selCoHost.notifier.value = true;
    }
  }
}

List<HostWithNotifier> getHostList() {
  List<HostWithNotifier> hostsList = [];

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

      hostsList.add(HostWithNotifier(host: host));
    }
  });

  return hostsList;
}
