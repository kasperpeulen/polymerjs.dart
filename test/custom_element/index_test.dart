@TestOn('browser')

import "package:test/test.dart";

import "package:web_components/web_components.dart";
import 'dart:js';
import 'dart:async';
import 'dart:html';
import 'package:polymerjs/polymer.dart';

main() {
  initWebComponents();
  Stream stream = window.on['WebComponentsReady'];

  test("WebComponentsReady", () {
    if (context["CustomElements"]["ready"] == null) {
      stream.listen(expectAsync((e) {
        expect(context["CustomElements"]["ready"], isNotNull);
      }));
    } else {
      expect(context["CustomElements"]["ready"], isNotNull);
    }
  });

  test("", () {
    expect(new PolymerElement.$("hello-world").$$("div").text, "Hello world!!!");
  });
}