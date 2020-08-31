



import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:marketing/Influencer/myProfile.dart';
import 'package:marketing/authentication/signup.dart';
import 'package:marketing/functions/LocalColors.dart';

import 'homeParent.dart';

class InfluencerMain extends StatefulWidget {
  InfluencerMain({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<InfluencerMain> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int _currentIndex = 0;

  // add
  final pageController = PageController();
  void onPageChanged(int index) {
    pageController.jumpToPage(index);

    setState(() {
      _currentIndex = index;
    });
  }

      List<Widget> _widgetOptions = <Widget>[
   Home(),
  Signup(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ), Profile()
  ];

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: PageView(
        physics:new NeverScrollableScrollPhysics(),
        children: _widgetOptions,
        controller: pageController,
       ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialCommunityIcons.upload),
            title: Text('Submissions'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            title: Text('Payment'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black38,
        selectedItemColor: Colors.black87.withAlpha(170),
        onTap: _onItemTapped,
      ),
    );
  }

}

