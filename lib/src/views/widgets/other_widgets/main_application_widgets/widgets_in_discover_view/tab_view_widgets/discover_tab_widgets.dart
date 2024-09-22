import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/helpers/helper_functions/other_functions.dart';
import 'tab_view_listtile.dart';

class AmptiveDiscoverTabView extends StatefulWidget {
  const AmptiveDiscoverTabView({super.key});

  @override
  State<AmptiveDiscoverTabView> createState() => _AmptiveDiscoverTabViewState();
}

class _AmptiveDiscoverTabViewState extends State<AmptiveDiscoverTabView> 
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
      children: [
        TabBar(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          splashFactory: NoSplash.splashFactory,
          tabAlignment: TabAlignment.start,
          labelPadding: EdgeInsets.zero,
          indicatorColor: AmptiveColors.transparentColor,
          padding: const EdgeInsets.only(left: 15),
          isScrollable: true,
          dividerColor: AmptiveColors.brandBlackColor,
          tabs: ['Top', 'Shows', 'Events', 'Users', 'Hashtags'].asMap().entries.map(
            (tab){              
              return Tab(
                child: ValueListenableBuilder(
                valueListenable: _isTabSelected,
                builder: (_, value, __) {
                  final isSelected = tab.key == value;
                    return AmptiveCustomContainer(
                      radius: 20,
                      margin: const EdgeInsets.only(right: 10),
                      color: isSelected ? 
                        AmptiveColors.whiteColor : AmptiveColors.fillGreyColor.withOpacity(0.3),
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                      child: Text(
                        tab.value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected ? AmptiveColors.brandBlackColor : AmptiveColors.whiteColor                           
                        ),
                      ),
                    );
                  }
                ),
              );
            }
          ).toList()
        ),
        
    
        AmptiveCustomContainer(
          padding: const EdgeInsets.all(15),
          height: AmptiveHelperFunctions.getScreenHeight(context),
          child: TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: List.generate(
                  10,
                  (_) => const AmptiveTabViewListTileWidget(
                    leadingImagePath: AmptiveImageStrings.weCanDoHardThingsBgImage,
                    addPlayButton: true,
                    title: 'We Can Do Hard Things',
                  ),
                )
              ),
              Column(
                children: List.generate(
                  10,
                  (_) => const AmptiveTabViewListTileWidget(
                    leadingImagePath: AmptiveImageStrings.OFFICE_LADIES,
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
                    leadingImagePath: AmptiveImageStrings.weCanDoHardThingsBgImage,
                    addPlayButton: true,
                    title: 'We Can Do Hard Things',
                  ),
                )
              ),
              Column(
                children: List.generate(
                  10,
                  (_) => const AmptiveTabViewListTileWidget(
                    leadingImagePath: AmptiveImageStrings.MAN_PHOTO,
                    title: 'We Can Do Hard Things',
                  ),
                )
              ),
              Column(
                children: List.generate(
                  10,
                  (_) => const AmptiveTabViewListTileWidget(
                    leadingImagePath: AmptiveImageStrings.CRIMINAL,
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