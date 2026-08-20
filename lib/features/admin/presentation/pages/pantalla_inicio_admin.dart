import 'package:flutter/material.dart';

import '../../../../core/servicios/servicio_supabase.dart';
import '../../../auth/domain/entities/usuario_autenticado.dart';
import '../../../client/presentation/theme/colores_cliente.dart';
import '../widgets/tarjeta_resumen_admin.dart';

class PantallaInicioAdmin extends StatefulWidget {
  const PantallaInicioAdmin({
    super.key,
    required this.usuario,
    required this.onCerrarSesion,
  });

  final UsuarioAutenticado usuario;
  final Future<void> Function() onCerrarSesion;

  @override
  State<PantallaInicioAdmin> createState() => _PantallaInicioAdminState();
}

class _PantallaInicioAdminState extends State<PantallaInicioAdmin> {
  late final Future<_ResumenAdmin> _resumen = _cargarResumen();

  Future<_ResumenAdmin> _cargarResumen() async {
    if (!ServicioSupabase.estaInicializado) {
      return const _ResumenAdmin();
    }

    final cliente = ServicioSupabase.cliente;

    Future<int> contar(String tabla) async {
      try {
        final datos = await cliente.from(tabla).select('id');
        return datos.length;
      } catch (_) {
        return 0;
      }
    }

    final resultados = await Future.wait([
      contar('perfiles'),
      contar('musculos'),
      contar('ejercicios'),
      contar('rutinas'),
      contar('seguimientos_musculares'),
    ]);

    return _ResumenAdmin(
      usuarios: resultados[0],
      musculos: resultados[1],
      ejercicios: resultados[2],
      rutinas: resultados[3],
      seguimientos: resultados[4],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClientColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _AdminHeader(
                    nombre: widget.usuario.nombreCompleto,
                    correo: widget.usuario.correo,
                    onCerrarSesion: widget.onCerrarSesion,
                  ),
                  const SizedBox(height: 18),
                  FutureBuilder<_ResumenAdmin>(
                    future: _resumen,
                    builder: (context, snapshot) {
                      final resumen = snapshot.data ?? const _ResumenAdmin();
                      return _ResumenGrid(resumen: resumen);
                    },
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('Gestion principal'),
                  const SizedBox(height: 12),
                  const _AdminActionGrid(),
                  const SizedBox(height: 24),
                  const _SectionLabel('Actividad reciente'),
                  const SizedBox(height: 12),
                  const _ActivityPanel(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  const _AdminHeader({
    required this.nombre,
    required this.correo,
    required this.onCerrarSesion,
  });

  final String nombre;
  final String correo;
  final Future<void> Function() onCerrarSesion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ClientColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ClientColors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.admin_panel_settings, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Panel administrador',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$nombre - $correo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: ClientColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton.filled(
            tooltip: 'Cerrar sesion',
            style: IconButton.styleFrom(
              backgroundColor: ClientColors.surfaceSoft,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onCerrarSesion,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}

class _ResumenGrid extends StatelessWidget {
  const _ResumenGrid({required this.resumen});

  final _ResumenAdmin resumen;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      children: [
        TarjetaResumenAdmin(
          titulo: 'Usuarios',
          valor: '${resumen.usuarios}',
          icono: Icons.people_outline,
        ),
        TarjetaResumenAdmin(
          titulo: 'Musculos',
          valor: '${resumen.musculos}',
          icono: Icons.accessibility_new,
          color: ClientColors.warning,
        ),
        TarjetaResumenAdmin(
          titulo: 'Ejercicios',
          valor: '${resumen.ejercicios}',
          icono: Icons.fitness_center,
          color: ClientColors.success,
        ),
        TarjetaResumenAdmin(
          titulo: 'Rutinas',
          valor: '${resumen.rutinas}',
          icono: Icons.assignment_outlined,
        ),
      ],
    );
  }
}

class _AdminActionGrid extends StatelessWidget {
  const _AdminActionGrid();

  @override
  Widget build(BuildContext context) {
    const acciones = [
      _AdminAction(
        titulo: 'Usuarios',
        subtitulo: 'Administrar perfiles',
        icono: Icons.people_outline,
      ),
      _AdminAction(
        titulo: 'Musculos',
        subtitulo: 'Editar catalogo',
        icono: Icons.accessibility_new,
      ),
      _AdminAction(
        titulo: 'Ejercicios',
        subtitulo: 'Crear y actualizar',
        icono: Icons.fitness_center,
      ),
      _AdminAction(
        titulo: 'Rutinas',
        subtitulo: 'Gestionar planes',
        icono: Icons.assignment_outlined,
      ),
    ];

    return Column(
      children: [
        for (final accion in acciones) ...[
          _AdminActionTile(accion: accion),
          if (accion != acciones.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _AdminActionTile extends StatelessWidget {
  const _AdminActionTile({required this.accion});

  final _AdminAction accion;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ClientColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ClientColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: ClientColors.redSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(accion.icono, color: ClientColors.red),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accion.titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      accion.subtitulo,
                      style: const TextStyle(
                        color: ClientColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ClientColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ActivityRow(
            icono: Icons.person_add_alt,
            titulo: 'Nuevo usuario registrado',
            subtitulo: 'Pendiente de revision administrativa',
          ),
          SizedBox(height: 14),
          _ActivityRow(
            icono: Icons.fitness_center,
            titulo: 'Catalogo preparado',
            subtitulo: 'Musculos y ejercicios listos para gestionar',
          ),
          SizedBox(height: 14),
          _ActivityRow(
            icono: Icons.security,
            titulo: 'Acceso por roles',
            subtitulo: 'Usuario y administrador separados por perfil',
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, color: ClientColors.red, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitulo,
                style: const TextStyle(
                  color: ClientColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _AdminAction {
  const _AdminAction({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
  });

  final String titulo;
  final String subtitulo;
  final IconData icono;
}

class _ResumenAdmin {
  const _ResumenAdmin({
    this.usuarios = 0,
    this.musculos = 0,
    this.ejercicios = 0,
    this.rutinas = 0,
    this.seguimientos = 0,
  });

  final int usuarios;
  final int musculos;
  final int ejercicios;
  final int rutinas;
  final int seguimientos;
}
