import 'package:ecommerce/common/widgets/custom_textfield.dart';
import 'package:ecommerce/constants/global_variables.dart';
import 'package:ecommerce/constants/utils.dart';
import 'package:ecommerce/features/address/services/address_services.dart';
import 'package:ecommerce/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = "/address";
  final String totalAmountPay;
  const AddressScreen({super.key, required this.totalAmountPay});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  List<PaymentItem> paymentItems = [];
  String addressToBeUsed = "";
  final AddressServices addressServices = AddressServices();

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmountPay,
        label: "Total Amount ",
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    streetAddressController.dispose();
    buildingController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
  }

  void onApplePayResult(res) {
    if (Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address.isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalAmountPay: double.parse(
        widget.totalAmountPay,
      ),
    );
  }

  void onGoolePayResult(res) {
    if (Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address.isEmpty) {
      addressServices.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalAmountPay: double.parse(
        widget.totalAmountPay,
      ),
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";
    bool isForm =
        streetAddressController.text.isNotEmpty ||
        buildingController.text.isNotEmpty ||
        cityController.text.isNotEmpty ||
        zipCodeController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            "${streetAddressController.text}, ${buildingController.text}, ${cityController.text}, ${zipCodeController.text}";
      } else {
        throw Exception("Please enter all the details!");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "OR",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Address Line 1",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: streetAddressController,
                      hintText: 'Street Address',
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Address Line 2",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: buildingController,
                      hintText: 'Apt, Suite, Unit, Building',
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "City",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'City',
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "ZIP Code",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: zipCodeController,
                      hintText: 'ZIP Code',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder<PaymentConfiguration>(
                future: PaymentConfiguration.fromAsset('applepay.json'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return ApplePayButton(
                      width: double.infinity,
                      height: 50,
                      style: ApplePayButtonStyle.whiteOutline,
                      type: ApplePayButtonType.buy,
                      margin: EdgeInsets.only(top: 15),
                      paymentConfiguration: snapshot.data!,
                      paymentItems: paymentItems,
                      onPaymentResult: onApplePayResult,
                      onPressed: () => payPressed(address),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              SizedBox(height: 20),
              FutureBuilder<PaymentConfiguration>(
                future: PaymentConfiguration.fromAsset('gpay.json'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return GooglePayButton(
                      onPressed: () => payPressed(address),
                      width: double.infinity,
                      height: 50,
                      theme: GooglePayButtonTheme.light,
                      type: GooglePayButtonType.buy,
                      margin: EdgeInsets.only(top: 15),
                      paymentConfiguration: snapshot.data!,
                      paymentItems: paymentItems,
                      onPaymentResult: onGoolePayResult,
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
