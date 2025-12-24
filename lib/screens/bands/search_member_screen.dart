import 'dart:async';
import 'package:flutter/material.dart';

class SearchMemberScreen extends StatefulWidget {
  const SearchMemberScreen({super.key});

  @override
  State<SearchMemberScreen> createState() => SearchMemberScreenState();
}

class SearchMemberScreenState extends State<SearchMemberScreen> {
  final ScrollController _scrollController = ScrollController();
  final _keywordController = TextEditingController(text: "");
  final _focusNode = FocusNode();
  bool _loading = false;
  final List<MemberItem> searchMemberList = [];
  List<String> _searchHistory = [];
  List<String> _searchSuggest = [];

  // 搜索事件
  void _searchHandler(bool clean) async {
    var keyword = _keywordController.text;
    if (keyword.isEmpty) {
      setState(() {
        searchMemberList.clear();
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    // 模拟搜索结果
    final mockResults = [
      MemberItem(name: '张惠妹', role: '歌手'),
      MemberItem(name: '张靓颖', role: '鼓手'),
      MemberItem(name: '塔斯肯', role: '吉他手'),
      MemberItem(name: 'Charlie Puth', role: '乐手'),
      MemberItem(name: '周杰伦', role: '主唱'),
      MemberItem(name: '林俊杰', role: '键盘手'),
    ];

    setState(() {
      if (clean) {
        searchMemberList.clear();
      }

      updateSearchHistory(keyword);

      if (mockResults.isNotEmpty) {
        searchMemberList.addAll(mockResults);
      }

      _focusNode.unfocus();
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _searchHandler(false);
      }
    });
    getSearchHistory();
    // 输入框选中
    _focusNode.requestFocus();
  }

  getSearchHistory() async {
    // 模拟从本地获取搜索历史
    final mockHistory = ['张惠妹', '张靓颖', '塔斯肯', 'Charlie Puth'];

    setState(() {
      _searchHistory = mockHistory;
    });
  }

  updateSearchHistory(String keyword, {bool isDelete = false}) async {
    // 模拟更新搜索历史
    if (_searchHistory.contains(keyword)) {
      _searchHistory.remove(keyword);
    }
    // 添加
    if (!isDelete) {
      _searchHistory.insert(0, keyword);
      // 最多 20 条
      if (_searchHistory.length > 20) {
        _searchHistory.removeLast();
      }
    }
    setState(() {
      _searchHistory = _searchHistory;
    });
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _focusNode.unfocus();
    _focusNode.dispose();
    super.dispose();
  }

  Timer? _debounceTimer;
  _onInputChange(String value) {
    // 防抖
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // 模拟搜索建议
      final suggestions = [
        '张惠妹',
        '张靓颖',
        '塔斯肯',
        'Charlie Puth',
        '周杰伦',
        '林俊杰',
      ].where((item) => item.toLowerCase().contains(value.toLowerCase())).toList();

      setState(() {
        _searchSuggest = suggestions;
      });
    });
  }

  Widget buildSearchHistory() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
      width: double.infinity,
      child: ListView(
        children: _searchHistory.map((keyword) {
          return InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            onTap: () {
              _keywordController.text = keyword;
              _searchHandler(true);
            },
            child: Container(
              padding: const EdgeInsets.only(top: 6, bottom: 6, left: 18, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    keyword,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 146, 146, 145),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.delete_forever,
                      size: 16,
                      color: Color.fromARGB(255, 146, 146, 145),
                    ),
                    onTap: () {
                      updateSearchHistory(keyword, isDelete: true);
                    },
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildSearchSuggest() {
    return ListView(
      children: _searchSuggest.map((item) {
        return ListTile(
          title: Text(item),
          onTap: () {
            _keywordController.text = item;
            _searchHandler(true);
            _focusNode.unfocus();
          },
        );
      }).toList(),
    );
  }

  Widget buildBody(BuildContext context) {
    if (_focusNode.hasFocus && _searchSuggest.isNotEmpty) {
      return buildSearchSuggest();
    }
    if (searchMemberList.isEmpty && _focusNode.hasFocus) {
      return buildSearchHistory();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: searchMemberList.length + 1,
      itemBuilder: (ctx, index) {
        if (searchMemberList.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: const Center(child: Text("Member not found")),
          );
        }
        if (index == searchMemberList.length) {
          return SizedBox(
            height: 40,
            child: Center(child: _loading ? const Text("Loading...") : const Text("~~ End ~~")),
          );
        }
        final item = searchMemberList[index];

        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(item.name),
          subtitle: Text(item.role, style: const TextStyle(color: Colors.grey)),
          trailing: const Icon(Icons.add),
          onTap: () {
            // TODO: 添加成员到乐队
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);

    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _SearchForm(
          keywordController: _keywordController,
          onSearch: () {
            _searchHandler(true);
          },
          onInput: _onInputChange,
          focusNode: _focusNode,
        ),
        actions: [TextButton(onPressed: () => navigator.pop(), child: const Text("Cancel"))],
        toolbarHeight: 70,
      ),
      body: buildBody(context),
    );
  }
}

class _SearchForm extends StatefulWidget {
  final TextEditingController keywordController;
  final Function() onSearch;
  final Function(String value) onInput;
  final FocusNode focusNode;

  const _SearchForm({
    required this.keywordController,
    required this.onSearch,
    required this.onInput,
    required this.focusNode,
  });

  @override
  State<_SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<_SearchForm> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.keywordController,
      onSubmitted: (value) => widget.onSearch(),
      focusNode: widget.focusNode,
      autocorrect: false,
      enableSuggestions: false,
      enableIMEPersonalizedLearning: false, // Prevents learning from user input (Android/iOS)
      spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(255, 239, 240, 241),
        constraints: BoxConstraints(maxHeight: 35),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        hintText: "Enter member email or mobile no",
        hintStyle: TextStyle(fontSize: 12),
        contentPadding: EdgeInsets.symmetric(vertical: 13.5, horizontal: 16),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          widget.onSearch();
          return;
        }

        widget.onInput(value);
      },
    );
  }
}

class MemberItem {
  final String name;
  final String role;

  MemberItem({required this.name, required this.role});
}
