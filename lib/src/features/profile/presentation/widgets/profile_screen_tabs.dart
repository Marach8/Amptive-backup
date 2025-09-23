import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/profile_bloc_export.dart';

class ProfileScreenTabs extends StatelessWidget {
  const ProfileScreenTabs({
    super.key,
    required this.tabs
  });

  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ATColors.black,             
      child: BlocBuilder<ProfileTabViewBloc, int>(
        builder: (_, int state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(        
              mainAxisAlignment: MainAxisAlignment.spaceBetween,            
              children: <Widget>[
                const SizedBox(width: 15,),
                ...tabs.map(
                  (String string){
                    final int index = tabs.indexOf(string);
                    final bool isSelected = index == state;
                    return ATContainer(
                      curve: Curves.decelerate,
                      alignment: Alignment.center, radius: 50,
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      margin: const EdgeInsets.only(right: 10),
                      color: isSelected ? ATColors.white : ATColors.black,
                      border: !isSelected ? Border.all(
                        color: ATColors.white.withOpacity(0.1),
                        width: 2
                      ) : null,
                      onTap: () => context.read<ProfileTabViewBloc>().goToPage(index),
                      child: Text(
                        string,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: ATSizes.size13,
                          color: isSelected ? ATColors.black : ATColors.white
                        ),
                      ),
                    );
                  }
                )
              ]
            ),
          );
        }
      ),
    );
  }
}
