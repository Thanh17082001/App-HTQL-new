import 'package:app_flutter/ui/auth/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthType { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final AuthType _authType = AuthType.login;
  late String mes;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ValueNotifier<bool> isLogin = ValueNotifier<bool>(true);
  final _passwordController = TextEditingController();
  final _isSubmitting = ValueNotifier<bool>(false);
  final Map<String, String> _authData = {
    'tenDangNhap': '',
    'matKhau': '',
  };

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    _isSubmitting.value = true;

    try {
      if (_authType == AuthType.login) {
        await context
            .read<AuthManager>()
            .login(_authData['tenDangNhap'], _authData['matKhau']);

        // ignore: use_build_context_synchronously
        if (context.read<AuthManager>().isLogin) {
          setState(() {
            isLogin.value = true;
          });
        } else {
          setState(() {
            isLogin.value = false;
            mes = 'Tài khoản hoặc mật khẩu không chính xác';
            _passwordController.text = '';
          });
        }
      }
    } catch (e) {
      setState(() {
            isLogin.value = false;
            mes = 'Thử lại sau!';
            _passwordController.text = '';
          });
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ValueListenableBuilder<bool>(
              valueListenable: isLogin,
              builder: (context, _isLogin, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isLogin.value)
                      Text(
                        mes,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(
                      height: 20.0,
                      child: Text('Tên đăng nhập'),
                    ),
                    _userNameField(),
                    const SizedBox(height: 15.0),
                    const SizedBox(
                      height: 20.0,
                      child: Text('Mật khẩu'),
                    ),
                    _passField(),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    submitButton(),
                  ],
                );
              }),
        ));
  }

  Widget _userNameField() {
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12)),
        hintText: 'Nhập tên đăng nhập của bạn',
        fillColor: Colors.blue[50],
        filled: true,
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Không được bỏ trống';
        } else {
          return null;
        }
      },
      onSaved: (newValue) {
        _authData['tenDangNhap'] = newValue!;
      },
    );
  }


  Widget _passField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập mật khẩu của bạn',
          fillColor: Colors.blue[50],
          filled: true),
      obscureText: true,
      keyboardType: TextInputType.text,
      controller: _passwordController,
      validator: (value) {
        if (value == null) {
          return 'Mật khẩu không được để trống';
        }
        return null;
      },
      onSaved: (value) {
        _authData['matKhau'] = value!;
      },
    );
  }


  Widget submitButton() {
    return GestureDetector(
      onTap: _submitForm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 60.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.blue[200]),
        child: Center(
          child: Text(
            _authType == AuthType.login ? 'Đăng nhập' : 'Đăng ký',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
