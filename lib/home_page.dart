import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stackoverflow_questions/result_card.dart';

import 'custom_theme.dart';
import 'info_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.themeCallback})
      : super(key: key);

  final Function themeCallback;
  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isDarkTheme = false;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  num _pageNumber = 1;
  String _searchString = '';
  bool _haveResults = false;
  late bool _hasMore;
  late dynamic _results;

  double get thumbnailWidth {
    return MediaQuery.of(context).size.width * .20;
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _searchController.addListener(() => _searchString = _searchController.text);
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
      appBar: _buildAppbar(),
      body: !_haveResults
          ? Container()
          : Builder(
              builder: (_) {
                List<Card> cards = [];
                for (var i = 0; i < _results.length; i++) {
                  cards.add(ResultCard(_results[i], thumbnailWidth));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: cards.length + 1,
                  itemBuilder: (_, index) {
                    if (index == cards.length) {
                      return _buildNavButtons();
                    }
                    return cards[index];
                  },
                );
              },
            ),
      drawer: _buildDrawer(),
    );
  }

  void _getSearchResults() async {
    if (_searchString.isNotEmpty && _pageNumber > 0) {
      _haveResults = false;
      Uri url = Uri(
          scheme: 'https',
          host: 'api.stackexchange.com',
          path: '2.3/search',
          query: 'site=stackoverflow&page=' +
              _pageNumber.toString() +
              '&pagesize=10&order=desc&sort=activity&intitle=' +
              _searchString);
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);
      await http.get(url).then((response) {
        if (response.statusCode == 200) {
          var decoded =
              convert.jsonDecode(response.body) as Map<String, dynamic>;
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
            );
          }
          _hasMore = decoded['has_more'];
          _results = decoded['items'];
          setState(() {
            _haveResults = true;
          });
        }
      });
    }
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      leading: Builder(
        builder: (
          BuildContext context,
        ) {
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
            filled: true,
            fillColor: Colors.transparent,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              color: Colors.white54,
              onPressed: () => setState(
                () => _searchController.clear(),
              ),
            ),
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            _pageNumber = 1;
            _searchString = value;
            _getSearchResults();
          },
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(
          10.0,
        ),
        child: ListView(
          children: [
            Row(
              children: [
                const Text(
                  'Dark Theme',
                ),
                Switch(
                  value: _isDarkTheme,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    setState(
                      () {
                        _isDarkTheme = value;
                        prefs.setBool(
                          'isDarkTheme',
                          _isDarkTheme,
                        );
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
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  child: GestureDetector(
                    child: Builder(
                      builder: (_) => const Icon(
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
    );
  }

  Widget _buildNavButtons() {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _pageNumber > 1
                  ? () {
                      --_pageNumber;
                      _getSearchResults();
                    }
                  : null,
              child: Row(
                children: const [
                  Icon(Icons.arrow_left),
                  Text(
                    'Previous',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: ElevatedButton(
              onPressed: _hasMore
                  ? () {
                      ++_pageNumber;
                      _getSearchResults();
                    }
                  : null,
              child: Row(
                children: const [
                  Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Icon(Icons.arrow_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
