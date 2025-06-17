// lib/tugas_14/screens/coin_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daftar_siswa_app/tugas_14/models/coin_model.dart';
import 'package:intl/intl.dart'; // Untuk format angka

class CoinDetailScreen extends StatelessWidget {
  final CoinModel coin;

  const CoinDetailScreen({super.key, required this.coin});

  // Helper untuk format mata uang IDR
  String formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  // Helper untuk format harga (dengan desimal)
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
      decimalDigits = 8;
    }

    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: decimalDigits,
    );
    return format.format(price);
  }

  // Helper untuk format persentase
  String formatPercentage(double percentage) {
    return '${percentage >= 0 ? '+' : ''}${percentage.toStringAsFixed(2)}%';
  }

  // Helper untuk membuat baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color changeColor =
        coin.priceChangePercentage24H >= 0
            ? const Color(0xFF4CAF50) // Green
            : const Color(0xFFF44336); // Red

    return Scaffold(
      appBar: AppBar(
        title: Text(
          coin.name, // Judul AppBar adalah nama koin
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        // Gunakan SingleChildScrollView agar bisa discroll
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon, Nama, Harga, Perubahan
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F3F57),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: coin.image,
                    placeholder:
                        (context, url) =>
                            const CircularProgressIndicator(strokeWidth: 2),
                    errorWidget:
                        (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.white70,
                          size: 40,
                        ),
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        coin.symbol.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatPrice(coin.currentPrice),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatPercentage(coin.priceChangePercentage24H),
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 32),

            // Bagian Detail Informasi
            _buildDetailRow('Market Cap', formatCurrency(coin.marketCap)),
            _buildDetailRow('Rank', coin.marketCapRank.toString()),
            _buildDetailRow(
              'Total Volume (24H)',
              coin.totalVolume != null
                  ? formatCurrency(coin.totalVolume!.toDouble())
                  : 'N/A',
            ),
            _buildDetailRow('High (24H)', formatPrice(coin.high24H)),
            _buildDetailRow('Low (24H)', formatPrice(coin.low24H)),
            _buildDetailRow(
              'Price Change (24H)',
              formatPrice(coin.priceChange24H),
            ),
            _buildDetailRow(
              'Market Cap Change (24H)',
              formatCurrency(coin.marketCapChange24H),
            ),
            _buildDetailRow(
              'Circulating Supply',
              formatPrice(coin.circulatingSupply),
            ),
            _buildDetailRow(
              'Total Supply',
              coin.totalSupply != null ? formatPrice(coin.totalSupply!) : 'N/A',
            ),
            _buildDetailRow(
              'Max Supply',
              coin.maxSupply != null ? formatPrice(coin.maxSupply!) : 'N/A',
            ),
            _buildDetailRow('ATH (All-Time High)', formatPrice(coin.ath)),
            _buildDetailRow(
              'ATH Change (%)',
              formatPercentage(coin.athChangePercentage),
            ),
            _buildDetailRow(
              'ATH Date',
              DateFormat('dd MMM yyyy').format(coin.athDate),
            ),
            _buildDetailRow('ATL (All-Time Low)', formatPrice(coin.atl)),
            _buildDetailRow(
              'ATL Change (%)',
              formatPercentage(coin.atlChangePercentage),
            ),
            _buildDetailRow(
              'ATL Date',
              DateFormat('dd MMM yyyy').format(coin.atlDate),
            ),
            if (coin.roi != null) ...[
              const Divider(color: Colors.white24, height: 32),
              const Text(
                'ROI (Return on Investment)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildDetailRow('Times', coin.roi!.times.toStringAsFixed(2)),
              _buildDetailRow(
                'Currency',
                coin.roi!.currency.name.toUpperCase(),
              ),
              _buildDetailRow(
                'Percentage',
                '${coin.roi!.percentage.toStringAsFixed(2)}%',
              ),
            ],
            const Divider(color: Colors.white24, height: 32),
            _buildDetailRow(
              'Last Updated',
              DateFormat('dd MMM yyyy HH:mm').format(coin.lastUpdated),
            ),
          ],
        ),
      ),
    );
  }
}
