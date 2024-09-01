import '../widget/cross_apps.dart';
import '../widget/dialogs/loading_dialog.dart';
import '../widget/dialogs/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/firestore/user.dart';
import '../providers/auth_service.dart';
import '../services/firestore.dart';
import '../utils/logger.dart';
import '../widget/event_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "", _mobileNos = "", _error = "";

  Future<void> onProfileUpdate(
      {required BuildContext context,
      required String uid,
      required IUser oldUser}) async {
    setState(() {
      _error = "";
      _formKey.currentState!.save();
    });

    if (oldUser.name == _name && oldUser.phone == _mobileNos) {
      setState(() {
        _error = "Nothing is changed!";
      });

      return;
    }

    if (_name.isEmpty) {
      setState(() {
        _error = "Name is Required!";
      });

      return;
    }

    if (_mobileNos.isEmpty) {
      setState(() {
        _error = "Mobile Number is Required.";
      });

      return;
    }

    if (int.tryParse(_mobileNos) == null) {
      setState(() {
        _error = "Mobile Number must only contains the numeric character.";
      });
      return;
    }

    if (_mobileNos.length < 10 || _mobileNos.length > 10) {
      setState(() {
        _error = "Mobile Number must be 10 digits long only.";
      });

      return;
    }

    FireStoreService fireStoreService = FireStoreService();

    showLoadingDialog(context: context);
    try {
      IUser updatedUser = await fireStoreService.updateUser(
          uid: uid, name: _name, phone: _mobileNos, oldUser: oldUser);

      if (context.mounted) {
        Navigator.of(context).pop();
        Provider.of<AuthService>(context, listen: false)
            .setFireStoreUser(updatedUser);
        showSnackBar(
            context: context, text: "user successfully updated", duration: 5);
      }
    } catch (error) {
      Navigator.of(context).pop();
      showSnackBar(
          context: context,
          text: "Unable to update user. error: $error",
          duration: 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final IUser? user =
        Provider.of<AuthService>(context, listen: false).fireStoreUser;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (route) => false);
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sign out Button
                  Align(
                    alignment: Alignment.topRight,
                    child: EventButton(
                      callback: () {
                        Provider.of<AuthService>(context, listen: false)
                            .signOut(context: context);
                      },
                      minWidth: 60,
                      child: Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                  // Email field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: Text(
                      "Email:",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleSmall
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade500)),
                    padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
                    child: Text(
                      user != null ? "${user.email}" : "",
                      style: Theme.of(context).primaryTextTheme.titleMedium,
                    ),
                  ),

                  // Name field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                    child: Text(
                      "Name:",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleSmall
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                  TextFormField(
                    initialValue:
                        user != null && user.name != null ? "${user.name}" : "",
                    style: Theme.of(context).primaryTextTheme.titleMedium,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: "ex: Bakasur Chanawala",
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  // Mobile Number field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                    child: Text(
                      "Mobile Number:",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleSmall
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                  TextFormField(
                    initialValue: user != null && user.phone != null
                        ? "${user.phone}"
                        : "",
                    style: Theme.of(context).primaryTextTheme.titleMedium,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: "ex: 9012453679",
                    ).applyDefaults(
                      Theme.of(context).inputDecorationTheme,
                    ),
                    onSaved: (value) {
                      _mobileNos = value!;
                    },
                  ),
                  const SizedBox(height: 30),

                  Visibility(
                    visible: _error.isNotEmpty,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              _error,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  _error = "";
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // update profile button
                  EventButton(
                    callback: () {
                      if (user != null) {
                        onProfileUpdate(
                            context: context, uid: user.uid!, oldUser: user);
                      } else {
                        showSnackBar(
                            context: context,
                            text: "User is Null",
                            duration: 5);
                      }
                    },
                    minWidth: width,
                    text: "Update Profile",
                  ),
                  const CrossAppPromotion(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
