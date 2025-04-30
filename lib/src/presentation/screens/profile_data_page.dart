import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_service.dart';
import 'main_navigation.dart';

class ProfileDataPage extends StatefulWidget {
  final String phone;
  const ProfileDataPage({Key? key, required this.phone}) : super(key: key);

  @override
  State<ProfileDataPage> createState() => _ProfileDataPageState();
}

class _ProfileDataPageState extends State<ProfileDataPage> {
  final _surname    = TextEditingController();
  final _name       = TextEditingController();
  final _patronymic = TextEditingController();
  bool _loading = false;

  bool get _filled =>
      _surname.text.isNotEmpty &&
          _name.text.isNotEmpty &&
          _patronymic.text.isNotEmpty;

  Future<void> _finish() async {
    final api = context.read<ApiService>();

    setState(() => _loading = true);

    await api.init();

    try {
      await api.updateProfile({
        'first_name': _name.text,
        'middle_name': _patronymic.text,
        'last_name': _surname.text,
        'phonenumber': widget.phone,
      });

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigation(initialIndex: 3),
        ),
            (_) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputBorder border(TextEditingController c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: c.text.isNotEmpty ? const Color(0xFF148A09) : Colors.grey,
      ),
    );

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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),

              _field(
                label: 'Фамилия',
                c: _surname,
                border: border(_surname),
              ),
              const SizedBox(height: 16),

              _field(
                label: 'Имя',
                c: _name,
                border: border(_name),
              ),
              const SizedBox(height: 16),

              _field(
                label: 'Отчество',
                c: _patronymic,
                border: border(_patronymic),
              ),
              const SizedBox(height: 32),

              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _filled
                        ? const Color(0xFF148A09)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _filled && !_loading ? _finish : null,
                  child: _loading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text(
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController c,
    required InputBorder border,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 14,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: c,
            decoration: InputDecoration(border: border),
            onChanged: (_) => setState(() {}),
          ),
        ],
      );
}
