import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_service.dart';
import 'main_navigation.dart';

class ProfileDataPage extends StatefulWidget {
  const ProfileDataPage({Key? key}) : super(key: key);

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
    setState(() => _loading = true);
    try {
      await context.read<ApiService>().updateProfile({
        'first_name':  _name.text,
        'middle_name': _patronymic.text,
        'last_name':   _surname.text,
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
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

    Widget field(String label, TextEditingController ctl) {
      return Column(
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
            controller: ctl,
            decoration: InputDecoration(border: border(ctl)),
            onChanged: (_) => setState(() {}),
          ),
        ],
      );
    }

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
              field('Фамилия', _surname),
              const SizedBox(height: 16),
              field('Имя', _name),
              const SizedBox(height: 16),
              field('Отчество', _patronymic),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _filled
                        ? const Color(0xFF148A09)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _filled && !_loading
                      ? () async {
                    // 1) Обновляем профиль (Bearer-токен уже установлен)
                    await _finish();
                    if (!mounted) return;
                    // 2) Переходим в основное приложение
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const MainNavigation(initialIndex: 3),
                      ),
                          (_) => false,
                    );
                  }
                      : null,
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
}
