import 'package:dio/dio.dart';
import 'package:nukdi4/models/category.dart';
import 'package:nukdi4/constants/global_variables.dart';

class CategoryService {
  final Dio _dio = Dio(BaseOptions(baseUrl: '$uri/api'));

  Future<List<Category>> fetchAll() async {
    final response = await _dio.get('/categories');
    return (response.data as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  Future<void> create(String name, String filePath) async {
    final formData = FormData.fromMap({
      'name': name,
      'image': await MultipartFile.fromFile(filePath, filename: 'upload.jpg'),
    });
    await _dio.post('/categories', data: formData);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/categories/$id');
  }
}
