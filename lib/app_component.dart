// Copyright (c) 2017, preston. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';

import 'package:english_words/english_words.dart';
import 'src/saved_names_service.dart';
// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [SavedNamesService, materialProviders],
)
class AppComponent implements OnInit {
  AppComponent(this._savedNamesService);

  var names = <WordPair>[];
  final SavedNamesService _savedNamesService;
  Set<WordPair> savedNames;

  void generateNames() {
    names = generateWordPairs().take(5).toList();
  }

  void saveName(WordPair name) {
    _savedNamesService.addWord(name);
  }

  void removeFromSaved(WordPair name) {
    _savedNamesService.removeWord(name);
  }

  void toggleSavedState(WordPair name) {
    if (savedNames.contains(name)) {
      removeFromSaved(name);
    } else {
      saveName(name);
    }
  }

  @override
  void ngOnInit() {
    _savedNamesService.open();
    savedNames = _savedNamesService.savedNames;
    generateNames();
  }
}
