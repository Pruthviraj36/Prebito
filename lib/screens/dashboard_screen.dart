import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ZoomDrawerController _controller = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _controller,
      style: DrawerStyle.Style1,
      menuScreen: MenuScreen(controller: _controller),
      mainScreen: DashboardScreen(controller: _controller), // Ensure the controller is passed
      borderRadius: 40,
      showShadow: true,
      angle: -10,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}

class MenuScreen extends StatelessWidget {
  final ZoomDrawerController controller;
  const MenuScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: AnimationLimiter(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              alignment: Alignment.center,
              child: const Text(
                'Soul Bridge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: AnimationConfiguration.synchronized(
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildMenuTile(context, Icons.person_add, 'Add User', '/addUser'),
                        _buildMenuTile(context, Icons.people, 'User List', '/userList'),
                        _buildMenuTile(context, Icons.favorite, 'Favorites', '/favoriteUser'),
                        _buildMenuTile(context, Icons.info, 'About Us', '/aboutUs'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onTap: () {
        controller.close?.call();
        Navigator.pushNamed(context, route);
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final ZoomDrawerController controller;
  const DashboardScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => controller.toggle?.call(), // Ensure the drawer opens
        ),
      ),
      body: AnimationLimiter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                _buildDashboardCard(context, Icons.person_add, 'Add User', '/addUser'),
                _buildDashboardCard(context, Icons.people, 'User List', '/userList'),
                _buildDashboardCard(context, Icons.favorite, 'Favorites', '/favoriteUser'),
                _buildDashboardCard(context, Icons.info, 'About Us', '/aboutUs'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, IconData icon, String title, String route) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
