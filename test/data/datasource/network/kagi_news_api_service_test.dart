import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';

import 'categories_api_tests.dart';
import 'category_details_api_tests.dart';

@GenerateMocks([Dio, Interceptors])
void main() {
  categoriesTests();

  categoryDetailsTests();
}
