enum Shape { Rectangle, Circular, None }


enum OperatingDays {
  monday(1 << 0),
  tuesday(1 << 1),
  wednesday(1 << 2),
  thursday(1 << 3),
  friday(1 << 4),
  saturday(1 << 5),
  sunday(1 << 6),
  holidays(1 << 7);

  final int value;
  const OperatingDays(this.value);
}

int getBitmaskFromSelectedDays(Set<OperatingDays> selectedDays) {
  return selectedDays.fold(0, (acc, day) => acc | day.value);
}

Set<OperatingDays> getSelectedDaysFromBitmask(int bitmask) {
  return OperatingDays.values
      .where((day) => (bitmask & day.value) == day.value)
      .toSet();
}
