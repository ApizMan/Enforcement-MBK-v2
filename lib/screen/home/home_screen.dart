import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInitialized = false;
  List<UserModel> userModel = []; // Initialize this
  List<OfficerUnitModel> unitModel = []; // Initialize this
  late String handHeldId;

  @override
  void initState() {
    handHeldId = "";
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: HeaderLayout(title: AppLocalizations.of(context)!.handHeldMBK),
      drawer: SidebarLayout(
        userModel: userModel,
        unitModel: unitModel,
        handHeldId: handHeldId,
      ),
    );
  }
}
