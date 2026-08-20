import 'package:flutter/material.dart';

import '../theme/colores_cliente.dart';
import '../widgets/tarjeta_estadistica_cliente.dart';
import '../widgets/titulo_seccion_cliente.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({
    super.key,
    required this.onOpenMuscles,
    required this.onOpenRoutines,
    required this.onOpenTracking,
    required this.onOpenStopwatch,
  });

  final VoidCallback onOpenMuscles;
  final VoidCallback onOpenRoutines;
  final VoidCallback onOpenTracking;
  final VoidCallback onOpenStopwatch;

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
                  _Header(onOpenTracking: onOpenTracking),
                  const SizedBox(height: 22),
                  _ActiveRoutineCard(onOpenRoutines: onOpenRoutines),
                  const SizedBox(height: 18),
                  const _ProgressRow(),
                  const SizedBox(height: 24),
                  ClientSectionTitle(
                    title: 'Accesos rapidos',
                    actionLabel: 'Rutinas',
                    onActionTap: onOpenRoutines,
                  ),
                  const SizedBox(height: 12),
                  _ActionGrid(
                    onOpenMuscles: onOpenMuscles,
                    onOpenRoutines: onOpenRoutines,
                    onOpenTracking: onOpenTracking,
                    onOpenStopwatch: onOpenStopwatch,
                  ),
                  const SizedBox(height: 24),
                  _NextSessionCard(onOpenTracking: onOpenTracking),
                  const SizedBox(height: 24),
                  const _WeeklyRoutinePreview(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onOpenTracking});

  final VoidCallback onOpenTracking;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ClientColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: const Text(
            'GP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, Mauricio',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Listo para entrenar hoy',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: ClientColors.textMuted),
              ),
            ],
          ),
        ),
        IconButton.filled(
          tooltip: 'Abrir seguimiento',
          style: IconButton.styleFrom(
            backgroundColor: ClientColors.surface,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onOpenTracking,
          icon: const Icon(Icons.monitor_heart_outlined),
        ),
      ],
    );
  }
}

class _ActiveRoutineCard extends StatelessWidget {
  const _ActiveRoutineCard({required this.onOpenRoutines});

  final VoidCallback onOpenRoutines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientColors.red,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ClientColors.red.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Rutina activa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Fuerza superior',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pecho, hombro y triceps - 6 ejercicios',
            style: TextStyle(color: Color(0xFFFFE3E3), fontSize: 14),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: ClientColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onOpenRoutines,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Ver rutinas'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: ClientStatCard(
            value: '4',
            label: 'Rutinas',
            icon: Icons.assignment_outlined,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ClientStatCard(
            value: '18',
            label: 'Ejercicios',
            icon: Icons.sports_gymnastics,
            color: ClientColors.warning,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ClientStatCard(
            value: '82%',
            label: 'Progreso',
            icon: Icons.trending_up,
            color: ClientColors.success,
          ),
        ),
      ],
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({
    required this.onOpenMuscles,
    required this.onOpenRoutines,
    required this.onOpenTracking,
    required this.onOpenStopwatch,
  });

  final VoidCallback onOpenMuscles;
  final VoidCallback onOpenRoutines;
  final VoidCallback onOpenTracking;
  final VoidCallback onOpenStopwatch;

  @override
  Widget build(BuildContext context) {
    final options = [
      _ActionOption(
        title: 'Musculos',
        subtitle: 'Ejercicios por grupo',
        icon: Icons.accessibility_new,
        onTap: onOpenMuscles,
      ),
      _ActionOption(
        title: 'Cronometro',
        subtitle: 'Series y descansos',
        icon: Icons.timer_outlined,
        onTap: onOpenStopwatch,
      ),
      _ActionOption(
        title: 'Semana',
        subtitle: 'Plan por dias',
        icon: Icons.view_week_outlined,
        onTap: onOpenRoutines,
      ),
      _ActionOption(
        title: 'Seguimiento',
        subtitle: 'Progreso muscular',
        icon: Icons.monitor_heart_outlined,
        onTap: onOpenTracking,
      ),
    ];

    return GridView.builder(
      itemCount: options.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        return _ActionTile(option: options[index]);
      },
    );
  }
}

class _ActionOption {
  const _ActionOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.option});

  final _ActionOption option;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ClientColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: option.onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(option.icon, color: ClientColors.red),
              const Spacer(),
              Text(
                option.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.subtitle,
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
      ),
    );
  }
}

class _NextSessionCard extends StatelessWidget {
  const _NextSessionCard({required this.onOpenTracking});

  final VoidCallback onOpenTracking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ClientColors.redDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bolt, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proximo entrenamiento',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Pierna completa - manana 18:30',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: ClientColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Abrir seguimiento',
            onPressed: onOpenTracking,
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _WeeklyRoutinePreview extends StatelessWidget {
  const _WeeklyRoutinePreview();

  @override
  Widget build(BuildContext context) {
    const days = [
      ('Lun', true),
      ('Mar', true),
      ('Mie', true),
      ('Jue', false),
      ('Vie', false),
      ('Sab', false),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientColors.surfaceSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Semana de entrenamiento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final day in days) ...[
                Expanded(
                  child: _DayPill(label: day.$1, isDone: day.$2),
                ),
                if (day != days.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({required this.label, required this.isDone});

  final String label;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDone ? ClientColors.red : ClientColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isDone ? Colors.white : ClientColors.textMuted,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
