class ResultItem {
  ResultItem(this.item);

  Map<String, dynamic> item;

  String get title {
    try {
      return item['title'];
    } catch (e) {
      return 'Title not found.';
    }
  }

  String get isAnswered {
    try {
      return item['isAnswered'].toString();
    } catch (e) {
      return 'Answered not found.';
    }
  }

  String get viewCount {
    try {
      return item['view_count'].toString();
    } catch (e) {
      return 'View count not found';
    }
  }

  String get answerCount {
    try {
      return item['answer_count'].toString();
    } catch (e) {
      return 'Answer count not found.';
    }
  }

  String get score {
    try {
      return item['score'].toString();
    } catch (e) {
      return 'Score not found.';
    }
  }

  String get lastActivityDate {
    try {
      return DateTime.fromMillisecondsSinceEpoch(
          (item['last_activity_date']) * 1000)
          .toString();
    } catch (e) {
      return 'Last activity date not found';
    }
  }

  String get creationDate {
    try {
      return DateTime.fromMillisecondsSinceEpoch((item['creation_date']) * 1000)
          .toString();
    } catch (e) {
      return 'Creation date not found.';
    }
  }

  String get link {
    try {
      return item['link'];
    } catch (e) {
      return 'Link not found.';
    }
  }

  String get profileImage {
    try {
      return item['owner']['profile_image'];
    } catch (e) {
      return 'Profile image not found.';
    }
  }

  String get displayName {
    try {
      return item['owner']['display_name'];
    } catch (e) {
      return 'Name not found.';
    }
  }
}