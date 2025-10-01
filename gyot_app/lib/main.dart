import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late bool _isMobile;
  bool _appStateDetected = false;


  @override
  Widget build(BuildContext context) {
    if (!_appStateDetected) {
      final mediaQuery = MediaQuery.of(context);
      final screenWidth = mediaQuery.size.width;
      _isMobile = screenWidth < 600;
      _appStateDetected = true;
    }

    return MaterialApp(
      title: 'Flutter Navigation Demo',
      home: _isMobile ? const MobileLayout() : const DesktopLayout(),
    );
  }

}

enum PageType { home, search, sources, addSource, settings, menu }

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  late Map<PageType, Widget> pages = {
    PageType.home: const ContentPage(title: "Home", icon: Icons.home_outlined),
    PageType.search:
        const ContentPage(title: "Search", icon: Icons.search_outlined),
    PageType.sources:
        const ContentPage(title: "Sources", icon: Icons.source_outlined),
    PageType.addSource:
        const ContentPage(title: "Add source", icon: Icons.add_circle_outline),
    PageType.settings:
        const ContentPage(title: "Settings", icon: Icons.settings_outlined),
    PageType.menu: const ContentPage(title: "Menu", icon: Icons.menu_outlined),
  };

  late PageType _currentPageType;

  @override
  void initState() {
    super.initState();
    _currentPageType = PageType.home;
  }

  void setCurrentPage(PageType type) {
    setState(() {
      _currentPageType = type;
    });
  }

  Widget getIconButton(IconData icon, String tooltip, PageType pageType) {
    return IconButton(
      icon: Icon(icon),
      color: _currentPageType == pageType
          ? Theme.of(context).primaryColor
          : Colors.grey,
      onPressed: () => setCurrentPage(pageType),
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentPageType],
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => _currentPageType = PageType.addSource,
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
            getIconButton(Icons.search, 'Search', PageType.search),
            getIconButton(Icons.source, 'Sources', PageType.sources),
            const SizedBox(width: 48),
            getIconButton(Icons.settings, 'Settings', PageType.settings),
            getIconButton(Icons.menu, 'Menu', PageType.menu),
          ],
        ),
      ),
    );
  }
}

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  final Map<PageType, Widget> pages = {
    PageType.search:
        const ContentPage(title: "Search", icon: Icons.search_outlined),
    PageType.sources:
        const ContentPage(title: "Sources", icon: Icons.source_outlined),
    PageType.addSource:
        const ContentPage(title: "Add source", icon: Icons.add_circle_outline),
    PageType.settings:
        const ContentPage(title: "Settings", icon: Icons.settings_outlined),
    PageType.menu: const ContentPage(title: "Menu", icon: Icons.menu_outlined),
  };
  final Map<int, PageType> indexToPageType = {
    0: PageType.addSource,
    1: PageType.search,
    2: PageType.sources,
    3: PageType.settings,
  };

  late PageType _currentPageType;
  late int _currentPageIndex;
  bool _isSideMenuExtended = false;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
    _currentPageType = indexToPageType[_currentPageIndex] ?? PageType.addSource;
  }

  void _setCurrentPage(int i) {
    setState(() {
      _currentPageIndex = i;
      final type = indexToPageType[i];
      if (type != null) {
        _currentPageType = type;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _currentPageIndex,
            onDestinationSelected: _setCurrentPage,
            extended: _isSideMenuExtended,
            leading: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
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
                icon: Icon(Icons.source_outlined),
                selectedIcon: Icon(Icons.source),
                label: Text('Sources'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: Text('Search'),
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
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: pages[_currentPageType] ?? const Text("test"),
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
    return Center(
      child: Column(
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
      ),
    );
  }
}
