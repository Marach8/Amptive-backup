import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/helpers/helper_functions/helper_functions.dart';
import 'tab_view_listtile.dart';

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
          indicatorColor: ATColors.trsprnt,
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
                children: List.generate(
                  10,
                  (_) => const AmptiveTabViewListTileWidget(
                    leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
                    addPlayButton: true,
                    title: 'We Can Do Hard Things',
                  ),
                )
              ),
              Column(
                children: List.generate(
                  10,
                  (_) => const AmptiveTabViewListTileWidget(
                    leadingImagePath: ATImgStrings.OFFICE_LADIES,
                    isCircular: true,
                    addPlayButton: true,
                    title: 'We Can Do Hard Things',
                  ),
                )
              ),
              Column(
                children: List.generate(
                  10,
                  (_) => const AmptiveTabViewListTileWidget(
                    leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
                    addPlayButton: true,
                    title: 'We Can Do Hard Things',
                  ),
                )
              ),
              Column(
                children: List.generate(
                  10,
                  (_) => const AmptiveTabViewListTileWidget(
                    leadingImagePath: ATImgStrings.MAN_PHOTO,
                    title: 'We Can Do Hard Things',
                  ),
                )
              ),
              Column(
                children: List.generate(
                  10,
                  (_) => const AmptiveTabViewListTileWidget(
                    leadingImagePath: ATImgStrings.CRIMINAL,
                    addPlayButton: true,
                    title: 'We Can Do Hard Things',
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