import 'package:dio/dio.dart';

final Dio dio = Dio()
  ..options.headers["Authorization"] =
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjMyMDMsInVzZXJfdHlwZSI6MiwicHJpdmlsZWdlIjpudWxsLCJpYXQiOjE3NDk2MzA3MzcsImV4cCI6MTc4MTE2NjczN30.V4okpSzbqNTeFklZljZEiHDZMa2fTH_YKvQJ7uve3NM"
  ..options.headers["Content-Type"] = "application/json";

Future<Map<String, dynamic>?> getMyPunchReport({
  required String startDate,
  required String endDate,
  required String facultyClgId,
}) async {
  final String baseUrl =
      "https://api.test.vppcoe.getflytechnologies.com/api/faculty";
  final String endpoint = "/report/myPunchReport";

  final data = {
    "startDate": startDate,
    "endDate": endDate,
    "faculty_clg_id": facultyClgId,
  };

  try {
    print("Making API call to: $baseUrl$endpoint");
    print("Request data: $data");
    print("Headers: ${dio.options.headers}");

    final response = await dio.post(
      "$baseUrl$endpoint",
      data: data,
    );

    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception(
          "API Error: ${response.statusCode} - ${response.statusMessage}");
    }
  } on DioException catch (e) {
    print("DioException occurred: ${e.message}");
    print("Error type: ${e.type}");
    print("Response data: ${e.response?.data}");
    print("Status code: ${e.response?.statusCode}");

    if (e.response?.statusCode == 401) {
      throw Exception(
          "Authentication failed. Please check your credentials or token.");
    } else if (e.response?.statusCode == 400) {
      throw Exception("Bad request. Please check your input data.");
    } else {
      throw Exception("Network error: ${e.message}");
    }
  } catch (e) {
    print("General error occurred: $e");
    throw Exception("Failed to fetch punch report: $e");
  }
}
