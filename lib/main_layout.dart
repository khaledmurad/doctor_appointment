import 'package:doctor_app_appointment/screens/appoinmentPage.dart';
import 'package:doctor_app_appointment/screens/fav_page.dart';
import 'package:doctor_app_appointment/screens/homePage.dart';
import 'package:doctor_app_appointment/screens/profile_page.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentpage = 0;
  final PageController _Page = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _Page,
        onPageChanged: (index) {
          setState(() {
            currentpage = index;
          });
        },
        children: [HomePage(),FavPage(), AppoinmentPage(),ProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.blueAccent,
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: currentpage,
        onTap: (page) {
          setState(() {
            currentpage = page;
            _Page.animateToPage(page,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          });
        },
      ),
    );
  }
}
