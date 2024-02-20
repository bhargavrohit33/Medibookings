class Doctor {
  final int id;
  final String firstName;
  final String lastName;
  final String specialty;
  final String? profilePicture;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialty,
    this.profilePicture,
  });
}
