import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_service.dart';
import 'profile_data_page.dart';

class CodeInputPage extends StatefulWidget {
  final String phone; // ← номер вида +996XXXXXXXXX

  const CodeInputPage({Key? key, required this.phone}) : super(key: key);

  @override
  State<CodeInputPage> createState() => _CodeInputPageState();
}

class _CodeInputPageState extends State<CodeInputPage> {
  final List<TextEditingController> _c =
  List.generate(4, (_) => TextEditingController());
  bool _loading = false;

  bool get _filled => _c.every((t) => t.text.isNotEmpty);

  String get _code => _c.map((e) => e.text).join();

  Future<void> _verify() async {
    final api = context.read<ApiService>();

    setState(() => _loading = true);
    try {
      await api.verifyCode(widget.phone, _code);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileDataPage(phone: widget.phone),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
              icon: SvgPicture.asset('assets/ic_arrow_back.svg',
                  width: 24, height: 24),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Авторизация',
          style: TextStyle(
              fontFamily: 'Gilroy', fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) => _box(i)),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _filled ? const Color(0xFF148A09) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _filled && !_loading ? _verify : null,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _box(int i) {
    return Container(
      width: 56,
      height: 56,
      margin: EdgeInsets.only(right: i < 3 ? 12 : 0),
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
          autofocus: i == 0,
          textAlign: TextAlign.center,
          maxLength: 1,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              counterText: '', border: InputBorder.none),
          onChanged: (val) {
            setState(() {});
            if (val.isNotEmpty && i < 3) {
              FocusScope.of(context).nextFocus();
            }
            if (val.isEmpty && i > 0) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }
}