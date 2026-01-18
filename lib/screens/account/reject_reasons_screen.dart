import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reorderables/reorderables.dart';

class RejectReasonsScreen extends StatefulWidget {
  const RejectReasonsScreen({super.key});

  @override
  State<RejectReasonsScreen> createState() => _RejectReasonsScreenState();
}

class _RejectReasonsScreenState extends State<RejectReasonsScreen> {
  final List<Map<String, dynamic>> _reasons = [
    {'id': '1', 'reason': 'Song not available'},
    {'id': '2', 'reason': 'Artist not found'},
    {'id': '3', 'reason': 'Technical difficulty'},
  ];
  // final List<Map<String, dynamic>> _reasons = [];
  final TextEditingController _reasonController = TextEditingController();
  String? _editingId;

  void _showEditBottomSheet({String? id, String? initialReason}) {
    _editingId = id;
    _reasonController.text = initialReason ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height / 3 + 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        id == null ? 'Add Reject Reason' : 'Edit Reject Reason',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reasonController,
                  maxLength: 100,
                  maxLines: 3,
                  autofocus: true,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                    labelText: 'Reject Reason (Required, max 100 characters)',
                    labelStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (_reasonController.text.trim().isNotEmpty) {
                        setState(() {
                          if (id == null) {
                            _reasons.add({
                              'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              'reason': _reasonController.text.trim(),
                            });
                          } else {
                            final index = _reasons.indexWhere((r) => r['id'] == id);
                            if (index != -1) {
                              _reasons[index]['reason'] = _reasonController.text.trim();
                            }
                          }
                        });
                        Navigator.of(context).pop();
                        _reasonController.clear();
                        _editingId = null;
                        Fluttertoast.showToast(
                          msg: id == null ? 'Reason added' : 'Reason updated',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 14.0,
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _reasonController.clear();
      _editingId = null;
    });
  }

  void _deleteReason(String id, String reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reason'),
        content: Text('Are you sure you want to delete "$reason"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _reasons.removeWhere((r) => r['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reason deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _reasons.removeAt(oldIndex);
      _reasons.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reject Reasons'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _showEditBottomSheet())],
      ),
      body: _reasons.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No reject reasons yet',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => _showEditBottomSheet(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Reject Reason'),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reasons.length,
              itemBuilder: (context, index) {
                final reason = _reasons[index];
                return ReorderableDelayedDragStartListener(
                  key: Key(reason['id']),
                  index: index,
                  child: Card(
                    // margin: const EdgeInsets.only(bottom: 8),
                    elevation: 0.5,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.drag_handle_outlined),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(right: 8),
                            title: Text(
                              reason['reason'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  iconSize: 20,
                                  onPressed: () => _showEditBottomSheet(
                                    id: reason['id'],
                                    initialReason: reason['reason'],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  iconSize: 20,
                                  color: Theme.of(context).colorScheme.error,
                                  onPressed: () => _deleteReason(reason['id'], reason['reason']),
                                ),
                              ],
                            ),
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onReorder: _onReorder,
            ),
      // floatingActionButton: _reasons.isEmpty
      //     ? null
      //     : FloatingActionButton.extended(
      //         onPressed: () => _showEditBottomSheet(),
      //         icon: const Icon(Icons.add),
      //         label: const Text('Add Reason'),
      //       ),
    );
  }
}
