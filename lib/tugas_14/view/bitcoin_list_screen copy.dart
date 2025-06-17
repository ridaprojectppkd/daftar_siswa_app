import 'package:daftar_siswa_app/tugas_14/api/get_coin.dart';

import 'package:flutter/material.dart';

class BitcoinListScreen extends StatelessWidget {
  const BitcoinListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getCoin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final coins = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: coins?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  /////////////////////bitcoin
                  final coin = coins[index];
                  return ListTile(
                    
                    title: Text('${coin.name}'),
                    subtitle: Text(coin.symbol),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(coin.image),
                    ),
                    trailing: Column(
                      children: [
                        Text(
                          ' ${coin.currentPrice}',
                          style: TextStyle(color: Colors.green),
                        ),
                        Text('${coin.atlDate}'),
                        Text(
                          '${coin.athChangePercentage}',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('Error:${snapshot.error}'));
            }
          },
        ),
      ),
    );
  }
}
