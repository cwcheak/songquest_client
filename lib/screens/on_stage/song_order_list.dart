import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:songquest/helper/logger.dart';
import 'package:songquest/screens/on_stage/song_order_item.dart';
import 'package:songquest/bloc/on_stage_bloc.dart';
import 'package:songquest/bloc/on_stage_state.dart';

class SongOrderList extends StatefulWidget {
  const SongOrderList({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<SongOrderList> createState() => _SongOrderListState();
}

class _SongOrderListState extends State<SongOrderList> {
  final ScrollController _controller = ScrollController();
  bool _isLoading = false;
  int _tabIndex = 0;
  List<String> _list = <String>['1', '2', '3', '4', '5', '6', '7', '8', '9'];
  int _currentActiveTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.tabIndex;
    _onRefresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize current active tab index from bloc state after widget is mounted
    final bloc = context.read<OnStageBloc>();
    if (bloc.state is OnStageTabChanged) {
      _currentActiveTabIndex = (bloc.state as OnStageTabChanged).tabIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnStageBloc, OnStageState>(
      builder: (context, state) {
        // Update local state when bloc state changes
        if (state is OnStageTabChanged) {
          _currentActiveTabIndex = state.tabIndex;
        }

        // Determine if this tab should have its own scroll controller
        // When _tabIndex != _currentActiveTabIndex, this tab is not active
        // so it gets its own controller to prevent scroll synchronization

        // final bool shouldUseOwnController = _tabIndex != _currentActiveTabIndex;
        // final ScrollController? controller = shouldUseOwnController ? _controller : null;

        // Logger.instance.d('shouldUseOwnController : ${shouldUseOwnController ? 'true' : 'false'}');

        return RefreshIndicator(
          onRefresh: _onRefresh,
          displacement: 120.0,
          child: CustomScrollView(
            /// 这里指定controller可以与外层NestedScrollView的滚动分离，避免一处滑动，5个Tab中的列表同步滑动。
            /// 这种方法的缺点是会重新layout列表
            controller: _tabIndex != _currentActiveTabIndex ? _controller : null,
            key: PageStorageKey<String>('$_tabIndex'),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: _list.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No new song requests',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                          return index < _list.length
                              ? SongOrderItem(
                                  key: Key('order_item_${_list[index]}'),
                                  tabIndex: _tabIndex,
                                  onAccept: () => _removeItem(_list[index]),
                                  onReject: () => _removeItem(_list[index]),
                                )
                              : Placeholder();
                        }, childCount: _list.length),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {}

  void _removeItem(String itemId) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _list.remove(itemId);
        });
      }
    });
  }
}
