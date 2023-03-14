import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/colors.dart';
import 'package:flutter_instagram/utils/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({
    Key? key,
  }) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _pageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onNavigationTap(value) {
    onPageChanged(value);
    _pageController.jumpToPage(value);
  }

  void onPageChanged(value) {
    setState(() => _pageIndex = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/logo.svg',
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () => onNavigationTap(0),
            icon: Icon(
              CupertinoIcons.house,
              color: _pageIndex == 0 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => onNavigationTap(1),
            icon: Icon(
              CupertinoIcons.search,
              color: _pageIndex == 1 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => onNavigationTap(2),
            icon: Icon(
              CupertinoIcons.camera,
              color: _pageIndex == 2 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => onNavigationTap(3),
            icon: Icon(
              CupertinoIcons.heart,
              color: _pageIndex == 3 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => onNavigationTap(4),
            icon: Icon(
              CupertinoIcons.person,
              color: _pageIndex == 4 ? primaryColor : secondaryColor,
            ),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: screenItems,
      ),
    );
  }
}
