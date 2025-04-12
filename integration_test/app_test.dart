import 'package:integration_test/integration_test.dart';

import 'app_test/kagi_news_page_test.dart' as kagi_news_test;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  kagi_news_test.main();
}