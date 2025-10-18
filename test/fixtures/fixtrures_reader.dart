import 'dart:io';

String fixturesPath(String name) => 'test/fixtures/$name';

String fixture(String name) => File(fixturesPath(name)).readAsStringSync();
