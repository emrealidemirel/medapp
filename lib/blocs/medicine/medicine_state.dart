part of 'medicine_cubit.dart';

sealed class MedicineState extends Equatable {
  const MedicineState();

  @override
  List<Object?> get props => [];
}

final class MedicineInitial extends MedicineState {}

final class MedicineLoaded extends MedicineState {
  final List<Medicine> medicines;
  final List<MedicineLog> allLogs;
  final AppTab? targetTab;
  final int version;

  const MedicineLoaded(
    this.medicines,
    this.allLogs, {
    this.targetTab,
    this.version = 0,
  });

  List<Medicine> get activeMedicines =>
      medicines.where((m) => m.isActive ?? false).toList();

  List<Medicine> get completedMedicines => medicines
      .where(
        (m) =>
            !(m.isActive ?? false) &&
            (m.remainingCount ?? 0) == 0 &&
            !(m.isUnlimited ?? false),
      )
      .toList();

  @override
  List<Object?> get props => [medicines, allLogs, targetTab, version];
}

final class MedicineFormState extends MedicineState {
  final Medicine? medicineToEdit;
  final String name;
  final String? note;
  final int? remainingCount;
  final RepeatCycle repeatCycle;
  final List<int> intakeDays;
  final List<DateTime> intakeDates;
  final List<String> intakeTimes;
  final bool isUnlimited;

  const MedicineFormState({
    this.medicineToEdit,
    this.name = '',
    this.note,
    this.remainingCount,
    this.repeatCycle = RepeatCycle.daily,
    this.intakeDays = const [1, 2, 3, 4, 5, 6, 7],
    this.intakeDates = const [],
    this.intakeTimes = const [],
    this.isUnlimited = false,
  });

  MedicineFormState copyWith({
    Medicine? medicineToEdit,
    String? name,
    String? note,
    int? remainingCount,
    RepeatCycle? repeatCycle,
    List<int>? intakeDays,
    List<DateTime>? intakeDates,
    List<String>? intakeTimes,
    bool? isUnlimited,
  }) {
    return MedicineFormState(
      medicineToEdit: medicineToEdit ?? this.medicineToEdit,
      name: name ?? this.name,
      note: note ?? this.note,
      remainingCount: remainingCount ?? this.remainingCount,
      repeatCycle: repeatCycle ?? this.repeatCycle,
      intakeDays: intakeDays ?? this.intakeDays,
      intakeDates: intakeDates ?? this.intakeDates,
      intakeTimes: intakeTimes ?? this.intakeTimes,
      isUnlimited: isUnlimited ?? this.isUnlimited,
    );
  }

  @override
  List<Object?> get props => [
    medicineToEdit,
    name,
    note,
    remainingCount,
    repeatCycle,
    intakeDays,
    intakeDates,
    intakeTimes,
    isUnlimited,
  ];
}
