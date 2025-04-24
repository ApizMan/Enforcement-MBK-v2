import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class CompoundAmFormBloc extends FormBloc<String, String> {
  @override
  FutureOr<void> onSubmitting() {
    throw UnimplementedError();
  }
}
