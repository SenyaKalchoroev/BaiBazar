// lib/src/presentation/screens/my_orders_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import 'order_details_page.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final List<Map<String, dynamic>> _statuses = [
    {'id': 1, 'label': 'Новые'},
    {'id': 2, 'label': 'В процессе'},
    {'id': 3, 'label': 'Завершенные'},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrderProvider>().loadOrders(1));
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Мои заказы',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          // ←―― горизонтальный список статусов
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _statuses.length,
              itemBuilder: (ctx, i) {
                final s   = _statuses[i];
                final sel = s['id'] == prov.selectedStatus;
                return GestureDetector(
                  onTap: () => prov.loadOrders(s['id'] as int),
                  child: Container(
                    // чуть более длинный и менее округлый «чип»
                    constraints: const BoxConstraints(minWidth: 80),
                    margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel ? Colors.green : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12), // меньше скругление
                    ),
                    child: Text(
                      s['label'] as String,
                      style: TextStyle(
                        color: sel ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ←―― контент под статусами
          if (prov.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (prov.orders.isEmpty)
            const Expanded(child: Center(child: Text('Нет заказов')))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: prov.orders.length,
                itemBuilder: (ctx, i) {
                  final o = prov.orders[i];
                  return _buildOrderItem(o.id, o);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(int orderId, dynamic o) {
    final date       = _fmt(o.date);
    final priceLabel = '${o.totalPrice}c';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // левая колонка: дата + цена
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Дата: $date',
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'к оплате: ',
                    style: const TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: priceLabel,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // правая колонка: статус + кнопка «Детали заказа»
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    o.getStatus,
                    style: const TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsPage(orderId: orderId),
                    ),
                  );
                },
                child: const Text(
                  'Детали заказа',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(String iso) {
    final d = DateTime.parse(iso);
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd.$mm.$yyyy';
  }

}
