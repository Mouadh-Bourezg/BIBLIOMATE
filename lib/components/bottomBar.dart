import 'package:flutter/material.dart';
import '../styles.dart';
import '../HomePage.dart';
import '../documentPage.dart';
import '../myProfilePage.dart';
import '../savedPage.dart';
import '../uploadDocument.dart';
import '../SearchPage.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onItemSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border(top: BorderSide(color: Colors.black, width: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIcon(Icons.home, 0, context),
          _buildIcon(Icons.search, 1, context),
          _buildCenterIcon(context),
          _buildIcon(Icons.bookmark, 3, context),
          _buildIcon(Icons.person, 4, context),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemSelected(index);
        _navigateToPage(index, context);
      },
      child: Icon(
        icon,
        color: currentIndex == index ? secondaryColor : Colors.black,
      ),
    );
  }

  Widget _buildCenterIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemSelected(2); // Index for the center icon
        _navigateToPage(2, context);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: secondaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToPage(int index, BuildContext context) {
    Widget page;
    switch (index) {
      case 0:
        page = HomePage(showBottomBar: true); // Ensure bottom bar is shown
        break;
      case 1:
        page = SearchPage(); // Navigate to SearchPage
        break;
      case 2:
        page = uploadDocumentPage();
        break;
      case 3:
        page = const SavedPage();
        break;
      case 4:
        page = ProfilePage();
        break;
      default:
        page = HomePage(showBottomBar: true); // Ensure bottom bar is shown
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
