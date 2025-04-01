import 'package:baibazar_app/src/presentation/screens/profile_authorized_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileDataPage extends StatefulWidget {
  const ProfileDataPage({Key? key}) : super(key: key);

  @override
  State<ProfileDataPage> createState() => _ProfileDataPageState();
}

class _ProfileDataPageState extends State<ProfileDataPage> {
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController patronymicController = TextEditingController();

  bool get isAllFilled {
    return surnameController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        patronymicController.text.isNotEmpty;
  }

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
              _buildLabel('Фамилия'),
              const SizedBox(height: 6),
              _buildTextField(surnameController),
              const SizedBox(height: 16),
              _buildLabel('Имя'),
              const SizedBox(height: 6),
              _buildTextField(nameController),
              const SizedBox(height: 16),
              _buildLabel('Отчество'),
              const SizedBox(height: 6),
              _buildTextField(patronymicController),
              const SizedBox(height: 32),
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
                          const ProfileAuthorizedPage())
                      );
                    } : null,
                    child: const Text(
                      'Завершить регистрацию',
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 14,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.text.isNotEmpty ? const Color(0xFF148A09) : Colors.grey,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              hintText: 'Напишите...',
              border: InputBorder.none,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ),
    );
  }
}