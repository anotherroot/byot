import 'package:flutter/material.dart';
// import 'package:test_apk/search_page.dart';
// import 'package:test_apk/sources_page.dart';

// import 'profile_page.dart';
// import 'settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSideMenuExtended = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      initialRoute: '/add-source',
      routes: {
        '/': (context) => getLayoutPage(context,
            const ContentPage(title: "home", icon: Icons.add_circle_outline)),
        '/sources': (context) => getLayoutPage(
            context,
            const ContentPage(
                title: "sources", icon: Icons.add_circle_outline)),
        '/search': (context) => getLayoutPage(context,
            const ContentPage(title: "search", icon: Icons.add_circle_outline)),
        '/add-source': (context) => getLayoutPage(
            context,
            const ContentPage(
                title: "Add srouce", icon: Icons.add_circle_outline)),
        '/settings': (context) => getLayoutPage(
            context,
            const ContentPage(
                title: "settings", icon: Icons.add_circle_outline)),
        '/menu': (context) => getLayoutPage(
            context,
            const ContentPage(
                title: "profile", icon: Icons.add_circle_outline)),
      },
    );
  }

  int _getSelectedIndexMobile(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null || route.settings.name == null) {
      return 10;
    }
    switch (route.settings.name) {
      case "/":
        return 10;
      case "/sources":
        return 0;
      case "/search":
        return 1;
      case "/add-source":
        return 2;
      case "/settings":
        return 3;
      case "/menu":
        return 4;
      default:
        return 10;
    }
    // return 0;
  }

  int _getSelectedIndexDesktop(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null || route.settings.name == null) {
      return 4;
    }
    switch (route.settings.name) {
      case "/add-source":
        return 0;
      case "/sources":
        return 1;
      case "/search":
        return 2;
      case "/settings":
        return 3;
      case "/":
        return 4;
      case "/menu":
        return 4;
      default:
        return 4;
    }
    // return 0;
  }

  void _onItemTappedMobile(BuildContext context, int index) {
    switch (index) {
      case 10:
        Navigator.pushNamed(context, '/');
        break;
      case 0:
        Navigator.pushNamed(context, '/sources');
        break;
      case 1:
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/add-source');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
      case 4:
        Navigator.pushNamed(context, '/menu');
        break;
      default:
        Navigator.pushNamed(context, '/');
        break;
    }
  }

  void _onItemTappedDesktop(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/add-source');
        break;
      case 1:
        Navigator.pushNamed(context, '/sources');
        break;
      case 2:
        Navigator.pushNamed(context, '/search');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
      case 4:
        Navigator.pushNamed(context, '/');
        break;
      default:
        Navigator.pushNamed(context, '/');
        break;
    }
  }

  Widget getLayoutPage(BuildContext context, Widget page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return buildMobileLayout(context, page);
        } else {
          return buildDesktopLayout(context, page);
        }
      },
    );
  }

  Widget buildMobileLayout(BuildContext context, Widget page) {
    final selectedIndex = _getSelectedIndexMobile(context);
    return Scaffold(
      body: page,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => _onItemTappedMobile(context, 2),
        tooltip: 'Add Source',
        elevation: 2.0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              color: selectedIndex == 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              onPressed: () => _onItemTappedMobile(context, 0),
              tooltip: 'Search',
            ),
            IconButton(
              icon: const Icon(Icons.source),
              color: selectedIndex == 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              onPressed: () => _onItemTappedMobile(context, 1),
              tooltip: 'Sources',
            ),
            // This is the empty space for the notch
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.settings),
              color: selectedIndex == 3
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              onPressed: () => _onItemTappedMobile(context, 3),
              tooltip: 'Settings',
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: selectedIndex == 4
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              onPressed: () => _onItemTappedMobile(context, 4),
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // Builds the UI for desktop devices with an expandable NavigationRail
  Widget buildDesktopLayout(BuildContext context, Widget page) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _getSelectedIndexDesktop(context),
            onDestinationSelected: (i) => _onItemTappedDesktop(context, i),
            // Controls whether the labels are shown
            extended: _isSideMenuExtended,
            // The header of the navigation rail, contains the menu button
            leading: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: IconButton(
                  icon: Icon(
                    _isSideMenuExtended ? Icons.menu_open : Icons.menu,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSideMenuExtended = !_isSideMenuExtended;
                    });
                  },
                ),
              ),
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.add_outlined),
                selectedIcon: Icon(Icons.add),
                label: Text('Add Source'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: Text('Search'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.source_outlined),
                selectedIcon: Icon(Icons.source),
                label: Text('Sources'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
            ],
          ),
          // A vertical line to separate the menu from the content
          const VerticalDivider(thickness: 1, width: 1),
          // The main content area
          Expanded(
            child: page,
          ),
        ],
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const ContentPage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 100,
          color: theme.colorScheme.primary.withOpacity(0.6),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: theme.textTheme.headlineMedium,
        ),
      ],
    );
  }
}
