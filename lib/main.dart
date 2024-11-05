import 'package:flutter/material.dart';
import 'package:uts_ppb/barang.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Barang> barangList = [
    Barang(title: 'Laptop', price: 25000000, stok: 0),
    Barang(title: 'Mouse', price: 1250000, stok: 0),
    Barang(title: 'Keyboard', price: 1500000, stok: 0),
    Barang(title: 'Monitor', price: 5000000, stok: 0),
    Barang(title: 'Printer', price: 2200000, stok: 0),
  ];

  int totalBayar = 0;
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();

    if (barangList.isNotEmpty) {
      controllers = List.generate(
        barangList.length,
        (index) => TextEditingController(text: '0'),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void reset() {
    setState(() {
      for (var i = 0; i < barangList.length; i++) {
        barangList[i].stok = 0;
        if (i < controllers.length) {
          controllers[i].text = '0';
        }
      }
      totalBayar = 0;
    });
  }

  void cetakStruk() {
    setState(() {
      totalBayar = barangList.fold(0, (sum, item) => sum + (item.price * item.stok));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Toko Komputer"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: barangList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(barangList[index].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Rp ${barangList[index].price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}"),
                        trailing: SizedBox(
                          width: 60,
                          child: TextField(
                            controller: controllers.isNotEmpty
                                ? controllers[index]
                                : null,
                            onChanged: (value) {
                              setState(() {
                                barangList[index].stok = int.tryParse(value) ?? 0;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0',
                              border: OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: reset,
                    child: const Text("Reset", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: cetakStruk,
                    child: const Text("Cetak Struk", style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26.0),
              Expanded(
                child: ListView.builder(
                  itemCount: barangList.length,
                  itemBuilder: (context, index) {
                    var item = barangList[index];
                    if (item.stok > 0) {
                      int subtotal = item.price * item.stok;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.shop_two, color: Colors.blue),
                          title: Text(item.title),
                          subtitle: Text("Rp ${item.price} x ${item.stok}"),
                          trailing: Text("Rp ${subtotal}"),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Total: Rp ${totalBayar}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
