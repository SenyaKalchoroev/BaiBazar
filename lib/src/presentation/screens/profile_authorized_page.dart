import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'package:flutter_svg/flutter_svg.dart';
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
    final api = context.read<ApiService>();
    try {
      await api.init();
      final data = await api.getProfile();
      print('🛰 Получен профиль: $data');
      developer.log('🛰 Получен профиль: $data ',name: 'CodeInputPage');
      setState(() {
        _profile = data;
        _loading = false;
      });
    } catch (e) {
      print('❌ Ошибка при получении profile: $e');
      developer.log('🛰 Получен профиль: $e ',name: 'CodeInputPage');
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Ошибка: $_error')),
      );
    }

    final lastName   = (_profile?['last_name']   ?? '').toString();
    final firstName  = (_profile?['first_name']  ?? '').toString();
    final middleName = (_profile?['middle_name'] ?? '').toString();
    final phone      = (_profile?['phonenumber'] ?? '').toString();

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
          _buildProfileOption(
            context,
            'Редактировать личные данные',
            'assets/ic_edit.svg',
            onTap: () => _showEditPersonalDataSheet(context),
          ),
          _buildProfileOption(
            context,
            'Сменить номер телефона',
            'assets/ic_phone.svg',
            onTap: () => _showChangePhoneNumberSheet(context),
          ),
          _buildProfileOption(
            context,
            'Мои заказы',
            'assets/ic_my_orders.svg',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyOrdersPage()),
            ),
          ),
          _buildProfileOption(
            context,
            'Сменить язык',
            'assets/ic_kg_language.svg',
            iconColor: Colors.red,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5E5E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
      BuildContext context, String text, String iconPath,
      {Color iconColor = Colors.green, VoidCallback? onTap}) {
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
                child: iconPath.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: iconColor == Colors.red
                      ? Icon(Icons.g_translate, color: iconColor, size: 16)
                      : SvgPicture.asset(iconPath, width: 16, height: 16),
                )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );

  }

  void _showEditPersonalDataSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const EditPersonalDataSheet(),
    );
  }

  void _showChangePhoneNumberSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const ChangePhoneNumberSheet(),
    );
  }
}


class EditPersonalDataSheet extends StatefulWidget {
  const EditPersonalDataSheet({Key? key}) : super(key: key);

  @override
  State<EditPersonalDataSheet> createState() => _EditPersonalDataSheetState();
}

class _EditPersonalDataSheetState extends State<EditPersonalDataSheet> {
  final TextEditingController surnameController = TextEditingController(text: 'Маликов');
  final TextEditingController nameController = TextEditingController(text: 'Эрмек');
  final TextEditingController patronymicController = TextEditingController(text: 'Мирланович');

  bool get isAllFilled {
    return surnameController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        patronymicController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: bottomInset,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
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
                _buildLabel('Фамилия'),
                const SizedBox(height: 6),
                _buildTextField(surnameController),
                const SizedBox(height: 12),
                _buildLabel('Имя'),
                const SizedBox(height: 6),
                _buildTextField(nameController),
                const SizedBox(height: 12),
                _buildLabel('Отчество'),
                const SizedBox(height: 6),
                _buildTextField(patronymicController),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Отмена',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isAllFilled ? const Color(0xFF148A09) : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isAllFilled ? () => Navigator.pop(context) : null,
                          child: const Text(
                            'Сохранить',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 14,
        color: Colors.black.withOpacity(0.7),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
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
            border: InputBorder.none,
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }
}

class ChangePhoneNumberSheet extends StatefulWidget {
  const ChangePhoneNumberSheet({Key? key}) : super(key: key);

  @override
  State<ChangePhoneNumberSheet> createState() => _ChangePhoneNumberSheetState();
}

class _ChangePhoneNumberSheetState extends State<ChangePhoneNumberSheet> {
  final TextEditingController phoneController = TextEditingController();
  bool get isFilled => phoneController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: bottomInset,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Сменить номер телефона',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Новый номер телефона',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isFilled ? const Color(0xFF148A09) : Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Отмена',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isFilled ? const Color(0xFF148A09) : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isFilled
                              ? () {
                            Navigator.pop(context);
                            _showChangePhoneCodeSheet(context);
                          }
                              : null,
                          child: const Text(
                            'Далее',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangePhoneCodeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ChangePhoneNumberCodeSheet(
        newPhoneNumber: phoneController.text,
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

  bool get isAllFilled => _codeControllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: bottomInset,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Сменить номер телефона',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Код из SMS на номер ${widget.newPhoneNumber}',
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(6, (index) => _buildCodeBox(index)),
                ),
                const SizedBox(height: 12),
                Row(
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
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isAllFilled ? const Color(0xFF148A09) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isAllFilled ? () => Navigator.pop(context) : null,
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCodeBox(int index) {
    return Container(
      width: 48,
      height: 48,
      margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _codeControllers[index].text.isNotEmpty
              ? const Color(0xFF148A09)
              : Colors.grey,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _codeControllers[index],
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