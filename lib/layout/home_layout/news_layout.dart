import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubit/cubit.dart';
import 'package:news_app/cubit/states.dart';
import 'package:news_app/cubit_app/cubit.dart';
import 'package:news_app/modules/search/search_screen.dart';
import 'package:news_app/shared/components/components.dart';


class NewsLayout extends StatelessWidget {
  const NewsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'News App',

            ),
            actions: [
              IconButton(
                icon: const Icon(
                    Icons.search,
                  ),
                onPressed: (){
                  navigateTo(context,SearchScreen());
                },
              ),
              IconButton(
                onPressed: (){
                AppCubit.get(context).changeAppMode();
                },
                icon:  const Icon(
                Icons.brightness_4_outlined,
              ),
              ),

            ],

          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNavBar(index);

            },
            items:cubit.bottomItems,

          ),
        );
      },
    );
  }
}
