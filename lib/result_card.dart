import 'package:flutter/material.dart';
import 'package:stackoverflow_questions/result_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultCard extends Card {
  ResultCard(Map<String, dynamic> parsedJson, double thumbnailWidth, {Key? key})
      : super(
            key: key,
            elevation: 10.0,
            margin: const EdgeInsets.all(15.0),
            child: getContent(parsedJson, thumbnailWidth));
}

Widget getContent(Map<String, dynamic> parsedJson, double thumbnailWidth) {
  ResultItem item = ResultItem(parsedJson);
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
                  item.title,
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Divider(endIndent: 50, color: Colors.black54),
                Text(
                  'Answered: ' + item.isAnswered,
                ),
                const SizedBox(height: 10),
                Text(
                  'View Count: ' + item.viewCount,
                ),
                const SizedBox(height: 10),
                Text(
                  'Answer Count: ' + item.answerCount,
                ),
                const SizedBox(height: 10),
                Text(
                  'Score: ' + item.score,
                ),
                const SizedBox(height: 10),
                Text(
                  'Last Activity: ' + item.lastActivityDate,
                ),
                const SizedBox(height: 10),
                Text(
                  'Created: ' + item.creationDate,
                ),
                const SizedBox(height: 10),
                Text(
                  'Tags: ' + item.tags,
                ),
                const SizedBox(height: 10),
                InkWell(
                  child: const Text(
                    'StackOverflow Page',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () => launchInBrowser(item.link),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Image(
                image: NetworkImage(
                  item.profileImage,
                ),
                width: thumbnailWidth,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Profile image not found.',
                  );
                },
              ),
              SelectableText(item.displayName),
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
