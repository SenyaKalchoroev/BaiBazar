import 'package:flutter/material.dart';
import 'code_input_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'Авторизация',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Войти в приложение',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Добро пожаловать в Bai Bazar! Для\nтого, чтобы совершать заказы вам\nнужно войти',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              color: Color(0xFF707070),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Введите номер телефона',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '+996',
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CodeInputPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 88,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFF148A09),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Далее',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
