import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medibookings/model/hospital/appointment/appointment_model.dart';
import 'package:medibookings/service/disposable_service.dart';
import 'package:medibookings/service/service_utils.dart';

class ReferenceService extends DisposableService{
  Appointment? appointmentToReference;
  final CollectionReference appointmentCollection =
      FirebaseFirestore.instance.collection(ServiceUtils.collection_appointment);
Future<void> setAppointment(Appointment appointment)async{
  appointmentToReference = appointment;
  notifyListeners();
}

Future<void> updateReferenceAppointment({required Appointment newAppointment})async{
  try{
   
    await appointmentCollection.doc(appointmentToReference!.id).update({
      ServiceUtils.appointmentModel_ReferralAppointmentId:newAppointment.id
    });
  newAppointment =  newAppointment.copyWith(
      patientId: appointmentToReference!.patientId,
      familyMember: appointmentToReference!.familyMember,
      isBooked: true,
    );
     await updateAppointment(newAppointment);
  }
  catch(e){
    rethrow;
  }
}
Future<void> updateAppointment(Appointment appointment) async {
    try {
     
      await appointmentCollection
          .doc(appointment.id)
          .update(appointment.toMap());
    } catch (error) {
      print('Error updating appointment: $error');
      rethrow;
    }
  }
}