import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Components/kTextfield.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Resources/colors.dart';

class Edit_Profile_UI extends ConsumerStatefulWidget {
  const Edit_Profile_UI({super.key});

  @override
  ConsumerState<Edit_Profile_UI> createState() => _Edit_Profile_UIState();
}

class _Edit_Profile_UIState extends ConsumerState<Edit_Profile_UI> {
  final formKey = GlobalKey<FormState>();
  final phone = TextEditingController();
  final email = TextEditingController();
  final name = TextEditingController();
  final isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final user = ref.read(userProvider);
        if (user != null) {
          phone.text = ref.read(userProvider)?.phone ?? "";
          email.text = user.email ?? "";
          name.text = user.name;
          setState(() {});
        }
      },
    );
  }

  updateProfile() async {
    try {
      FocusScope.of(context).unfocus();
      isLoading.value = true;
      final res = await ref.read(authRepository).updateProfile({
        "phone": phone.text,
        "email": email.text,
        "name": name.text,
      });
      await ref.read(authRepository).auth(ref);
      KSnackbar(context, res: res);
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    phone.dispose();
    email.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return KScaffold(
      isLoading: isLoading,
      appBar: KAppBar(
        context,
        title: "Edit Profile",
        actions: [
          IconButton(
              onPressed: () => context.push("/help"),
              icon: Icon(Icons.help_outline_rounded)),
          width5,
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                user.image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: user.image,
                        imageBuilder: (context, imageProvider) => Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: imageProvider,
                          ),
                        ),
                      )
                    : Center(
                        child: CircleAvatar(
                          radius: 30,
                          child: Label(user.name[0].toUpperCase(), fontSize: 22)
                              .regular,
                        ),
                      ),
                height10,
                Label(user.name).title,
                Label(user.email ?? user.phone!, weight: 500).regular,
                height20,
                KTextfield(
                  controller: phone,
                  autoFocus: phone.text.isEmpty,
                  label: "Phone (+91)",
                  hintText: "Eg. 909XXXXXX1",
                  showRequired: false,
                  prefixText: "+91",
                  maxLength: 10,
                  autofillHints: [AutofillHints.telephoneNumber],
                  keyboardType: TextInputType.phone,
                  validator: (val) => KValidation.phone(val),
                ).regular,
                height20,
                KTextfield(
                  controller: email,
                  label: "Email",
                  hintText: "Eg. john@mail.com",
                  prefix: Icon(Icons.alternate_email_outlined),
                  showRequired: false,
                  autofillHints: [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => KValidation.email(val),
                ).regular,
                height20,
                KTextfield(
                  controller: name,
                  label: "Name",
                  hintText: "Eg. John Doe",
                  showRequired: false,
                  autofillHints: [AutofillHints.name],
                  keyboardType: TextInputType.name,
                  validator: (val) => KValidation.required(val),
                ).regular,
                height20,
                KButton(
                  onPressed: updateProfile,
                  label: "Update",
                  style: KButtonStyle.expanded,
                  backgroundColor: kColor(context).tertiary,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
