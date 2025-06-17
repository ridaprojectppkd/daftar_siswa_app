import 'package:daftar_siswa_app/tugas_14/api/get_coin.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daftar_siswa_app/tugas_14/models/coin_model.dart'; // Pastikan path model Anda benar
// Pastikan path API Anda benar
import 'package:intl/intl.dart'; // Untuk formatting angka

class CryptoMarketsScreen extends StatefulWidget {
  const CryptoMarketsScreen({super.key});

  @override
  State<CryptoMarketsScreen> createState() => _CryptoMarketsScreenState();
}

class _CryptoMarketsScreenState extends State<CryptoMarketsScreen> {
  // Future untuk mengambil data koin dari API
  late Future<List<CoinModel>> futureCoins;
  // List untuk menyimpan semua koin yang diambil, sebagai sumber data utama
  List<CoinModel> allCoins = [];
  // List untuk menyimpan koin yang ditampilkan setelah filtering/pencarian
  List<CoinModel> filteredCoins = [];
  // Controller untuk mengelola input teks pada kolom pencarian
  TextEditingController searchController = TextEditingController();
  // State boolean untuk mengontrol tampilan mode pencarian di AppBar
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi futureCoins dengan memanggil fungsi API
    futureCoins = getCoin();
    // Setelah data dari futureCoins didapatkan, isi allCoins dan filteredCoins
    futureCoins.then((coins) {
      setState(() {
        allCoins = coins;
        filteredCoins = coins; // Awalnya, tampilkan semua koin
      });
    });

    // Tambahkan listener ke searchController untuk memicu _filterCoins setiap kali teks berubah
    searchController.addListener(_filterCoins);
  }

  @override
  void dispose() {
    // Hapus listener dan buang controller saat widget dibuang untuk mencegah memory leaks
    searchController.removeListener(_filterCoins);
    searchController.dispose();
    super.dispose();
  }

  // Metode untuk memfilter daftar koin berdasarkan teks pencarian
  void _filterCoins() {
    String query =
        searchController.text
            .toLowerCase(); // Ambil teks pencarian dan ubah ke lowercase
    setState(() {
      if (query.isEmpty) {
        filteredCoins =
            allCoins; // Jika teks pencarian kosong, tampilkan semua koin
      } else {
        // Filter koin berdasarkan nama atau simbol yang mengandung query
        filteredCoins =
            allCoins.where((coin) {
              return coin.name.toLowerCase().contains(query) ||
                  coin.symbol.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  // Metode untuk mengganti antara mode tampilan judul dan mode pencarian di AppBar
  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching; // Toggle status pencarian
      if (!isSearching) {
        searchController
            .clear(); // Bersihkan teks pencarian saat keluar dari mode search
        _filterCoins(); // Panggil _filterCoins untuk mereset daftar ke semua koin
      }
    });
  }

  // Helper function untuk memformat nilai mata uang ke format IDR (contoh: Rp 1.000.000)
  String formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0, // Tidak ada desimal untuk mata uang volume/market cap
    );
    return format.format(amount);
  }

  // Helper function untuk memformat harga koin dengan jumlah desimal yang adaptif
  String formatPrice(double price) {
    int decimalDigits;
    if (price >= 1000) {
      decimalDigits = 2;
    } else if (price >= 100) {
      decimalDigits = 3;
    } else if (price >= 10) {
      decimalDigits = 4;
    } else if (price >= 1) {
      decimalDigits = 5;
    } else {
      decimalDigits =
          8; // Untuk harga yang sangat kecil, tampilkan lebih banyak desimal
    }

    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '', // Tanpa simbol mata uang di harga utama
      decimalDigits: decimalDigits,
    );
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Kondisional: Tampilkan TextField untuk pencarian atau judul "Markets"
        title:
            isSearching
                ? TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Search coins...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: InputBorder.none, // Hapus border default TextField
                    contentPadding:
                        EdgeInsets.zero, // Hapus padding default TextField
                  ),
                  autofocus:
                      true, // Fokuskan TextField secara otomatis saat muncul
                )
                : const Text(
                  'Markets',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
        actions: [
          // Tombol aksi: ikon pencarian atau ikon tutup (close)
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch, // Panggil fungsi toggle search
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian filter/tab mata uang
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCurrencyTab(
                    'IDR',
                    true,
                  ), // Saat ini hanya IDR yang aktif karena API
                  _buildCurrencyTab('USD', false),
                  _buildCurrencyTab('BTC', false),
                  _buildCurrencyTab('ETH', false),
                  _buildCurrencyTab('USDT', false),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 1), // Garis pemisah
          // Header kolom daftar koin (Name, Market Price, Change%)
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

          // Bagian daftar koin menggunakan FutureBuilder untuk menangani state data
          Expanded(
            child: FutureBuilder<List<CoinModel>>(
              future: futureCoins,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Tampilkan indikator loading saat data sedang diambil
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Tampilkan pesan error jika terjadi kesalahan
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || allCoins.isEmpty) {
                  // Tampilkan pesan jika tidak ada data koin sama sekali
                  return const Center(child: Text('No coins found.'));
                } else {
                  // Jika data sudah ada, periksa apakah filteredCoins kosong setelah pencarian
                  if (filteredCoins.isEmpty &&
                      searchController.text.isNotEmpty) {
                    return const Center(
                      child: Text('No matching coins found.'),
                    );
                  }
                  // Tampilkan daftar koin yang sudah difilter
                  return ListView.builder(
                    itemCount: filteredCoins.length,
                    itemBuilder: (context, index) {
                      final coin = filteredCoins[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigasi ke CoinDetailScreen saat item diketuk
                          Navigator.pushNamed(
                            context,
                            '/coinDetail', // Nama rute yang didefinisikan di main.dart
                            arguments:
                                coin, // Kirim objek CoinModel sebagai argumen
                          );
                        },
                        child: _buildCryptoAssetItem(
                          coin,
                        ), // Widget untuk menampilkan satu item koin
                      );
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

  // Widget untuk membangun setiap tab mata uang (IDR, USD, dll.)
  Widget _buildCurrencyTab(String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0), // Padding antar tab
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
          if (isSelected) // Indikator garis bawah untuk tab yang aktif
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 24,
              decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  // Widget untuk membangun tampilan setiap item koin dalam daftar
  Widget _buildCryptoAssetItem(CoinModel coin) {
    Color changeColor;
    Color bubbleColor;

    double changePercentage = coin.priceChangePercentage24H;

    // Tentukan warna berdasarkan persentase perubahan (hijau untuk naik, merah untuk turun)
    if (changePercentage >= 0) {
      changeColor = const Color(0xFF4CAF50); // Hijau
      bubbleColor = const Color(
        0xFF2E6B4F,
      ); // Hijau lebih gelap untuk latar belakang bubble
    } else {
      changeColor = const Color(0xFFF44336); // Merah
      bubbleColor = const Color(
        0xFF7A3744,
      ); // Merah lebih gelap untuk latar belakang bubble
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ), // Padding sekitar item
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Pusatkan secara vertikal
        children: [
          // Icon koin
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3F3F57), // Latar belakang icon
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
          const SizedBox(width: 12), // Spasi setelah icon
          // Nama dan Volume koin
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.symbol.toUpperCase(), // Simbol koin (misal: BTC)
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Vol: ${coin.totalVolume != null ? formatCurrency(coin.totalVolume!.toDouble()) : 'N/A'}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12), // Spasi setelah nama/volume
          // Harga pasar dan Market Cap
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatPrice(coin.currentPrice), // Harga saat ini
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'MCap: ${formatCurrency(coin.marketCap)}', // Market Cap
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12), // Spasi setelah harga/market cap
          // Gelembung persentase perubahan 24 jam
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
