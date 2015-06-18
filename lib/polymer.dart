library polymerjs.polymer;

import 'dart:html';
import 'dart:js';
import 'dart:async';
import 'package:polymerjs/iron-behaviours.dart';
import 'package:polymerjs/jsutils.dart';

export 'package:initialize/initialize.dart';
export 'package:web_components/src/init.dart';
export "dart:html";
export "dart:js";
export 'package:polymerjs/jsutils.dart';

/**
 * Finds the first descendant element of this document that matches the
 * specified group of selectors.
 */
HtmlElement $(String selectors) => querySelector(selectors);

WebElement $$(String selectors) {
  HtmlElement element = querySelector(selectors);
  if (element == null) {
    return null;
  } else {
    JsObject js = new JsObject.fromBrowserObject(element);
    String name = js["constructor"]["name"];
    if (name.contains("-")) {
      return new PolymerElement.from(element);
    } else {
      return new WebElement.from(element);
    }
  }
}

JsObject polymer(Map constructor) {
  var js = jsify(constructor);

  return context.callMethod("Polymer", [js]);
}
class Polymer {
  static JsObject get js => context["Polymer"];

  dynamic operator [](String propertyName) => js[propertyName];
  void operator []=(String propertyName, dynamic value) {
    js[propertyName] = value;
  }

  static call(Map constructor) => polymer(constructor);

  static JsObject Class(Map constructor) {
    return context["Polymer"].callMethod("Class", [jsify(constructor)]);
  }

  static JsObject registerElement(String tag, JsObject constructor) {
    return new JsObject.fromBrowserObject(document).callMethod(
        'registerElement',
        [tag, constructor]);
  }

  /// Re-evaluates and applies custom CSS properties based on dynamic changes,
  /// such as adding or removing classes in this element's local DOM.
  static updateStyles() => context["Polymer"].callMethod("updateStyles");
}


class WebElement {

  final HtmlElement element;

  Map<String, Stream> eventStreams = {};

  JsObject _js;
  JsObject get js => _js != null ? _js : new JsObject.fromBrowserObject(element);

  WebElement(String tag, [String typeExtension])
      : element = new Element.tag(tag, typeExtension);

  // See this issue for why this is needed:
  // https://github.com/dart-lang/sdk/issues/23661
  WebElement.extension(String tag, String typeExtension)
      : this(tag, typeExtension);

  WebElement.from(this.element);

  WebElement.$(String selectors) : element = querySelector(selectors);

  WebElement.fromJsObject(JsObject jsHTMLElement)
      : element = jsElementToDartElement(jsHTMLElement);

  /// Use WebElement.el as a shorthand for WebElement.element.
  HtmlElement get el => element;

  /// The HTMLElement.style property returns a CssStyleDeclaration object that
  /// represents the element's style attribute.
  CssStyleDeclaration get style => element.style;

  /// The offsetHeight read-only property is the height of the element including
  /// vertical padding and borders, in pixels, as an integer.
  int get offsetHeight => element.offsetHeight;

  /**
   * All text within this node and its decendents.
   *
   * ## Other resources
   *
   * * [Node.textContent]
   * (https://developer.mozilla.org/en-US/docs/Web/API/Node.textContent) from
   * MDN.
   */
  String get text => element.text;

  /**
   * All text within this node and its decendents.
   *
   * ## Other resources
   *
   * * [Node.textContent]
   * (https://developer.mozilla.org/en-US/docs/Web/API/Node.textContent) from
   * MDN.
   */
  set text(String value) => element.text = value;

  /// The id property represents the element's identifier, reflecting the id
  /// global attribute.
  ///
  /// It must be unique in a document, and is often used to retrieve the element.
  /// Other common usages of id include using the element's ID as a selector when
  /// styling the document with CSS.
  String get id => element.id;

  /// The id property represents the element's identifier, reflecting the id
  /// global attribute.
  ///
  /// It must be unique in a document, and is often used to retrieve the element.
  /// Other common usages of id include using the element's ID as a selector when
  /// styling the document with CSS.
  set id(String value) => element.id = value;

  /// The innerHTML property gets the HTML syntax describing the element's
  /// descendants.
  String get innerHtml => element.innerHtml;

  /// Use the native dom property,
  /// see https://github.com/dart-lang/sdk/issues/23666
  void set innerHtml(String html) {
    this["innerHTML"] = html;
  }

  void appendTo(HtmlElement parentElement) {
    parentElement.append(element);
  }

  dynamic property(String name) => js[name];

  dynamic setProperty(String name, dynamic value) => js[name] = value;


  dynamic operator [](String propertyName) {
    var property = js[propertyName];
    if (property is JsFunction) {
      dartify([arg0, arg1, arg2, arg3, arg4, arg5, arg6]) =>
      call(propertyName, [arg0, arg1, arg2, arg3, arg4, arg5, arg6]);
      return dartify;
    }
    return property;
  }
  void operator []=(String propertyName, dynamic value) {
    js[propertyName] = value;
  }

  dynamic call(String methodName, [List args]) =>
  js.callMethod(methodName, args);

  Stream on(String eventName, {Function converter, bool sync: false}) {
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

class PolymerElement extends WebElement with PolymerBase {

  PolymerElement(String tag, [typeExtension])
      : super.extension(tag, typeExtension);

  PolymerElement.tag(String tag) : super.extension(tag, null);

  PolymerElement.extension(String tag, String typeExtension)
      : super.extension(tag, typeExtension);

  PolymerElement.from(HtmlElement element) : super.from(element);

  PolymerElement.$(String selector) : super.$(selector);

  PolymerElement.fromConstructor(JsFunction constructor, [List args])
      : super.fromJsObject(new JsObject(constructor, args));


  dynamic operator [](String propertyName) {
    var property = js[propertyName];
    if (propertyName.contains(".")) {
      property = this.get(propertyName);
    }
    if (property is JsFunction) {
      dartify([arg0, arg1, arg2, arg3, arg4, arg5, arg6]) =>
      call(propertyName, [arg0, arg1, arg2, arg3, arg4, arg5, arg6]);
      return dartify;
    }
    return property;
  }

  void operator []=(String propertyName, dynamic value) {
    if(propertyName.contains(".")) {
      this.set(propertyName, value);
    } else {
      js[propertyName] = value;
    }
  }

  /// The user can directly modify a Polymer element's custom style property by
  /// setting key-value pairs in `customStyle` on the element and then calling
  /// `updateStyles.
  dynamic get customStyle => this["customStyle"];

  /// The user can directly modify a Polymer element's custom style property by
  /// setting key-value pairs in `customStyle` on the element and then calling
  /// `updateStyles.
  set customStyle(dynamic value) {
    if (value is Map) {
      this["customStyle"] = jsify(value);
    } else {
      this["customStyle"] = value;
    }
  }
}

abstract class PolymerBase {
  dynamic operator [](String propertyName);
  void operator []=(String propertyName, dynamic value);
  dynamic call(String methodName, [List args]);
  Stream on(String eventName, {Function converter, bool sync: false});

  /// Array of objects to extend this prototype with. Each entry in the array may specify either a behavior object or array of behaviors. Each behavior may define lifecycle callbacks, properties, hostAttributes, observers and listeners. Lifecycle callbacks will be called for each behavior in the order give in the behaviors array, followed by the callback on the prototype. Additionally, any non-lifecylce functions on the behavior object are mixed into the base prototype, such that same-named function on the prototype take precedence, followed by later behaviors over earlier behaviors.
  List get behaviors => this["behaviors"];

  /// Object containing entries specifying event listeners to create on each instance of this element, where keys specify the event name and values specify the name of the handler method to call on this prototype.
  Map get listeners => this["listeners"];

  /// Object containing property configuration data, where keys are property names and values are descriptor objects that configure Polymer features for the property.
  Map get properties => mapify(this["properties"]);

  /// Convenience method to run querySelector on this local DOM scope. This
  /// function calls Polymer.dom(this.root).querySelector(selector).
  HtmlElement $$(String selector) => call("\$\$", [selector]);

  /// Removes an item from an array, if it exists.
  ///
  /// [path] String or array. Path to array from which to remove the item
  /// (or the array itself).
  ///
  /// [item] Item to remove.
  ///
  /// @return Array containing item removed.
  List arrayDelete(dynamic path, dynamic item) =>
      call("arrayDelete", ([path, item]));

  /// Runs a callback function asyncronously.
  ///
  /// By default (if no waitTime is specified), async callbacks are run at
  /// microtask timing, which will occur before paint.
  ///
  /// [callback] The callback function to run, bound to this.
  /// [waitTime] Time to wait before calling the callback. If unspecified or 0,
  /// the callback will be run at microtask timing (before paint).
  /// Returns a number that may be used to cancel the async job.
  num async(Function callback, [int waitTime]) =>
      call("async", [callback, waitTime]);

  /// Polymer library implementation of the Custom Elements `attachedCallback`.
  ///
  /// Note users should not override `attachedCallback`, and instead should
  /// implement the `attached` method on Polymer elements to receive attached-time
  /// callbacks.
  void attachedCallBack() => call("attachedCallBack", []);

  /// Removes an HTML attribute from one node, and adds it to another.
  ///
  /// [name] HTML attribute name
  /// [toElement] New element to add the attribute to.
  /// [fromElement] Old element to remove the attribute from.
  void attributeFollows(
          String name, HtmlElement toElement, HtmlElement fromElement) =>
      call("attributeFollows", [name, toElement, fromElement]);

  /// Cancels an async operation started with async.
  void cancelAsync(num handle) => call("cancelAsync", [handle]);

  /// Cancels an active debouncer. The `callback` will not be called.
  ///
  /// [jobName] The name of the debouncer started with debounce
  void cancelDebouncer(String jobname) => call("cancelDebouncer", [jobname]);

  /// Removes a class from one node, and adds it another.
  ///
  /// [name] CSS class name
  /// [toElement] New element to add the class to.
  /// [fromElement] Old element to remove the class from.
  void classFollows(
          String name, HtmlElement toElement, HtmlElement fromElement) =>
      call("classFollows", [name, toElement, fromElement]);

  /// Convenience method for creating an element and configuring it.
  ///
  /// [tag] HTML element tag to create.<br>
  /// [props] Object of properties to configure on the instance.<br>
  /// @return The created and configured element.
  HtmlElement create(String tag, Map props) => call("create", [tag, props]);

  /// Call debounce to collapse multiple requests for a named task in to one invocation which is made after the wait time has elapsed with no new request. If no wait time is given, the callback will be called at microtask timing (guaranteed before paint).
  ///
  /// [jobName] String to indentify the debounce job.<br>
  /// [callback] Function that is called (with `this` context) when the wait time elapses.<br>
  /// [wait] Optional wait time in milliseconds (ms) after the last signal that must elapse before invoking `callback`.
  void debounce(jobName, callback, wait) =>
      call("debounce", [jobName, callback, wait]);

  /**
   * Converts a string to a typed value.
   *
   * This method is called by Polymer when reading HTML attribute values to JS properties. User may override this method on Polymer elements prototypes to provide deserialization for custom types. Note, the argument is the value of the [type] field provided in the `properties` configuration object for a given property, and is by convention the constructor for the type to deserialize.
   *
   * Note: The return value of `undefined` is used as a sentinel value to indicate the attribute should be removed.
   *
   * [value] Attribute value to deserialize.<br>
   * [type] Type to deserialize the string to.<br>
   */
  dynamic deserialize(String value, Type type) =>
      call("deserialize", [value, jsify(type)]);

  /// No documentation available.
  void distributeContent() => call("distributeContent", []);

  /// Return the element whose local dom within which this element is contained. This is a shorthand for `Polymer.dom(this).getOwnerRooat().host`.
  void domHost() => call("domHost", []);

  /// Polyfill for Element.prototype.matches, which is sometimes still prefixed.
  ///
  /// [selector] Selector to test.<br>
  /// [node] Element to test the selector against.<br>
  /// @return true if the element matches the selector.
  bool elementMatches(String selector, [HtmlElement node]) =>
      call("elementMatches", [selector, node]);

  /// Dispatches a custom event with an optional detail object.
  ///
  /// [type] Name of event type. <br>
  /// [detail] Detail object containing event-specific payload.<br>
  /// [object] Object specifying options. These may include `bubbles` (boolean),
  /// `cancelable` (boolean) and `node` on which to fire the event
  /// (HTMLElement,  defaults to `this`).<br>
  /// @return new event that was fired
  CustomEvent fire(String type, {Map detail, Map options}) =>
      call("fire", [type, jsify(detail), jsify(options)]);

  /// Immediately calls the debouncer `callback` and activates it.
  ///
  /// [jobName] The name of the debouncer started with `debounce`.
  void flushDebouncer(String jobName) => call("flushDebouncer", [jobName]);

  /// Convenience method for reading a value from a path.
  ///
  /// [path] {String|List<String|num>} Path to the value to read. The path may
  /// be specified as a string (e.g. `foo.bar.baz`) or an array of paths parts
  /// (e.g. `['foo.bar', 'baz']`). Note that that bracketed experssions are not supported; string-based path parts must be seperated by dots. Note that when dereferencing array indices, the index may be used as a dotted part directly (e.g. `user.12.name` or `['users', 12, 'name']`). <br>
  /// [root] Root object from which the path is evaluated.<br>
  /// @return at the path, or `undefined` if any part of the path is undefined
  dynamic get(dynamic path, [root]) => call("get", [path, root]);

  /// Returns a list of nodes distributed to this element's `<content>`.
  ///
  /// If this element contains more than one `<content>` in it's local DOM, an optional selector may be passed to choose the desired content
  List<Node> getContentChildNodes([String selector]) =>
      call("getContentChildNodes", [selector]);

  /// Returns a list of elements children distributed to this element's `<content>`.
  List<HtmlElement> getContentChildren([String selector]) =>
      call("getContentChildren", [selector]);

  /// Returns the native element prototype for the tag specified.
  ///
  /// [tag] HTML tag name<br>
  /// @return prototype for the specified tag
  JsObject getNativePrototype(tag) => call("getNativePrototype", [tag]);

  /// Returns a property descriptor object for the property specified.
  ///
  /// This method allows introspecting the configuration of a Polymer element's
  /// properties as configured in its `properties` object. Note, the method
  /// normalizes shorthand forms of the properties object into longhand form.
  ///
  /// [property] Name of property to introspect.
  JsObject getPropertyInfo(String property) =>
      call("getPropertyInfo", [property]);

  /// Convenience method for importing an HTML document imperatively.
  ///
  /// This method creates a new `<link rel="import">` element with the provided
  /// URL and appends it to the document to start loading. In the `onload`
  /// callback, the `import` property of the `link` element will contain the
  /// imported document contents.
  ///
  /// [href] URL of document to load.<br>
  /// [onload] Callback notify when an import successfully loaded.<br>
  /// [onerror] Callback to notify when an import unseccesfully loaded.<br>
  /// @return link element for the URL to be loaded.
  LinkElement importHref(String href, Function onLoad, Function onError) =>
      call("importHref", [href, onLoad, onError]);

  /// Calls `importNode` on the `content` of the `template` specified and
  /// returns a document fragment containing the imported content.
  ///
  /// [template] HTML template element to instance.<br>
  /// @return fragment containing the imported template content.
  DocumentFragment instanceTemplate(template) =>
      call("instanceTemplate", [template]);

  /// Returns whether a named debouncer is active.
  ///
  /// [jobName] The name of the debouncer started with debounce.<br>
  /// @return the debouncer is active (has not yet fired)
  bool isDebouncerActive(String jobName) =>
      call("isDebouncerActive", [jobName]);

  /// Aliases one data path as another, such that path notifications from one are routed to the other.
  ///
  /// [to] Target path to link.<br>
  /// [from] Source path to link.<br>
  void linkPaths(String to, String from) => call("linkPaths", [to, from]);

  /// Convenience method to add an event listener on a given element, late bound to a named method on this element.
  ///
  /// [node] Element to add event listener to.
  /// [eventName] Name of even to listen for.
  /// [methodName] Name of handler method on this to call.
  void listen(HtmlElement node, String eventName, String methodName) =>
      call("listen", [node, eventName, methodName]);

  /// Copes props from a source object to target a target object.
  void mixin(JsObject target, JsObject source) =>
      call("mixin", [target, source]);

  /// Notify that a path has changed.
  ///
  /// Returns true if notification actually took place, based on a dirty check
  /// of whether the new value was already known.
  bool notifyPath(path, value, fromAbove) =>
      call("notifyPath", [path, value, fromAbove]);

  /// Removes an item from the end of array at the path specified.
  ///
  /// The arguments after `path` and return value match that of `Array.prototype.pop`.
  ///
  /// This method notifies other paths to the same array that a splice occured
  /// at the array.
  ///
  /// [path] Path to array.<br>
  /// @return Returns the item that was removed.
  dynamic pop(String path) => call("pop", [path]);

  /// Lifecylce callback invoked when all local DOM children of this element have been created and "configured" with data ound from this element, attribute values or defaults.
  void ready() => call("ready", []);

  /// Serializes a property to its associated attribute.
  ///
  /// Generally users should set `reflectAttribute: true` in the properties configuration to achieve automatic attribute reflection.
  void reflectPropertyToAttribute(name) =>
      call("reflectPropertyToAttribute", [name]);

  /// Rewrites a given URL relative to the original location of the document containing the `dom-module` for this element. This method will return the same URL before and after vulcanization.
  ///
  /// [url] URL to resolve
  ///
  /// @return URL relative to the import
  String resolveUrl(url) => call("resolveUrl", [url]);

  /// Apply style scoping to the specified `container` and all its descendants.
  /// If [shouldObserve] is true, changes to the container are monitored via
  /// mutation observer and scoping is applied.
  ///
  /// [container] Element to scope.
  ///
  /// [shouldObserve] When true, monitors the container for changes and re-applies
  /// scoping for any future changes.
  void scopeSubtree(container, shouldObserve) =>
      call("scopeSubtree", [container, shouldObserve]);

  /// Convienence method for setting a value to a path and notifying any elements
  /// bound to the same path.
  ///
  /// Note, if any part in the path except for the last is undefined, this method
  /// does nothing (this method does not throw when dereferencing undefined paths).
  void set(String path, dynamic value, [root]) => call("set", [path, value, root]);

  /// Toggles a CSS class on or off.
  void toggleClass(String name, [bool boolean, HtmlElement node]) =>
      call("toggleClass", [name, boolean, node]);

  /// Re-evaluates and applies custom CSS properties based on dynamic changes to this element's scope, such as adding or removing classes in this element's local DOM.
  void updateStyles() => call("updateStyles");
}

/// `iron-pages` is used to select one of its children to show. One use is to
/// cycle through a list of children "pages".
class IronPages extends PolymerElement
    with IronSelectableBehavior, IronResizableBehavior {
  IronPages() : super.tag("iron-pages");
  IronPages.from(HtmlElement element) : super.from(element);
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
class PaperMenu extends PolymerElement
    with IronMenuBehavior, IronMultiSelectableBehavior, IronSelectableBehavior, IronA11yKeysBehavior {
  PaperMenu() : super.tag("paper-menu");
  PaperMenu.from(HtmlElement element) : super.from(element);
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
class PaperItem extends PolymerElement {
  PaperItem() : super.tag("paper-item");
  PaperItem.from(HtmlElement element) : super.from(element);
  PaperItem.$(String selector) : super.$(selector);
}

class PaperButton extends PolymerElement
    with IronButtonState, IronControlState, IronA11yKeysBehavior {
  PaperButton() : super.tag("paper-button");
  PaperButton.from(HtmlElement element) : super.from(element);
  PaperButton.$(String selector) : super.$(selector);

  /// If true, the button should be styled with a shadow.
  bool get raised => this["raised"];

  /// If true, the button should be styled with a shadow.
  set raised(bool value) => this["raised"] = value;
}
