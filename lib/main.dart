import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:news_app/cubit/bloc_observer.dart';
import 'package:news_app/cubit/cubit.dart';
//import 'package:news_app/cubit/cubit.dart';
//import 'package:news_app/cubit/states.dart';
import 'package:news_app/cubit_app/cubit.dart';
import 'package:news_app/cubit_app/states.dart';
import 'package:news_app/layout/home_layout/news_layout.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer=MyBlocObserver();
  DioHelper.init();
 await CacheHelper.init();
 bool isDark=CacheHelper.getBoolData(key:'isDark');
  runApp( MyApp(isDark));
}

class MyApp extends StatelessWidget {
  final bool isDark;

const MyApp(this.isDark, {Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [

        BlocProvider(create: (context,)=>NewsCubit()..getBusiness()..getSports()..getScience(),),
        BlocProvider( create: (BuildContext context)=>AppCubit()..changeAppMode(
          fromShared: isDark,
        ),)

      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener:(context,state){},
        builder: (context,state){
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.cyan,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                titleSpacing: 20.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,

                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme:  IconThemeData(
                  color: Colors.black,

                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.cyan,
                  elevation: 20.0

              ),
              textTheme: const TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,

                ),
              ),



            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.cyan,
              scaffoldBackgroundColor: HexColor('333739',),
              appBarTheme: AppBarTheme(
                titleSpacing: 20.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor:  HexColor('333739',),
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness:  Brightness.light
                ),
                backgroundColor:HexColor('333739'),
                elevation: 0.0,
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme:  const IconThemeData(
                  color: Colors.white,
                ),
              ),
              bottomNavigationBarTheme:BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.cyan,
                unselectedItemColor: Colors.grey,
                elevation: 20.0,
                backgroundColor:  HexColor('333739',),


              ),
              textTheme: const TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),



            ),
            themeMode:AppCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
            home:const NewsLayout(),
          );
        },
      ),
    );
  }
}

