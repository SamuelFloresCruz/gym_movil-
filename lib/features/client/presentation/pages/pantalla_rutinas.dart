import 'package:flutter/material.dart';

import '../../data/catalogo_entrenamiento_cliente.dart';
import '../../domain/entities/musculo_entrenamiento.dart';
import '../theme/colores_cliente.dart';
import '../widgets/icono_musculo_cliente.dart';
import '../widgets/titulo_seccion_cliente.dart';

class ClientRoutinesPage extends StatefulWidget {
  const ClientRoutinesPage({super.key});

  @override
  State<ClientRoutinesPage> createState() => _ClientRoutinesPageState();
}

class _ClientRoutinesPageState extends State<ClientRoutinesPage> {
  var _selectedMuscleIndex = 0;
  var _selectedDayIndex = 0;
  final _selectedMusclesByDay = <String, Set<String>>{
    'Lun': {'Pecho', 'Triceps'},
    'Mar': {'Espalda', 'Biceps'},
    'Mie': {'Pierna', 'Gluteos'},
  };

  static const _muscles = ClientTrainingCatalog.muscles;
  static const _weekDays = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
  static const _weekDayNames = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo',
  ];

  TrainingMuscle get _selectedMuscle => _muscles[_selectedMuscleIndex];
  String get _selectedDay => _weekDays[_selectedDayIndex];

  Set<String> get _selectedDayMuscles {
    return _selectedMusclesByDay.putIfAbsent(_selectedDay, () => <String>{});
  }

  void _selectDay(int index) {
    setState(() {
      _selectedDayIndex = index;
      final musclesForDay = _selectedDayMuscles;
      if (musclesForDay.isNotEmpty &&
          !musclesForDay.contains(_selectedMuscle.name)) {
        _selectedMuscleIndex = _muscles.indexWhere(
          (muscle) => muscle.name == musclesForDay.first,
        );
      }
    });
  }

  void _selectWorkoutMuscle(int index) {
    setState(() {
      _selectedMuscleIndex = index;
      _selectedDayMuscles.add(_muscles[index].name);
    });
  }

  void _removeWorkoutMuscle(String muscleName) {
    setState(() {
      _selectedDayMuscles.remove(muscleName);
      if (_selectedDayMuscles.isNotEmpty &&
          !_selectedDayMuscles.contains(_selectedMuscle.name)) {
        _selectedMuscleIndex = _muscles.indexWhere(
          (muscle) => muscle.name == _selectedDayMuscles.first,
        );
      }
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
                  const _RoutinesHeader(),
                  const SizedBox(height: 18),
                  _WeeklyPlannerSection(
                    days: _weekDays,
                    dayNames: _weekDayNames,
                    muscles: _muscles,
                    muscleCountByDay: {
                      for (final day in _weekDays)
                        day: _selectedMusclesByDay[day]?.length ?? 0,
                    },
                    selectedDayIndex: _selectedDayIndex,
                    selectedMuscleIndex: _selectedMuscleIndex,
                    selectedMuscles: _selectedDayMuscles,
                    onSelectDay: _selectDay,
                    onSelectMuscle: _selectWorkoutMuscle,
                    onRemoveMuscle: _removeWorkoutMuscle,
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

class _RoutinesHeader extends StatelessWidget {
  const _RoutinesHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rutinas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Organiza tus entrenamientos por dia y grupo muscular.',
          style: TextStyle(color: ClientColors.textMuted, height: 1.35),
        ),
      ],
    );
  }
}

class _WeeklyPlannerSection extends StatelessWidget {
  const _WeeklyPlannerSection({
    required this.days,
    required this.dayNames,
    required this.muscles,
    required this.muscleCountByDay,
    required this.selectedDayIndex,
    required this.selectedMuscleIndex,
    required this.selectedMuscles,
    required this.onSelectDay,
    required this.onSelectMuscle,
    required this.onRemoveMuscle,
  });

  final List<String> days;
  final List<String> dayNames;
  final List<TrainingMuscle> muscles;
  final Map<String, int> muscleCountByDay;
  final int selectedDayIndex;
  final int selectedMuscleIndex;
  final Set<String> selectedMuscles;
  final ValueChanged<int> onSelectDay;
  final ValueChanged<int> onSelectMuscle;
  final ValueChanged<String> onRemoveMuscle;

  @override
  Widget build(BuildContext context) {
    final activeMuscle = muscles[selectedMuscleIndex];
    final showActiveMuscle = selectedMuscles.contains(activeMuscle.name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ClientSectionTitle(title: 'Plan semanal'),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var index = 0; index < days.length; index++) ...[
              Expanded(
                child: _DayBox(
                  label: days[index],
                  count: muscleCountByDay[days[index]] ?? 0,
                  isSelected: selectedDayIndex == index,
                  onTap: () => onSelectDay(index),
                ),
              ),
              if (index != days.length - 1) const SizedBox(width: 6),
            ],
          ],
        ),
        const SizedBox(height: 22),
        ClientSectionTitle(
          title: 'Musculos para ${dayNames[selectedDayIndex]}',
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: muscles.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final muscle = muscles[index];
            return _RoutineMuscleCard(
              muscle: muscle,
              isSelected: selectedMuscles.contains(muscle.name),
              isActive: selectedMuscleIndex == index && showActiveMuscle,
              onTap: () => onSelectMuscle(index),
              onDoubleTap: selectedMuscles.contains(muscle.name)
                  ? () => onRemoveMuscle(muscle.name)
                  : null,
            );
          },
        ),
        const SizedBox(height: 22),
        if (showActiveMuscle)
          _MusclePartsPreview(muscle: activeMuscle)
        else
          const _NoMuscleSelectedCard(),
      ],
    );
  }
}

class _DayBox extends StatelessWidget {
  const _DayBox({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? ClientColors.red : ClientColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 62,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? ClientColors.red : ClientColors.border,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$count',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.82)
                      : ClientColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutineMuscleCard extends StatelessWidget {
  const _RoutineMuscleCard({
    required this.muscle,
    required this.isSelected,
    required this.isActive,
    required this.onTap,
    this.onDoubleTap,
  });

  final TrainingMuscle muscle;
  final bool isSelected;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive
          ? ClientColors.red
          : isSelected
          ? ClientColors.redSoft
          : ClientColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? ClientColors.red : ClientColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(clientMuscleIcon(muscle.name), color: Colors.white),
                  const Spacer(),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: isActive ? Colors.white : ClientColors.red,
                      size: 18,
                    ),
                ],
              ),
              const Spacer(),
              Text(
                muscle.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${muscle.parts.length} partes',
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

class _MusclePartsPreview extends StatelessWidget {
  const _MusclePartsPreview({required this.muscle});

  final TrainingMuscle muscle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClientSectionTitle(title: 'Partes de ${muscle.name}'),
        const SizedBox(height: 12),
        for (final part in muscle.parts) ...[
          _PartCard(part: part),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _PartCard extends StatelessWidget {
  const _PartCard({required this.part});

  final TrainingMusclePart part;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClientColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ClientColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            part.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final exercise in part.exercises)
                _ExerciseChip(label: exercise),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExerciseChip extends StatelessWidget {
  const _ExerciseChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: ClientColors.surfaceSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: ClientColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NoMuscleSelectedCard extends StatelessWidget {
  const _NoMuscleSelectedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClientColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ClientColors.border),
      ),
      child: const Text(
        'Selecciona un musculo para ver sus partes y ejercicios.',
        style: TextStyle(color: ClientColors.textMuted, height: 1.35),
      ),
    );
  }
}
