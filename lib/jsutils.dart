library jsutils;

import 'dart:js';
import 'dart:convert';
import 'package:polymerjs/polymer.dart';


final JsObject _jsJSON = context['JSON'];
final JsObject _Object = context['Object'];

/**
 * Convert a Dart object to a suitable parameter to a JavaScript method.
 */
dynamic jsify(Object dartObject) {
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
    return new JsFunction.withThis((HtmlElement element,
                                    [arg0, arg1, arg2, arg3, arg4, arg5, arg6]) {
//      if (typeConstructor == null) {
//        typeConstructor = (element) => new PolymerElement.from(element);
//      }
//      var polymerElement = new PolymerElement.from(element);
      List args = [element, arg0, arg1, arg2, arg3, arg4, arg5, arg6];
      args.removeWhere((e) => e == null);
      args = args.map(dartify).toList();
      while (argCount(dartObject) < args.length) {
        args.removeLast();
      }
      while (argCount(dartObject) > args.length) {
        args.add(null);
      }
      return Function.apply(dartObject, args);
    });
  }
  return dartObject;
}

int argCount(Function f) {
  if (f is Func0) return 0;
  if (f is Func1) return 1;
  if (f is Func2) return 2;
  if (f is Func3) return 3;
  if (f is Func4) return 4;
  if (f is Func5) return 5;
  if (f is Func6) return 6;
  if (f is Func7) return 7;
  throw 'not supported for more that 7 args';
}
typedef Func0();
typedef Func1(p1);
typedef Func2(p1,p2);
typedef Func3(p1,p2,p3);
typedef Func4(p1,p2,p3,p4);
typedef Func5(p1,p2,p3,p4,p5);
typedef Func6(p1,p2,p3,p4,p6);
typedef Func7(p1,p2,p3,p4,p6,p7);


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


Object dartify(dynamic js) {

  if (js is HtmlElement) {
    return new PolymerElement.from(js);
  } else if (js is CustomEvent){
    if (js.type == "track") {
      return new TrackDetail(new JsObject.fromBrowserObject(js)["detail"], js);
    }
    if (js.type == "tap") {
      return new TapDetail(new JsObject.fromBrowserObject(js)["detail"], js);
    }
    if (js.type == 'down') {
      return new DownDetail(new JsObject.fromBrowserObject(js)["detail"], js);
    }
    if (js.type == 'up') {
      return new UpDetail(new JsObject.fromBrowserObject(js)["detail"], js);
    }
    return js;
  } else if (!(js is JsObject)) {
    return js;
  } else if (js is JsFunction) {
    return ([arg0, arg1, arg2, arg3, arg4, arg5, arg6]) =>
    js.apply([arg0, arg1, arg2, arg3, arg4, arg5, arg6]);
  } else if (js["sourceEvent"] != null){
    return null;
  } else if (js["constructor"] == context["Object"]) {
    return mapify(js);
  }
  return js;
}

/**
 * Convert a JavaScript result object to an equivalent Dart map.
 */
Map mapify(JsObject obj) {
  if (obj == null) return null;
  return JSON.decode(_jsJSON.callMethod('stringify', [obj]));
}

JsObject jsType(Type type) {
  switch ('$type') {
    case 'int':
    case 'double':
    case 'num':
      return context['Number'];
    case 'bool':
      return context['Boolean'];
    case 'List':
      return context['Array'];
    case 'DateTime':
      return context['DateTime'];
    case 'String':
      return context['String'];
    case 'Map':
    case 'JsObject':
    default:
      return context['Object'];
  }
}

dynamic jsElementToDartElement(jsHTMLElement) {
  context['hack_to_convert_jsobject_to_html_element'] = jsHTMLElement;
  Element element = context['hack_to_convert_jsobject_to_html_element'];
  context.deleteProperty('hack_to_convert_jsobject_to_html_element');
  return element;
}

/// This event fires when moving while finger/button is down.
class TrackDetail extends Detail {

  TrackDetail(JsObject js, CustomEvent event) : super(js, event),
  state = js['state'],
  x = js['x'],
  y = js['y'],
  dx = js['dx'],
  dy = js['dy'],
  ddx = js['ddx'],
  ddy = js['ddy'],
  sourceEvent = js['sourceEvent'];

  /// A string indicating the tracking state. The possible values are:
  ///
  /// start - fired when tracking is first detected (finger/button down and
  /// moved past a pre-set distance threshold)
  ///
  /// track - fired while tracking
  ///
  /// end - fired when tracking ends
  final String state;

  /// clientX coordinate for event
  final int x;

  /// clientY coordinate for event
  final int y;

  /// change in pixels horizontally since the first track event
  final int dx;

  /// change in pixels vertically since the first track event
  final int dy;

  /// change in pixels horizontally since last track event
  final int ddx;

  /// change in pixels vertically since last track event
  final int ddy;

  /// the original DOM event that caused the track action
  final Event sourceEvent;

  /// a method that may be called to determine the element currently being hovered
  Element hover() => _js.callMethod("hover");
}

/// This event fires when finger/button went down.
class DownDetail extends Detail {
  DownDetail(JsObject js, CustomEvent event) : super(js, event),
  x = js['x'],
  y = js['y'],
  sourceEvent = js['sourceEvent'];

  /// clientX coordinate for event
  final int x;

  /// clientY coordinate for event
  final int y;

  /// the original DOM event that caused the down action
  final Event sourceEvent;
}

/// This event fires when finger/button went up.
class UpDetail extends Detail {
  UpDetail(JsObject js, CustomEvent event) : super(js, event),
  x = js['x'],
  y = js['y'],
  sourceEvent = js['sourceEvent'];

  /// clientX coordinate for event
  final int x;

  /// clientY coordinate for event
  final int y;

  /// the original DOM event that caused the up action
  final Event sourceEvent;
}

/// This event fires when finger/button went up and down.
class TapDetail extends Detail {
  TapDetail(JsObject js, CustomEvent event) : super(js, event),
  x = js['x'],
  y = js['y'],
  sourceEvent = js['sourceEvent'];

  /// clientX coordinate for event
  final int x;

  /// clientY coordinate for event
  final int y;

  /// the original DOM event that caused the tap action
  final Event sourceEvent;
}

class Detail {
  final CustomEvent customEvent;

  final JsObject _js;

  Detail(this._js, this.customEvent);

  dynamic operator [](String propertyName) {
    var property = _js[propertyName];
    if (property is JsFunction) {
      return([arg0, arg1, arg2, arg3, arg4, arg5, arg6]) =>
      _js.callMethod(propertyName, [arg0, arg1, arg2, arg3, arg4, arg5, arg6]);
    }
    return property;
  }
}
