import 'package:flutter/material.dart';
import 'package:medibookings/common/app_colors.dart';
import 'package:medibookings/common/route_name.dart';
import 'package:medibookings/common/shimera_widget.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/hospital/patient/patient_model.dart';
import 'package:medibookings/model/nurse/appointment.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/model/route_model.dart';
import 'package:medibookings/presentation/screens/Nurse/reference/appointments_slots_card_reference.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/custom_appBar_without_backbutton.dart';
import 'package:medibookings/presentation/widget/images_widgets.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/service/hospital/patient_service_hospital.dart';
import 'package:medibookings/service/nurse/nurse_appointmet_service.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:provider/provider.dart';



class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({super.key});

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  late DateTime _selectedDate;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedStatus = 'All'; // Initial value for appointment status filter
  }

  List<NurseAppointment> filterNurseBookingsByDate(
      DateTime date, List<NurseAppointment> nurseBookings) {
    // Filter nurse bookings by date
    return nurseBookings.where((booking) {
      return booking.appointmentDate.year == date.year &&
          booking.appointmentDate.month == date.month &&
          booking.appointmentDate.day == date.day;
    }).toList();
  }

  List<NurseAppointment> filterNurseBookingsByStatus(
      String status, List<NurseAppointment> nurseBookings) {
    // Filter nurse bookings by appointment status
    if (status == "All") {
      return nurseBookings;
    } else {
      
      AppointmentStatus check = appointmentStatusFromString(_selectedStatus);
      return nurseBookings
          .where((booking) => booking.appointmentStatus == check)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentService = Provider.of<NurseAppointmentService>(context);
    final theme = Theme.of(context);
    return Scaffold(
      
      body: Column(
        children: [
          // Date filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Filter by Date: '),
                      TextButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          _selectedDate.toString().substring(0, 10),
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        dropdownColor: theme.scaffoldBackgroundColor,
                        value: _selectedStatus,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedStatus = newValue!;
                          });
                        },
                        items: <String>[
                          'All',
                          'Pending',
                          'Approved',
                          'Rejected',
                          'CancelledByPatient'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: defaultInputDecoration(
                          hintText: 'By Status',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Nurse booking list
          Expanded(
            child: StreamBuilder<List<NurseAppointment>>(
              stream: appointmentService.nurseAppointments,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return commonLoading();
                } else if (snapshot.hasError) {
                  return SomethingWentWrongWidget(
                    superContext: context,
                  );
                } else {
                  final filteredBookings =
                      filterNurseBookingsByDate(_selectedDate, snapshot.data!)
                          .where((booking) => filterNurseBookingsByStatus(
                                  _selectedStatus, snapshot.data!)
                              .contains(booking))
                          .toList();
                  return ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return BookingItem(
                        nurseAppointment: filteredBookings[index],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookingItem extends StatelessWidget {
  final NurseAppointment nurseAppointment;
  const BookingItem({super.key, required this.nurseAppointment});

  @override
  Widget build(BuildContext context) {
    final nurseService = Provider.of<NurseService>(context);
     final patientService = Provider.of<PatientServiceHospital>(context);
    final theme = Theme.of(context);
    return FutureBuilder<PatientModel?>(
        future: patientService.getPatientById(nurseAppointment.patientID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SomethingWentWrongWidget(superContext: context);
          } else if (snapshot.hasData ) {
           return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, RouteName.nurseAppointmentDetail,arguments: NurseAppointmentRouteAruguments(nurseAppointment: nurseAppointment,patientModel: snapshot.data!));
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cardRadius),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(cardRadius)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    tag(nurseAppointment.appointmentStatus),
                                    Text(
                                      "${capitalizeFirstLetter(snapshot.data!.firstName)} ${capitalizeFirstLetter(snapshot.data!.lastName)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      formatTimeForAppintment(
                                          context: context,
                                          time: nurseAppointment.appointmentDate),
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return ShimmerWidget();
          }
        });
  }

  
}
Widget tag(AppointmentStatus status) {
    Color? color;
    String label;
    switch (status) {
      case AppointmentStatus.Pending:
        color = Colors.blue.withOpacity(.6);
        label = 'Pending';
        break;
      case AppointmentStatus.Approved:
        color = Colors.green.withOpacity(.6);
        ;
        label = 'Approved';
        break;
      case AppointmentStatus.Rejected:
        color = Colors.red.withOpacity(.6);
        ;
        label = 'Rejected';
        break;
      case AppointmentStatus.CancelledByPatient:
        color = Colors.orange.withOpacity(.6);
        ;
        label = 'Cancelled';
        break;
    }
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(cardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }