import 'package:chat_ads/theme/colors.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final AuthController controller = AuthController();

  bool loading = false;

  Future<void> _login() async {
    setState(() => loading = true);

    final result = await controller.login(
      emailController.text.trim(),
      senhaController.text.trim(),
    );

    setState(() => loading = false);

    if (!mounted) return;

    if (result.success) {
      Navigator.pushReplacementNamed(context, "/chat");
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // centraliza verticalmente
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png", width: 150),
                SizedBox(height: 20),
                CustomTextField(
                  controller: emailController,
                  label: "Email",
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: senhaController,
                  label: "Senha",
                  obscure: true,
                ),
                const SizedBox(height: 20),

                CustomButton(
                  text: "Entrar",
                  loading: loading,
                  onPressed: _login,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta? "),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/register"),
                      child: const Text(
                        "Cadastre-se",
                        style: TextStyle(
                          color: AppColors.link,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
