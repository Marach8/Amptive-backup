import 'package:flutter/material.dart';
import '../../models/host.dart';
import '../../config/utils/image_strings.dart';
import 'dart:developer' as marach show log;

class GoLiveService {

  factory GoLiveService() => _instance;

  // constructorÏ
  GoLiveService._();
  // Class Initializer
  static final GoLiveService _instance = GoLiveService._();

  late List<ObjectWithNotifier<Host>> coHostsListData;
  late TextEditingController titleController;


  late ValueNotifier<bool> coHostSelectionStarted;
  late ValueNotifier<bool> scroll2Bottom;

  late ValueNotifier<int> selectedCoHostLength;
  late ValueNotifier<Set<ObjectWithNotifier<Host>>> selectedCoHosts;
  late ValueNotifier<Set<ObjectWithNotifier<Host>>> goLiveHostListNotifier;
  late ValueNotifier<List<ObjectWithNotifier<Host>>> goLiveHostList4AudienceNotifier;


  void initFormControl() {
    coHostSelectionStarted = ValueNotifier(false);
    selectedCoHostLength = ValueNotifier(0);
    scroll2Bottom = ValueNotifier(false);
    selectedCoHosts = ValueNotifier(
      List.generate(
        5,
        (_) => ObjectWithNotifier<Host>(obj: Host.empty())
      ).toSet()
    );
    coHostsListData = getHostList();
    goLiveHostListNotifier = ValueNotifier(
      getHostList().take(1).toSet()..addAll(
        List.generate(
          5,
          (_) => ObjectWithNotifier<Host>(obj: Host.empty())
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

  void dispose() {
    selectedCoHostLength.dispose();
    selectedCoHosts.dispose();
    titleController.dispose();

    for (ObjectWithNotifier<Host> coHostNotifier in coHostsListData) {
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

  void hostAddCohost(ObjectWithNotifier<Host> host, int index){
    // final newList = List<HostWithNotifier>.from(goLiveHostListNotifier.value);
    // newList[index] = host;
    // host.notifier.value = true;
    // goLiveHostListNotifier.value = newList.toSet();


    if(counter <= 5){
      marach.log(counter.toString());
      final List<ObjectWithNotifier<Host>> audienceList = goLiveHostList4AudienceNotifier.value;
      audienceList.add(coHostsListData[counter]);
      goLiveHostList4AudienceNotifier.value = List.from(audienceList);
      counter ++;
    }
  }
  

  void hostRemoveCohost(ObjectWithNotifier<Host> host, int index){
    // final newList = List<HostWithNotifier>.from(goLiveHostListNotifier.value);
    // newList[index] = HostWithNotifier(host: Host.empty());
    // host.notifier.value = false;
    // goLiveHostListNotifier.value = newList.toSet();


    if(counter > 1){
      final List<ObjectWithNotifier<Host>> audienceList = goLiveHostList4AudienceNotifier.value;
      audienceList.removeAt(counter - 1);
      goLiveHostList4AudienceNotifier.value = List.from(audienceList);
      counter --;
    }
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

  coHostsData.forEach((String pics, List<String> details) {
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
