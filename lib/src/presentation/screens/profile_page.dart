import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_service.dart';
import 'code_input_page.dart';
import 'profile_data_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;

  bool get _valid => _phoneController.text.length == 9;

  Future<void> _sendPhone() async {
    final phone = '+996${_phoneController.text}';
    setState(() => _loading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential cred) async {
        try {
          final u = await _auth.signInWithCredential(cred);
          final idToken = await u.user!.getIdToken();
          await context.read<ApiService>().registerAuthenticate(
            idToken: idToken!,
            phone: phone,
          );
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfileDataPage()),
          );
        } catch (_) {
        }
      },

      verificationFailed: (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ошибка: ${e.message}')));
      },

      codeSent: (verificationId, _) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CodeInputPage(
              phone: phone,
              verificationId: verificationId,
            ),
          ),
        );
      },

      codeAutoRetrievalTimeout: (_) {},
    );

    if (mounted) setState(() => _loading = false);
  }

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
                    const Expanded(
                      child: Text(
                        'Войти в приложение\n\nДобро пожаловать в Bai Bazar! '
                            'Для того, чтобы совершать заказы вам нужно войти',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 14,
                          color: Color(0xFF707070),
                          height: 1.3,
                        ),
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
                    border: Border.all(color: _valid ? Colors.green : Colors.grey),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '+996',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 16,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 0,
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            maxLength: 9,
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: 'XXX XXXX',
                            ),
                            style: const TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _valid && !_loading ? _sendPhone : null,
                        child: Container(
                          width: 88,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: _valid ? const Color(0xFF148A09) : Colors.grey,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: _loading
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : const Text(
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
