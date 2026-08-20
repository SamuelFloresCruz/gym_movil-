import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/servicios/servicio_supabase.dart';
import '../../domain/entities/usuario_autenticado.dart';

class RepositorioAutenticacionSupabase {
  const RepositorioAutenticacionSupabase();

  SupabaseClient get _cliente => ServicioSupabase.cliente;

  Future<UsuarioAutenticado?> obtenerUsuarioActual() async {
    if (!ServicioSupabase.estaInicializado) {
      return null;
    }

    final usuario = _cliente.auth.currentUser;
    if (usuario == null) {
      return null;
    }

    return _obtenerPerfil(usuario.id, usuario.email ?? '');
  }

  Future<UsuarioAutenticado> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    final respuesta = await _cliente.auth.signInWithPassword(
      email: correo,
      password: contrasena,
    );

    final usuario = respuesta.user;
    if (usuario == null) {
      throw const AuthException('No se pudo iniciar sesion.');
    }

    return _obtenerPerfil(usuario.id, usuario.email ?? correo);
  }

  Future<void> cerrarSesion() async {
    if (!ServicioSupabase.estaInicializado) {
      return;
    }

    await _cliente.auth.signOut();
  }

  Future<UsuarioAutenticado> _obtenerPerfil(
    String usuarioId,
    String correo,
  ) async {
    final perfil = await _cliente
        .from('perfiles')
        .select('id, id_publico, nombre_completo, correo, rol')
        .eq('id', usuarioId)
        .single();

    return UsuarioAutenticado(
      id: perfil['id'] as String,
      correo: (perfil['correo'] as String?) ?? correo,
      nombreCompleto:
          (perfil['nombre_completo'] as String?) ?? 'Usuario GymPro',
      rol: (perfil['rol'] as String?) ?? 'usuario',
      idPublico: (perfil['id_publico'] as String?) ?? '',
    );
  }
}
