import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:isearchbar/isearchbar.dart';

void main() {
  const MethodChannel channel = MethodChannel('isearchbar');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await Isearchbar.platformVersion, '42');
  });
}
