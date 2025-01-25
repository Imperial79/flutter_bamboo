// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/KSearchbar.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/Pill.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kCard.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Models/address_model.dart';
import 'package:flutter_bamboo/Repository/address_repo.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Components/kTextfield.dart';
import '../../Resources/theme.dart';

class Saved_Address_UI extends ConsumerStatefulWidget {
  const Saved_Address_UI({super.key});

  @override
  ConsumerState<Saved_Address_UI> createState() => _Saved_Address_UIState();
}

class _Saved_Address_UIState extends ConsumerState<Saved_Address_UI> {
  final searchKey = TextEditingController();
  final isLoading = ValueNotifier(false);
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  addAddress() async {
    try {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;

        final res = await ref.read(addressRepo).addAddress(AddressModel(
              name: name.text,
              phone: phone.text,
              address: address.text,
              city: city.text,
              state: state.text,
              pincode: pincode.text,
            ));

        if (!res.error) {
          Navigator.pop(context);
          await ref.refresh(addressFuture.future);
          KSnackbar(context, res: res);

          name.clear();
          phone.clear();
          address.clear();
          pincode.clear();
          city.clear();
          state.clear();
        }
      }
    } catch (e) {
      KSnackbar(context, message: "$e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    searchKey.dispose();
    name.dispose();
    phone.dispose();
    address.dispose();
    pincode.dispose();
    city.dispose();
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressData = ref.watch(addressFuture);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(addressFuture.future),
      child: KScaffold(
        appBar: AppBar(
          title: Label("Saved Address").regular,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(kPadding),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Flexible(
                      child: KSearchbar(
                        controller: searchKey,
                        hintText: "Search the address here",
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: isLoading,
                      builder: (context, loading, _) {
                        return KButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: !loading,
                              builder: (context) => addAddressDialog(),
                            );
                          },
                          label: "Add",
                          radius: 7,
                          padding: EdgeInsets.all(12),
                        );
                      },
                    ),
                  ],
                ),
                height10,
                ...addressData.when(
                  data: (data) {
                    if (data.isNotEmpty) {
                      return [
                        Label("Address list", fontSize: 17).regular,
                        ListView.separated(
                          separatorBuilder: (context, index) => height10,
                          itemCount: data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => KCard(
                            color: KColor.scaffold,
                            borderWidth: 1,
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 20,
                              children: [
                                SvgPicture.asset(
                                  "$kIconPath/location.svg",
                                  height: 60,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Pill(
                                            label: "Primary",
                                            backgroundColor:
                                                kScheme.tertiaryContainer,
                                            textColor: kScheme.tertiary,
                                          ).text,
                                          Icon(
                                            Icons.check_circle_outline_outlined,
                                            color: KColor.primary,
                                          ),
                                        ],
                                      ),
                                      height10,
                                      Label(data[index].name!).title,
                                      Label("+91 ${data[index].phone}").regular,
                                      Label(
                                        "${data[index].address!} - ${data[index].pincode}",
                                        weight: 500,
                                      ).subtitle,
                                      Label(
                                        "${data[index].city!}, ${data[index].state}",
                                        weight: 500,
                                      ).subtitle,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ];
                    }
                    return [
                      kNoData(context,
                          title: "No Address Found!",
                          subtitle: "Add an address.")
                    ];
                  },
                  error: (error, stackTrace) => [kNoData(context)],
                  loading: () => [CircularProgressIndicator()],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addAddressDialog() {
    return StatefulBuilder(
      builder: (context, setState) {
        return ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, loading, _) {
            return Dialog(
              backgroundColor: KColor.card,
              insetPadding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(kPadding),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Label("Add new address", fontSize: 20, weight: 700).title,
                      Label("Enter details below").subtitle,
                      height20,
                      KTextfield(
                        controller: name,
                        readOnly: loading,
                        label: "Name",
                        hintText: "Eg. John Doe",
                        keyboardType: TextInputType.name,
                        autofillHints: [AutofillHints.name],
                        validator: (val) => KValidation.required(val),
                      ).regular,
                      height20,
                      KTextfield(
                        controller: phone,
                        readOnly: loading,
                        label: "Phone",
                        maxLength: 10,
                        prefixText: "+91",
                        hintText: "Eg. 909××××××0",
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.phone,
                        autofillHints: [AutofillHints.telephoneNumber],
                        validator: (val) => KValidation.phone(val),
                      ).regular,
                      height20,
                      KTextfield(
                        controller: pincode,
                        readOnly: loading,
                        label: "Pincode",
                        hintText: "Eg. 000001",
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autofillHints: [AutofillHints.postalCode],
                        validator: (val) => KValidation.required(val),
                      ).regular,
                      height20,
                      KTextfield(
                        controller: address,
                        readOnly: loading,
                        label: "Address",
                        hintText:
                            "Eg. ABC Street, Near Landmark, City XYZ - 000001",
                        maxLines: 2,
                        minLines: 2,
                        keyboardType: TextInputType.streetAddress,
                        autofillHints: [AutofillHints.postalAddress],
                        validator: (val) => KValidation.required(val),
                      ).regular,
                      height20,
                      KTextfield(
                        controller: city,
                        readOnly: loading,
                        label: "City",
                        hintText: "Eg. Agra",
                        keyboardType: TextInputType.text,
                        autofillHints: [AutofillHints.addressCity],
                        validator: (val) => KValidation.required(val),
                      ).regular,
                      height20,
                      KTextfield(
                        controller: state,
                        readOnly: loading,
                        label: "State",
                        hintText: "Choose a state",
                        keyboardType: TextInputType.text,
                        autofillHints: [AutofillHints.addressCity],
                        validator: (val) => KValidation.required(val),
                      ).dropdown(
                          dropdownMenuEntries: ["West Bengal"]
                              .map(
                                (e) => DropdownMenuEntry(
                                  value: e,
                                  label: e,
                                  labelWidget: Label(e).regular,
                                ),
                              )
                              .toList()),
                      height20,
                      KButton(
                        onPressed: addAddress,
                        label: "Add Address",
                        isLoading: loading,
                        style: KButtonStyle.expanded,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
