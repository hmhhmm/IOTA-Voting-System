import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<String> createDid() async {
    final response = await http.post(Uri.parse('$baseUrl/did/create'), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['did'] ?? '';
    }
    throw Exception('Failed to create DID');
  }

  Future<String> issueCredential(String did, String region, int age) async {
    final response = await http.post(
      Uri.parse('$baseUrl/credential/issue'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'did': did, 'region': region, 'age': age}),
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Failed to issue credential');
  }

  Future<String> submitFeedback(String did, String feedback) async {
    final response = await http.post(
      Uri.parse('$baseUrl/feedback/submit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'did': did, 'feedback': feedback}),
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Failed to submit feedback');
  }

  Future<Map<String, dynamic>> submitVote(String userId, String vote, String candidate, String did) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vote'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId, 'vote': vote, 'candidate': candidate, 'did': did}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to submit vote');
  }

  Future<Map<String, dynamic>> submitPolicyVote(String userId, String policy, String vote) async {
    final response = await http.post(
      Uri.parse('$baseUrl/policy_vote'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId, 'policy': policy, 'vote': vote}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to submit policy vote');
  }

  Future<Map<String, dynamic>> health() async {
    final response = await http.get(Uri.parse('$baseUrl/health'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Backend health check failed');
  }
} 