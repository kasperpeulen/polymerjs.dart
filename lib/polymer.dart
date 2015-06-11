library polymer;

import 'dart:html';
import 'dart:js';
import 'dart:async';
import 'dart:convert';
import 'package:polymerjs_wrapper/IronBehaviours.dart';

/**
 * Finds the first descendant element of this document that matches the specified group of selectors.
 */
Element $(String selectors) => querySelector(selectors);

/**
 * Convert a JavaScript result object to an equivalent Dart map.
 */
Map mapify(JsObject obj) {
  if (obj == null) return null;
  return JSON.decode(context['JSON'].callMethod('stringify', [obj]));
}

class PolymerBase {
  HtmlElement element;
  Map<String, Stream> eventStreams = {};

  JsObject _js;
  JsObject get js =>
      _js != null ? _js : new JsObject.fromBrowserObject(element);

  PolymerBase(String tag) : element = new Element.tag(tag);
  PolymerBase.fromElement(this.element);
  PolymerBase.fromSelector(String selector) : element = $(selector);
  PolymerBase.$(String selector) : element = $(selector);

  dynamic property(String name) => js[name];
  dynamic setProperty(String name, dynamic value) => js[name] = value;

  dynamic operator [](String propertyName) => js[propertyName];
  void operator []=(String propertyName, dynamic value) {
    js[propertyName] = value;
  }
  dynamic call(String methodName, [List args]) =>
      js.callMethod(methodName, args);

  Stream listen(String eventName, {Function converter, bool sync: false}) {
    if (!eventStreams.containsKey(eventName)) {
      StreamController controller = new StreamController.broadcast(sync: sync);
      eventStreams[eventName] = controller.stream;
      element.on[eventName].listen((e) {
        controller.add(converter == null ? e : converter(e));
      });
    }
    return eventStreams[eventName];
  }
}

/// `iron-pages` is used to select one of its children to show. One use is to
/// cycle through a list of children "pages".
class IronPages extends PolymerBase
    with IronSelectableBehavior, IronResizableBehavior {
  IronPages() : super("iron-pages");
  IronPages.fromElement(HtmlElement element) : super.fromElement(element);
  IronPages.fromSelector(String selector) : super.fromSelector(selector);
  IronPages.$(String selector) : super.$(selector);
}

/// <paper-menu> implements an accessible menu control with Material Design
/// styling. The focused item is highlighted, and the selected item has bolded
/// text. Make a multi-select menu with the multi attribute. Items in a
/// multi-select menu can be deselected, and multiple item can be selected.
/// <paper-menu> has role="menu" by default. A multi-select menu will also have
/// aria-multiselectable set. It implements key bindings to navigate through the
/// menu with the up and down arrow keys, esc to exit the menu, and enter to
/// activate a menu item. Typing the first letter of a menu item will also focus it.
class PaperMenu extends PolymerBase
    with IronMenuBehavior, IronMultiSelectableBehavior, IronSelectableBehavior, IronA11yKeysBehavior {
  PaperMenu() : super("paper-menu");
  PaperMenu.fromElement(HtmlElement element) : super.fromElement(element);
  PaperMenu.fromSelector(String selector) : super.fromSelector(selector);
  PaperMenu.$(String selector) : super.$(selector);
}

/// `<paper-item>` is a non-interactive list item. By default, it is a horizontal
/// flexbox.
///
/// Use this element with `<paper-item-body>` to make Material Design styled
/// two-line and three-line items.
///
/// ```
/// <paper-item>
/// <paper-item-body two-line>
/// <div>Show your status</div>
/// <div secondary>Your status is visible to everyone</div>
/// </paper-item-body>
/// <iron-icon icon="warning"></iron-icon>
/// </paper-item>
/// ```
///
/// ### Styling
/// 
/// The following custom properties and mixins are available for styling:
/// 
/// Custom property | Description | Default
/// ----------------|-------------|----------
/// `--paper-item-min-height` | Minimum height of the item | `48px`
/// `--paper-item`            | Mixin applied to the item  | `{}`
/// 
/// ### Accessibility
/// 
/// This element has `role="listitem"` by default. Depending on usage, it may
/// be more appropriate to set `role="menuitem"`, `role="menuitemcheckbox"` or
/// `role="menuitemradio"`.
///
/// ```
/// <paper-item role="menuitemcheckbox">
/// <paper-item-body>
/// Show your status
/// </paper-item-body>
/// <paper-checkbox></paper-checkbox>
/// </paper-item>
/// ```
///
/// @group Paper Elements
/// @element paper-item
/// @demo demo/index.html
///
class PaperItem extends PolymerBase {
  PaperItem() : super("paper-item");
  PaperItem.fromElement(HtmlElement element) : super.fromElement(element);
  PaperItem.fromSelector(String selector) : super.fromSelector(selector);
  PaperItem.$(String selector) : super.$(selector);
}


