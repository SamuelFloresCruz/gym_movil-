import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/configuracion_supabase.dart';

class ServicioSupabase {
  const ServicioSupabase._();

  static var _inicializado = false;

  static bool get estaInicializado => _inicializado;

  static SupabaseClient get cliente {
    if (!_inicializado) {
      throw StateError(
        'Supabase no esta inicializado. Agrega tus credenciales en '
        'lib/core/config/configuracion_supabase.dart',
      );
    }

    return Supabase.instance.client;
  }

  static Future<void> inicializar() async {
    if (!ConfiguracionSupabase.estaConfigurado) {
      return;
    }

    await Supabase.initialize(
      url: ConfiguracionSupabase.url,
      publishableKey: ConfiguracionSupabase.clavePublica,
    );

    _inicializado = true;
  }
}
