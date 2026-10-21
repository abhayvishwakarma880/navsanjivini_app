class HelpResource {
  final String id;
  final String name;
  final String description;
  final String contactNumber;
  final String operatingHours;
  final bool isTollFree;

  const HelpResource({
    required this.id,
    required this.name,
    required this.description,
    required this.contactNumber,
    required this.operatingHours,
    this.isTollFree = true,
  });
}
