import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:employee_management/bloc/employee_bloc/employee_bloc.dart';
import 'package:employee_management/views/screens/employee_list.dart';

import 'data/models/hive/employee_web.dart';

void main() async {
  // Initialize Hive for Flutter (this works for web as well)
  await Hive.initFlutter();

  // Register the Employee adapter
  Hive.registerAdapter(EmployeeWebAdapter());

  // Open a Hive box for storing Employee objects
  await Hive.openBox<EmployeeWeb>('employees');

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAlSXyLVpxsmAQbvJqSHZTLWqEfDAG7o1M",
          authDomain: "raven-english-school.firebaseapp.com",
          projectId: "raven-english-school",
          storageBucket: "raven-english-school.appspot.com",
          messagingSenderId: "532398284543",
          appId: "1:532398284543:web:853ba40048837d4595f6ca",
          measurementId: "G-J8TF91RDPY"));

  runApp(const MyApp());
}

class CustomMaterialLocalizations extends DefaultMaterialLocalizations {
  final MaterialLocalizations delegate;

  CustomMaterialLocalizations(this.delegate);

  @override
  List<String> get narrowWeekdays =>
      ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  List<String> get weekdays => [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday'
      ];

  @override
  String aboutListTileTitle(String applicationName) =>
      delegate.aboutListTileTitle(applicationName);

  @override
  String get alertDialogLabel => delegate.alertDialogLabel;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class CustomMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const CustomMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final defaultLocalizations =
        await GlobalMaterialLocalizations.delegate.load(locale);
    return CustomMaterialLocalizations(defaultLocalizations);
  }

  @override
  bool shouldReload(CustomMaterialLocalizationsDelegate old) => false;
}

@override
bool shouldReload(CustomMaterialLocalizationsDelegate old) => false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Employee Management',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          CustomMaterialLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(
          primaryColor: const Color(0xFF1DA1F2),
          primaryColorLight: const Color(0xFFEDF8FF),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
                color: Color(0xFF323238),
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 20 / 16),
            headlineMedium: TextStyle(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w500,
                fontSize: 18,
                height: 21.09 / 16),
            headlineLarge: TextStyle(
                color: Color(0xFF323238),
                fontWeight: FontWeight.w500,
                fontSize: 18,
                height: 21.09 / 18),
            labelMedium: TextStyle(
                color: Color(0xFF1DA1F2),
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 16.41 / 16),
            bodySmall: TextStyle(
                color: Color(0xFF949C9E),
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 20 / 16),
            labelLarge: TextStyle(
                color: Color(0xFF949C9E),
                fontWeight: FontWeight.w400,
                fontSize: 15,
                height: 20 / 16),
            labelSmall: TextStyle(
                color: Color(0xFFF34642),
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 20 / 16),
          ),
          hintColor: const Color(0xFF949C9E),
          dividerColor: const Color(0XFFF2F2F2),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              borderRadius: BorderRadius.circular(5.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFF34642)),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFF34642)),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFFF34642),
          ),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => EmployeeBloc(),
          child: const EmployeeList(),
        ));
  }
}
