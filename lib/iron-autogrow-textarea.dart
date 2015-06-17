import 'dart:html';
import 'dart:async';

import 'package:polymerjs/polymer.dart';


/// `iron-autogrow-textarea` is an element containing a textarea that grows in
/// height as more lines of input are entered. Unless an explicit height or the
/// `maxRows` property is set, it will never scroll.
///
/// Example:
///
///     <iron-autogrow-textarea id="a1">
///       <textarea id="t1"></textarea>
///     </iron-autogrow-textarea>
///
/// Because the `textarea`'s `value` property is not observable, you should use
/// this element's `bind-value` instead for imperative updates.
///
/// @group Iron Elements
/// @hero hero.svg
/// @demo demo/index.html
class IronAutogrowTextarea extends PolymerElement with IronValidatableBehavior {

  IronAutogrowTextarea() : super.tag("iron-autogrow-textarea");
  IronAutogrowTextarea.from(HtmlElement element) : super.from(element);
  IronAutogrowTextarea.$(String selector) : super.$(selector);

  /// Use this property instead of `value` for two-way data binding.
  String get bindValue => this["bindValue"];

  /// Use this property instead of `value` for two-way data binding.
  set bindValue(String value) => this["bindValue"] = value;

  /// The initial number of rows.
  /// @default 1
  int get rows => this["rows"];

  /// The initial number of rows.
  /// @default 1
  set rows(int value) => this["rows"] = value;

  /// The maximum number of rows this element can grow to until it scrolls.
  /// 0 means no maximum.
  ///
  /// @default 0
  int get maxRows => this["maxRows"];

  /// The maximum number of rows this element can grow to until it scrolls.
  /// 0 means no maximum.
  ///
  /// @default 0
  set maxRows(int value) => this["maxRows"] = value;

  /// Bound to the textarea's `autocomplete` attribute.
  ///
  /// @default 'off'
  String get autocomplete => this["autocomplete"];

  /// Bound to the textarea's `autocomplete` attribute.
  ///
  /// @default 'off'
  set autocomplete(String value) => this["autocomplete"] = value;

  /// Bound to the textarea's `autofocus` attribute.
  ///
  /// @default 'off'
  String get autofocus => this["autofocus"];

  /// Bound to the textarea's `autofocus` attribute.
  ///
  /// @default 'off'
  set autofocus(String value) => this["autofocus"] = value;

  /// Bound to the textarea's `inputmode` attribute.
  String get inputmode => this["inputmode"];

  /// Bound to the textarea's `inputmode` attribute.
  set inputmode(String value) => this["inputmode"] = value;

  /// Bound to the textarea's `name` attribute.
  String get name => this["name"];

  /// Bound to the textarea's `name` attribute.
  set name(String value) => this["name"] = value;

  /// Bound to the textarea's `placeholder` attribute.
  String get placeholder => this["placeholder"];

  /// Bound to the textarea's `placeholder` attribute.
  set placeholder(String value) => this["placeholder"] = value;

  /// Bound to the textarea's `readonly` attribute.
  String get readonly => this["readonly"];

  /// Bound to the textarea's `readonly` attribute.
  set readonly(String value) => this["readonly"] = value;

  /// Set to true to mark the textarea as required.
  bool get required => this["required"];

  /// Set to true to mark the textarea as required.
  set required(bool value) => this["required"] = value;

  /// The maximum length of the input value.
  num get maxlength => this["maxlength"];

  /// The maximum length of the input value.
  set maxlength(num value) => this["maxlength"] = value;

  /// Returns the underlying textarea.
  TextAreaElement get textarea => this["textarea"];
}

/**
 * Use `Polymer.IronValidatableBehavior` to implement an element that validates user input.
 *
 * ### Accessiblity
 *
 * Changing the `invalid` property, either manually or by calling `validate()` will update the
 * `aria-invalid` attribute.
 *
 * @demo demo/index.html
 * @polymerBehavior
 */
abstract class IronValidatableBehavior {

  dynamic operator [](String propertyName);
  void operator []=(String propertyName, dynamic value);
  dynamic call(String methodName, [List args]);
  Stream on(String eventName, {Function converter, bool sync: false});

  /**
   * Namespace for this validator.
   * @default 'validator'
   */
  String get validatorType => this["validatorType"];

  /**
   * Namespace for this validator.
   * @default 'validator'
   */
  set validatorType(String value) => this["validatorType"] = value;

  /// Name of the validator to use
  String get validator => this["validator"];

  /// Name of the validator to use
  set validator(String value) => this["validator"] = value;

  /// True if the last call to `validate` is invalid.
  /// @notify
  /// @reflectToAttribute
  /// @default false
  bool get invalid => this["invalid"];

  /// True if the last call to `validate` is invalid.
  /// @notify
  /// @reflectToAttribute
  /// @default false
  set invalid(bool value) => this["invalid"] = value;
}

