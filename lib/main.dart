import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_colors.dart';
import 'components/screens/ascii_image/ascii_image_screen.dart';
import 'components/screens/ascii_image/bloc/ascii_image/ascii_image_bloc.dart';
import 'components/screens/ascii_image/bloc/options/options_bloc.dart';
import 'utils/custom_ink_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ASCIICameraApp());
}

class ASCIICameraApp extends StatelessWidget {
  const ASCIICameraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => OptionsBloc()),
          BlocProvider(create: (_) => ASCIIImageBloc()),
        ],
        child: const ASCIIImageScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.grey,
      scaffoldBackgroundColor: AppColors.black,
      backgroundColor: AppColors.black,
      splashFactory: CustomInkSplash.splashFactory,
      colorScheme: ColorScheme.fromSwatch(
        accentColor: AppColors.white,
      ),
    );
  }
}
