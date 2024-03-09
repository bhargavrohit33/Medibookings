class ServiceUtils{
  static const String collection_hospital = "hospital";
 static const String hospitalModel_Name = "name";
  static const String hospitalModel_Email = "email"; 
  static const String hospitalModel_Address = "address";
  static const String hospitalModel_DocumentLinks = "documentLinks"; 
  static const String hospitalModel_IsVerified = "isVerified";
  static const String hospitalModel_ContactNumber = "contactNumber";

  // doctor
static const String collection_doctor= 'doctors';
static const String doctorModel_FirstName = "firstName";
  static const String doctorModel_LastName = "lastName";
  static const String doctorModel_Specialization = "specialization";
 static const String doctorModel_ProfilePhoto = "profile";
  static const String doctorModel_HospitalId = "hospitalId";

  // appointment

  static const String collection_appointment = "appointments";
  static const String appointmentModel_Id = 'id';
  static const String appointmentModel_PatientId = 'patientId';
  static const String appointmentModel_HospitalId = 'hospitalId';
  static const String appointmentModel_TimeSlotDuration = 'timeSlotDuration';
  static const String appointmentModel_PrescriptionId = 'prescriptionId';
  static const String appointmentModel_Doctor = 'doctorId';
  static const String appointmentModel_AppointmentDate = 'appointmentDate';
  static const String appointmentModel_ReferralAppointmentId = 'referralAppointmentId';
  static const String appointmentModel_isBooked = 'isBooked';
    static const String appointmentModel_familyMember = 'familyMember';
  static const String appointmentModel_familyMember_firstName = 'firstName';
  static const String appointmentModel_familyMember_lastName = 'lastName';
  static const String appointmentModel_familyMember_phone_number = 'phoneNumber';
}