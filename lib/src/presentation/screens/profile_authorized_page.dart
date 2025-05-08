import 'dart:developer' as developer;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    try {
      final api = context.read<ApiService>();
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

  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const LanguageSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
          body: Center(child: Text('error'.tr(args: [_error!])))
      );
    }

    final lastName   = (_profile!['last_name']   ?? '').toString();
    final firstName  = (_profile!['first_name']  ?? '').toString();
    final middleName = (_profile!['middle_name'] ?? '').toString();
    final phone      = (_profile!['phonenumber'] ?? '').toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('profile').tr(),
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
            iconPath: 'assets/ic_edit.svg',
            textKey: 'edit_data',
            onTap: () async {
              final updated = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => EditPersonalDataSheet(profile: _profile!),
              );
              if (updated == true) _loadProfile();
            },
          ),
          _buildProfileOption(
            iconPath: 'assets/ic_phone.svg',
            textKey: 'change_phone',
            onTap: () async {
              final entered = await showModalBottomSheet<_SmsArguments>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ChangePhoneNumberSheet(currentPhone: phone),
              );
              if (entered != null) {
                final verified = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ChangePhoneNumberCodeSheet(
                    verificationId: entered.verificationId,
                    newPhone: entered.newPhone,
                  ),
                );
                if (verified == true) _loadProfile();
              }
            },
          ),
          _buildProfileOption(
            iconPath: 'assets/ic_my_orders.svg',
            textKey: 'my_orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyOrdersPage()),
            ),
          ),
          _buildProfileOption(
            iconPath: 'assets/ic_kg_language.svg',
            textKey: 'change_language',
            iconColor: Colors.red,
            onTap: _showLanguageSheet,
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
                    MaterialPageRoute(
                      builder: (_) => const MainNavigation(initialIndex: 0),
                    ),
                  );
                },
                child: const Text(
                  'logout',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ).tr(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required String iconPath,
    required String textKey,
    Color iconColor = Colors.green,
    required VoidCallback onTap,
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
              textKey,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ).tr(),
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
class _SmsArguments {
  final String verificationId;
  final String newPhone;
  _SmsArguments(this.verificationId, this.newPhone);
}
class ChangePhoneNumberSheet extends StatefulWidget {
  final String currentPhone;
  const ChangePhoneNumberSheet({Key? key, required this.currentPhone}) : super(key: key);
  @override State<ChangePhoneNumberSheet> createState() => _ChangePhoneNumberSheetState();
}
class _ChangePhoneNumberSheetState extends State<ChangePhoneNumberSheet> {
  late final TextEditingController _ctrl;
  String? _verificationId;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.currentPhone);
  }
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool get _valid => _ctrl.text.trim().isNotEmpty;

  Future<void> _sendSms() async {
    setState(() => _sending = true);
    final phone = _ctrl.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('sms_error'.tr(args:[e.message!]))));
        setState(() => _sending = false);
      },
      codeSent: (verId, _) {
        _verificationId = verId;
        setState(() => _sending = false);
        // возвращаем и verificationId, и новый номер
        Navigator.pop(context, _SmsArguments(verId, phone));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.3, minChildSize: 0.2, maxChildSize: 0.8,
      builder: (_, scroll) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        child: SingleChildScrollView(
          controller: scroll,
          padding: EdgeInsets.only(left:16, right:16, top:16, bottom:bottom),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width:50, height:5, decoration: BoxDecoration(color:Colors.grey[400], borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height:12),
            const Center(child: Text('change_phone', style: TextStyle(fontFamily:'Gilroy', fontWeight:FontWeight.bold, fontSize:16))),
            const SizedBox(height:16),
            const Text('new_phone', style: TextStyle(fontFamily:'Gilroy', fontSize:14, color:Colors.black54)).tr(),
            const SizedBox(height:6),
            Container(
              height:48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: _valid ? const Color(0xFF148A09) : Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left:12),
                child: TextField(
                  controller: _ctrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontFamily:'Gilroy', fontSize:16),
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (_) => setState((){}),
                ),
              ),
            ),
            const SizedBox(height:24),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('cancel', style: TextStyle(fontFamily:'Gilroy', fontSize:16, color:Colors.black)).tr(),
                ),
              ),
              const SizedBox(width:12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48), backgroundColor: _valid ? const Color(0xFF148A09) : Colors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _valid && !_sending ? _sendSms : null,
                  child: _sending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('next', style: TextStyle(fontFamily:'Gilroy', fontSize:16, color:Colors.white, fontWeight: FontWeight.w600)).tr(),
                ),
              ),
            ]),
            const SizedBox(height:24),
          ]),
        ),
      ),
    );
  }
}

class ChangePhoneNumberCodeSheet extends StatefulWidget {
  final String verificationId;
  final String newPhone;
  const ChangePhoneNumberCodeSheet({
    Key? key,
    required this.verificationId,
    required this.newPhone,
  }) : super(key: key);

  @override
  State<ChangePhoneNumberCodeSheet> createState() => _ChangePhoneNumberCodeSheetState();
}

class _ChangePhoneNumberCodeSheetState extends State<ChangePhoneNumberCodeSheet> {
  final List<TextEditingController> _codeCtrls = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _verifying = false;

  bool get _allFilled => _codeCtrls.every((c) => c.text.isNotEmpty);
  String get _smsCode => _codeCtrls.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _codeCtrls) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() => _verifying = true);
    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _smsCode,
      );
      await FirebaseAuth.instance.currentUser!.updatePhoneNumber(cred);
      await context.read<ApiService>().updateProfile({'phonenumber': widget.newPhone});
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('verify_error'.tr(args:[e.toString()]))));
      setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.5, minChildSize: 0.3, maxChildSize: 0.8,
      builder: (_, scroll) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        child: SingleChildScrollView(
          controller: scroll,
          padding: EdgeInsets.only(left:16, right:16, top:16, bottom:bottom),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width:50, height:5, decoration: BoxDecoration(color:Colors.grey[400], borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height:12),
            const Center(child: Text('enter_code', style: TextStyle(fontFamily:'Gilroy', fontWeight:FontWeight.bold, fontSize:16))),
            const SizedBox(height:16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) => _buildBox(i)),
              ),
            ),
            const SizedBox(height:12),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _allFilled ? const Color(0xFF148A09) : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _allFilled && !_verifying ? _verify : null,
                child: _verifying
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('confirm', style: TextStyle(fontFamily:'Gilroy', fontWeight:FontWeight.w600, fontSize:16, color:Colors.white)).tr(),
              ),
            ),
            const SizedBox(height:24),
          ]),
        ),
      ),
    );
  }

  Widget _buildBox(int idx) {
    return Container(
      width:48, height:48,
      margin: EdgeInsets.only(right: idx<5?8:0),
      decoration: BoxDecoration(
        border: Border.all(color: _codeCtrls[idx].text.isNotEmpty ? const Color(0xFF148A09) : Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _codeCtrls[idx],
        focusNode: _focusNodes[idx],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
        style: const TextStyle(fontFamily:'Gilroy', fontSize:16),
        onChanged: (v) {
          if (v.length == 1 && idx < 5) _focusNodes[idx+1].requestFocus();
          if (v.isEmpty && idx > 0) _focusNodes[idx-1].requestFocus();
          setState(() {});
        },
      ),
    );
  }
}

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({Key? key}) : super(key: key);

  Future<void> _changeLocale(BuildContext ctx, Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);

    await ctx.setLocale(locale);

    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentCode = context.locale.languageCode; // 'ru' или 'ky'
    BoxDecoration chip(bool selected) => BoxDecoration(
      color: selected ? Colors.green[100] : Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'change_language',
            style: Theme.of(context).textTheme.titleMedium,
          ).tr(),
          const SizedBox(height: 12),

          // Кыргызча
          GestureDetector(
            onTap: () => _changeLocale(context, const Locale('ky')),
            child: Container(
              decoration: chip(currentCode == 'ky'),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Text('kg_language', style: const TextStyle(fontSize: 16)).tr(),
                  const Spacer(),
                  SvgPicture.asset('assets/ic_kg_language.svg', width: 20, height: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Русский
          GestureDetector(
            onTap: () => _changeLocale(context, const Locale('ru')),
            child: Container(
              decoration: chip(currentCode == 'ru'),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Text('ru_language', style: const TextStyle(fontSize: 16)).tr(),
                  const Spacer(),
                  SvgPicture.asset('assets/ic_ru_language.svg', width: 20, height: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}