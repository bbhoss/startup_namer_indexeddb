import 'package:angular2/angular2.dart';
import 'dart:indexed_db' as idb;
import 'dart:html' show window;
import 'dart:async';
import 'package:english_words/english_words.dart';

@Injectable()
class SavedNamesService {
  static const String DATABASE_NAME = 'saved_names';
  static const String NAME_INDEX = 'name_index';
  final savedNames = new Set<WordPair>();
  idb.Database _db;

  void _initializeDatabase(idb.VersionChangeEvent e) {
    idb.Database db = (e.target as idb.Request).result;

    db.createObjectStore(DATABASE_NAME, autoIncrement: false);
  }

  Future _loadFromDB(idb.Database db) {
    _db = db;
    _getAllNamesFromDB();
  }

  void _getAllNamesFromDB() {
    var trans = _db.transaction(DATABASE_NAME, 'readonly');
    var store = trans.objectStore(DATABASE_NAME);

    savedNames.clear(); // TODO: Make this not necessary
    var cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
    cursors.listen((cursor) {
      var wordPair =
          new WordPair(cursor.value['first'], cursor.value['second']);
      savedNames.add(wordPair);
    });
  }

  Future open() {
    return window.indexedDB
        .open(DATABASE_NAME, version: 1, onUpgradeNeeded: _initializeDatabase)
        .then(_loadFromDB);
  }

  Future addWord(WordPair word) {
    print('add word');
    var trans = _db.transaction(DATABASE_NAME, 'readwrite');
    var store = trans.objectStore(DATABASE_NAME);
    return store.put({
      'first': word.first,
      'second': word.second,
    }, word.join()).then((_) => _getAllNamesFromDB());
  }

  Future removeWord(WordPair word) {
    print('remove word');
    var trans = _db.transaction(DATABASE_NAME, 'readwrite');
    var store = trans.objectStore(DATABASE_NAME);
    return store.delete(word.join()).then((_) => _getAllNamesFromDB());
  }
}
