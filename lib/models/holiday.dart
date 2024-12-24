class Holiday {
  String nameOfHoliday;
  String startDate;
  String endDate;
  String type;

  Holiday({
    this.nameOfHoliday = '',
    this.startDate = '',
    this.endDate = '',
    this.type = '',
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      nameOfHoliday: json['name'] ?? '',
      startDate: json['start']?.toString().split('T')[0] ?? '',
      endDate: json['end']?.toString().split('T')[0] ?? '',
      type: json['type'] ?? '',
    );
  }
}
