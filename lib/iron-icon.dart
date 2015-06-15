import 'package:polymerjs/polymer.dart';
import 'dart:html';


class IronIcon extends PolymerElement {

  IronIcon() : super("iron-icon");
  IronIcon.from(HtmlElement element) : super.from(element);
  IronIcon.fromSelector(String selector) : super.fromSelector(selector);
  IronIcon.$(String selector) : super.$(selector);

  /// The name of the icon to use. The name should be of the form:
  /// `iconset_name:icon_name`.
  String get icon => this["icon"];

  /// The name of the icon to use. The name should be of the form:
  /// `iconset_name:icon_name`.
  set icon(String value) => this["icon"] = value;

  /// The name of the theme to use, if one is specified by the iconset.
  String get theme => this["theme"];

  /// The name of the theme to use, if one is specified by the iconset.
  set theme(String value) => this["theme"] = value;

  /// When using iron-icon without an iconset, you can set the src to be the
  /// URL of an individual icon image file. Note that this will take precedence
  /// over a given icon attribute.
  String get src => this["src"];

  /// When using iron-icon without an iconset, you can set the src to be the
  /// URL of an individual icon image file. Note that this will take precedence
  /// over a given icon attribute.
  set src(String value) => this["src"] = value;

}