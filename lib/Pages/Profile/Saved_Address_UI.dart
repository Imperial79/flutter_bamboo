// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Models/address_model.dart';
import 'package:ngf_organic/Repository/address_repo.dart';
import 'package:ngf_organic/Resources/app-data.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../Components/kTextfield.dart';

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

  makePrimary(int addressId) async {
    try {
      isLoading.value = true;

      final res = await ref.read(addressRepo).makePrimary(addressId);
      if (!res.error) {
        _refresh();
        KSnackbar(context, res: res);
      }
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  deleteAddress(int addressId) async {
    try {
      isLoading.value = true;

      final res = await ref.read(addressRepo).delete(addressId);
      if (!res.error) {
        _refresh();
        KSnackbar(context, res: res);
      }
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  _refresh() async {
    await ref.refresh(addressFuture.future);
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
      onRefresh: () => _refresh(),
      child: KScaffold(
        isLoading: isLoading,
        appBar: KAppBar(context, title: "Saved Address"),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(kPadding),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      label: "Add Address",
                      icon: Icon(Icons.add),
                      style: KButtonStyle.outlined,
                      backgroundColor: Kolor.scaffold,
                      radius: 10,
                      foregroundColor: Kolor.secondary,
                    );
                  },
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
                          itemBuilder: (context, index) =>
                              _addressCard(data[index]),
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
                  loading: () => [
                    loadingAddress(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadingAddress() {
    return Skeletonizer(
      child: ListView.separated(
        separatorBuilder: (context, index) => height10,
        itemCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => KCard(
          color: Kolor.scaffold,
          borderWidth: 1,
          width: double.infinity,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label("name").title,
                  Label("+91 phone").regular,
                  Label(
                    "${"Address"} - ${"Pincode"}",
                    weight: 500,
                  ).subtitle,
                  Label(
                    "${"city"}, ${"State"}",
                    weight: 500,
                  ).subtitle,
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Chip(
                    backgroundColor: kColor(context).errorContainer,
                    side: BorderSide.none,
                    label: Label("Delete",
                            color: kColor(context).error, weight: 600)
                        .regular,
                  ),
                  Chip(
                    label: Label("Make Primary").regular,
                  ),
                ],
              )
            ],
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
              backgroundColor: Kolor.card,
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
                        onTap: () => FocusScope.of(context).unfocus(),
                        controller: state,
                        readOnly: loading,
                        label: "State",
                        hintText: "Choose a state",
                        keyboardType: TextInputType.text,
                        autofillHints: [AutofillHints.addressCity],
                        validator: (val) => KValidation.required(val),
                      ).dropdown(
                          dropdownMenuEntries: indianStates
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

  Widget _addressCard(AddressModel address) {
    return KCard(
      onTap: () {
        if (!address.isPrimary!) {
          makePrimary(address.id!);
        }
      },
      color: Kolor.scaffold,
      borderWidth: 1,
      width: double.infinity,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (address.isPrimary!) ...[
                KCard(
                  radius: 100,
                  color: StatusText.info.lighten(),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Label(
                    "Primary",
                    fontSize: 12,
                    color: StatusText.info.darken(),
                  ).regular,
                ),
                height5,
              ],
              Label(address.name!).title,
              Label("+91 ${address.phone}").regular,
              Label(
                "${address.address!} - ${address.pincode}",
                weight: 500,
              ).subtitle,
              Label(
                "${address.city!}, ${address.state}",
                weight: 500,
              ).subtitle,
            ],
          ),
          Row(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () => deleteAddress(address.id!),
                child: Chip(
                  backgroundColor: kColor(context).errorContainer,
                  side: BorderSide.none,
                  label:
                      Label("Delete", color: kColor(context).error, weight: 600)
                          .regular,
                ),
              ),
              if (!address.isPrimary!)
                GestureDetector(
                  onTap: () => makePrimary(address.id!),
                  child: Chip(
                    label: Label("Make Primary").regular,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
