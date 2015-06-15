import 'package:grinder/grinder.dart';

const dartium = "dartium";
const chrome = "chrome";
const firefox = "firefox";
const safari = "safari";

const all = const ['dartium,firefox,chrome,safari'];
const base = "test/base.dart";
const polymer = "test/polymer.dart";
const iron_collapse = "test/iron-collapse.dart";
const iron_autogrow_textarea = "test/iron-autogrow-textarea.dart";
const custom_element = "test/custom_element/index_test.dart";

const allFiles = const [
  base,
  polymer,
  iron_collapse,
  iron_autogrow_textarea,
  custom_element
];

main(args) => grind(args);

@Task('Install and update bower')
bower() {
  run('bower', arguments: ['install']);
//  run('bower', arguments: ['update']);
}

@DefaultTask("Test all browsers.")
@Depends("bower")
testAll() => new TestRunner().test(
    files: allFiles,
    platformSelector: all,
    pubServe: 8081);

@Task("Custom test")
test() => new TestRunner().test(
    files: [
      base,
      polymer,
      iron_collapse,
      iron_autogrow_textarea,
      custom_element
    ],
    platformSelector: all,
    pubServe: 8081);

@Task("Pub serve")
serve() {
  run("pub", arguments: ["serve"]);
}