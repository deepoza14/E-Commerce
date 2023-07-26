import 'package:ecommerce/database/address_database.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({Key? key}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  String addressType = "HOME"; // Set initial address type to "HOME"

  TextEditingController addressNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController flatBuildingController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController alternateMobileController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    addressNameController.dispose();
    fullNameController.dispose();
    flatBuildingController.dispose();
    landmarkController.dispose();
    stateController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    alternateMobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColorTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColorTheme.background,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: MyColorTheme.primaryColor,
          ),
        ),
        title: Text(
          "Add Address",
          style: TextStyle(
            color: MyColorTheme.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Address Type",
                  style: TextStyle(
                    color: MyColorTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          addressType = "HOME";
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: addressType == "HOME"
                                ? MyColorTheme.primaryColor
                                : Colors.grey,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.home,
                              color: addressType == "HOME"
                                  ? MyColorTheme.primaryColor
                                  : Colors.grey,
                            ),
                            Text(
                              "HOME",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: addressType == "HOME"
                                    ? MyColorTheme.primaryColor
                                    : Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          addressType = "WORK";
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: addressType == "WORK"
                                ? MyColorTheme.primaryColor
                                : Colors.grey,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.work,
                              color: addressType == "WORK"
                                  ? MyColorTheme.primaryColor
                                  : Colors.grey,
                            ),
                            Text(
                              "WORK",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: addressType == "WORK"
                                    ? MyColorTheme.primaryColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          addressType = "OTHER";
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: addressType == "OTHER"
                                ? MyColorTheme.primaryColor
                                : Colors.grey,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: addressType == "OTHER"
                                  ? MyColorTheme.primaryColor
                                  : Colors.grey,
                            ),
                            Text(
                              "OTHER",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: addressType == "OTHER"
                                    ? MyColorTheme.primaryColor
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (addressType == "OTHER")
                        TextFormField(
                          controller: addressNameController,
                          decoration: const InputDecoration(
                            labelText: 'Address Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the address name';
                            }
                            return null;
                          },
                        ),
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: flatBuildingController,
                        decoration: InputDecoration(
                          labelText:
                              addressType == "WORK" || addressType == "OTHER"
                                  ? 'Flat, Building, Company, Apartment'
                                  : 'Flat, House no, Building, Apartment',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the flat/building details';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: landmarkController,
                        decoration: const InputDecoration(
                          labelText: 'Landmark',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the landmark';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("State"),
                                TextFormField(
                                  controller: stateController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter State',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the state';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("City"),
                                TextFormField(
                                  controller: cityController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter City',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the city';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: pincodeController,
                              decoration: const InputDecoration(
                                labelText: 'Pincode',
                              ),
                              style: const TextStyle(),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the pincode';
                                } else if (value.length != 6) {
                                  return 'Please enter 6 digit pincode';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: alternateMobileController,
                              decoration: const InputDecoration(
                                labelText: 'Alternate Mobile',
                              ),
                              /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the alternate mobile number';
                                }
                                return null;
                              },*/
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: SizedBox(
                          height: 40,
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Form is valid, proceed with adding address
                                //addNewAddress();
                                addNewAddress();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColorTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "ADD",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNewAddress() async {
    final address = {
      AddressDatabase.columnAddressType: addressType,
      AddressDatabase.columnAddressName: addressNameController.text,
      AddressDatabase.columnFullName: fullNameController.text,
      AddressDatabase.columnFlatBuilding: flatBuildingController.text,
      AddressDatabase.columnLandmark: landmarkController.text,
      AddressDatabase.columnState: stateController.text,
      AddressDatabase.columnCity: cityController.text,
      AddressDatabase.columnPincode: pincodeController.text,
      AddressDatabase.columnAlternateMobile: alternateMobileController.text,
    };

    await AddressDatabase.insertAddress(address);

    Navigator.pop(context);
  }
}
// Show a snackbar or navigate to a different screen to indicate successful address addition
