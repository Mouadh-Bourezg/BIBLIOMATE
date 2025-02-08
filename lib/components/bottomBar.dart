import 'package:flutter/material.dart';
// Replace with your own page imports
import '../HomePage.dart';
import '../SearchPage.dart';
import '../uploadDocument.dart';
import '../savedPage.dart';
import '../myProfilePage.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic height for the bottom navigation bar
    final double navBarHeight = screenHeight * 0.1; // 10% of screen height

    // Dynamic padding based on screen width
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width

    return Container(
      // Dynamic height for a modern feel
      height: navBarHeight,
      decoration: BoxDecoration(
        // A nice blue gradient from top-left to bottom-right
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // Round only the top corners
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenWidth * 0.05), // 5% of screen width
          topRight: Radius.circular(screenWidth * 0.05), // 5% of screen width
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAnimatedIcon(Icons.home, 0, context, screenWidth),
          _buildAnimatedIcon(Icons.search, 1, context, screenWidth),
          _buildCenterIcon(context, screenWidth),
          _buildAnimatedIcon(Icons.bookmark, 3, context, screenWidth),
          _buildAnimatedIcon(Icons.person, 4, context, screenWidth),
        ],
      ),
    );
  }

  /// Builds a normal tab icon (home, search, bookmark, person) with a scale
  /// animation based on whether it's selected or not.
  Widget _buildAnimatedIcon(
      IconData icon, int index, BuildContext context, double screenWidth) {
    final bool isSelected = currentIndex == index;

    // Fixed size for the container to prevent layout shifts
    final double containerSize = screenWidth * 0.12; // 12% of screen width

    // Dynamic icon size based on screen width
    final double iconSize =
        isSelected ? screenWidth * 0.07 : screenWidth * 0.06; // 7% or 6%

    return GestureDetector(
      onTap: () {
        onItemSelected(index);
        _navigateToPage(index, context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        // Fixed width and height to prevent layout shifts
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            // Change color if selected
            color: isSelected ? Colors.white : Colors.white70,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  /// Special center icon (Add)
  /// Positioned as a circular button with a white icon
  Widget _buildCenterIcon(BuildContext context, double screenWidth) {
    return GestureDetector(
      onTap: () {
        onItemSelected(2);
        _navigateToPage(2, context);
      },
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.025), // 2.5% of screen width
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: Colors.blue,
          size: screenWidth * 0.08, // 8% of screen width
        ),
      ),
    );
  }

  /// Use pushReplacement with no transitions
  /// to navigate to the selected page
  void _navigateToPage(int index, BuildContext context) {
    Widget page;
    switch (index) {
      case 0:
        page = HomePage(showBottomBar: true);
        break;
      case 1:
        page = SearchPage();
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
        page = HomePage(showBottomBar: true);
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
