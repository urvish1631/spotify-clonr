import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class MediaPickerBottomSheet extends StatelessWidget {
  const MediaPickerBottomSheet({
    Key? key,
    required String title,
    required List<Widget> children,
  })  : _title = title,
        _children = children,
        super(key: key);

  final String _title;
  final List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemeText(
            text: _title,
            lightTextColor: whiteColor,
            darkTextColor: Colors.white,
            fontSize: fontSize16,
            fontWeight: fontWeightMedium,
          ),
          const SizedBox(height: 10.0),
          Flexible(
            child: GridView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0.0,
                mainAxisExtent: 80.0,
                crossAxisSpacing: 0.0,
              ),
              children: _children,
            ),
          )
        ],
      ),
    );
  }
}
