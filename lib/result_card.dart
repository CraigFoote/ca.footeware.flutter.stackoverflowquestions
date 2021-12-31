import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultCard extends Card {
  ResultCard(Map<String, dynamic> parsedJson, {Key? key})
      : super(
            key: key,
            margin: const EdgeInsets.all(15.0),
            child: getContent(parsedJson));
}

Widget getContent(Map<String, dynamic> item) {
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
                image: NetworkImage(
                  item['owner']['profile_image'],
                ),
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Image not found.');
                },
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
