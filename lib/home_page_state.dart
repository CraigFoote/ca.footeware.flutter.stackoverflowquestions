import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stackoverflow_questions/result_card.dart';

import 'custom_theme.dart';
import 'info_page.dart';
import 'main.dart';

class HomePageState extends State<HomePage> {
  bool _isDarkTheme = false;
  final _searchController = TextEditingController();
  num _pageNumber = 1;
  String _searchString = '';
  Map<String, dynamic> results = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = (prefs.getBool('isDarkTheme') ?? false);
      widget.themeCallback(
          _isDarkTheme ? CustomTheme.darkTheme : CustomTheme.lightTheme);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Preferences',
            );
          },
        ),
        title: Container(
          // width: double.infinity,
          // height: 40,
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: TextField(
            autofocus: true,
            controller: _searchController,
            style: const TextStyle(
              color: Colors.white54,
            ),
            decoration: InputDecoration(
              // constraints: const BoxConstraints.expand(width: double.infinity),
              filled: true,
              fillColor: Colors.transparent,
              // prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => setState(
                  () => _searchController.clear(),
                ),
              ),
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            onSubmitted: (value) => _doSearch(context, _pageNumber, value),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                _doSearch(context, _pageNumber, _searchController.text),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: _displayResults(),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Row(
                children: [
                  const Text('Dark Theme'),
                  Switch(
                    value: _isDarkTheme,
                    onChanged: (value) async {
                      final prefs = await SharedPreferences.getInstance();
                      setState(
                        () {
                          _isDarkTheme = value;
                          prefs.setBool('isDarkTheme', _isDarkTheme);
                          widget.themeCallback(value
                              ? CustomTheme.darkTheme
                              : CustomTheme.lightTheme);
                        },
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      child: Builder(
                        builder: (context) => const Icon(
                          Icons.info,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const InfoPage(
                                title: 'Info',
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _doSearch(BuildContext context, num pageNumber, String searchString) {
    _searchString = searchString;
    _getSearchResults(context, _pageNumber, _searchString);
  }

  _getSearchResults(
      BuildContext context, num pageNumber, String searchString) async {
    Uri url = Uri(
        scheme: 'https',
        host: 'api.stackexchange.com',
        path: '2.3/search',
        query: 'site=stackoverflow&page=' +
            pageNumber.toString() +
            '&pagesize=10&order=desc&sort=activity&intitle=' +
            searchString);
    results = json.decode(await http.read(url));
    setState(() {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }

  _displayResults() {
    if (results.isNotEmpty) {
      var items = results['items'];
      List<Card> cards = [];
      for (var i = 0; i < items.length; i++) {
        cards.add(ResultCard(items[i]));
      }
      return ListView.builder(
        controller: _scrollController,
        itemCount: cards.length + 1,
        itemBuilder: (context, index) {
          if (index == cards.length) {
            return _getNavButtons(context);
          }
          return cards[index];
        },
      );
    }
  }

  Widget _getNavButtons(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _doSearch(context, _pageNumber--, _searchString),
              child: Row(
                children: const [
                  Icon(
                    Icons.arrow_left,
                  ),
                  Text(
                    'Previous',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _doSearch(context, _pageNumber++, _searchString),
              child: Row(
                children: const [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
