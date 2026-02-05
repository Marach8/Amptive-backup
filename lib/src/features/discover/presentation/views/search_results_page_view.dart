

import 'package:amptive/src/features/discover/presentation/widgets/search_item_tile.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';

import '../../../../config/utils/image_strings.dart';

class SearchResultsTabsView extends StatefulWidget {
  const SearchResultsTabsView({super.key});

  @override
  State<SearchResultsTabsView> createState() => _SearchResultsTabsViewState();
}

class _SearchResultsTabsViewState extends State<SearchResultsTabsView> 
with SingleTickerProviderStateMixin{
  late TabController _tabController;
  late ValueNotifier<int> _isTabSelected;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _isTabSelected = ValueNotifier(0);
    
    _tabController.addListener(
      () => _isTabSelected.value = _tabController.index
    );
  }

  @override 
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          splashFactory: NoSplash.splashFactory,
          tabAlignment: TabAlignment.start,
          labelPadding: EdgeInsets.zero,
          indicatorColor: ATColors.transparent,
          padding: const EdgeInsets.only(left: 15),
          isScrollable: true,
          dividerColor: ATColors.hex0D0D0D,
          tabs: <String>['All', 'Shows', 'Events', 'Users', 'Hashtags'].asMap().entries.map(
            (MapEntry<int, String> tab){              
              return Tab(
                child: ValueListenableBuilder(
                valueListenable: _isTabSelected,
                builder: (_, int value, __) {
                  final bool isSelected = tab.key == value;
                    return ATContainer(
                      radius: 20,
                      margin: const EdgeInsets.only(right: 10),
                      color: isSelected ? 
                        ATColors.white : ATColors.hex9E9E9E.withOpacity(0.3),
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                      child: Text(
                        tab.value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(                        
                          color: isSelected ? ATColors.hex0D0D0D : ATColors.white                           
                        ),
                      ),
                    );
                  }
                ),
              );
            }
          ).toList()
        ),
        
    
        ATContainer(
          padding: const EdgeInsets.all(15),
          height: ATHelperFuncs.getScreenHeight(context),
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Column(
                children: List<Widget>.generate(
                  10,
                  (_) => SearchItemTile(
                    leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
                    title: 'We Can Do Hard Things',
                    trailing: ATContainer(
                      onTap: (){},
                      boxShape: BoxShape.circle,
                      height: 24, width: 24,
                      color: ATColors.hexB6B6B6,
                      child: Icon(Icons.play_arrow, size: 15, color: ATColors.hex0D0D0D,),
                    ),
                  ),
                )
              ),
              Column(
                children: List<Widget>.generate(
                  10,
                  (_) => SearchItemTile(
                    leadingImagePath: ATImgStrings.OFFICE_LADIES,
                    isCircular: true,
                    title: 'We Can Do Hard Things',
                    trailing: ATContainer(
                      onTap: (){},
                      boxShape: BoxShape.circle,
                      height: 24, width: 24,
                      color: ATColors.hexB6B6B6,
                      child: Icon(Icons.play_arrow, size: 15, color: ATColors.hex0D0D0D,),
                    ),
                  ),
                )
              ),
              Column(
                children: List<Widget>.generate(
                  10,
                  (_) => SearchItemTile(
                    leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
                    title: 'We Can Do Hard Things',
                    trailing: ATContainer(
                      onTap: (){},
                      boxShape: BoxShape.circle,
                      height: 24, width: 24,
                      color: ATColors.hexB6B6B6,
                      child: Icon(Icons.play_arrow, size: 15, color: ATColors.hex0D0D0D,),
                    ),
                  ),
                )
              ),
              Column(
                children: List<Widget>.generate(
                  10,
                  (_) => SearchItemTile(
                    leadingImagePath: ATImgStrings.MAN_PHOTO,
                    title: 'We Can Do Hard Things',
                    trailing: InkWell(
                      onTap: (){},
                      child: Icon(Icons.keyboard_arrow_right, size: 24, color: ATColors.hexB6B6B6,),
                    ),
                  ),
                )
              ),
              Column(
                children: List<Widget>.generate(
                  10,
                  (_) => SearchItemTile(
                    leadingImagePath: ATImgStrings.CRIMINAL,
                    title: 'We Can Do Hard Things',
                    trailing: ATContainer(
                      onTap: (){},
                      boxShape: BoxShape.circle,
                      height: 24, width: 24,
                      color: ATColors.hexB6B6B6,
                      child: Icon(Icons.play_arrow, size: 15, color: ATColors.hex0D0D0D,),
                    ),
                  ),
                )
              ),
            ],
          ),
        )
      ],
    );
  }
}