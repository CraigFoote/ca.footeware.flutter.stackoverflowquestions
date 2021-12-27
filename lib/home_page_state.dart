import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'custom_theme.dart';
import 'info_page.dart';
import 'main.dart';

class HomePageState extends State<HomePage> {
  bool _isDarkTheme = false;
  final _searchController = TextEditingController();
  num _pageNumber = 1;
  String _searchString = '';
  bool _haveResults = false;
  late Map<String, dynamic> results;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
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
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: _isDarkTheme ? Colors.black38 : Colors.white54,
                prefixIcon: const Icon(Icons.search),
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
        ),
      ),
      body: _haveResults ? _displayResults() : Container(),
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
        path: '2.3/questions',
        query: 'site=stackoverflow&page=' +
            pageNumber.toString() +
            '&pagesize=10&order=desc&sort=activity&tagged=' +
            searchString);
    results = json.decode(await http.read(url));
    setState(() {
      _haveResults = true;
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  _displayResults() {
    var items = results['items'];
    List<Card> cards = [];
    for (var i = 0; i < items.length; i++) {
      cards.add(_createCard(items[i]));
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

  Row _getNavButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () =>
                      _doSearch(context, _pageNumber--, _searchString),
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
                  onPressed: () =>
                      _doSearch(context, _pageNumber++, _searchString),
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
        ),
      ],
    );
  }

  Card _createCard(item) {
    return Card(
      margin: const EdgeInsets.all(15.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    item['title'],
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const Divider(
                    endIndent: 50,
                    color: Colors.black54,
                  ),
                  Text(
                    'Answered: ' + item['is_answered'].toString(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'View Count: ' + item['view_count'].toString(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Answer Count: ' + item['answer_count'].toString(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Score: ' + item['score'].toString(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Last Activity: ' +
                        DateTime.fromMillisecondsSinceEpoch(
                            (item['last_activity_date']) * 1000)
                            .toString(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Created: ' +
                        DateTime.fromMillisecondsSinceEpoch(
                            (item['creation_date']) * 1000)
                            .toString(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: const Text(
                      'StackOverflow Page',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () => launchInBrowser(
                      item['link'],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Image(
                  image: NetworkImage(item['owner']['profile_image']),
                ),
                SelectableText(item['owner']['display_name']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceWebView: false,
    )) {
      throw 'Could not launch $url';
    }
  }
}