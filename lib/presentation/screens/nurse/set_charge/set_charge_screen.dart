import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';
import 'package:medibookings/model/nurse/nurse/nurse_model.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/widget/commonLoading.dart';
import 'package:medibookings/presentation/widget/snack_bar.dart';
import 'package:medibookings/presentation/widget/somethin_went_wrong.dart';
import 'package:medibookings/screens/button.dart';
import 'package:medibookings/service/nurse/nurse_service.dart';
import 'package:provider/provider.dart';

class SetChargeScreen extends StatelessWidget {
  const SetChargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Charge',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: const SetChargeForm(),
    );
  }
}

class SetChargeForm extends StatefulWidget {
  const SetChargeForm({super.key});

  @override
  _SetChargeFormState createState() => _SetChargeFormState();
}

class _SetChargeFormState extends State<SetChargeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _chargeAmountController = TextEditingController();
  final TextEditingController _timeAllottedController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     final nurseService = Provider.of<NurseService>(context,listen: false);
    _chargeAmountController.text = nurseService.nurseModel!.perHourCharge.toString();
  }
  @override
  Widget build(BuildContext context) {
    final nurseService = Provider.of<NurseService>(context);
    return isLoading?commonLoading(): Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<NurseModel>(
        stream: nurseService.getNurseProfile,
        builder: (context, snapshot) {
          if(snapshot.hasData){
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textFormField(
                  textEditingController: _chargeAmountController,
                  decoration: defaultInputDecoration(hintText: "Per hour charge"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the per hour charge';
                    }
                    try {
                      double.parse(value);
                    } catch (error) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
               
                const SizedBox(height: 16.0),
                basicButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      try{
                        setState(() {
                          isLoading = true;
                        });
                        await  nurseService.updatePerHourCharge(double.parse(_chargeAmountController.text));
                        custom_snackBar(context, 'Hourly charge successfully updated');
                      }
                      catch(e){
                         custom_snackBar(context, 'Failed to update hourly charge');
                          
                      }finally{
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  text: 'Add Charge',
                ),
              ],
            ),
          );
        }
        else  if(snapshot.hasError){
          return SomethingWentWrongWidget(superContext: context);
        }
        else{
          return commonLoading();
        }
        }
        
      ),
    );
  }

 
}
