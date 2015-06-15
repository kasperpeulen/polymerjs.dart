@TestOn('browser')
library test_IronAutoGrowTextarea;

import "package:test/test.dart";
import 'dart:async';
import 'dart:js';
import 'dart:html';
import 'package:polymerjs/iron-collapse.dart';

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

  group('iron-collapse', () {
    IronCollapse collapse = new IronCollapse.$("iron-collapse");
    var delay = new Duration(milliseconds:500);
    var collapseHeight;
    test('opened attribute', () {
      expect(collapse.opened, true);
    });

    test('horizontal attribute', () {
      expect(collapse.horizontal, false);
    });

    test('default opened height', () {
      expect(new Future.delayed(delay, () {
        collapseHeight = collapse.element.getComputedStyle().height;
        return collapseHeight;
      }
      ), completion(isNot("0px")));
    }, onPlatform: {
      "firefox": new Skip("firefox... getComputedStyle is null")
    });

    test('set opened to false', () {
      collapse.opened = false;
      expect(new Future.delayed(delay, () =>
      collapse.element.getComputedStyle().height
      ), completion("0px"));
    }, onPlatform: {
      "firefox": new Skip("firefox... getComputedStyle is null")
    });

    test('set opened to true', () {
      collapse.opened = true;
      expect(new Future.delayed(delay, () =>
      collapse.element.getComputedStyle().height
      ), completion(collapseHeight));
    }, onPlatform: {
      "firefox": new Skip("firefox... getComputedStyle is null")
    });
  });
}
