import 'package:flutter/material.dart';
import 'components/bottomBar.dart';

class documentPage extends StatelessWidget {
  const documentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          infoDocument(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onItemSelected: (index) {
          // Handle navigation
        },
      ),
    );
  }
}

class infoDocument extends StatelessWidget {
  const infoDocument({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.grey,
      width: screenWidth,
      height: screenHeight * 0.45,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: screenHeight * 0.3,
            color: Colors.blue,
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.25,
                  color: Colors.red,
                ),
                SizedBox(width: screenWidth * 0.1),
                Column(
                  children: [
                    const Text(
                      'Title of the document',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Uploaded by:',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Container(
                      child: const Row(
                        children: [],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
