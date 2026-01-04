import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:songquest/screens/components/load_image.dart';
import './components/my_flexible_space_bar.dart';
import './components/elapsed_time_widget.dart';
import 'package:songquest/helper/image_utils.dart';
import 'package:songquest/screens/on_stage/song_order_list.dart';
import 'package:songquest/bloc/on_stage_bloc.dart';
import 'package:songquest/bloc/on_stage_event.dart';

enum StageMenuItems { newStage, editStage, deleteStages }

class SongOrderScreen extends StatefulWidget {
  const SongOrderScreen({super.key});

  @override
  _SongOrderScreenState createState() => _SongOrderScreenState();
}

class _SongOrderScreenState extends State<SongOrderScreen>
    with AutomaticKeepAliveClientMixin<SongOrderScreen>, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int _lastReportedPage = 0;
  late OnStageBloc _onStageBloc;
  _CollapsiblePositionedWidgetState? _collapsibleWidgetState;
  final GlobalKey<_CollapsiblePositionedWidgetState> _collapsibleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _onStageBloc = OnStageBloc();
    _tabController = TabController(vsync: this, length: 4);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// Pre-cache images for smooth transitions
      _preCacheImages();
      // Initialize the collapsible widget state reference
      _collapsibleWidgetState = _collapsibleKey.currentState;
    });
  }

  void _preCacheImages() {
    // Pre-cache tab icons
    precacheImage(AssetImage('assets/images/order/new_order_active.png'), context);
    precacheImage(AssetImage('assets/images/order/new_order_inactive.png'), context);
    precacheImage(AssetImage('assets/images/order/pending_active.png'), context);
    precacheImage(AssetImage('assets/images/order/pending_inactive.png'), context);
    precacheImage(AssetImage('assets/images/order/completed_active.png'), context);
    precacheImage(AssetImage('assets/images/order/completed_inactive.png'), context);
    precacheImage(AssetImage('assets/images/order/cancelled_active.png'), context);
    precacheImage(AssetImage('assets/images/order/cancelled_inactive.png'), context);
  }

  @override
  void dispose() {
    _onStageBloc.close();
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: BlocProvider(
        create: (context) => _onStageBloc,
        child: Builder(
          builder: (context) {
            return Stack(
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
                              gradient: LinearGradient(
                                colors: [Color(0xFF243055), Color(0xFF354672)],
                              ),
                            ),
                          ),
                  ),
                ),

                // Main content with NestedScrollView
                NestedScrollView(
                  key: const Key('song_orders'),
                  physics: const ClampingScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) =>
                      _buildSliverBuilder(context),
                  body: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      /// Handle page changes without causing scroll lag
                      if (notification.depth == 0 && notification is ScrollEndNotification) {
                        final PageMetrics metrics = notification.metrics as PageMetrics;
                        final int currentPage = (metrics.page ?? 0).round();
                        if (currentPage != _lastReportedPage) {
                          _lastReportedPage = currentPage;
                          _onPageChange(context, currentPage);
                        }
                      }
                      return false;
                    },
                    child: PageView.builder(
                      key: const Key('pageView'),
                      itemCount: 4,
                      controller: _pageController,
                      itemBuilder: (_, index) =>
                          SongOrderList(tabIndex: index, key: ValueKey('song_order_list_$index')),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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
              icon: const Icon(Icons.menu, color: Colors.white),
              itemBuilder: (context) => _buildPopupBtnItems(),
              offset: const Offset(0, 46),
              constraints: const BoxConstraints(minWidth: 130, maxWidth: 130),
              onSelected: (item) {
                _handleMenuSelection(item, context);
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          title: Text(
            'Ang Ang\'s Roastery',
            style: TextStyle(
              color: isDark ? Colors.black87 : Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          elevation: 0.0,
          centerTitle: true,
          expandedHeight: 186.0,
          pinned: true,
          flexibleSpace: MyFlexibleSpaceBar(
            onCollapseProgressChanged: (double progress) {
              // Invert progress so 0.0 = expanded (visible) and 1.0 = collapsed (hidden)
              // Accelerate the fading by making it fade out faster
              final opacity = 1.0 - (progress * 1.5).clamp(0.0, 1.0);
              if (_collapsibleWidgetState != null) {
                _collapsibleWidgetState!.updateOpacity(opacity);
              }
            },
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF243055), Color(0xFF354672)]),
              ),
              child: CollapsiblePositionedWidget(
                key: _collapsibleKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(children: [SizedBox(height: 56.0), _buildStageInfo(context)]),
                ),
              ),
            ),
            // centerTitle: true,
            // titlePadding: const EdgeInsetsDirectional.only(start: 16.0, bottom: 14.0),
            collapseMode: CollapseMode.pin,
            // title: Text(
            //   'Ang Ang\'s Roastery',
            //   style: TextStyle(
            //     color: isDark ? Colors.black87 : Colors.white,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 14,
            //   ),
            // ),
          ),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: _SliverAppBarDelegate(
          DecoratedBox(
            decoration: BoxDecoration(
              image: isDark
                  ? null
                  : DecorationImage(
                      image: ImageUtils.getAssetImage('order/order_bg1_modified'),
                      fit: BoxFit.fill,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: isDark ? const Color(0xFF1e1e1e) : Colors.white,
                child: Container(
                  // height: 80.0,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TabBar(
                    labelPadding: EdgeInsets.zero,
                    controller: _tabController,
                    dividerHeight: 0,
                    indicatorColor: Colors.transparent,
                    labelColor: Theme.of(context).colorScheme.onSecondary,
                    tabs: <Widget>[
                      _OrderTabView(
                        0,
                        'New  ',
                        'order/new_order_active',
                        'order/new_order_inactive',
                        currentIndex: _currentIndex,
                      ),
                      _OrderTabView(
                        1,
                        'Pending',
                        'order/pending_active',
                        'order/pending_inactive',
                        currentIndex: _currentIndex,
                      ),
                      _OrderTabView(
                        2,
                        'Completed',
                        'order/completed_active',
                        'order/completed_inactive',
                        currentIndex: _currentIndex,
                      ),
                      _OrderTabView(
                        3,
                        'Cancelled',
                        'order/cancelled_active',
                        'order/cancelled_inactive',
                        currentIndex: _currentIndex,
                      ),
                    ],
                    onTap: (index) {
                      if (!mounted) return;
                      setState(() {
                        _currentIndex = index;
                      });
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

  void _onPageChange(BuildContext context, int index) {
    /// Dispatch Bloc event to update the active tab index
    context.read<OnStageBloc>().add(OnStageTabChangedEvent(index));

    /// Update the current index to match the page change
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

Widget _buildStageInfo(BuildContext context) {
  final TextStyle? textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
    fontWeight: FontWeight.w300,
    letterSpacing: -0.2,
    color: Colors.white,
  );

  final TextStyle? statStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
    color: Colors.white,
  );

  // Example start time - in a real app, this would come from your data
  final DateTime startTime = DateTime.now().subtract(const Duration(minutes: 59, seconds: 50));

  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.all(12.0),
    child: Column(
      children: [
        Row(
          children: [
            // Location
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.white, size: 16),
                  SizedBox(width: 4.0),
                  Text('Ang Ang Roastery', style: textStyle, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            // Timer
            Row(
              children: [
                Icon(Icons.access_time_outlined, color: Colors.white, size: 16),
                SizedBox(width: 4.0),
                ElapsedTimeWidget(startTime: startTime),
              ],
            ),
          ],
        ),
        // Band Name
        Row(
          children: [
            Icon(Icons.groups, color: Colors.white, size: 16),
            SizedBox(width: 4.0),
            Text('Ang Ang Roastery', style: textStyle, overflow: TextOverflow.ellipsis),
          ],
        ),
        // Stat
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            spacing: 8,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('185', textAlign: TextAlign.center, style: statStyle),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('Songs Performed', textAlign: TextAlign.center, style: textStyle),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('\$200', textAlign: TextAlign.center, style: statStyle),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('Tipping', textAlign: TextAlign.center, style: textStyle),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[
              //       Text('185 cm', textAlign: TextAlign.center, style: statStyle),
              //       Padding(
              //         padding: const EdgeInsets.only(top: 6),
              //         child: Text('Height', textAlign: TextAlign.center, style: textStyle),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    ),
  );
}

class CollapsiblePositionedWidget extends StatefulWidget {
  final Widget child;
  final double initialOpacity;

  const CollapsiblePositionedWidget({Key? key, required this.child, this.initialOpacity = 1.0})
    : super(key: key);

  @override
  _CollapsiblePositionedWidgetState createState() => _CollapsiblePositionedWidgetState();
}

class _CollapsiblePositionedWidgetState extends State<CollapsiblePositionedWidget> {
  double _opacity = 1.0;

  void updateOpacity(double opacity) {
    setState(() {
      _opacity = opacity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: widget.child,
    );
  }
}

class _OrderTabView extends StatelessWidget {
  final int index;
  final String text;
  final String activeIcon;
  final String inactiveIcon;
  final int currentIndex;

  const _OrderTabView(
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
          width: 62.0,
          // padding: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.only(top: 8.0),
          // decoration: BoxDecoration(border: Border.all(color: Colors.black87, width: 2.0)),
          child: Column(
            children: <Widget>[
              LoadAssetImage(
                currentIndex == index ? activeIcon : inactiveIcon,
                width: 24,
                height: 24,
                color: currentIndex == index
                    ? (isDark ? Colors.white : Colors.black87)
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  color: currentIndex == index
                      ? (isDark ? Colors.white : Colors.black87)
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  fontSize: 10,
                  fontWeight: currentIndex == index ? FontWeight.bold : FontWeight.normal,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        // Badge for notifications (example)
        Positioned(
          right: 0.0,
          top: 8.0,
          child: index < 4
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    // color: Color(0xFF6D37B0), // Softer Amethyst Purple
                    color: Color(0xFF512889), // Deep Plum Purple
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
