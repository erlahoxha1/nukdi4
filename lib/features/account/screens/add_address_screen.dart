import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nukdi4/features/auth/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:nukdi4/provider/user_provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  bool _isEditable = false;

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
      _isEditable = false; // existing user
    } else {
      _isEditable = true; // new user
    }
  }

  void saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final fullAddress =
        '${_streetController.text.trim()}, '
        '${_postalCodeController.text.trim()}, '
        '${_cityController.text.trim()}, '
        '${_countryController.text.trim()}';

    await AuthService().updateUserAddress(
      context: context,
      address: fullAddress,
    );

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

    setState(() {
      _isEditable = false;
    });
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
      appBar: AppBar(
        title: const Text('Add Address'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildField(_cityController, 'City', _isEditable),
              const SizedBox(height: 10),
              buildField(_countryController, 'Country', _isEditable),
              const SizedBox(height: 10),
              buildPostalField(_postalCodeController, _isEditable),
              const SizedBox(height: 10),
              buildField(_streetController, 'Street Address', _isEditable),
              const SizedBox(height: 30),

              if (!_isEditable)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditable = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Change Address',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              if (_isEditable)
                ElevatedButton(
                  onPressed: saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
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
      ),
    );
  }

  Widget buildField(
    TextEditingController controller,
    String label,
    bool enabled,
  ) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (!enabled) return null;
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget buildPostalField(TextEditingController controller, bool enabled) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      decoration: const InputDecoration(
        labelText: 'Postal Code',
        border: OutlineInputBorder(),
        counterText: '',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!enabled) return null;
        if (value == null || value.trim().isEmpty) {
          return 'Postal code is required';
        }
        if (!RegExp(r'^\d{4}$').hasMatch(value.trim())) {
          return 'Please enter exactly 4 digits';
        }
        return null;
      },
    );
  }
}
