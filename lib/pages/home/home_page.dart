import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/data.dart';
import 'widgets/model_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  double _currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8)
      ..addListener(() {
        setState(() {
          _currentPageValue = _pageController.page!;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: _ModelPreview(
        pageController: _pageController,
        currentPageValue: _currentPageValue,
      ),
    );
  }
}

class _ModelPreview extends StatelessWidget {
  const _ModelPreview({
    Key? key,
    required this.pageController,
    required this.currentPageValue,
  }) : super(key: key);

  final PageController pageController;
  final double currentPageValue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PageView.builder(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: models.length,
        itemBuilder: (context, index) {
          var scale = (currentPageValue - index).abs();
          return ModelCard(
            index: index,
            scale: scale,
          );
        },
      ),
    );
  }
}
