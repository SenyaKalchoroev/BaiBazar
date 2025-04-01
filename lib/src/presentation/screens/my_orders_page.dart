import 'package:baibazar_app/src/presentation/screens/order_details_page.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> mockOrders = [
    {
      'date': '30.01.25',
      'status': 'В процессе',
      'price': '80c',
    },
    {
      'date': '30.01.25',
      'status': 'В процессе',
      'price': '80c',
    },
    {
      'date': '30.01.25',
      'status': 'В процессе',
      'price': '80c',
    },
    {
      'date': '30.01.25',
      'status': 'В процессе',
      'price': '80c',
    },
    {
      'date': '30.01.25',
      'status': 'В процессе',
      'price': '80c',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildOrderItem(Map<String, String> order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Дата: ${order['date']}',
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
                        text: order['price'],
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    order['status'] ?? '',
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
                      MaterialPageRoute(builder:(_)=>
                      const OrderDetailsPage())
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

  Widget _buildOrdersList(String tabType) {
    return ListView.builder(
      itemCount: mockOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderItem(mockOrders[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            tabs: const [
              Tab(text: 'Новые'),
              Tab(text: 'В процессе'),
              Tab(text: 'Завершенные'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOrdersList('Новые'),
            _buildOrdersList('В процессе'),
            _buildOrdersList('Завершенные'),
          ],
        ),
      ),
    );
  }
}
