import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ms')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Kuantan City Council'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @idUser.
  ///
  /// In en, this message translates to:
  /// **'ID User'**
  String get idUser;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @witness.
  ///
  /// In en, this message translates to:
  /// **'Witness'**
  String get witness;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @duplicateCopy.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Copy'**
  String get duplicateCopy;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @handHeldMBK.
  ///
  /// In en, this message translates to:
  /// **'Handheld MBK'**
  String get handHeldMBK;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Are You Confirm To Logout?'**
  String get logoutDesc;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @handheldId.
  ///
  /// In en, this message translates to:
  /// **'ID Handheld'**
  String get handheldId;

  /// No description provided for @idLogIn.
  ///
  /// In en, this message translates to:
  /// **'ID Log In'**
  String get idLogIn;

  /// No description provided for @totalAllNotice.
  ///
  /// In en, this message translates to:
  /// **'Total All Notices'**
  String get totalAllNotice;

  /// No description provided for @totalNoticeNotYetUpload.
  ///
  /// In en, this message translates to:
  /// **'Total Notice Not Yet Been Upload'**
  String get totalNoticeNotYetUpload;

  /// No description provided for @totalPicture.
  ///
  /// In en, this message translates to:
  /// **'Total Picture'**
  String get totalPicture;

  /// No description provided for @totalPayTransaction.
  ///
  /// In en, this message translates to:
  /// **'Total Pay Transaction'**
  String get totalPayTransaction;

  /// No description provided for @totalAmountPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Amount Payment'**
  String get totalAmountPayment;

  /// No description provided for @connectAndPrint.
  ///
  /// In en, this message translates to:
  /// **'Connect & Print'**
  String get connectAndPrint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveDesc.
  ///
  /// In en, this message translates to:
  /// **'Successfully been save!'**
  String get saveDesc;

  /// No description provided for @macAddress.
  ///
  /// In en, this message translates to:
  /// **'MAC Address'**
  String get macAddress;

  /// No description provided for @successPrintingDesc.
  ///
  /// In en, this message translates to:
  /// **'✅ Compound Successfully Printing!'**
  String get successPrintingDesc;

  /// No description provided for @newPrinter.
  ///
  /// In en, this message translates to:
  /// **'New Printer'**
  String get newPrinter;

  /// No description provided for @compoundParking.
  ///
  /// In en, this message translates to:
  /// **'Compound Parking'**
  String get compoundParking;

  /// No description provided for @compoundAm.
  ///
  /// In en, this message translates to:
  /// **'Compound AM'**
  String get compoundAm;

  /// No description provided for @plateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @taxRoadNumber.
  ///
  /// In en, this message translates to:
  /// **'Tax Road Number'**
  String get taxRoadNumber;

  /// No description provided for @bodyType.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get bodyType;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brands;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @formPicture.
  ///
  /// In en, this message translates to:
  /// **'Form Picture'**
  String get formPicture;

  /// No description provided for @legalProvisions.
  ///
  /// In en, this message translates to:
  /// **'Legal Provisions'**
  String get legalProvisions;

  /// No description provided for @sectionOrOrderOrMethod.
  ///
  /// In en, this message translates to:
  /// **'Section/Order/Method'**
  String get sectionOrOrderOrMethod;

  /// No description provided for @fault.
  ///
  /// In en, this message translates to:
  /// **'Fault'**
  String get fault;

  /// No description provided for @zone.
  ///
  /// In en, this message translates to:
  /// **'Zone'**
  String get zone;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @placement.
  ///
  /// In en, this message translates to:
  /// **'Place/Road'**
  String get placement;

  /// No description provided for @locationDetail.
  ///
  /// In en, this message translates to:
  /// **'Location Detail'**
  String get locationDetail;

  /// No description provided for @squarePoleNumber.
  ///
  /// In en, this message translates to:
  /// **'Square Pole Number'**
  String get squarePoleNumber;

  /// No description provided for @vehicleClamping.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Clamping'**
  String get vehicleClamping;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @vehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetails;

  /// No description provided for @vehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Number'**
  String get vehicleNumber;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @faultDetail.
  ///
  /// In en, this message translates to:
  /// **'Fault Detail'**
  String get faultDetail;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @capture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @noticeNo.
  ///
  /// In en, this message translates to:
  /// **'Notice Number'**
  String get noticeNo;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noNewNotice.
  ///
  /// In en, this message translates to:
  /// **'No New Notices'**
  String get noNewNotice;

  /// No description provided for @pendingDesc.
  ///
  /// In en, this message translates to:
  /// **'Pending Duplicate Copy'**
  String get pendingDesc;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching'**
  String get searching;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @resubmit.
  ///
  /// In en, this message translates to:
  /// **'Re-Submit'**
  String get resubmit;

  /// No description provided for @successUploaded.
  ///
  /// In en, this message translates to:
  /// **'Successfully Uploaded'**
  String get successUploaded;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @captureImageAfterCompound.
  ///
  /// In en, this message translates to:
  /// **'Capture Image After Compound'**
  String get captureImageAfterCompound;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @successPushServer.
  ///
  /// In en, this message translates to:
  /// **'Pending Compound has been successfully uploaded to the server.'**
  String get successPushServer;

  /// No description provided for @warningImage1.
  ///
  /// In en, this message translates to:
  /// **'Compound that not have Image After'**
  String get warningImage1;

  /// No description provided for @warningImage2.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure Wanted To Continue this Action?'**
  String get warningImage2;

  /// No description provided for @compoundSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Compound Success Created'**
  String get compoundSuccessDesc;

  /// No description provided for @printOfflineDesc.
  ///
  /// In en, this message translates to:
  /// **'Are sure wanted to continue this action?'**
  String get printOfflineDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ms':
      return AppLocalizationsMs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
