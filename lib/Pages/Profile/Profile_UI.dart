import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/KNavigationBar.dart';
import 'package:ngf_organic/Components/KScaffold.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kButton.dart';
import 'package:ngf_organic/Components/kCard.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:ngf_organic/Resources/app_config.dart';
import 'package:ngf_organic/Resources/colors.dart';
import 'package:ngf_organic/Resources/commons.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:ngf_organic/Resources/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Profile_UI extends ConsumerStatefulWidget {
  const Profile_UI({super.key});

  @override
  ConsumerState<Profile_UI> createState() => _Profile_UIState();
}

class _Profile_UIState extends ConsumerState<Profile_UI> {
  final isLoading = ValueNotifier(false);
  logout() async {
    try {
      isLoading.value = true;
      final res = await ref.read(authRepository).logout();
      if (!res.error) {
        activePageNotifier.value = 0;
        AuthRepo.googleSignIn.signOut();
        ref.read(userProvider.notifier).state = null;
      }
    } catch (e) {
      KSnackbar(context, message: e, error: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return KScaffold(
      isLoading: isLoading,
      appBar: KAppBar(context, showBack: false, title: "Profile"),
      body: SafeArea(
        child: user != null
            ? SingleChildScrollView(
                padding: EdgeInsets.all(kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.isMember)
                      Container(
                        padding: EdgeInsets.all(kPadding),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: kRadius(15),
                          image: DecorationImage(
                            image: AssetImage("$kImagePath/premium-bg.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: user.image.isNotEmpty
                                  ? NetworkImage(user.image)
                                  : null,
                              child: user.image.isEmpty
                                  ? Label(user.name[0].toUpperCase(),
                                          fontSize: 22)
                                      .regular
                                  : null,
                            ),
                            height10,
                            Label(
                              user.name,
                              color: Colors.white,
                            ).title,
                            Label(
                              "Member",
                              fontSize: 13,
                              weight: 600,
                              color: Colors.white,
                            ).title,
                          ],
                        ),
                      )
                    else ...[
                      Center(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: user.image.isNotEmpty
                              ? NetworkImage(user.image)
                              : null,
                          child: user.image.isEmpty
                              ? Label(user.name[0].toUpperCase(), fontSize: 22)
                                  .regular
                              : null,
                        ),
                      ),
                      height10,
                      Center(
                        child: Label(user.name).title,
                      ),
                      if (user.phone != null)
                        Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Label(
                              user.phone!,
                              fontSize: 17,
                              weight: 700,
                            ).subtitle,
                            InkWell(
                              onTap: () => context.push("/edit-profile"),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 15,
                                  ),
                                  Label("Edit").regular
                                ],
                              ),
                            )
                          ],
                        )
                      else
                        Center(
                          child: InkWell(
                            onTap: () => context.push("/profile/edit"),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  color: KColor.fadeText,
                                  size: 20,
                                ),
                                Label("Add phone", fontSize: 15, weight: 600)
                                    .subtitle,
                              ],
                            ),
                          ),
                        ),
                    ],
                    height20,
                    KCard(
                      padding: EdgeInsets.all(7),
                      color: KColor.scaffold,
                      borderWidth: 1,
                      width: double.infinity,
                      child: Column(
                        children: [
                          _profileBtn(
                            icon: Icons.location_on_outlined,
                            label: "Saved Address",
                            path: "/profile/saved-address",
                          ),
                          div,
                          _profileBtn(
                            icon: Icons.inventory_2_outlined,
                            label: "Orders",
                            path: "/profile/orders",
                          ),
                          div,
                          _profileBtn(
                            icon: Icons.receipt_long,
                            label: "Transactions",
                            path: "/profile/transactions",
                          ),
                          div,
                          _profileBtn(
                            icon: Icons.help,
                            label: "Help",
                            path: "/profile/help",
                          ),
                          div,
                          _profileBtn(
                            icon: Icons.exit_to_app,
                            label: "Logout",
                            path: "",
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => logoutDialog(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    height10,
                    Label("Version $kAppVersion", weight: 600).subtitle,
                    _appLogo(),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kLoginRequired(context),
                  _appLogo(),
                ],
              ),
      ),
    );
  }

  Widget logoutDialog() {
    return AlertDialog(
      title: Label("Do you want to logout?").title,
      content: Label(
              "Logging out will stop all the notifications for offers and promotions.")
          .regular,
      actions: [
        KButton(
          onPressed: () {
            Navigator.pop(context);
          },
          label: "No",
          radius: 100,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          backgroundColor: kScheme.error,
        ),
        KButton(
          onPressed: () {
            Navigator.pop(context);
            logout();
          },
          label: "Yes",
          radius: 100,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          backgroundColor: kScheme.tertiary,
        ),
      ],
    );
  }

  Widget _appLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "$kImagePath/logo.png",
              ),
            ),
          ),
        ),
        Center(child: Label("NGF Organic © ${DateTime.now().year}").regular),
        Center(child: Label("NIGHTBIRDES HUB (OPC) PRIVATE LIMITED").regular),
      ],
    );
  }

  Widget _profileBtn({
    required IconData icon,
    required String label,
    required String path,
    void Function()? onTap,
  }) {
    return KCard(
      color: KColor.scaffold,
      onTap: onTap ?? () => context.push(path),
      child: Row(
        spacing: 20,
        children: [
          Icon(
            icon,
            size: 25,
          ),
          Expanded(
            child: Label(label, weight: 600).regular,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 15,
          )
        ],
      ),
    );
  }
}
