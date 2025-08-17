import 'dart:convert';
import 'package:http/http.dart';

class GlobalGetDataFrame {
  static Future<List> getDataFrame(uri) async {
    final url = Uri.parse(uri);
    final response = await get(url);
    final Map<String, dynamic> json = jsonDecode(response.body);
    final List data = json['data'];
    return data;
    // members = data.map((e) => TeamMember.fromJson(e)).toList();
  }
}
