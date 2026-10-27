/// Represents an authenticated Doctor / Healthcare Professional.
class DoctorUser {
  final String id;
  final String name;
  final String email;
  final String specialization;

  const DoctorUser({
    required this.id,
    required this.name,
    required this.email,
    this.specialization = 'Mental Health Practitioner',
  });
}

