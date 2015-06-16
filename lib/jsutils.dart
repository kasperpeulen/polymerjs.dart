library jsutils;

import 'dart:js';
import 'dart:convert';


final JsObject _jsJSON = context['JSON'];
final JsObject _Object = context['Object'];

/**
 * Convert a Dart object to a suitable parameter to a JavaScript method.
 */
JsObject jsify(Object object) {
  if (object == null) return null;
  if (object is Type) {
    return jsType(object);
  }
  return new JsObject.jsify(object);
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

