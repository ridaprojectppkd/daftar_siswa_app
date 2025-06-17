// lib/tugas_14/screens/coin_list_screen.dart
import 'package:daftar_siswa_app/tugas_14/api/get_coin.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daftar_siswa_app/tugas_14/models/coin_model.dart'; // Import model Anda
import 'package:intl/intl.dart'; // Untuk format angka

class CryptoMarketsScreen extends StatefulWidget {
  const CryptoMarketsScreen({super.key});

  @override
  State<CryptoMarketsScreen> createState() => _CryptoMarketsScreenState();
}

class _CryptoMarketsScreenState extends State<CryptoMarketsScreen> {
  late Future<List<CoinModel>> futureCoins;

  @override
  void initState() {
    super.initState();
    futureCoins = getCoin(); // Panggil API saat initState
  }

  // Helper untuk format mata uang IDR
  String formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits:
          0, // Sesuai dengan tampilan gambar (tidak ada desimal untuk volume)
    );
    return format.format(amount);
  }

  // Helper untuk format harga (dengan desimal)
  String formatPrice(double price) {
    // Menyesuaikan desimal berdasarkan skala harga
    int decimalDigits;
    if (price >= 1000) {
      decimalDigits = 2; // Contoh: 1234.56
    } else if (price >= 100) {
      decimalDigits = 3; // Contoh: 123.456
    } else if (price >= 10) {
      decimalDigits = 4; // Contoh: 12.3456
    } else if (price >= 1) {
      decimalDigits = 5; // Contoh: 1.23456
    } else {
      decimalDigits = 6; // Untuk harga sangat kecil
    }

    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '', // Tidak pakai simbol mata uang di harga utama
      decimalDigits: decimalDigits,
    );
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Markets',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currency Filters/Tabs (Tetap statis karena API hanya mengambil IDR)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCurrencyTab('IDR', true), // Ganti ke IDR
                  _buildCurrencyTab('USD', false),
                  _buildCurrencyTab('BTC', false),
                  _buildCurrencyTab('ETH', false),
                  _buildCurrencyTab('USDT', false),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          // List Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Name',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Market Price',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Change%',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CoinModel>>(
              future: futureCoins,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No coins found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final coin = snapshot.data![index];
                      return _buildCryptoAssetItem(coin);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyTab(String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 24,
              decoration: BoxDecoration(
                color: Colors.tealAccent, // Active tab indicator color
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCryptoAssetItem(CoinModel coin) {
    Color changeColor;
    Color bubbleColor;

    double changePercentage = coin.priceChangePercentage24H;

    if (changePercentage >= 0) {
      changeColor = const Color(0xFF4CAF50); // Green
      bubbleColor = const Color(0xFF2E6B4F); // Darker green for bubble
    } else {
      changeColor = const Color(0xFFF44336); // Red
      bubbleColor = const Color(0xFF7A3744); // Darker red for bubble
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          // Crypto Icon from URL
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(
                0xFF3F3F57,
              ), // A slightly lighter dark background for the icon
              borderRadius: BorderRadius.circular(8),
            ),
            child: CachedNetworkImage(
              imageUrl: coin.image,
              placeholder:
                  (context, url) =>
                      const CircularProgressIndicator(strokeWidth: 2),
              errorWidget:
                  (context, url, error) =>
                      const Icon(Icons.error, color: Colors.white70),
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Name and Pair
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.symbol
                      .toUpperCase(), // Gunakan symbol seperti BTC, DASH, dll.
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  // Menampilkan totalVolume dalam format IDR
                  'Vol: ${coin.totalVolume != null ? formatCurrency(coin.totalVolume!.toDouble()) : 'N/A'}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          // Market Price
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatPrice(
                    coin.currentPrice,
                  ), // Format harga dengan formatPrice
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'MCap: ${formatCurrency(coin.marketCap)}', // Menampilkan marketCap
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Change Percentage Bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${changePercentage >= 0 ? '+' : ''}${changePercentage.toStringAsFixed(2)}%',
              style: TextStyle(
                color: changeColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
