import 'package:flutter/material.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key});

  static const _background = Color(0xFF09090B);
  static const _surface = Color(0xFF16171B);
  static const _surfaceSoft = Color(0xFF202126);
  static const _red = Color(0xFFE53935);
  static const _redDark = Color(0xFF8F1D1D);
  static const _textMuted = Color(0xFFA8ABB4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _Header(),
                  const SizedBox(height: 22),
                  const _MembershipCard(),
                  const SizedBox(height: 18),
                  const _ProgressRow(),
                  const SizedBox(height: 24),
                  _SectionTitle(
                    title: 'Accesos rapidos',
                    actionLabel: 'Ver todo',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 12),
                  const _ActionGrid(),
                  const SizedBox(height: 24),
                  const _TodayWorkoutCard(),
                  const SizedBox(height: 24),
                  const _WeeklyRoutinePreview(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ClientHomePage._surface,
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
                style: TextStyle(color: ClientHomePage._textMuted),
              ),
            ],
          ),
        ),
        IconButton.filled(
          tooltip: 'Notificaciones',
          style: IconButton.styleFrom(
            backgroundColor: ClientHomePage._surface,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientHomePage._red,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ClientHomePage._red.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Membresia activa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Plan mensual GymPro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Vigente hasta el 30/09/2026',
            style: TextStyle(color: Color(0xFFFFE3E3), fontSize: 14),
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
          child: _MetricCard(
            value: '5',
            label: 'Dias activos',
            icon: Icons.local_fire_department_outlined,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            value: '12',
            label: 'Ejercicios',
            icon: Icons.fitness_center,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            value: '82%',
            label: 'Rutina',
            icon: Icons.trending_up,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ClientHomePage._surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ClientHomePage._red, size: 22),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ClientHomePage._textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          onPressed: onActionTap,
          child: Text(
            actionLabel,
            style: const TextStyle(color: ClientHomePage._red),
          ),
        ),
      ],
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid();

  @override
  Widget build(BuildContext context) {
    const options = [
      _ActionOption(
        title: 'Entrenamiento',
        subtitle: 'Grupos musculares',
        icon: Icons.fitness_center,
      ),
      _ActionOption(
        title: 'Rutina',
        subtitle: 'Semana actual',
        icon: Icons.calendar_month_outlined,
      ),
      _ActionOption(
        title: 'Perfil',
        subtitle: 'Datos y membresia',
        icon: Icons.person_outline,
      ),
      _ActionOption(
        title: 'Soporte',
        subtitle: 'Contacto rapido',
        icon: Icons.chat_bubble_outline,
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
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.option});

  final _ActionOption option;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ClientHomePage._surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(option.icon, color: ClientHomePage._red),
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
                  color: ClientHomePage._textMuted,
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

class _TodayWorkoutCard extends StatelessWidget {
  const _TodayWorkoutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientHomePage._surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ClientHomePage._redDark,
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
                  'Entrenamiento de hoy',
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
                  'Pecho, hombros y triceps',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: ClientHomePage._textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Abrir entrenamiento',
            onPressed: () {},
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
        color: ClientHomePage._surfaceSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rutina semanal',
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
        color: isDone ? ClientHomePage._red : ClientHomePage._surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isDone ? Colors.white : ClientHomePage._textMuted,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      backgroundColor: ClientHomePage._surface,
      indicatorColor: ClientHomePage._red.withValues(alpha: 0.18),
      selectedIndex: 0,
      onDestinationSelected: (_) {},
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center),
          label: 'Entrenar',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Rutina',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }
}
