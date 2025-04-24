import 'package:eo_apk_mbk_v2/form_blocs/form_bloc.dart';
import 'package:flutter/material.dart';

class CompoundAmScreen extends StatelessWidget {
  final CompoundAmFormBloc? compoundAmFormBloc;
  const CompoundAmScreen({super.key, this.compoundAmFormBloc});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Compound AM Screen"));
  }
}
