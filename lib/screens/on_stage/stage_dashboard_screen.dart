import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

enum StageMenuItems { newStage, editStage, deleteStages }

class StageDashboardScreen extends StatefulWidget {
  const StageDashboardScreen({super.key});

  @override
  _StageDashboardScreenState createState() => _StageDashboardScreenState();
}

class _StageDashboardScreenState extends State<StageDashboardScreen>
    with AutomaticKeepAliveClientMixin<StageDashboardScreen>, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController _tabController;
  late PageController _pageController;
  int _currentIndex = 0;
  int _lastReportedPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// Pre-cache images for smooth transitions
      _preCacheImages();
    });
  }

  void _preCacheImages() {
    // Pre-cache tab icons
    precacheImage(AssetImage('assets/icons/order/new_order_active.png'), context);
    precacheImage(AssetImage('assets/icons/order/new_order_inactive.png'), context);
    precacheImage(AssetImage('assets/icons/order/pending_active.png'), context);
    precacheImage(AssetImage('assets/icons/order/pending_inactive.png'), context);
    precacheImage(AssetImage('assets/icons/order/completed_active.png'), context);
    precacheImage(AssetImage('assets/icons/order/completed_inactive.png'), context);
    precacheImage(AssetImage('assets/icons/order/cancelled_active.png'), context);
    precacheImage(AssetImage('assets/icons/order/cancelled_inactive.png'), context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background gradient
          SafeArea(
            child: SizedBox(
              height: 105,
              width: double.infinity,
              child: isDark
                  ? null
                  : const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                      ),
                    ),
            ),
          ),

          // Main content with NestedScrollView
          NestedScrollView(
            key: const Key('stage_dashboard'),
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => _buildSliverBuilder(context),
            body: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                /// Handle page changes without causing scroll lag
                if (notification.depth == 0 && notification is ScrollEndNotification) {
                  final PageMetrics metrics = notification.metrics as PageMetrics;
                  final int currentPage = (metrics.page ?? 0).round();
                  if (currentPage != _lastReportedPage) {
                    _lastReportedPage = currentPage;
                    _onPageChange(currentPage);
                  }
                }
                return false;
              },
              child: PageView.builder(
                key: const Key('pageView'),
                itemCount: 4,
                controller: _pageController,
                itemBuilder: (_, index) => _buildStageListPage(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSliverBuilder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return <Widget>[
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          actions: <Widget>[
            PopupMenuButton<StageMenuItems>(
              icon: const Icon(Icons.menu),
              itemBuilder: (context) => _buildPopupBtnItems(),
              offset: const Offset(0, 46),
              constraints: const BoxConstraints(minWidth: 130, maxWidth: 130),
              onSelected: (item) {
                _handleMenuSelection(item, context);
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          expandedHeight: 100.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: isDark
                ? Container(height: 113.0, color: const Color(0xFF121212))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 113.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                    ),
                  ),
            centerTitle: true,
            titlePadding: const EdgeInsetsDirectional.only(start: 16.0, bottom: 14.0),
            collapseMode: CollapseMode.pin,
            title: Text(
              'Stage Dashboard',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: _SliverAppBarDelegate(
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF121212) : null,
              gradient: isDark
                  ? null
                  : const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: isDark ? const Color(0xFF1e1e1e) : Colors.white,
                child: Container(
                  height: 80.0,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TabBar(
                    labelPadding: EdgeInsets.zero,
                    controller: _tabController,
                    labelColor: isDark ? Colors.white : Colors.white,
                    unselectedLabelColor: isDark ? Colors.grey[400] : Colors.white70,
                    labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontSize: 14),
                    indicatorColor: Colors.transparent,
                    tabs: <Widget>[
                      _StageTabView(
                        0,
                        'New',
                        'assets/icons/order/new_order_active.png',
                        'assets/icons/order/new_order_inactive.png',
                        currentIndex: _currentIndex,
                      ),
                      _StageTabView(
                        1,
                        'Live',
                        'assets/icons/order/pending_active.png',
                        'assets/icons/order/pending_inactive.png',
                        currentIndex: _currentIndex,
                      ),
                      _StageTabView(
                        2,
                        'Completed',
                        'assets/icons/order/completed_active.png',
                        'assets/icons/order/completed_inactive.png',
                        currentIndex: _currentIndex,
                      ),
                      _StageTabView(
                        3,
                        'Cancelled',
                        'assets/icons/order/cancelled_active.png',
                        'assets/icons/order/cancelled_inactive.png',
                        currentIndex: _currentIndex,
                      ),
                    ],
                    onTap: (index) {
                      if (!mounted) return;
                      _pageController.jumpToPage(index);
                    },
                  ),
                ),
              ),
            ),
          ),
          80.0,
        ),
      ),
    ];
  }

  Widget _buildStageListPage(int index) {
    final stageTitles = ['New Performances', 'Live Now', 'Completed Shows', 'Cancelled Shows'];

    final stageDescriptions = [
      'Manage new stage requests and bookings',
      'Monitor live performances in real-time',
      'Review completed stage performances',
      'View cancelled or postponed shows',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stageTitles[index],
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            stageDescriptions[index],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, itemIndex) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Stage Performance ${itemIndex + 1}'),
                    subtitle: Text('Band Name • ${DateTime.now().toString().substring(0, 10)}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Handle stage item tap
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChange(int index) {
    setState(() {
      _currentIndex = index;
    });

    /// Animate tab controller to match page change
    _tabController.animateTo(index, duration: const Duration(milliseconds: 300));
  }

  List<PopupMenuItem<StageMenuItems>> _buildPopupBtnItems() {
    return [
      PopupMenuItem(value: StageMenuItems.newStage, child: const Text('New Stage')),
      PopupMenuItem(value: StageMenuItems.editStage, child: const Text('Edit Stage')),
      PopupMenuItem(value: StageMenuItems.deleteStages, child: const Text('Delete Stages')),
    ];
  }

  void _handleMenuSelection(StageMenuItems item, BuildContext context) {
    switch (item) {
      case StageMenuItems.newStage:
        // Handle new stage creation
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Creating new stage...')));
        break;
      case StageMenuItems.editStage:
        // Handle stage editing
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Editing stage...')));
        break;
      case StageMenuItems.deleteStages:
        // Handle stage deletion
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Deleting stages...')));
        break;
    }
  }
}

class _StageTabView extends StatelessWidget {
  final int index;
  final String text;
  final String activeIcon;
  final String inactiveIcon;
  final int currentIndex;

  const _StageTabView(
    this.index,
    this.text,
    this.activeIcon,
    this.inactiveIcon, {
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: <Widget>[
        Container(
          width: 60.0,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                currentIndex == index ? activeIcon : inactiveIcon,
                width: 24.0,
                height: 24.0,
                color: isDark ? Colors.white : Colors.black87,
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(color: isDark ? Colors.white : Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        // Badge for notifications (example)
        Positioned(
          right: 0.0,
          top: 8.0,
          child: index < 3
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.widget, this.height);

  final Widget widget;
  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
