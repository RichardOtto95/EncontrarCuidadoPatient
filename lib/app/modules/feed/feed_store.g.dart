// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FeedStore on _FeedStoreBase, Store {
  final _$feedListAtom = Atom(name: '_FeedStoreBase.feedList');

  @override
  ObservableList<dynamic> get feedList {
    _$feedListAtom.reportRead();
    return super.feedList;
  }

  @override
  set feedList(ObservableList<dynamic> value) {
    _$feedListAtom.reportWrite(value, super.feedList, () {
      super.feedList = value;
    });
  }

  final _$feedListCompleteAtom = Atom(name: '_FeedStoreBase.feedListComplete');

  @override
  List<dynamic> get feedListComplete {
    _$feedListCompleteAtom.reportRead();
    return super.feedListComplete;
  }

  @override
  set feedListComplete(List<dynamic> value) {
    _$feedListCompleteAtom.reportWrite(value, super.feedListComplete, () {
      super.feedListComplete = value;
    });
  }

  final _$feedMapReportingAtom = Atom(name: '_FeedStoreBase.feedMapReporting');

  @override
  ObservableMap<dynamic, dynamic> get feedMapReporting {
    _$feedMapReportingAtom.reportRead();
    return super.feedMapReporting;
  }

  @override
  set feedMapReporting(ObservableMap<dynamic, dynamic> value) {
    _$feedMapReportingAtom.reportWrite(value, super.feedMapReporting, () {
      super.feedMapReporting = value;
    });
  }

  final _$hasNextAtom = Atom(name: '_FeedStoreBase.hasNext');

  @override
  bool get hasNext {
    _$hasNextAtom.reportRead();
    return super.hasNext;
  }

  @override
  set hasNext(bool value) {
    _$hasNextAtom.reportWrite(value, super.hasNext, () {
      super.hasNext = value;
    });
  }

  final _$feedLimitAtom = Atom(name: '_FeedStoreBase.feedLimit');

  @override
  int get feedLimit {
    _$feedLimitAtom.reportRead();
    return super.feedLimit;
  }

  @override
  set feedLimit(int value) {
    _$feedLimitAtom.reportWrite(value, super.feedLimit, () {
      super.feedLimit = value;
    });
  }

  final _$maxDocsAtom = Atom(name: '_FeedStoreBase.maxDocs');

  @override
  int get maxDocs {
    _$maxDocsAtom.reportRead();
    return super.maxDocs;
  }

  @override
  set maxDocs(int value) {
    _$maxDocsAtom.reportWrite(value, super.maxDocs, () {
      super.maxDocs = value;
    });
  }

  final _$setCardsAtom = Atom(name: '_FeedStoreBase.setCards');

  @override
  bool get setCards {
    _$setCardsAtom.reportRead();
    return super.setCards;
  }

  @override
  set setCards(bool value) {
    _$setCardsAtom.reportWrite(value, super.setCards, () {
      super.setCards = value;
    });
  }

  final _$addPostsAtom = Atom(name: '_FeedStoreBase.addPosts');

  @override
  bool get addPosts {
    _$addPostsAtom.reportRead();
    return super.addPosts;
  }

  @override
  set addPosts(bool value) {
    _$addPostsAtom.reportWrite(value, super.addPosts, () {
      super.addPosts = value;
    });
  }

  final _$reportingPostAtom = Atom(name: '_FeedStoreBase.reportingPost');

  @override
  bool get reportingPost {
    _$reportingPostAtom.reportRead();
    return super.reportingPost;
  }

  @override
  set reportingPost(bool value) {
    _$reportingPostAtom.reportWrite(value, super.reportingPost, () {
      super.reportingPost = value;
    });
  }

  final _$loadCircularDialogCardAtom =
      Atom(name: '_FeedStoreBase.loadCircularDialogCard');

  @override
  bool get loadCircularDialogCard {
    _$loadCircularDialogCardAtom.reportRead();
    return super.loadCircularDialogCard;
  }

  @override
  set loadCircularDialogCard(bool value) {
    _$loadCircularDialogCardAtom
        .reportWrite(value, super.loadCircularDialogCard, () {
      super.loadCircularDialogCard = value;
    });
  }

  final _$connectedAtom = Atom(name: '_FeedStoreBase.connected');

  @override
  bool get connected {
    _$connectedAtom.reportRead();
    return super.connected;
  }

  @override
  set connected(bool value) {
    _$connectedAtom.reportWrite(value, super.connected, () {
      super.connected = value;
    });
  }

  final _$likingAtom = Atom(name: '_FeedStoreBase.liking');

  @override
  bool get liking {
    _$likingAtom.reportRead();
    return super.liking;
  }

  @override
  set liking(bool value) {
    _$likingAtom.reportWrite(value, super.liking, () {
      super.liking = value;
    });
  }

  final _$viewDrProfileAsyncAction =
      AsyncAction('_FeedStoreBase.viewDrProfile');

  @override
  Future viewDrProfile(String doctorId) {
    return _$viewDrProfileAsyncAction.run(() => super.viewDrProfile(doctorId));
  }

  final _$toLikeAsyncAction = AsyncAction('_FeedStoreBase.toLike');

  @override
  Future toLike(String feedId, String doctorId) {
    return _$toLikeAsyncAction.run(() => super.toLike(feedId, doctorId));
  }

  final _$_FeedStoreBaseActionController =
      ActionController(name: '_FeedStoreBase');

  @override
  bool getLiking() {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.getLiking');
    try {
      return super.getLiking();
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCardDialog(bool c) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.setCardDialog');
    try {
      return super.setCardDialog(c);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getTime(Timestamp time) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase.getTime');
    try {
      return super.getTime(time);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
feedList: ${feedList},
feedListComplete: ${feedListComplete},
feedMapReporting: ${feedMapReporting},
hasNext: ${hasNext},
feedLimit: ${feedLimit},
maxDocs: ${maxDocs},
setCards: ${setCards},
addPosts: ${addPosts},
reportingPost: ${reportingPost},
loadCircularDialogCard: ${loadCircularDialogCard},
connected: ${connected},
liking: ${liking}
    ''';
  }
}
