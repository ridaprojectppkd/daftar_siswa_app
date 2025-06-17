import 'package:daftar_siswa_app/tugas_14/models/coin_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<CoinModel>> getCoin() async {
  final response = await http.get(
    Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=idr'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> coinJson = json.decode(response.body);
    return coinJson.map((json) => CoinModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}
