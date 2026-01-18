import 'package:flutter/material.dart';
import 'package:songquest/helper/logger.dart';
import 'package:songquest/screens/components/custom_dialog.dart';

class SongOrderItem extends StatefulWidget {
  const SongOrderItem({
    super.key,
    required this.tabIndex,
    required this.onAccept,
    required this.onReject,
  });

  final int tabIndex;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  State<SongOrderItem> createState() => _SongOrderItemState();
}

class _SongOrderItemState extends State<SongOrderItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _heightAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _acceptAllDialog(BuildContext context, int orderNo) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          title: const Text('Confirm Accept All'),
          content: const Text('Are you sure you want to accept all songs in this request?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Accept All'),
              onPressed: () {
                Logger.instance.d("Order $orderNo accepted all songs");
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        _animateAndRemove();
      }
    });
  }

  void _animateAndRemove() {
    _controller.forward().then((_) {
      widget.onAccept();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? Colors.black87 : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizeTransition(
            sizeFactor: _heightAnimation,
            axisAlignment: 0.0,
            child: Card(
              color: backgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0),
                ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
                child: FadeTransition(
                  opacity: Tween<double>(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: _buildContent(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final TextStyle? songTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: -0.2);

    final TextStyle? textTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontSize: 12, letterSpacing: -0.2);

    final TextStyle? artistTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400, letterSpacing: -0.2);

    final TextStyle? dateTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w300, letterSpacing: -0.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Received: Dec 25, 10:20 PM', style: dateTextStyle)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Accepted: Dec 25, 10:23 PM', style: dateTextStyle)],
        ),
        // const SizedBox(height: 2.0),
        // Divider(color: Theme.of(context).dividerColor, thickness: 1),
        const SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Expanded(child: Text('David Cheong', style: textTextStyle)),
            Text('#128', style: textTextStyle),
          ],
        ),
        // Row(
        //   children: <Widget>[
        //     Expanded(child: SizedBox.shrink()),
        //     Text('Dec 25, 10:20 PM', style: dateTextStyle),
        //   ],
        // ),
        // const SizedBox(height: 4.0),
        Divider(color: Theme.of(context).dividerColor, thickness: 1),
        const SizedBox(height: 4.0),
        Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Text('Feeling Good', style: songTextStyle),
                  const SizedBox(width: 8.0),
                  Text('- Michael Buble', style: artistTextStyle),
                ],
              ),
            ),
            Text('\$20', style: textTextStyle),
          ],
        ),
        Row(
          children: [
            Text('Perfect', style: songTextStyle),
            const SizedBox(width: 8.0),
            Text('- Ed Sheeran', style: artistTextStyle),
          ],
        ),
        Row(
          children: [
            Text('寂寞边界', style: songTextStyle),
            const SizedBox(width: 8.0),
            Text('- 张栋梁', style: artistTextStyle),
          ],
        ),
        const SizedBox(height: 4.0),
        Divider(color: Theme.of(context).dividerColor, thickness: 1),
        const SizedBox(height: 4.0),
        Text('Note:', style: textTextStyle),
        const SizedBox(height: 8.0),
        Text('谢谢你们！Thank you for accepting my song. Love you all!!!', style: textTextStyle),
        Divider(color: Theme.of(context).dividerColor, thickness: 1),
        const SizedBox(height: 4.0),
        Row(
          spacing: 8.0,
          children: [
            const Expanded(child: SizedBox.shrink()),
            OrderItemButton(
              key: Key('order_item_accept_all_${widget.tabIndex}'),
              text: 'Accept All',
              textColor: isDark ? Colors.black87 : Colors.white,
              bgColor: isDark ? Colors.black87 : Theme.of(context).colorScheme.secondary,
              onTap: () => _acceptAllDialog(context, 128),
            ),
            OrderItemButton(
              key: Key('order_item_accept_partial_${widget.tabIndex}'),
              text: 'Accept Partial',
              textColor: isDark ? Colors.white : Colors.black87,
              bgColor: isDark ? Colors.black87 : Colors.grey[300],
              onTap: () => _acceptPartialDialog(context, 128),
            ),
            OrderItemButton(
              key: Key('order_item_reject_${widget.tabIndex}'),
              text: 'Reject',
              textColor: isDark ? Colors.white : Colors.black87,
              bgColor: isDark ? Colors.black87 : Colors.grey[300],
              onTap: () => _rejectDialog(context, 128),
            ),
          ],
        ),
      ],
    );
  }

  void _acceptPartialDialog(BuildContext context, int orderNo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final List<String> songs = [
          'Feeling Good - Michael Buble',
          'Perfect - Ed Sheeran',
          '寂寞边界 - 张栋梁',
        ];
        final List<bool> selectedSongs = List.filled(songs.length, false);

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Accept Partial",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: CheckboxListTile(
                            title: Text(songs[index]),
                            value: selectedSongs[index],
                            dense: true,
                            onChanged: (bool? value) {
                              setState(() {
                                selectedSongs[index] = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final selectedCount = selectedSongs.where((selected) => selected).length;
                        if (selectedCount > 0) {
                          Logger.instance.d("Accepting $selectedCount selected songs");
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select at least one song')),
                          );
                        }
                      },
                      child: Text(
                        "Accept selected (${selectedSongs.where((selected) => selected).length})",
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _rejectDialog(BuildContext context, int orderNo) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          title: const Text('Confirm Rejection'),
          content: const Text('Are you sure to reject this song request?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Reject'),
              onPressed: () {
                Logger.instance.d("Order $orderNo rejected");
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        _animateAndRemove();
      }
    });
  }
}

class OrderItemButton extends StatelessWidget {
  const OrderItemButton({super.key, this.bgColor, this.textColor, required this.text, this.onTap});

  final Color? bgColor;
  final Color? textColor;
  final GestureTapCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //child: GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4.0)),
        constraints: const BoxConstraints(minWidth: 64.0, maxHeight: 30.0, minHeight: 30.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 12,
            color: textColor,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
      //),
    );
  }
}
