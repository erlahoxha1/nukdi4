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
            backgroundColor: Colors.grey[900],
            title: const Text('Success', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Address updated successfully!',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.redAccent),
                ),
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
      body: Stack(
        children: [
          Container(color: const Color(0xFF680909)), // dark red
          ClipPath(
            clipper: SteepDiagonalClipper(),
            child: Container(color: const Color(0xFF1C1C1E)), // dark gray
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Add Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildField(_cityController, 'City', _isEditable),
                        const SizedBox(height: 10),
                        buildField(_countryController, 'Country', _isEditable),
                        const SizedBox(height: 10),
                        buildPostalField(_postalCodeController, _isEditable),
                        const SizedBox(height: 10),
                        buildField(
                          _streetController,
                          'Street Address',
                          _isEditable,
                        ),
                        const SizedBox(height: 30),

                        if (!_isEditable)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditable = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Change Address',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),

                        if (_isEditable)
                          ElevatedButton(
                            onPressed: saveAddress,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save Address',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
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
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      decoration: InputDecoration(
        labelText: 'Postal Code',
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
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

class SteepDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
