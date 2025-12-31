import 'package:flutter/material.dart';
import 'package:songquest/screens/on_stage/song_order_item.dart';

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
  List<String> _list = <String>['1', '2', '3'];

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.tabIndex;
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      displacement: 100.0,
      child: CustomScrollView(
        /// 这里指定controller可以与外层NestedScrollView的滚动分离，避免一处滑动，5个Tab中的列表同步滑动。
        /// 这种方法的缺点是会重新layout列表
        // controller: _tabIndex != provider.index ? _controller : null,
        key: PageStorageKey<String>('$_tabIndex'),
        slivers: <Widget>[
          SliverOverlapInjector(
            ///SliverAppBar的expandedHeight高度,避免重叠
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: _list.isEmpty
                ? SliverFillRemaining(child: Placeholder())
                : SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return index < _list.length
                          ? SongOrderItem(key: Key('order_item_$index'), tabIndex: _tabIndex)
                          : Placeholder();
                    }, childCount: _list.length),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {}
}
