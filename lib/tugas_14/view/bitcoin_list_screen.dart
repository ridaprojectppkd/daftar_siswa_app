import 'package:daftar_siswa_app/tugas_14/api/get_coin.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daftar_siswa_app/tugas_14/models/coin_model.dart';
import 'package:intl/intl.dart';

class CryptoMarketsScreen extends StatefulWidget {
  const CryptoMarketsScreen({super.key});

  @override
  State<CryptoMarketsScreen> createState() => _CryptoMarketsScreenState();
}

class _CryptoMarketsScreenState extends State<CryptoMarketsScreen> {
  late Future<List<CoinModel>> futureCoins;
  List<CoinModel> allCoins = [];
  List<CoinModel> filteredCoins = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  // Tambahkan state untuk mata uang yang aktif
  String activeCurrency =
      'USD'; // nilai yang pada umumnya di bitcoin API Currency

  @override /////////////initstate itu fungsinya memanggill data2 API
  void initState() {
    super.initState();
    futureCoins = getCoin();
    futureCoins.then((coins) {
      setState(() {
        allCoins = coins;
        filteredCoins = coins;
      });
    });
    searchController.addListener(
      _filterCoins,
    ); //////////proses filterasi saat dalam pencarian
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCoins);
    searchController.dispose();
    super.dispose();
  }

  void _filterCoins() {
    ////////////////////Filter coin berdasarkan input teks (nama atau simbol coin)
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCoins = allCoins;
      } else {
        filteredCoins =
            allCoins.where((coin) {
              return coin.name.toLowerCase().contains(query) ||
                  coin.symbol.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  void _toggleSearch() {
    //////////////Membersihkan pencarian saat mode dinonaktifkan
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear(); //////bersihin text field setelah mencari
        _filterCoins(); ////Memfilter daftar coin berdasarkan teks pencarian. Saat teks kosong, filteredCoins akan sama dengan allCoins.
        //Menampilkan semua coin kembali (stelah input pencarian sudah dikosongkan).
      }
    });

    ////////jadi gini saat apk dibuka (false), ketika serach di klik itu (true), ketika pencet silang (false data kembali)
  }

  // Fungsi untuk mengubah mata uang
  void _changeCurrency(String currency) {
    //////contonh currency : IDR USD BTC
    setState(() {
      //setsate kalo di update nanti akan ada perubahan di ui
      activeCurrency = currency;
    });
  }

  // Modifikasi formatCurrency untuk menangani berbagai mata uang
  //Menyesuaikan format tampilan berdasarkan mata uang aktif
  String formatCurrency(double amount) {
    if (activeCurrency == 'IDR') {
      final format = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return format.format(amount);
    } else if (activeCurrency == 'BTC') {
      return '₿ ${amount.toStringAsFixed(8)}';
    } else if (activeCurrency == 'ETH') {
      return 'Ξ ${amount.toStringAsFixed(6)}';
    } else {
      // Default USD
      final format = NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
        decimalDigits: 2, ////////angka dibelakang koma
      );
      return format.format(amount);
    }
  }

  // Modifikasi formatPrice untuk menangani berbagai mata uang
  String formatPrice(double price) {
    if (activeCurrency == 'BTC' || activeCurrency == 'ETH') {
      // Untuk BTC dan ETH, tampilkan lebih banyak digit desimal
      int decimalDigits = activeCurrency == 'BTC' ? 8 : 6;

      ///8 6 adalah jumlah nilai terkecil dri bitcoin contohnya ₿ 0.00000001=1 satohsi
      return '${activeCurrency == 'BTC' ? '₿' : 'Ξ'} ${price.toStringAsFixed(decimalDigits)}';
    }

    // Untuk IDR dan USD////decimal digit 6
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
      decimalDigits = 8;
    }

    final format = NumberFormat.currency(
      locale:
          activeCurrency == 'IDR'
              ? 'id_ID'
              : 'en_US', //////jika  idr maka mata uang dollar tapi jika bukan maka mata uang dollar
      symbol:
          activeCurrency == 'IDR'
              ? 'Rp '
              : '\$', /////INTL PubsPec YAML untuk lokalisasi format angka
      decimalDigits: decimalDigits,
    );
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            isSearching
                ? TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Search coins...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  autofocus: true,
                )
                : const Text(
                  'Markets',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian filter mata uang
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  /////////pakai buildcurrenytab karena mampu membangun 2 parameter.
                  ////contoh: parameter 1 IDR  maka Activecurrencrynya juga IDR, kalau kepilih ada garis bawahnya
                  _buildCurrencyTab('IDR', activeCurrency == 'IDR'),
                  _buildCurrencyTab('USD', activeCurrency == 'USD'),
                  _buildCurrencyTab('BTC', activeCurrency == 'BTC'),
                  _buildCurrencyTab('ETH', activeCurrency == 'ETH'),
                  _buildCurrencyTab('USDT', activeCurrency == 'USDT'),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          // Header kolom
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(127, 68, 137, 255),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2, ////flex fungsinya sama kayak expanded
                  child: Text(
                    'Price ($activeCurrency)',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 13,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Change%',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 13,
                    ),
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
                } else if (!snapshot.hasData || allCoins.isEmpty) {
                  return const Center(child: Text('No coins found.'));
                } else {
                  if (filteredCoins.isEmpty &&
                      searchController.text.isNotEmpty) {
                    return const Center(
                      child: Text('No matching coins found.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredCoins.length,
                    itemBuilder: (context, index) {
                      final coin = filteredCoins[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/coinDetail', ///ada di main routenya
                            arguments: coin,
                          );
                        },
                        child: _buildCryptoAssetItem(coin),
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

  // Modifikasi _buildCurrencyTab untuk menangani tap
  Widget _buildCurrencyTab(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _changeCurrency(text); // Panggil fungsi untuk mengubah mata uang
      },
      child: Padding(
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
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoAssetItem(CoinModel coin) {
    Color changeColor;
    Color bubbleColor;

    double changePercentage = coin.priceChangePercentage24H;

    if (changePercentage >= 0) {
      changeColor = const Color.fromARGB(255, 163, 255, 166);
      bubbleColor = const Color(0xFF2E6B4F);
    } else {
      changeColor = const Color.fromARGB(255, 255, 151, 143);
      bubbleColor = const Color.fromARGB(255, 143, 48, 67);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3F3F57),
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
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.symbol.toUpperCase(),
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
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatPrice(coin.currentPrice),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'MCap: ${formatCurrency(coin.marketCap)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${changePercentage >= 0 ? '+' : ''}${changePercentage.toStringAsFixed(2)}%', ////kalau lebih dari nol maka +
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
