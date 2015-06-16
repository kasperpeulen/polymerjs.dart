@TestOn('browser')
library test_IronAutoGrowTextarea;

import "package:test/test.dart";
import 'package:polymerjs/iron-autogrow-textarea.dart';
import 'dart:async';
import 'dart:js';
import 'dart:html';


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

  group("iron-autogrow-textarea", () {
    test('setting bindValue sets textarea value', () {
      var autogrow = new IronAutogrowTextarea.$('#basic');
      var textarea = autogrow.textarea;
      autogrow.bindValue = 'batman';
      expect(textarea.value, autogrow.bindValue);
    });

    test('can set an initial bindValue', () {
      var autogrow = new IronAutogrowTextarea.$('#has-bindValue');
      expect(autogrow.textarea.value, 'foobar');
    });


    test('can set an initial number of rows', () {
      var autogrow = new IronAutogrowTextarea.$("#rows");
      expect(autogrow.textarea.rows, 3);
    });

    test('adding rows grows the textarea', () {
      var autogrow = new IronAutogrowTextarea.$('#basic');
      int initialHeight = autogrow.offsetHeight;

      autogrow.bindValue = 'batman\nand\nrobin';
      int finalHeight = autogrow.offsetHeight;
      expect(finalHeight > initialHeight, isTrue);
    });

    test('removing rows shrinks the textarea', () {
      var autogrow = new IronAutogrowTextarea.$('#basic');
      autogrow.bindValue = 'batman\nand\nrobin';
      int initialHeight = autogrow.offsetHeight;

      autogrow.bindValue = 'batman';
      int finalHeight = autogrow.offsetHeight;
      expect(finalHeight < initialHeight, isTrue);
    });
  });
}