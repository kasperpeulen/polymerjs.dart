/// Make sure to import the following in your html test:
/// <script src="components/iron-test-helpers/mock-interactions.js">
/// <script src="src="components/iron-test-helpers/test-helpers.js>
library IronTestHelper;

import 'dart:js';
import 'dart:html';

JsObject proxy = context["MockInteractions"];

class MockInteractions {
  static blur(HtmlElement target) => proxy["blur"].apply([target]);

  static down(HtmlElement target) => proxy["down"].apply([target]);

  static up(HtmlElement target) => proxy["up"].apply([target]);

  static downAndUp(HtmlElement target) => proxy["downAndUp"].apply([target]);

  static tap(HtmlElement target) => proxy["tap"].apply([target]);

  static track(HtmlElement target) => proxy["track"].apply([target]);

  static pressEnter(HtmlElement target) => proxy["pressEnter"].apply([target]);

  static pressSpace(HtmlElement target) => proxy["pressSpace"].apply([target]);

  static keyDownOn(HtmlElement target, {int keyCode: 13}) => proxy["keyDownOn"].apply([target,keyCode]);

  static keyUpOn(HtmlElement target, {int keyCode: 13}) => proxy["keyUpOn"].apply([target,keyCode]);

//  middleOfNode: middleOfNode,
//  topLeftOfNode: topLeftOfNode
}

