import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task('Install and update bower')
bower() {
  run('bower', arguments: ['install']);
  run('bower', arguments: ['update']);
}

@DefaultTask("Test")
@Depends("bower")
test() => new TestRunner().test(
    files: "test/polymer.dart",
    platformSelector: ["chrome"]);