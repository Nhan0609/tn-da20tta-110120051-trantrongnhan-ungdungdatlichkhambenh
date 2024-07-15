import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://vn-public-apis.fpo.vn';

  // Fetch all provinces
  Future<List<dynamic>> fetchProvinces() async {
    return _fetchData('$baseUrl/provinces/getAll');
  }

  // Fetch all districts
  Future<List<dynamic>> fetchDistricts() async {
    return _fetchData('$baseUrl/districts/getAll');
  }

  // Fetch districts by province
  Future<List<dynamic>> fetchDistrictsByProvince(String provinceId) async {
    return _fetchData('$baseUrl/districts/getByProvince?provinceId=$provinceId');
  }

  // Fetch all wards
  Future<List<dynamic>> fetchWards() async {
    return _fetchData('$baseUrl/wards/getAll');
  }

  // Fetch wards by district
  Future<List<dynamic>> fetchWardsByDistrict(String districtId) async {
    return _fetchData('$baseUrl/wards/getByDistrict?districtId=$districtId');
  }

  // Generic method to fetch data from given endpoint
  Future<List<dynamic>> _fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
