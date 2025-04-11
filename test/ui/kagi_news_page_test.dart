import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository.dart';
import 'package:kagi_news/data/datasource/repository/result.dart';
import 'package:kagi_news/i18n/strings.g.dart';
import 'package:kagi_news/ui/category_details_tab.dart';
import 'package:kagi_news/ui/kagi_news_controller.dart';
import 'package:kagi_news/ui/kagi_news_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mock classes
import '../data/datasource/network/model/news_category_details_test_data_client.dart';
@GenerateMocks([KagiNewsRepository])
import 'kagi_news_page_test.mocks.dart';

void main() {
  late MockKagiNewsRepository mockRepository;
  late KagiNewsController controller;
  late ValueNotifier<Result<KagiNewsCategoriesResponse>?> categoriesNotifier;

  setUp(() {
    mockRepository = MockKagiNewsRepository();

    // Set up the repository mock to return null immediately
    when(mockRepository.getCategories()).thenAnswer((_) async => Result.success(
          KagiNewsCategoriesResponse(
            categories: [],
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        ));

    // Create a real controller with mocked repository
    controller = KagiNewsController(repository: mockRepository);

    // Get the real notifiers from the controller
    categoriesNotifier = controller.categoriesNotifier;
  });

  // Helper function to build the widget under test
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: KagiNewsPage(controller: controller),
    );
  }

  testWidgets(
    'shows loading indicator when data is null',
    (WidgetTester tester) async {
      controller.categoriesNotifier.value = null;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'shows error message when there is an error',
    (WidgetTester tester) async {
      when(mockRepository.getCategories()).thenAnswer(
        (_) async => Result<KagiNewsCategoriesResponse>.error(
            t.errors.failedToLoadCategories),
      );

      controller.fetchCategories();

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(
          find.textContaining(t.errors.failedToLoadCategories), findsOneWidget);
    },
  );

  testWidgets(
    'shows "No Categories Available" when categories are empty',
    (WidgetTester tester) async {
      when(mockRepository.getCategories()).thenAnswer(
        (_) async => Result<KagiNewsCategoriesResponse>.success(
          KagiNewsCategoriesResponse(
            categories: [],
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        ),
      );
      categoriesNotifier.value = Result.success(
        KagiNewsCategoriesResponse(
          categories: [],
          timestamp: DateTime.now().microsecondsSinceEpoch,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.textContaining(t.app.noCategoriesAvailable), findsOneWidget);
    },
  );

  testWidgets(
    'shows tabs when categories are loaded',
    (WidgetTester tester) async {
      when(mockRepository.getCategories()).thenAnswer(
        (_) async => Result<KagiNewsCategoriesResponse>.success(
          KagiNewsCategoriesResponse(
            categories: [
              NewsCategory(name: 'Technology', file: 'tech.json'),
              NewsCategory(name: 'Science', file: 'science.json'),
              NewsCategory(name: 'Health', file: 'health.json'),
            ],
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        ),
      );
      controller.fetchCategories();

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Science'), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);

      expect(controller.categoryDetailsNotifiers.length, 3);
      expect(
          controller.categoryDetailsNotifiers.keys.contains('tech.json'), true);
      expect(controller.categoryDetailsNotifiers.keys.contains('science.json'),
          true);
      expect(controller.categoryDetailsNotifiers.keys.contains('health.json'),
          true);
    },
  );

  testWidgets('can switch between tabs', (WidgetTester tester) async {
    when(mockRepository.getCategories()).thenAnswer((_) async => Result.success(
          KagiNewsCategoriesResponse(
            categories: [
              NewsCategory(name: 'Technology', file: 'tech.json'),
              NewsCategory(name: 'Science', file: 'science.json'),
            ],
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        ));
    categoriesNotifier.value = Result.success(
      KagiNewsCategoriesResponse(
        categories: [
          NewsCategory(name: 'Technology', file: 'tech.json'),
          NewsCategory(name: 'Science', file: 'science.json'),
        ],
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Technology'), findsOneWidget);

    await tester.tap(find.text('Science'));
    await tester.pumpAndSettle();

    expect(find.byType(TabBarView), findsOneWidget);
  });

  testWidgets("shows category details when tab is selected",
      (WidgetTester tester) async {
    NewsCategoryDetailsResponse techCategoryDetailsResponse =
        NewsCategoryDetailsTestDataClient.getTechNewsCategoryDetailsResponse();
    NewsCategoryDetailsResponse businessCategoryDetailsResponse =
        NewsCategoryDetailsTestDataClient
            .getBusinessNewsCategoryDetailsResponse();

    // techCategoryDetailsResponse.clusters.map((i) => i.title);

    when(mockRepository.getCategories()).thenAnswer(
      (_) async => Result.success(
        KagiNewsCategoriesResponse(
          categories: [
            NewsCategory(name: 'Technology', file: 'tech.json'),
            NewsCategory(name: 'Business', file: 'business.json'),
          ],
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
    when(mockRepository.getCategoryDetails('business.json')).thenAnswer(
      (_) async => Result.success(businessCategoryDetailsResponse),
    );
    when(mockRepository.getCategoryDetails('tech.json')).thenAnswer(
      (_) async => Result.success(techCategoryDetailsResponse),
    );

    controller.fetchCategories();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Technology'), findsOneWidget);

    final TabController tabController =
        DefaultTabController.of(tester.element(find.text('Technology')));
    expect(tabController.index, equals(0));

    expect(find.byType(CategoryDetailsTab), findsOneWidget);

    for(var i = 0; i < techCategoryDetailsResponse.clusters.length; i++) {
      final cluster = techCategoryDetailsResponse.clusters[i];
      await tester.scrollUntilVisible(
          find.text(cluster.title),
          10,
          scrollable: find.byType(Scrollable).first,
          duration: const Duration(milliseconds: 100),
      );
      expect(find.text(cluster.title), findsOneWidget);
    }

    await tester.tap(find.text('Business'));
    await tester.pumpAndSettle();

    for(var i = 0; i < businessCategoryDetailsResponse.clusters.length; i++) {
      final cluster = businessCategoryDetailsResponse.clusters[i];
      await tester.scrollUntilVisible(
          find.text(cluster.title),
          10,
          scrollable: find.byType(Scrollable).first,
          duration: const Duration(milliseconds: 100),
      );
      expect(find.text(cluster.title), findsOneWidget);
    }
  });
}
