import 'package:flutter/material.dart';

void main() => runApp(const FakePhonePeDemoApp());

class FakePhonePeDemoApp extends StatelessWidget {
  const FakePhonePeDemoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Fake PhonePe Demo',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5F259F)), useMaterial3: true),
    home: const PaymentDemoPage(),
  );
}

class PaymentDemoPage extends StatefulWidget {
  const PaymentDemoPage({super.key});
  @override
  State<PaymentDemoPage> createState() => _PaymentDemoPageState();
}

class _PaymentDemoPageState extends State<PaymentDemoPage> {
  final amount = TextEditingController(text: '100');
  final sender = TextEditingController(text: 'Demo Sender');
  final receiver = TextEditingController(text: 'Demo Receiver');

  @override
  void dispose() { amount.dispose(); sender.dispose(); receiver.dispose(); super.dispose(); }

  void showReceipt() {
    final value = double.tryParse(amount.text.trim());
    if (value == null || value <= 0 || sender.text.trim().isEmpty || receiver.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid amount and both names.')));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReceiptPage(
      amount: value, sender: sender.text.trim(), receiver: receiver.text.trim(),
      reference: 'DEMO-${DateTime.now().millisecondsSinceEpoch}',
    )));
  }

  Widget field(String label, TextEditingController controller, {TextInputType type = TextInputType.text}) =>
    Padding(padding: const EdgeInsets.only(bottom: 14), child: TextField(
      controller: controller, keyboardType: type,
      decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
    ));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F3FC),
    appBar: AppBar(backgroundColor: const Color(0xFF5F259F), foregroundColor: Colors.white, title: const Text('Fake PhonePe — DEMO')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const DemoBanner(),
      const SizedBox(height: 20),
      const Text('Payment simulator', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('This screen creates a local demo receipt only.'),
      const SizedBox(height: 22),
      field('Demo amount (₹)', amount, type: TextInputType.number),
      field('Sender name', sender),
      field('Receiver name', receiver),
      SizedBox(height: 52, child: FilledButton(
        style: FilledButton.styleFrom(backgroundColor: const Color(0xFF5F259F)),
        onPressed: showReceipt, child: const Text('Show DEMO success screen'))),
      const SizedBox(height: 18),
      const Text('No money is sent. No UPI ID, bank account, QR code, or payment network is used.',
        textAlign: TextAlign.center),
    ]),
  );
}

class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFFFFE8A3), borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFB77900))),
    child: const Row(children: [
      Icon(Icons.warning_amber_rounded, color: Color(0xFF8A5600)),
      SizedBox(width: 8),
      Expanded(child: Text('DEMO ONLY — NOT A REAL PAYMENT',
        style: TextStyle(color: Color(0xFF754900), fontWeight: FontWeight.bold))),
    ]),
  );
}

class ReceiptPage extends StatelessWidget {
  final double amount;
  final String sender, receiver, reference;
  const ReceiptPage({super.key, required this.amount, required this.sender, required this.receiver, required this.reference});

  Widget detail(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 112, child: Text(label)),
      Expanded(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600))),
    ]),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F3FC),
    appBar: AppBar(backgroundColor: const Color(0xFF5F259F), foregroundColor: Colors.white, title: const Text('Demo receipt')),
    body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Card(
      color: Colors.white, child: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const DemoBanner(), const SizedBox(height: 22),
        const Icon(Icons.check_circle, color: Color(0xFF218838), size: 66),
        const SizedBox(height: 10),
        const Text('DEMO SUCCESS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('₹${amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const Divider(height: 30),
        detail('From', sender), detail('To', receiver), detail('Demo reference', reference),
        const SizedBox(height: 18),
        const Text('SIMULATED TRANSACTION — NO MONEY WAS TRANSFERRED',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Back to demo')),
      ])),
    ))),
  );
}
