import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';


class SelectedCohostsRow extends StatelessWidget {
  const SelectedCohostsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CohostServiceBloc, (List<ATCohost<bool>>, List<ATCohost<bool>>), List<ATCohost<bool>>>(
      selector: ((List<ATCohost<bool>>, List<ATCohost<bool>>) state) => state.$2,
      builder: (_, List<ATCohost<bool>> selectedCoHosts) {  
        final bool coHostExists = selectedCoHosts.any(
          (ATCohost<bool> cohost) => cohost.profilePicture != null
        );
        
        return ATAnimatedXFade(
          condition: coHostExists,
          secondChild: const SizedBox.shrink(),
          firstChild: ATContainer(
            height: 43, alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectedCoHosts.indexed.map(
                  ((int, ATCohost<bool>) entry) {
                    final bool isEmptyCohost = entry.$2.profilePicture == null;
                    
                    if(isEmptyCohost){                
                      return ATContainer(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 15),
                        border: Border.all(color: ATColors.white.withValues(alpha: 0.4)),
                        height: 43, width: 43, radius: 30,
                        child: Text(
                          (entry.$1 + 1).toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: ATFontSizes.size12
                          ),
                        ),
                      );
                    }
                
                    return Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ATImgLoader(
                              height: 43, width: 43, boxFit: BoxFit.cover,
                              imgPath: entry.$2.profilePicture ?? ''
                            ),
                          ),
                          Positioned(
                            top: 0, right: -4, 
                            child: ATContainer(
                              onTap: () => context.read<CohostServiceBloc>().removeCohost(entry.$2),
                              color: ATColors.textRedColor,
                              height: 17, width: 17,
                              boxShape: BoxShape.circle,
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Icon(Icons.close)
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                ).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}