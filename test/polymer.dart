@TestOn('dartium||chrome||firefox||safari')

library tests;

import 'dart:async';
import "dart:html";
import "dart:js";

import "package:test/test.dart";

import 'package:polymerjs_wrapper/polymer.dart';
import 'package:polymerjs_wrapper/IronTestHelper.dart';


void main() {
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

// <iron-pages selected="1">
//   <section>page 0</section>
//   <section>page 1</section>
// </iron-pages>

  group("IronSelectableBehavior", () {
    var pages = new IronPages.$("iron-pages");
    test("properties", () {
      pages.selectedAttribute = "my-attribute";
      pages.selected = 0;
      expect($("[my-attribute]").text, "page 0");
      expect($("[my-attribute]"), pages.selectedItem);
      expect(pages.indexOf(pages.selectedItem), 0);
    });
    test("methods", () {
      expect(pages.items[0], pages.selectedItem);
      pages.select(1);
      expect(pages.selected, 1);
      pages.selectNext();
      expect(pages.selected, 0);
      pages.selectPrevious();
      expect(pages.selected, 1);
    });
  });

// <paper-menu multi selected-values="[0,1]">
//   <paper-item>item 0</paper-item>
//   <paper-item>item 1</paper-item>
//   <paper-item>item 2</paper-item>
// </paper-menu>

  group("IronMultiSelectableBehavior", () {

    var menu = new PaperMenu.$("paper-menu");
    while (menu == null) {
      menu = new PaperMenu.$("paper-menu");
    }
    test("properties and methods", () {
      expect(menu.multi, true);
      expect(menu.selectedValues, [0, 1]);
      menu.select(1);
      expect(menu.selectedValues, [0]);
      menu.select(2);
      expect(menu.selectedItems[1].text.trim(), "item 2");
      var startItem = menu.focusedItem;
      menu.addOwnKeyBinding("space", '_onUpKey');
      MockInteractions.pressSpace(menu.element);
      expect(menu.focusedItem, isNot(startItem));
      startItem = menu.focusedItem;
      menu.removeOwnKeyBindings();
      MockInteractions.pressSpace(menu.element);
      expect(menu.focusedItem, startItem);
    });

    test("events", (){

      bool deselected = false;
      menu.onIronDeSelect.listen((e) => deselected = true);
      MockInteractions.tap(menu.items[0]);
      Timer.run(() => expect(deselected, isTrue));

      bool selected = false;
      menu.onIronSelect.listen((e) => selected = true);
      MockInteractions.tap(menu.items[0]);
      Timer.run(() => expect(selected, isTrue));

    });
  });

  group("IronResizableBehavior", () {

    test("listen", () {
      var pages;
      while (pages == null) {
        pages = new IronPages.$("iron-pages");
      }
      expect(pages.selected, 1);
      pages.ironResize.listen((e) {
        expect(pages.selected, 0);
      });
      pages.selected = 0;
    });
  });
}
