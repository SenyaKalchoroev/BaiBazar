// lib/src/presentation/screens/order_details_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_service.dart';
import '../providers/order_provider.dart';
import '../../data/models/order_detail.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;
  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrderProvider>().loadOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Детали заказа',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : prov.detail == null
          ? const Center(child: Text('Ошибка загрузки'))
          : _buildBody(context, prov.detail!),
    );
  }

  Widget _buildBody(BuildContext ctx, OrderDetail order) {
    final api = ctx.read<ApiService>();

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: order.itemIds.length,
          itemBuilder: (c, i) {
            final productId = order.itemIds[i];
            return FutureBuilder<Map<String, dynamic>>(
              future: api.getProductById(productId),
              builder: (c, snap) {
                if (!snap.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final prod = snap.data!;

                final imgs = (prod['product'] as List)
                    .cast<Map<String, dynamic>>();
                final rel = imgs.isNotEmpty ? imgs[0]['image'] as String : '';
                final imgUrl = 'https://baibazar.pp.ua$rel';

                final title   = prod['title']  as String;
                final priceKg = prod['price']  as String;
                final qty     = prod['weight'] != null
                    ? '${prod['weight']}кг'
                    : '1';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imgUrl,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey, width: 72, height: 72),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Цена за кг: $priceKg',
                              style: const TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Количество: $qty',
                              style: const TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),

        DraggableScrollableSheet(
          initialChildSize: 0.15,
          minChildSize: 0.15,
          maxChildSize: 0.45,
          builder: (c, scroll) => Material(
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: SingleChildScrollView(
              controller: scroll,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildInfoRow('Ваш курьер', order.fullName ?? '—'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Телефон', order.phone ?? '—'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Дата', _fmt(order.date)),
                    const SizedBox(height: 12),
                    _buildInfoRow('Статус', order.status),
                    const SizedBox(height: 12),
                    _buildInfoRow('Цена за продукты',
                        '${order.totalPrice.toStringAsFixed(0)}c'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Цена за доставку', '50c'),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Итого',
                      '${(order.totalPrice + 50).toStringAsFixed(0)}c',
                      valueStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value,
      {TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Gilroy', fontSize: 14)),
        Text(value,
            style: valueStyle ??
                const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _fmt(DateTime d) {
    final dd   = d.day.toString().padLeft(2, '0');
    final mm   = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd.$mm.$yyyy';
  }
}
