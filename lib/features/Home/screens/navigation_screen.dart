import 'package:coffee_shop_app/features/Home/screens/profile.dart';
import 'package:flutter/material.dart';

import '../../../core/pallete/theme.dart';
import '../../order/screen/orders_tabbarview.dart';
import '../../product/screen/product_add.dart';
import 'home_page.dart';


class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    OrderTabbarView1(),
    ProfilePage(),
  ];

  static const List<Color> tabColors = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'uniqueHeroTagMainFab', // Provide a unique heroTag
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductAddScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFDB3022),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _onItemTapped(0),
              color: pageIndex == 0 ? Palette.redLightColor : tabColors[0],
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => _onItemTapped(1),
              color: pageIndex == 1 ? Palette.redLightColor : tabColors[1],
            ),
            SizedBox(width: 48.0), // The width of the center button space
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => _onItemTapped(2),
              color: pageIndex == 2 ? Palette.redLightColor : tabColors[2],
            ),
          ],
        ),
      ),
    );
  }
}
