import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = "https://apoorvmittal-querynest-backend.hf.space"; 
  static const String baseUrl = "http://localhost:8000"; 
  // baseURL = localhost:8000
  // replace with your deployed backend later

  /// 🔍 Search query
  static Future<List<Map<String, dynamic>>> search(String query) async {
    final response = await http.post(
      Uri.parse("$baseUrl/search"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "query": query,
        "top_k": 3,
      }),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to search");
    }
  }

  /// 📤 Upload PDF
  static Future<String> uploadFile(File file) async {
    // print("Start: Try to upload file");
    // print("Filepath: ${file.path}");
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload_pdf"));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var res = await request.send();
    var responseBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      final data = json.decode(responseBody);
      return data["message"];
    } else {
      throw Exception("Upload failed: $responseBody");
    }
  }
}
