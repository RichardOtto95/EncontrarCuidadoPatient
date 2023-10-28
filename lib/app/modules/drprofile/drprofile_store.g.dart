// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drprofile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DrProfileStore on _DrprofileStoreBase, Store {
  final _$indexAtom = Atom(name: '_DrprofileStoreBase.index');

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  final _$ratingsAverageAtom = Atom(name: '_DrprofileStoreBase.ratingsAverage');

  @override
  String get ratingsAverage {
    _$ratingsAverageAtom.reportRead();
    return super.ratingsAverage;
  }

  @override
  set ratingsAverage(String value) {
    _$ratingsAverageAtom.reportWrite(value, super.ratingsAverage, () {
      super.ratingsAverage = value;
    });
  }

  final _$ratingsLengthAtom = Atom(name: '_DrprofileStoreBase.ratingsLength');

  @override
  int get ratingsLength {
    _$ratingsLengthAtom.reportRead();
    return super.ratingsLength;
  }

  @override
  set ratingsLength(int value) {
    _$ratingsLengthAtom.reportWrite(value, super.ratingsLength, () {
      super.ratingsLength = value;
    });
  }

  final _$moreReviewsAtom = Atom(name: '_DrprofileStoreBase.moreReviews');

  @override
  bool get moreReviews {
    _$moreReviewsAtom.reportRead();
    return super.moreReviews;
  }

  @override
  set moreReviews(bool value) {
    _$moreReviewsAtom.reportWrite(value, super.moreReviews, () {
      super.moreReviews = value;
    });
  }

  final _$limitAtom = Atom(name: '_DrprofileStoreBase.limit');

  @override
  int get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(int value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  final _$maxDocsAtom = Atom(name: '_DrprofileStoreBase.maxDocs');

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

  final _$setCardsAtom = Atom(name: '_DrprofileStoreBase.setCards');

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

  final _$mapReportAtom = Atom(name: '_DrprofileStoreBase.mapReport');

  @override
  ObservableMap<dynamic, dynamic> get mapReport {
    _$mapReportAtom.reportRead();
    return super.mapReport;
  }

  @override
  set mapReport(ObservableMap<dynamic, dynamic> value) {
    _$mapReportAtom.reportWrite(value, super.mapReport, () {
      super.mapReport = value;
    });
  }

  final _$toLikeAsyncAction = AsyncAction('_DrprofileStoreBase.toLike');

  @override
  Future toLike(String feedId, String doctorId) {
    return _$toLikeAsyncAction.run(() => super.toLike(feedId, doctorId));
  }

  final _$reportPostAsyncAction = AsyncAction('_DrprofileStoreBase.reportPost');

  @override
  Future reportPost(String report, String postId) {
    return _$reportPostAsyncAction.run(() => super.reportPost(report, postId));
  }

  final _$getMoreOpinionAsyncAction =
      AsyncAction('_DrprofileStoreBase.getMoreOpinion');

  @override
  Future getMoreOpinion() {
    return _$getMoreOpinionAsyncAction.run(() => super.getMoreOpinion());
  }

  final _$getOpinionsAsyncAction =
      AsyncAction('_DrprofileStoreBase.getOpinions');

  @override
  Future<List<dynamic>> getOpinions({int index, String doctorId}) {
    return _$getOpinionsAsyncAction
        .run(() => super.getOpinions(index: index, doctorId: doctorId));
  }

  final _$getRatingsAsyncAction = AsyncAction('_DrprofileStoreBase.getRatings');

  @override
  Future getRatings(String doctorId) {
    return _$getRatingsAsyncAction.run(() => super.getRatings(doctorId));
  }

  final _$_DrprofileStoreBaseActionController =
      ActionController(name: '_DrprofileStoreBase');

  @override
  dynamic setCardDialog(bool c) {
    final _$actionInfo = _$_DrprofileStoreBaseActionController.startAction(
        name: '_DrprofileStoreBase.setCardDialog');
    try {
      return super.setCardDialog(c);
    } finally {
      _$_DrprofileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String converterDateToString(Timestamp date) {
    final _$actionInfo = _$_DrprofileStoreBaseActionController.startAction(
        name: '_DrprofileStoreBase.converterDateToString');
    try {
      return super.converterDateToString(date);
    } finally {
      _$_DrprofileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getTime(Timestamp time) {
    final _$actionInfo = _$_DrprofileStoreBaseActionController.startAction(
        name: '_DrprofileStoreBase.getTime');
    try {
      return super.getTime(time);
    } finally {
      _$_DrprofileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
index: ${index},
ratingsAverage: ${ratingsAverage},
ratingsLength: ${ratingsLength},
moreReviews: ${moreReviews},
limit: ${limit},
maxDocs: ${maxDocs},
setCards: ${setCards},
mapReport: ${mapReport}
    ''';
  }
}
