// ignore_for_file: deprecated_member_use

import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/helpers/theme.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:eo_apk_mbk_v2/widgets/loading_dialog.dart';
import 'package:eo_apk_mbk_v2/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  LoginFormBloc? formBloc;
  bool _isInitialized = false;
  List<UserModel> userModel = []; // Initialize this
  List<OfficerUnitModel> unitModel = []; // Initialize this
  String handHeldId = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null && arguments['userModel'] != null) {
        userModel = arguments['userModel'] as List<UserModel>;
        unitModel = arguments['unitModel'] as List<OfficerUnitModel>;
        handHeldId = arguments['handHeldId'] as String;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: BlocProvider(
                    create:
                        (context) => LoginFormBloc(
                          officerInfos: userModel,
                          officerUnits: unitModel,
                        ),
                    child: Builder(
                      builder: (context) {
                        formBloc = BlocProvider.of<LoginFormBloc>(context);
                        return FormBlocListener<LoginFormBloc, String, String>(
                          onSubmitting: (context, state) {
                            LoadingDialog.show(context);
                          },
                          onSubmissionFailed:
                              (context, state) => LoadingDialog.hide(context),
                          onSuccess: (context, state) {
                            LoadingDialog.hide(context);
                            Navigator.popAndPushNamed(
                              context,
                              RouteManager.homeScreen,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.successResponse!)),
                            );
                          },
                          onFailure: (context, state) {
                            LoadingDialog.hide(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.failureResponse!)),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo
                              Image.asset(
                                logo,
                                fit: BoxFit.fill,
                                width: 200,
                                height: 150,
                              ),

                              const SizedBox(height: 32),

                              // Title
                              Text(
                                AppLocalizations.of(context)!.welcome,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.appName,
                                style: TextStyle(color: Colors.grey),
                              ),

                              const SizedBox(height: 32),

                              // Username field
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc!.userId,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  label: Text(
                                    AppLocalizations.of(context)!.idUser,
                                  ),
                                  prefixIcon: const Icon(Icons.person),
                                  hintText:
                                      '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.idUser}',
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kBlack),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kBlack),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                ),
                              ),

                              // Password field
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc!.password,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  label: Text(
                                    AppLocalizations.of(context)!.password,
                                  ),
                                  hintText:
                                      '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.password}',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kBlack),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kBlack),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                ),
                              ),

                              DropdownFieldBlocBuilder<OfficerUnitModel?>(
                                showEmptyItem: false,
                                selectFieldBloc: formBloc!.unit,
                                decoration: InputDecoration(
                                  label: Text(
                                    AppLocalizations.of(context)!.unit,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.account_balance_rounded,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kBlack),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kBlack),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                ),
                                itemBuilder: (context, value) {
                                  if (value != null) {
                                    return FieldItem(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: Text(
                                          value.description ?? 'Unknown',
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const FieldItem(
                                      child: Text("No user selected"),
                                    );
                                  }
                                },
                              ),

                              DropdownFieldBlocBuilder<UserModel?>(
                                showEmptyItem: false,
                                selectFieldBloc: formBloc!.witness,
                                decoration: InputDecoration(
                                  label: Text(
                                    AppLocalizations.of(context)!.witness,
                                  ),
                                  prefixIcon: const Icon(Icons.group),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kBlack),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kBlack),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                ),
                                itemBuilder: (context, value) {
                                  if (value != null) {
                                    return FieldItem(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: Text(value.userId ?? 'Unknown'),
                                      ),
                                    );
                                  } else {
                                    return const FieldItem(
                                      child: Text("No user selected"),
                                    );
                                  }
                                },
                              ),

                              // Login button
                              PrimaryButton(
                                buttonWidth: 0.9,
                                borderRadius: 10.0,
                                onPressed: () => formBloc!.submit(),
                                label: Text(
                                  AppLocalizations.of(context)!.login,
                                  style: textStyleNormal(color: kWhite),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            FooterLayout(handHeldId: handHeldId),
          ],
        ),
      ),
    );
  }
}
