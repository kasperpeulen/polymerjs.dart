@TestOn('browser')
library tests;

import 'dart:async';
import "dart:html";
import "dart:js";

import "package:test/test.dart";

import 'package:polymerjs/polymer.dart';
import 'package:polymerjs/jsutils.dart';


void main() {
  var item = new PolymerElement.$("paper-item");
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

  group("deserialize", () {

    test("int", () {
      expect(item.deserialize("1", int), 1);
    });
    test("List", () {
      expect(item.deserialize('[1,"hello"]', List),[1,'hello']);
    });
    test("Map", () {
      expect(item.deserialize('{"1":1,"2":2}', Map)["1"], 1);
      expect(mapify(item.deserialize('{"1":1,"2":2}', Map)), {"1":1,"2":2});
    });
    test("bool", () {
      expect(item.deserialize('true', Map), true);
    });
  });

  test("item.elementMatches('paper-item') == true", () =>
      expect(item.elementMatches('paper-item'), true));

  test("getContentChildNodes", () {
    expect(item.getContentChildNodes()[1],$('paper-item div'));
  });
  
  test("item.getContentChildren() == [\$('paper-item div')]", () =>
      expect(item.getContentChildren(), [$('paper-item div')]));

  test("item.get('properties') == item.properties", ()
      => expect(item.get('properties'), item["properties"]));

  test("item.get('nonsense') == null", ()
      => expect(item.get('nonsense'), null));

  test("setting custom styles", () async{
    expect(item.element.getComputedStyle().minHeight, "48px");
    item["customStyle"]["--paper-item-min-height"] = "60px";
    item.updateStyles();
    expect(item.element.getComputedStyle().minHeight, "60px");
  }, skip: "Bug in polymer js, needs a workaround for now.");

  test("setting custom styles workaround", () async{
    expect(item.element.getComputedStyle().minHeight, "48px");
    item.customStyle["--paper-item-min-height"] = "60px";
    Polymer.updateStyles();
    new Future(() {
      expect(item.element.getComputedStyle().minHeight, "60px");
    });
  });

}



