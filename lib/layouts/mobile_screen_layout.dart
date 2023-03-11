import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/colors.dart';
import 'package:flutter_instagram/utils/globals.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
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
    setState(() => _pageIndex = value);
    _pageController.jumpToPage(value);
  }

  void onPageChanged(value) {
    setState(() => _pageIndex = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: screenItems,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          activeColor: primaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house),
              label: '',
              backgroundColor: primaryColor,
              activeIcon: Icon(CupertinoIcons.house_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add_circled),
              label: '',
              backgroundColor: primaryColor,
              activeIcon: Icon(CupertinoIcons.add_circled_solid),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart),
              label: '',
              backgroundColor: primaryColor,
              activeIcon: Icon(CupertinoIcons.heart_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: '',
              backgroundColor: primaryColor,
              activeIcon: Icon(CupertinoIcons.person_fill),
            ),
          ],
          currentIndex: _pageIndex,
          onTap: onNavigationTap,
        ),
      ),
    );
  }
}
