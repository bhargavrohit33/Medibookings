import 'package:flutter/material.dart';
import 'package:medibookings/presentation/screens/common/textFormField.dart';
import 'package:medibookings/presentation/screens/widget/button.dart';


class SetChargeScreen extends StatelessWidget {
  const SetChargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Charge'),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textFormField(
              textEditingController: _chargeAmountController,
              decoration: const InputDecoration(labelText: 'Charge Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the charge amount';
                }
                return null;
              },
            ),
            textFormField(
              textEditingController: _timeAllottedController,
              decoration: const InputDecoration(labelText: 'Time Allotted (minutes)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the time allotted';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            basicButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle form submission
                  _addCharge();
                }
              },
              text: 'Add Charge',
            ),
          ],
        ),
      ),
    );
  }

  void _addCharge() {
    // Logic to add charge
    // You can access charge amount and time allotted using _chargeAmountController.text and _timeAllottedController.text respectively
    // Make API call or update database here
  }
}
