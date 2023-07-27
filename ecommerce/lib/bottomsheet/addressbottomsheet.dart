import 'package:ecommerce/database/address_database.dart';
import 'package:ecommerce/screens/savedaddress.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressesBottomSheetWidget extends StatefulWidget {
  const AddressesBottomSheetWidget({super.key});

  @override
  State<AddressesBottomSheetWidget> createState() =>
      _AddressesBottomSheetWidgetState();
}

class _AddressesBottomSheetWidgetState
    extends State<AddressesBottomSheetWidget> {
  List<Map<String, dynamic>> addresses = [];

  String? logincheck;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  void fetchAddresses() async {
    final List<Map<String, dynamic>> fetchedAddresses =
        await AddressDatabase.getAddresses();
    setState(() {
      addresses = fetchedAddresses;
    });
  }

  Widget buildAddressWidget(Map<String, dynamic> address) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.red[100],
        border: Border.all(color: Colors.red),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              address[AddressDatabase.columnFullName],
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
            child: Text(
              "${address[AddressDatabase.columnFlatBuilding]}, ${address[AddressDatabase.columnLandmark]}, ${address[AddressDatabase.columnCity]}, ${address[AddressDatabase.columnState]},${address[AddressDatabase.columnPincode]}",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 20,
              width: 50,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Center(
                child: Text(
                  address[AddressDatabase.columnAddressType],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddNewAddressWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SavedAddress()),
          );
        },
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.red[100],
            border: Border.all(color: Colors.red),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 30,
                color: MyColorTheme.primaryColor,
              ),
              Text(
                "Add New Address",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyColorTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPincodeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: GestureDetector(
              onTap: () {
                // Dismiss the keyboard when tapping outside the input fields
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Enter PIN Code",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: MyColorTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 4),
                      child: Text(
                        "Enter PIN Code to see product \navailability, offers and discounts",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        "PIN Code",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    size: 25,
                                    color: MyColorTheme.primaryColor,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyColorTheme.primaryColor),
                                  ),
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColorTheme.primaryColor,
                              // Button background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                // Button border radius
                              ),
                            ),
                            onPressed: () {
                              // Handle button press here
                            },
                            child: const Text(
                              "Apply",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    "Select Delivery Location",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: MyColorTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 4),
              child: Text(
                "Select a delivery location to see product \navailability, offers and discounts",
                style: TextStyle(fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemCount: addresses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == addresses.length) {
                      return buildAddNewAddressWidget(context);
                    } else {
                      final address = addresses[index];
                      return buildAddressWidget(address);
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _showPincodeBottomSheet(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: MyColorTheme.primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Enter a pincode",
                      style: TextStyle(
                          color: MyColorTheme.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Icon(
                    (Icons.my_location),
                    color: MyColorTheme.primaryColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Detect my location",
                    style: TextStyle(
                        color: MyColorTheme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
