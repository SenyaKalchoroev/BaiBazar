// lib/src/presentation/screens/profile_authorized_page.dart

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_service.dart';
import 'my_orders_page.dart';
import 'main_navigation.dart';

class ProfileAuthorizedPage extends StatefulWidget {
  const ProfileAuthorizedPage({Key? key}) : super(key: key);

  @override
  State<ProfileAuthorizedPage> createState() => _ProfileAuthorizedPageState();
}

class _ProfileAuthorizedPageState extends State<ProfileAuthorizedPage> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final api = context.read<ApiService>();
    try {
      await api.init();
      final data = await api.getProfile();
      developer.log('🛰 Profile loaded: $data', name: 'Profile');
      setState(() {
        _profile = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(body: Center(child: Text('Ошибка: $_error')));
    }

    final lastName   = (_profile!['last_name']   ?? '').toString();
    final firstName  = (_profile!['first_name']  ?? '').toString();
    final middleName = (_profile!['middle_name'] ?? '').toString();
    final phone      = (_profile!['phonenumber'] ?? '').toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Профиль',
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
      ),
      body: Column(
        children: [
          // header with name + phone
          Container(
            width: double.infinity,
            color: const Color(0xFFF5F5F5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$lastName $firstName $middleName',
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone.isNotEmpty ? phone : '—',
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF707070),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Edit personal data
          _buildProfileOption(
            'Редактировать личные данные',
            'assets/ic_edit.svg',
            onTap: () async {
              final updated = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => EditPersonalDataSheet(profile: _profile!),
              );
              if (updated == true) {
                _loadProfile();
              }
            },
          ),

          // Change phone number
          _buildProfileOption(
            'Сменить номер телефона',
            'assets/ic_phone.svg',
            onTap: () async {
              final updated = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ChangePhoneNumberSheet(
                  currentPhone: phone,
                ),
              );
              if (updated == true) {
                _loadProfile();
              }
            },
          ),

          // My orders
          _buildProfileOption(
            'Мои заказы',
            'assets/ic_my_orders.svg',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyOrdersPage()),
            ),
          ),

          _buildProfileOption(
            'Сменить язык',
            'assets/ic_kg_language.svg',
            iconColor: Colors.red,
            onTap: () {
              // TODO: implement language switching
            },
          ),

          const Spacer(),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5E5E5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  context.read<ApiService>().clearToken();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 0)),
                  );
                },
                child: const Text(
                  'Выйти',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
      String text,
      String iconPath, {
        Color iconColor = Colors.green,
        VoidCallback? onTap,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: iconColor == Colors.red
                    ? Icon(Icons.g_translate, color: iconColor, size: 16)
                    : SvgPicture.asset(iconPath, width: 16, height: 16),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class EditPersonalDataSheet extends StatefulWidget {
  final Map<String, dynamic> profile;
  const EditPersonalDataSheet({Key? key, required this.profile}) : super(key: key);

  @override
  State<EditPersonalDataSheet> createState() => _EditPersonalDataSheetState();
}

class _EditPersonalDataSheetState extends State<EditPersonalDataSheet> {
  late final TextEditingController surnameController;
  late final TextEditingController nameController;
  late final TextEditingController patronymicController;

  @override
  void initState() {
    super.initState();
    surnameController    = TextEditingController(text: widget.profile['last_name']   as String? ?? '');
    nameController       = TextEditingController(text: widget.profile['first_name']  as String? ?? '');
    patronymicController = TextEditingController(text: widget.profile['middle_name'] as String? ?? '');
  }

  bool get isAllFilled =>
      surnameController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          patronymicController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final api = context.read<ApiService>();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SingleChildScrollView(
          controller: scrollCtrl,
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Редактировать личные данные',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Фамилия', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              _buildTextField(surnameController),

              const SizedBox(height: 12),
              const Text('Имя', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              _buildTextField(nameController),

              const SizedBox(height: 12),
              const Text('Отчество', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              _buildTextField(patronymicController),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Отмена', style: TextStyle(fontFamily: 'Gilroy', fontSize: 16, color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: isAllFilled ? const Color(0xFF148A09) : Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: isAllFilled
                          ? () async {
                        await api.updateProfile({
                          'last_name':   surnameController.text,
                          'first_name':  nameController.text,
                          'middle_name': patronymicController.text,
                        });
                        Navigator.pop(context, true);
                      }
                          : null,
                      child: const Text('Сохранить',
                        style: TextStyle(fontFamily: 'Gilroy', fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController c) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.text.isNotEmpty ? const Color(0xFF148A09) : Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: TextField(
          controller: c,
          style: const TextStyle(fontFamily: 'Gilroy', fontSize: 16),
          decoration: const InputDecoration(border: InputBorder.none),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }
}

/// Bottom sheet for changing phone number
class ChangePhoneNumberSheet extends StatefulWidget {
  final String currentPhone;
  const ChangePhoneNumberSheet({Key? key, required this.currentPhone}) : super(key: key);

  @override
  State<ChangePhoneNumberSheet> createState() => _ChangePhoneNumberSheetState();
}

class _ChangePhoneNumberSheetState extends State<ChangePhoneNumberSheet> {
  late final TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.currentPhone);
  }

  bool get isFilled => phoneController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SingleChildScrollView(
          controller: scrollCtrl,
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Сменить номер телефона',
                  style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Новый номер телефона', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isFilled ? const Color(0xFF148A09) : Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontFamily: 'Gilroy', fontSize: 16),
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Напишите...'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Отмена', style: TextStyle(fontFamily: 'Gilroy', fontSize: 16, color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: isFilled ? const Color(0xFF148A09) : Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: isFilled
                          ? () {
                        Navigator.pop(context, true);
                        showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ChangePhoneNumberCodeSheet(newPhoneNumber: phoneController.text),
                        ).then((ok) {
                          if (ok == true) {
                            Navigator.pop(context, true);
                          }
                        });
                      }
                          : null,
                      child: const Text('Далее', style: TextStyle(fontFamily: 'Gilroy', fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePhoneNumberCodeSheet extends StatefulWidget {
  final String newPhoneNumber;
  const ChangePhoneNumberCodeSheet({Key? key, required this.newPhoneNumber}) : super(key: key);

  @override
  State<ChangePhoneNumberCodeSheet> createState() => _ChangePhoneNumberCodeSheetState();
}

class _ChangePhoneNumberCodeSheetState extends State<ChangePhoneNumberCodeSheet> {
  final List<TextEditingController> _codeControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool get isAllFilled => _codeControllers.every((c) => c.text.isNotEmpty);

  @override
  void dispose() {
    for (final c in _codeControllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final api = context.read<ApiService>();

    return DraggableScrollableSheet(
      initialChildSize: 0.5, // чуть выше открывается
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SingleChildScrollView(
          controller: scrollCtrl,
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Сменить номер телефона',
                  style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Код из SMS на номер ${widget.newPhoneNumber}',
                style: const TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 12),

              // OTP input boxes centered
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) => _buildCodeBox(index)),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Не пришел код?', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Повторить', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.green)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAllFilled ? const Color(0xFF148A09) : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isAllFilled
                      ? () async {
                    await api.updateProfile({'phonenumber': widget.newPhoneNumber});
                    Navigator.pop(context, true);
                  }
                      : null,
                  child: const Text(
                    'Подтвердить',
                    style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
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

  Widget _buildCodeBox(int index) {
    return Container(
      width: 48, height: 48,
      margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _codeControllers[index].text.isNotEmpty ? const Color(0xFF148A09) : Colors.grey),
      ),
      child: TextField(
        controller: _codeControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontFamily: 'Gilroy', fontSize: 16),
        decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }
}

