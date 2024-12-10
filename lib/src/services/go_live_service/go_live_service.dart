import 'package:flutter/material.dart';
import '../../models/host.dart';
import '../../utils/constants/strings/image_strings.dart';
import 'dart:developer' as marach show log;

class GoLiveService {
  // Class Initializer
  static final GoLiveService _instance = GoLiveService._();

  factory GoLiveService() => _instance;

  // constructorÏ
  GoLiveService._();

  late List<HostWithNotifier> coHostsListData;
  late TextEditingController titleController;


  late ValueNotifier<bool> coHostSelectionStarted;
  late ValueNotifier<bool> scroll2Bottom;

  late ValueNotifier<int> selectedCoHostLength;
  late ValueNotifier<Set<HostWithNotifier>> selectedCoHosts;
  late ValueNotifier<Set<HostWithNotifier>> goLiveHostListNotifier;
  late ValueNotifier<List<HostWithNotifier>> goLiveHostList4AudienceNotifier;


  initFormControl() {
    coHostSelectionStarted = ValueNotifier(false);
    selectedCoHostLength = ValueNotifier(0);
    scroll2Bottom = ValueNotifier(false);
    selectedCoHosts = ValueNotifier(
      List.generate(
        5,
        (_) => HostWithNotifier(host: Host.empty())
      ).toSet()
    );
    coHostsListData = getHostList();
    goLiveHostListNotifier = ValueNotifier(
      getHostList().take(1).toSet()..addAll(
        List.generate(
          5,
          (_) => HostWithNotifier(host: Host.empty())
        )
      )
    );
    goLiveHostList4AudienceNotifier = ValueNotifier(
      getHostList().take(1).toList()
    );

    // init controllers
    titleController = TextEditingController();
    coHostsListData = getHostList();
  }

  dispose() {
    selectedCoHostLength.dispose();
    selectedCoHosts.dispose();
    titleController.dispose();

    for (var coHostNotifier in coHostsListData) {
      coHostNotifier.notifier.dispose();
    }
  }


  // removeSelectedCoHost(HostWithNotifier selectedCoHost) {
  //   final currentList = selectedCoHosts.value.toList();
  //   currentList.remove(selectedCoHost);
  //   currentList.insert((selectedCoHostLength.value - 1), HostWithNotifier(host: Host.empty()));
  //   selectedCoHostLength.value = selectedCoHostLength.value - 1;
  //   selectedCoHosts.value = currentList.toSet();
  //   selectedCoHost.notifier.value = false;

  //   if(selectedCoHostLength.value == 0){
  //     coHostSelectionStarted.value = false;
  //   }
  //   else{coHostSelectionStarted.value = true;}
  // }

  // addSelectedCoHost(HostWithNotifier selectedCoHost) {
  //   if(selectedCoHostLength.value < 5){
  //     final currentSet = selectedCoHosts.value.toList();
  //     currentSet[selectedCoHostLength.value] = selectedCoHost;
  //     selectedCoHostLength.value = selectedCoHostLength.value + 1;
  //     selectedCoHosts.value = currentSet.toSet();
  //     selectedCoHost.notifier.value = true;

  //     if(selectedCoHostLength.value == 0){
  //       coHostSelectionStarted.value = false;
  //     }
  //     else{coHostSelectionStarted.value = true;}
  //   }
  // }

  
  int counter = 1;

  hostAddCohost(HostWithNotifier host, int index){
    // final newList = List<HostWithNotifier>.from(goLiveHostListNotifier.value);
    // newList[index] = host;
    // host.notifier.value = true;
    // goLiveHostListNotifier.value = newList.toSet();


    if(counter <= 5){
      marach.log(counter.toString());
      final audienceList = goLiveHostList4AudienceNotifier.value;
      audienceList.add(coHostsListData[counter]);
      goLiveHostList4AudienceNotifier.value = List.from(audienceList);
      counter ++;
    }
  }
  

  hostRemoveCohost(HostWithNotifier host, int index){
    // final newList = List<HostWithNotifier>.from(goLiveHostListNotifier.value);
    // newList[index] = HostWithNotifier(host: Host.empty());
    // host.notifier.value = false;
    // goLiveHostListNotifier.value = newList.toSet();


    if(counter > 1){
      final audienceList = goLiveHostList4AudienceNotifier.value;
      audienceList.removeAt(counter - 1);
      goLiveHostList4AudienceNotifier.value = List.from(audienceList);
      counter --;
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
