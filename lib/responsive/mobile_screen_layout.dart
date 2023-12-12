import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/screens/add_post_screen.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';
import 'package:flutter_danthocode_instagram_clone/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // UserModel user = Provider.of<UserModelProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: pageScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: InstagramColor.mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? InstagramColor.primaryColor : InstagramColor.secondaryColor,
            ),
            label: '',
            backgroundColor: InstagramColor.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? InstagramColor.primaryColor : InstagramColor.secondaryColor,
            ),
            label: '',
            backgroundColor: InstagramColor.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? InstagramColor.primaryColor : InstagramColor.secondaryColor,
              size: 40,
            ),
            label: '',
            backgroundColor: InstagramColor.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _page == 3 ? InstagramColor.primaryColor : InstagramColor.secondaryColor,
            ),
            label: '',
            backgroundColor: InstagramColor.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? InstagramColor.primaryColor : InstagramColor.secondaryColor,
            ),
            label: '',
            backgroundColor: InstagramColor.primaryColor,
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
