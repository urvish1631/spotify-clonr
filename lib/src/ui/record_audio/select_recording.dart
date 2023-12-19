import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/ui/record_audio/audio_recorder.dart';
import 'package:spotify_clone/src/ui/record_audio/write_article.dart';

class SelectRecordingScreen extends StatefulWidget {
  const SelectRecordingScreen({Key? key}) : super(key: key);

  @override
  State<SelectRecordingScreen> createState() => _SelectRecordingScreenState();
}

class _SelectRecordingScreenState extends State<SelectRecordingScreen>
    with TickerProviderStateMixin {
  //Variables
  int? _selectedIndex;
  TabController? _tabController;

  //Life cycle methods
  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _selectedIndex ?? 0,
    );
    _tabController?.addListener(() {
      setState(() {
        _selectedIndex = _tabController?.index;
      });
      if ((_tabController ??
              TabController(
                length: 2,
                vsync: this,
                initialIndex: _selectedIndex ?? 0,
              ))
          .indexIsChanging) {
        FocusScope.of(context).unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getTabs(_tabController),
        const SizedBox(height: 20.0),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              AudioRecorderScreen(),
              WriteArticleScreen(fromProfile: false),
            ],
          ),
        ),
      ],
    ).authContainerScaffold(
      context: context,
      isLeadingEnable: true,
      isTitleEnable: true,
      title: Localization.of().addArticle,
    );
  }

  //Widget
  Widget _getTabs(TabController? tabController) {
    return TabBar(
      labelColor: whiteColor,
      unselectedLabelColor: ternartColor,
      indicatorColor: primaryColor,
      controller: tabController,
      tabs: [
        Tab(
          text: Localization.of().record,
        ),
        Tab(
          text: Localization.of().write,
        ),
      ],
    );
  }
}
