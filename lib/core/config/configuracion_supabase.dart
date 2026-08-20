class ConfiguracionSupabase {
  const ConfiguracionSupabase._();

  static const url = 'https://ozayqcgxplpsquzyghxe.supabase.co';
  static const clavePublica = 'sb_publishable_oGfrpiSx7Qa-RAkrzxmrjQ_HaWtPKPt';

  static bool get estaConfigurado {
    return url.trim().isNotEmpty && clavePublica.trim().isNotEmpty;
  }
}
