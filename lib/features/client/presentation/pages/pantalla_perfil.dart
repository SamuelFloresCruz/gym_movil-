import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/colores_cliente.dart';
import '../widgets/tarjeta_estadistica_cliente.dart';
import '../widgets/titulo_seccion_cliente.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  var _name = 'Mauricio Alvarez';
  var _goal = 'Ganar masa muscular';
  var _level = 'Intermedio';
  var _weight = '72 kg';
  var _height = '1.74 m';

  static const _userId = '4829157';

  Future<void> _copyUserId() async {
    await Clipboard.setData(const ClipboardData(text: _userId));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('ID copiado al portapapeles.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: ClientColors.surfaceSoft,
        ),
      );
  }

  Future<void> _openEditProfile() async {
    final result = await showModalBottomSheet<_ProfileEditResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ClientColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _EditProfileSheet(
          name: _name,
          goal: _goal,
          level: _level,
          weight: _weight,
          height: _height,
        );
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      _name = result.name;
      _goal = result.goal;
      _level = result.level;
      _weight = result.weight;
      _height = result.height;
    });
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
                  _ProfileHeader(onEdit: _openEditProfile),
                  const SizedBox(height: 18),
                  _UserCard(
                    name: _name,
                    userId: _userId,
                    goal: _goal,
                    level: _level,
                    onCopyId: _copyUserId,
                  ),
                  const SizedBox(height: 18),
                  _ProfileStats(weight: _weight, height: _height),
                  const SizedBox(height: 24),
                  const ClientSectionTitle(title: 'Objetivo actual'),
                  const SizedBox(height: 12),
                  _GoalCard(goal: _goal, level: _level),
                  const SizedBox(height: 24),
                  const ClientSectionTitle(title: 'Progreso'),
                  const SizedBox(height: 12),
                  const _ProgressSummary(),
                  const SizedBox(height: 24),
                  const ClientSectionTitle(title: 'Cuenta'),
                  const SizedBox(height: 12),
                  _ProfileOptionTile(
                    icon: Icons.badge_outlined,
                    title: 'ID de usuario',
                    subtitle: _userId,
                    trailingIcon: Icons.copy_outlined,
                    onTap: _copyUserId,
                  ),
                  const SizedBox(height: 10),
                  const _ProfileOptionTile(
                    icon: Icons.lock_outline,
                    title: 'Seguridad',
                    subtitle: 'Contrasena y acceso',
                    trailingIcon: Icons.chevron_right,
                  ),
                  const SizedBox(height: 10),
                  const _ProfileOptionTile(
                    icon: Icons.settings_outlined,
                    title: 'Preferencias',
                    subtitle: 'Tema, idioma y unidades',
                    trailingIcon: Icons.chevron_right,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        IconButton.filled(
          tooltip: 'Editar perfil',
          style: IconButton.styleFrom(
            backgroundColor: ClientColors.surface,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.name,
    required this.userId,
    required this.goal,
    required this.level,
    required this.onCopyId,
  });

  final String name;
  final String userId;
  final String goal;
  final String level;
  final VoidCallback onCopyId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ClientColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 68,
                height: 68,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ClientColors.red,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: ClientColors.red.withValues(alpha: 0.28),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Text(
                  'MA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$level - $goal',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ClientColors.textMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Material(
            color: ClientColors.surfaceSoft,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: onCopyId,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code_2, color: ClientColors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ID para compartir rutinas',
                            style: TextStyle(
                              color: ClientColors.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            userId,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.copy_outlined, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({required this.weight, required this.height});

  final String weight;
  final String height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClientStatCard(
            value: weight,
            label: 'Peso',
            icon: Icons.monitor_weight_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClientStatCard(
            value: height,
            label: 'Altura',
            icon: Icons.height,
            color: ClientColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: ClientStatCard(
            value: '5',
            label: 'Dias',
            icon: Icons.calendar_today_outlined,
            color: ClientColors.success,
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.level});

  final String goal;
  final String level;

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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ClientColors.redSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.flag_outlined, color: ClientColors.red),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Nivel $level - entrenamiento personalizado',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ClientColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ClientColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Meta semanal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '82%',
                style: TextStyle(
                  color: ClientColors.red,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.82,
              minHeight: 9,
              backgroundColor: ClientColors.surfaceSoft,
              valueColor: AlwaysStoppedAnimation<Color>(ClientColors.red),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '4 rutinas completadas de 5 programadas esta semana.',
            style: TextStyle(color: ClientColors.textMuted, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  const _ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final IconData trailingIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ClientColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ClientColors.redSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: ClientColors.red, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ClientColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(trailingIcon, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({
    required this.name,
    required this.goal,
    required this.level,
    required this.weight,
    required this.height,
  });

  final String name;
  final String goal;
  final String level;
  final String weight;
  final String height;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late String _goal;
  late String _level;

  static const _goals = [
    'Ganar masa muscular',
    'Definir musculatura',
    'Bajar grasa',
    'Mejorar fuerza',
  ];

  static const _levels = ['Principiante', 'Intermedio', 'Avanzado'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _weightController = TextEditingController(text: widget.weight);
    _heightController = TextEditingController(text: widget.height);
    _goal = widget.goal;
    _level = widget.level;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final weight = _weightController.text.trim();
    final height = _heightController.text.trim();

    if (name.isEmpty || weight.isEmpty || height.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Completa los datos principales.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: ClientColors.surfaceSoft,
          ),
        );
      return;
    }

    Navigator.of(context).pop(
      _ProfileEditResult(
        name: name,
        goal: _goal,
        level: _level,
        weight: weight,
        height: height,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 18, 20, bottomInset + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Editar perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Cerrar',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _profileInputDecoration(
                label: 'Nombre',
                icon: Icons.person_outline,
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _goal,
              dropdownColor: ClientColors.surface,
              decoration: _profileInputDecoration(
                label: 'Objetivo',
                icon: Icons.flag_outlined,
              ),
              items: [
                for (final goal in _goals)
                  DropdownMenuItem(value: goal, child: Text(goal)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _goal = value);
                }
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _level,
              dropdownColor: ClientColors.surface,
              decoration: _profileInputDecoration(
                label: 'Nivel',
                icon: Icons.trending_up,
              ),
              items: [
                for (final level in _levels)
                  DropdownMenuItem(value: level, child: Text(level)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _level = value);
                }
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _profileInputDecoration(
                      label: 'Peso',
                      icon: Icons.monitor_weight_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _profileInputDecoration(
                      label: 'Altura',
                      icon: Icons.height,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: ClientColors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileEditResult {
  const _ProfileEditResult({
    required this.name,
    required this.goal,
    required this.level,
    required this.weight,
    required this.height,
  });

  final String name;
  final String goal;
  final String level;
  final String weight;
  final String height;
}

InputDecoration _profileInputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: ClientColors.textMuted),
    prefixIcon: Icon(icon, color: ClientColors.red),
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
  );
}
