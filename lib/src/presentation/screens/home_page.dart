import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Поиск',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Категории',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _CategoryItem(imageUrl: 'https://via.placeholder.com/50', title: 'Молочка'),
                    _CategoryItem(imageUrl: 'https://via.placeholder.com/50', title: 'Овощи'),
                    _CategoryItem(imageUrl: 'https://via.placeholder.com/50', title: 'Фрукты'),
                    _CategoryItem(imageUrl: 'https://via.placeholder.com/50', title: 'Мясо'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Продукты',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Новые',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                childAspectRatio: 0.8,
                children: const [
                  _ProductCard(
                    imageUrl: 'https://via.placeholder.com/100',
                    title: 'Свежие огурцы',
                    price: '80c',
                  ),
                  _ProductCard(
                    imageUrl: 'https://via.placeholder.com/100',
                    title: 'Помидоры',
                    price: '80c',
                  ),
                  _ProductCard(
                    imageUrl: 'https://via.placeholder.com/100',
                    title: 'Свежие огурцы',
                    price: '80c',
                  ),
                  _ProductCard(
                    imageUrl: 'https://via.placeholder.com/100',
                    title: 'Помидоры',
                    price: '80c',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  const _CategoryItem({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 25,
          ),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const _ProductCard({required this.imageUrl, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Цена за 1kg', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(price, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
