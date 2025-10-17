// import 'package:dio/dio.dart';
// import '../models/note.dart';
//
// class ApiService {
//   final Dio _dio;
//
//   ApiService() : _dio = Dio() {
//     _dio.options = BaseOptions(
//       baseUrl: 'https://jsonplaceholder.typicode.com',
//       headers: {
//         'Content-Type': 'application/json',
//         'User-Agent': 'FlutterApp',
//       },
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//     );
//
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           print(' Request: ${options.method} ${options.path}');
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           print(' Response: ${response.statusCode}');
//           return handler.next(response);
//         },
//         onError: (error, handler) {
//           print(' Error: ${error.message}');
//           return handler.next(error);
//         },
//       ),
//     );
//   }
//   Future<Note> fetchNoteById(int id) async {
//     try {
//       final response = await _dio.get('/posts/$id');
//
//       if (response.statusCode == 200) {
//         return Note.fromJson(response.data);
//       } else {
//         throw Exception('Failed to load note. Code: ${response.statusCode}');
//       }
//     } on DioException catch (e) {
//       final message = e.response != null
//           ? 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}'
//           : 'Connection error: ${e.message}';
//       throw Exception(message);
//     }
//   }
// }