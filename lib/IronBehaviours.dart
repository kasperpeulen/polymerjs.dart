import 'dart:html';
import 'dart:js';
import 'dart:async';

abstract class IronSelectableBehavior {
  dynamic operator [](String propertyName);
  void operator []=(String propertyName, dynamic value);
  dynamic call(String methodName, [List args]);
  Stream listen(String eventName, {Function converter, bool sync: false});

  /// The event that fires from items when they are selected. Selectable will
  /// listen for this event from items and update the selection state. Set to
  /// empty string to listen to no events.
  String get activateEvent => this["activateEvent"];

  /// The event that fires from items when they are selected. Selectable will
  /// listen for this event from items and update the selection state. Set to
  /// empty string to listen to no events.
  set activateEvent(String value) => this["activateEvent"] = value;

  /// If you want to use the attribute value of an element for selected instead
  /// of the index, set this to the name of the attribute.
  String get attrForSelected => this["attrForSelected"];

  /// If you want to use the attribute value of an element for selected instead
  /// of the index, set this to the name of the attribute.
  set attrForSelected(String value) => this["attrForSelected"] = value;

  /// This is a CSS selector sting. If this is set, only items that matches the
  /// CSS selector are selectable.
  String get selectable => this["selectable"];

  /// This is a CSS selector sting. If this is set, only items that matches the
  /// CSS selector are selectable.
  set selectable(String value) => this["selectable"] = value;

  /// Gets or sets the selected element. The default is to use the index of the item.
  /// @notify
  int get selected => int.parse("${this["selected"]}");

  /// Gets or sets the selected element. The default is to use the index of the item.
  /// @notify
  set selected(int value) => this["selected"] = value;

  /// The attribute to set on elements when selected.
  String get selectedAttribute => this["selectedAttribute"];
  /// The attribute to set on elements when selected.
  set selectedAttribute(String value) => this["selectedAttribute"] = value;

  /// The class to set on elements when selected. default: iron-selected
  String get selectedClass => this["selectedClass"];

  /// The class to set on elements when selected. default: iron-selected
  set selectedClass(String value) => this["selectedClass"] = value;

  /// Returns the currently selected item. @readonly @notify
  HtmlElement get selectedItem => this["selectedItem"];

  /// Returns the currently selected item. @readonly @notify
  set selectedItem(HtmlElement value) => this["selectedItem"] = value;

  /// Returns the index of the given item.
  int indexOf(HtmlElement item) => call("indexOf", [item]);

  /// Returns an array of selectable items.
  List get items => this["items"];

  /// Selects the given value.
  void select(int value) => call("select", [value]);

  /// Select the next item.
  void selectNext() => call("selectNext");

  /// Select the previous item.
  void selectPrevious() => call("selectPrevious");

  Stream get onIronActivate => listen("iron-activate");

  Stream get onIronSelect => listen("iron-select");

  Stream get onIronDeSelect => listen("iron-deselect");

}

/// see [elements.polymer-project.org](https://elements.polymer-project.org/elements/iron-selector?active=Polymer.IronMultiSelectableBehavior)
abstract class IronMultiSelectableBehavior {
  dynamic operator [](String propertyName);
  void operator []=(String propertyName, dynamic value);
  dynamic call(String methodName, [List args]);

  /// If true, multiple selections are allowed.
  bool get multi => this["multi"];

  /// If true, multiple selections are allowed.
  set multi(bool value) => this["multi"] = value;

  /// Returns an array of currently selected items.
  /// @readonly
  /// @notify
  List get selectedItems => this["selectedItems"];

  /// Gets or sets the selected elements. This is used instead of selected when
  /// multi is true.
  /// @notify
  List get selectedValues => this["selectedValues"];

  /// Gets or sets the selected elements. This is used instead of
  /// selected when multi is true.
  /// @notify
  set selectedValues(List value) => this["selectedValues"] = value;

  /// default: ''
  dynamic multiChanged(multi) => call("mutliChanged", [multi]);

  /// Selects the given value. If the multi property is true, then the selected
  /// state of the value will be toggled; otherwise the value will be selected.
  void select(int value) => call("select", [value]);
}

/// IronResizableBehavior is a behavior that can be used in Polymer elements to
/// coordinate the flow of resize events between "resizers" (elements that control
/// the size or hidden state of their children) and "resizables" (elements that
/// need to be notified when they are resized or un-hidden by their parents in
/// order to take action on their new measurements). Elements that perform measurement
/// should add the IronResizableBehavior behavior to their element definition and
/// listen for the iron-resize event on themselves. This event will be fired when
/// they become showing after having been hidden, when they are resized explicitly
/// by another resizable, or when the window has been resized. Note, the iron-resize
/// event is non-bubbling.
abstract class IronResizableBehavior {
  dynamic operator [](String propertyName);
  void operator []=(String propertyName, dynamic value);
  dynamic call(String methodName, [List args]);
  Stream listen(String eventName, {Function converter, bool sync: false});

  /// Used to assign the closest resizable ancestor to this resizable if the
  /// ancestor detects a request for notifications.
  void assignParentResizable(parentResizable) =>
  call("assignParentResizable", [parentResizable]);

  /// Can be called to manually notify a resizable and its descendant resizables
  /// of a resize change.
  void notifyResize() => call("notifyResize", []);

  /// Used to remove a resizable descendant from the list of descendants that
  /// should be notified of a resize change.
  void stopResizeNotificationsFor(dynamic target) =>
  call("stopResizeNotificationsFor", [target]);

  /// This event will be fired when the element becomes showing after having been hidden, when the element is resized explicitly by another resizable, or when the window has been resized. Note, the iron-resize event is non-bubbling.
  Stream get ironResize => listen("iron-resize");
}

/// Polymer.IronMenuBehavior implements accessible menu behavior.
abstract class IronMenuBehavior {
  dynamic operator [](String propertyName);
  void operator []=(String propertyName, dynamic value);
  dynamic call(String methodName, [List args]);

  /// The attribute to use on menu items to look up the item title. Typing the
  /// first letter of an item when the menu is open focuses that item. If unset,
  /// textContent will be used.
  String get attrForItemTitle => this["attrForItemTitle"];

  /// The attribute to use on menu items to look up the item title. Typing the
  /// first letter of an item when the menu is open focuses that item. If unset,
  /// textContent will be used.
  set attrForItemTitle(String value) => this["attrForItemTitle"] = value;

  /// Returns the currently focused item.
  /// @readOnly
  HtmlElement get focusedItem => this["focusedItem"];

  /// default = {
  /// 'up': '_onUpKey',
  /// 'down': '_onDownKey',
  /// 'esc': '_onEscKey',
  /// 'enter': '_onEnterKey',
  /// 'shift+tab:keydown': '_onShiftTabDown'
  /// }
  Map get keyBindings => mapify(this["keyBindings"]);

  /// default = {
  /// 'up': '_onUpKey',
  /// 'down': '_onDownKey',
  /// 'esc': '_onEscKey',
  /// 'enter': '_onEnterKey',
  /// 'shift+tab:keydown': '_onShiftTabDown'
  /// }
  set keyBindings(Map value) => this["keyBindings"] = new JsObject.jsify(value);

  /// default: ''
  void select(dynamic value) => call("select", [value]);
}

/**
 * `Polymer.IronA11yKeysBehavior` provides a normalized interface for processing
 * keyboard commands that pertain to [WAI-ARIA best practices](http://www.w3.org/TR/wai-aria-practices/#kbd_general_binding).
 * The element takes care of browser differences with respect to Keyboard events
 * and uses an expressive syntax to filter key presses.
 *
 * Use the `keyBindings` prototype property to express what combination of keys
 * will trigger the event to fire.
 *
 * Use the `key-event-target` attribute to set up event handlers on a specific
 * node.
 * The `keys-pressed` event will fire when one of the key combinations set with the
 * `keys` property is pressed.
 *
 * @polymerBehavior IronA11yKeysBehavior
 */
abstract class IronA11yKeysBehavior {
  dynamic operator [](String propertyName);
  void operator []=(String propertyName, dynamic value);
  dynamic call(String methodName, [List args]);
  Stream listen(String eventName, {Function converter, bool sync: false});

  /// The HTMLElement that will be firing relevant KeyboardEvents.
  /// Default: this
  HtmlElement get keyEventTarget => this["keyEventTarget"];

  /// The HTMLElement that will be firing relevant KeyboardEvents.
  /// Default: this
  set keyEventTarget(HtmlElement value) => this["keyEventTarget"] = value;

  /// Can be used to imperatively add a key binding to the implementing element. This is the imperative equivalent of declaring a keybinding in the `keyBindings` prototype property.
  void addOwnKeyBinding(String eventString, String handlerName) =>
  call("addOwnKeyBinding", [eventString, handlerName]);

  /// When called, will remove all imperatively-added key bindings.
  void removeOwnKeyBindings() => call("removeOwnKeyBindings");

  /// The `keys-pressed` event will fire when one of the key combinations set
  /// with the `keys` property is pressed. **Doesn't seem to be implemented.**
  Stream get keysPressed => listen("keys-pressed");
}
