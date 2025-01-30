import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/KScaffold.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kTextfield.dart';
import 'package:flutter_bamboo/Repository/auth_repo.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_bamboo/Resources/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Edit_Profile_UI extends ConsumerStatefulWidget {
  const Edit_Profile_UI({super.key});

  @override
  ConsumerState<Edit_Profile_UI> createState() => _Edit_Profile_UIState();
}

class _Edit_Profile_UIState extends ConsumerState<Edit_Profile_UI> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return KScaffold(
      appBar: KAppBar(
        context,
        title: "Edit Profile",
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.help_outline_rounded)),
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
                CachedNetworkImage(
                  imageUrl: user!.image,
                  imageBuilder: (context, imageProvider) => Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageProvider,
                    ),
                  ),
                ),
                height10,
                Label(user.name).title,
                Label(user.email, weight: 500).regular,
                height20,
                KTextfield(
                  label: "Phone (+91)",
                  hintText: "Eg. 909XXXXXX1",
                  showRequired: false,
                  prefixText: "+91",
                  autofillHints: [AutofillHints.telephoneNumber],
                  keyboardType: TextInputType.phone,
                  validator: (val) => KValidation.phone(val),
                ).regular,
                height20,
                KButton(
                  onPressed: () {},
                  label: "Save",
                  style: KButtonStyle.expanded,
                  backgroundColor: kScheme.tertiaryContainer,
                  foregroundColor: kScheme.tertiary,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
