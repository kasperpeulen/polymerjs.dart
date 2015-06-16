import 'dart:js';
import 'dart:html';
import 'package:polymerjs/polymer.dart' show PolymerElement;

export 'package:initialize/initialize.dart';
export 'package:web_components/src/init.dart';


void polymer(Map constructor) {
  context["Polymer"].apply([jsify(constructor)]);
}

JsObject jsify(Object dartObject) {
  if (dartObject == null) {
    return null;
  } else if (dartObject is JsObject) {
    return dartObject;
  } else if (dartObject is List) {
    return new JsArray.from(dartObject.map((item) => jsify(item)));
  } else if (dartObject is Map<String, dynamic>) {
    JsObject jsObject = new JsObject(context["Object"]);
    dartObject.forEach((key, value) {
      jsObject[key] = jsify(value);
    });
    return jsObject;
  } else if (dartObject is Type) {
    return dartType2Js[dartObject];
  } else if (dartObject is Function) {
    return new JsFunction.withThis((HtmlElement element) {
      dartObject(new PolymerElement.from(element));
    });
  }
  return dartObject;
}

Map<Type, JsFunction> dartType2Js = {
  int : context['Number'],
  double : context['Number'],
  num : context['Number'],
  bool : context["Boolean"],
  String : context["String"],
  List : context["Array"],
  DateTime : context["DateTime"],
  Map : context["Object"],
  JsObject : context["Object"],
  Function : context["JsFunction"]
};