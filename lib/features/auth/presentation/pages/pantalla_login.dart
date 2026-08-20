import 'package:flutter/material.dart';

import '../../../client/presentation/theme/colores_cliente.dart';
import '../../data/repositories/repositorio_autenticacion_supabase.dart';
import '../../domain/entities/usuario_autenticado.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key, required this.onSesionIniciada});

  final ValueChanged<UsuarioAutenticado> onSesionIniciada;

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _repositorio = const RepositorioAutenticacionSupabase();

  var _cargando = false;
  var _ocultarContrasena = true;

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate() || _cargando) {
      return;
    }

    setState(() => _cargando = true);

    try {
      final usuario = await _repositorio.iniciarSesion(
        correo: _correoController.text.trim(),
        contrasena: _contrasenaController.text,
      );

      if (!mounted) {
        return;
      }

      widget.onSesionIniciada(usuario);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Correo o contrasena incorrectos.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: ClientColors.surfaceSoft,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClientColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _LoginBrand(),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: ClientColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ClientColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.28),
                          blurRadius: 28,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Iniciar sesion',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ingresa con tu cuenta para continuar.',
                            style: TextStyle(
                              color: ClientColors.textMuted,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 22),
                          TextFormField(
                            controller: _correoController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              label: 'Correo electronico',
                              icon: Icons.mail_outline,
                            ),
                            validator: (value) {
                              final correo = value?.trim() ?? '';
                              if (correo.isEmpty || !correo.contains('@')) {
                                return 'Ingresa un correo valido.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _contrasenaController,
                            obscureText: _ocultarContrasena,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _iniciarSesion(),
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              label: 'Contrasena',
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                tooltip: _ocultarContrasena
                                    ? 'Mostrar contrasena'
                                    : 'Ocultar contrasena',
                                onPressed: () {
                                  setState(() {
                                    _ocultarContrasena = !_ocultarContrasena;
                                  });
                                },
                                icon: Icon(
                                  _ocultarContrasena
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if ((value ?? '').length < 6) {
                                return 'La contrasena debe tener minimo 6 caracteres.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: ClientColors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _cargando ? null : _iniciarSesion,
                            icon: _cargando
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.login),
                            label: Text(_cargando ? 'Verificando' : 'Entrar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginBrand extends StatelessWidget {
  const _LoginBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ClientColors.red,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: ClientColors.red.withValues(alpha: 0.28),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: const Text(
            'GP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'GymPro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Gestion de entrenamiento para usuarios y administradores.',
          style: TextStyle(color: ClientColors.textMuted, height: 1.35),
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  required IconData icon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: ClientColors.textMuted),
    prefixIcon: Icon(icon, color: ClientColors.red),
    suffixIcon: suffixIcon,
    suffixIconColor: ClientColors.textMuted,
    filled: true,
    fillColor: ClientColors.surfaceSoft,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ClientColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ClientColors.red, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ClientColors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ClientColors.red, width: 1.4),
    ),
  );
}
