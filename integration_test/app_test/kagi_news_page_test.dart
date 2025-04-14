import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository.dart';
import 'package:kagi_news/data/datasource/repository/result.dart';
import 'package:kagi_news/di/injector.dart';
import 'package:kagi_news/ui/controller/kagi_news_controller.dart';
import 'package:kagi_news/ui/screens/kagi_news_page.dart';
import 'package:mockito/mockito.dart';

import '../../test/mocks/mock_injector.dart';
import '../../test/mocks/repository_mocks.mocks.dart';
import 'news_category_details_test_data_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockKagiNewsRepository mockRepository;
  late KagiNewsController controller;

  void setupMockResponses() {
    when(mockRepository.getCategories()).thenAnswer(
      (_) async => Result.success(
        KagiNewsCategoriesResponse(
          categories: [
            NewsCategory(name: 'On This Day', file: 'onthisday.json'),
            NewsCategory(name: 'Technology', file: 'tech.json'),
            NewsCategory(name: 'Business', file: 'business.json'),
          ],
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
    when(mockRepository.sync()).thenAnswer(
      (_) async => Result.success(true),
    );
    when(mockRepository.getCategoryDetails('tech.json')).thenAnswer(
      (_) async => Result.success(
        NewsCategoryDetailsTestDataClient.getTechNewsCategoryDetailsResponse(),
      ),
    );
    when(mockRepository.getCategoryDetails('business.json')).thenAnswer(
      (_) async => Result.success(
        NewsCategoryDetailsTestDataClient
            .getBusinessNewsCategoryDetailsResponse(),
      ),
    );
    when(mockRepository.getCategoryDetails('onthisday.json')).thenAnswer(
      (_) async => Result.success(
        NewsCategoryDetailsResponse(
          category: null,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          read: null,
          clusters: [],
          onThisDayItems: [
            OnThisDayItem(
              year: '1969',
              htmlContent: 'Apollo 11 landed on the moon',
              sortYear: 1969.0,
              type: 'event',
            ),
            OnThisDayItem(
              year: '2000',
              htmlContent: 'Y2K transition occurred without major issues',
              sortYear: 2000.0,
              type: 'event',
            ),
          ],
        ),
      ),
    );
    when(mockRepository.getCategoryDetails('empty.json')).thenAnswer(
      (_) async => Result.success(
        NewsCategoryDetailsResponse(
          category: 'Empty',
          timestamp: DateTime.now().millisecondsSinceEpoch,
          read: 0,
          clusters: null,
          onThisDayItems: null,
        ),
      ),
    );
  }

  Widget buildTestApp() {
    return MaterialApp(
      home: KagiNewsPage(controller: controller),
    );
  }

  setUp(() {
    MockInjector.setup();

    mockRepository = Injector.container.resolve<KagiNewsRepository>()
        as MockKagiNewsRepository;

    setupMockResponses();

    controller = Injector.container.resolve<KagiNewsController>();
  });

  group('Full App Flow Integration Tests', () {
    testWidgets(
        'Loads and displays categories, content, and supports navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());

      controller.fetchCategories();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text('On This Day'), findsOneWidget);
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Business'), findsOneWidget);

      // Default behavior: the first (On This Day) tab should be selected.
      expect(find.text('On This Day in History'), findsOneWidget);
      expect(find.text('1969'), findsOneWidget);
      expect(find.text('2000'), findsOneWidget);

      // Navigate to Technology Tab and verify content
      await tester.tap(find.text('Technology'));
      await tester.pumpAndSettle();

      final techDetails = NewsCategoryDetailsTestDataClient
          .getTechNewsCategoryDetailsResponse();
      if (techDetails.clusters != null && techDetails.clusters!.isNotEmpty) {
        // If there are clusters, scroll to find the title of the first tech article.
        await tester.scrollUntilVisible(
          find.text(techDetails.clusters![0].title),
          10.0,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(techDetails.clusters![0].title), findsOneWidget);
      }

      // Navigate to Business Tab and verify content
      await tester.tap(find.text('Business'));
      await tester.pumpAndSettle();

      final businessDetails = NewsCategoryDetailsTestDataClient
          .getBusinessNewsCategoryDetailsResponse();
      if (businessDetails.clusters != null &&
          businessDetails.clusters!.isNotEmpty) {
        await tester.scrollUntilVisible(
          find.text(businessDetails.clusters![0].title),
          10.0,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text(businessDetails.clusters![0].title), findsOneWidget);
      }

      // Open a detail bottom sheet for an article
      if (techDetails.clusters != null && techDetails.clusters!.isNotEmpty) {
        // Navigate back to Technology tab.
        await tester.tap(find.text('Technology'));
        await tester.pumpAndSettle();

        // Tap on the first tech article to open its detail.
        await tester.scrollUntilVisible(
          find.text(techDetails.clusters![0].title),
          10.0,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text(techDetails.clusters![0].title));
        await tester.pumpAndSettle();
        expect(find.byType(DraggableScrollableSheet), findsOneWidget);

        // Close the bottom sheet.
        await tester.tap(find.byIcon(Icons.close).last);
        await tester.pumpAndSettle();
      }

      // Test Pull-to-Refresh Functionality
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 300));
      await tester.pumpAndSettle();

      // Assert: Verify that the repository's sync method was called.
      verify(mockRepository.sync()).called(greaterThan(0));
    });

    testWidgets('Displays error message when category loading fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp());
      controller.fetchCategories();
      await tester.pumpAndSettle();

      expect(find.text('Technology'), findsOneWidget);

      when(mockRepository.getCategoryDetails('tech.json')).thenAnswer(
        (_) async => Result.error('Failed to load tech news'),
      );

      // Navigate to the Technology tab.
      await tester.tap(find.text('Technology'));
      await tester.pumpAndSettle();

      // Verify an error message is displayed.
      expect(find.textContaining('Failed to load'), findsOneWidget);
    });
  });
}
