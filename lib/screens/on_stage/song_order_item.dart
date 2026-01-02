import 'package:flutter/material.dart';
import 'package:songquest/helper/logger.dart';
import 'package:songquest/screens/components/custom_dialog.dart';

class SongOrderItem extends StatelessWidget {
  const SongOrderItem({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark ? Colors.black87 : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        // elevation: 1,
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(padding: const EdgeInsets.all(16.0), child: _buildContent(context)),
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
    ).textTheme.bodySmall?.copyWith(letterSpacing: -0.2);

    final TextStyle? artistTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400, letterSpacing: -0.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text('David Cheong', style: textTextStyle)),
            Text('#128 (Dec 25, 10:20 PM)', style: textTextStyle),
          ],
        ),
        const SizedBox(height: 4.0),
        Divider(),
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
        Divider(),
        const SizedBox(height: 4.0),
        Text('Note:', style: textTextStyle),
        const SizedBox(height: 8.0),
        Text('谢谢你们！Thank you for accepting my song. Love you all!!!', style: textTextStyle),
        Divider(),
        const SizedBox(height: 4.0),
        Row(
          spacing: 8.0,
          children: [
            const Expanded(child: SizedBox.shrink()),
            OrderItemButton(
              key: Key('order_item_accept_all_$tabIndex'),
              text: 'Accept All',
              textColor: isDark ? Colors.black87 : Colors.white,
              bgColor: isDark ? Colors.black87 : Theme.of(context).colorScheme.secondary,
              onTap: () => _acceptAllDialog(context, 128),
            ),
            OrderItemButton(
              key: Key('order_item_accept_partial_$tabIndex'),
              text: 'Accept Partial',
              textColor: isDark ? Colors.white : Colors.black87,
              bgColor: isDark ? Colors.black87 : Colors.grey[300],
              onTap: () => _acceptPartialDialog(context, 128),
            ),
            OrderItemButton(
              key: Key('order_item_reject_$tabIndex'),
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

  void _acceptAllDialog(BuildContext context, int orderNo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Accept All'),
              onPressed: () {
                Logger.instance.d("Order $orderNo accepted all songs");
                Navigator.of(context).pop();
                // TODO: Add actual accept all logic here
              },
            ),
          ],
        );
      },
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

  void _rejectDialog(BuildContext context, int orderNo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          title: const Text('Confirm Rejection'),
          content: const Text(
            'Are you sure to reject this song request? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reject'),
              onPressed: () {
                Logger.instance.d("Order $orderNo rejected");
                Navigator.of(context).pop();
                // TODO: Add actual reject logic here
              },
            ),
          ],
        );
      },
    );
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
