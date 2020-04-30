import 'dart:io';

String mockedResponse(String name) =>
    File('test/mockassets/$name').readAsStringSync();
