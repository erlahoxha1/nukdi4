import 'package:flutter/material.dart';
import 'package:nukdi4/features/auth/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:nukdi4/provider/user_provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentAddress =
        Provider.of<UserProvider>(context, listen: false).user.address;
    if (currentAddress.isNotEmpty) {
      final parts = currentAddress.split(', ');
      if (parts.length == 4) {
        _streetController.text = parts[0];
        _postalCodeController.text = parts[1];
        _cityController.text = parts[2];
        _countryController.text = parts[3];
      }
    }
  }

  void saveAddress() async {
    final fullAddress =
        '${_streetController.text.trim()}, '
        '${_postalCodeController.text.trim()}, '
        '${_cityController.text.trim()}, '
        '${_countryController.text.trim()}';

    if (fullAddress.replaceAll(',', '').trim().isNotEmpty) {
      await AuthService().updateUserAddress(
        context: context,
        address: fullAddress,
      );

      // Confirmation dialog
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Address updated successfully!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Address'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildField(_cityController, 'City'),
            const SizedBox(height: 10),
            buildField(_countryController, 'Country'),
            const SizedBox(height: 10),
            buildField(_postalCodeController, 'Postal Code'),
            const SizedBox(height: 10),
            buildField(_streetController, 'Street Address'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveAddress,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
