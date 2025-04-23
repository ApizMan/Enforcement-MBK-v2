import 'package:get/get.dart';

class InputValidator {
  static String? required(dynamic value) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return Get.locale!.languageCode == 'en'
          ? "Please fill in this field"
          : "Ruangan ini perlu di isi";
    }
    return null;
  }

  static String? nickname(String nickname) {
    if (nickname.length > 10) {
      return Get.locale!.languageCode == 'en'
          ? "Nickname is too long"
          : "Gelaran terlalu panjang";
    }
    return null;
  }

  static String? managerName(String managerName) {
    if (managerName.length > 100) {
      return "Manager's Name must not more than 100 characters";
    }
    return null;
  }

  static String? cafeName(String cafeName) {
    if (cafeName.length > 20) {
      return "Cafe's Name must not more than 20 characters";
    }
    return null;
  }

  static String? nric(String nric) {
    if (nric.length != 12) {
      return Get.locale!.languageCode == 'en'
          ? "Must 12 numeric characters"
          : "Nomber mestilah 12 angka";
    }
    return null;
  }

  static String? pin(String nric) {
    if (nric.length != 4) {
      return Get.locale!.languageCode == 'en'
          ? "Must 4 numeric characters"
          : "Nombor mestilah 4 angka";
    }
    return null;
  }

  static String? phoneNo(String phoneNo) {
    if (phoneNo.length < 9) {
      return Get.locale!.languageCode == 'en'
          ? "Invalid Phone Number"
          : "Nombor Telefon tidak wujud";
    } else if (phoneNo.length > 11) {
      return Get.locale!.languageCode == 'en'
          ? "Invalid Phone Number"
          : "Nombor Telefon tidak wujud";
    }
    return null;
  }

  static String? usernameChar(String username) {
    // lower case
    if (!RegExp(r'^[a-z0-9_\(\)\|]+$').hasMatch(username.trim())) {
      return Get.locale!.languageCode == 'en'
          ? "Only lowercase and ( , ) , _ , | are allowed"
          : "Hanya huruf kecil dan ( , ) , _ , | dibenarkan";
    } else if (username.trim().length > 15) {
      return "The password you enter is too long";
    }
    return null;
  }

  static String? passwordChar(String password) {
    if (password.length < 8) {
      return "The password must have at least 8 characters";
    } else if (password.length > 40) {
      return "The password you enter is too long";
    }
    return null;
  }

  static String? confirmPasswordChar(String? confirmPassword, String password) {
    if (confirmPassword != password) {
      return "Password must be the same as above.";
    }
    return null;
  }

  static String? nameChar(String name) {
    if (name.trim().length < 4) {
      return "The name must have at least 4 characters";
    } else if (name.trim().length > 40) {
      return "The name you enter is too long";
    }
    return null;
  }

  static String? emailChar(String email) {
    if (email.trim().length < 4 ||
        email.trim().length > 40 ||
        !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(email.trim())) {
      return Get.locale!.languageCode == 'en'
          ? "Invalid Email"
          : "Emel Tidak Sah";
    }
    return null;
  }

  static String? amount(String amount) {
    if (amount.isEmpty) {
      return "Please Enter the amount";
    }
    return null;
  }

  static String? time(String time) {
    if (time.length != 2) {
      return "Must 2 numeric characters";
    }
    return null;
  }
}
