// lib/src/presentation/screens/code_input_page.dart

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/api/api_service.dart';
import 'profile_data_page.dart';

class CodeInputPage extends StatefulWidget {
  final String phone;
  final String verificationId;
  const CodeInputPage({
    Key? key,
    required this.phone,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<CodeInputPage> createState() => _CodeInputPageState();
}

class _CodeInputPageState extends State<CodeInputPage> {
  final List<TextEditingController> _c =
  List.generate(6, (_) => TextEditingController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  bool get _filled => _c.every((t) => t.text.isNotEmpty);
  String get _smsCode => _c.map((e) => e.text).join();

  Future<void> _verify() async {
    setState(() => _loading = true);
    try {
      final smsCode = _smsCode;
      developer.log('🔑 SMS Code: $smsCode', name: 'CodeInputPage');

      final cred = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      try {
        await _auth.signInWithCredential(cred);
      } catch (e) {
        developer.log('⚠️ signInWithCredential failed, but ignoring: $e',
            name: 'CodeInputPage');
      }

      final user = _auth.currentUser;
      if (user == null) throw Exception('Нет текущего пользователя Firebase');
      final firebaseUid = user.uid;
      developer.log('🔥 Firebase UID: $firebaseUid', name: 'CodeInputPage');

      final idToken = await user.getIdToken();
      developer.log('📨 Firebase ID Token: $idToken', name: 'CodeInputPage');

      await context.read<ApiService>().registerAuthenticate(
        idToken: firebaseUid.toString(),
        phone: widget.phone,
      );
    } catch (e) {
      developer.log('❌ _verify error: $e', name: 'CodeInputPage');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget box(int i) => Container(
      width: 48,
      height: 48,
      margin: EdgeInsets.only(right: i < 5 ? 8 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _c[i].text.isNotEmpty
              ? const Color(0xFF148A09)
              : Colors.grey[300]!,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _c[i],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 16,
          ),
          onChanged: (v) {
            setState(() {});
            if (v.isNotEmpty && i < 5) {
              FocusScope.of(context).nextFocus();
            } else if (v.isEmpty && i > 0) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
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
        child: Column(
          children: [
            const SizedBox(height: 24),
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
              child: Row(children: List.generate(6, box)),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _filled ? const Color(0xFF148A09) : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _filled && !_loading
                      ? () async {
                    await _verify();
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ProfileDataPage()),
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
          ],
        ),
      ),
    );
  }
}
