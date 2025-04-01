import 'package:baibazar_app/src/presentation/screens/profile_data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CodeInputPage extends StatefulWidget {
  const CodeInputPage({Key? key}) : super(key: key);

  @override
  State<CodeInputPage> createState() => _CodeInputPageState();
}

class _CodeInputPageState extends State<CodeInputPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
        (_) => TextEditingController(),
  );

  bool get isAllFilled => _controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.grey[300],
            shape: const CircleBorder(),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/ic_arrow_back.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Авторизация',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                    'Код из SMS',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    6,
                        (index) => _buildOtpBox(index),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Не пришел код?',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Повторить через ',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '01:20',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAllFilled ? const Color(0xFF148A09) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isAllFilled ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder:(_)=>
                          const ProfileDataPage())
                      );
                    } : null,
                    child: const Text(
                      'Подтвердить',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 48,
      height: 48,
      margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _controllers[index].text.isNotEmpty
              ? const Color(0xFF148A09)
              : Colors.grey[300]!,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }
}
