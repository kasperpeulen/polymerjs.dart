import "package:polymerjs/polymer.dart";

@initMethod
main() {
  var CustomConstructor = polymer({
    "is": "custom-constructor",
    "factoryImpl" : (self, List args) {
      self["foo"] = args[0];
      self["bar"] = args[1];
    }
  });

  new PolymerElement.fromConstructor(CustomConstructor, [42, 'octopus'])
    ..appendTo(document.body);
}