
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubit/states.dart';
//import 'package:news_app/cubit_app/states.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/modules/science/science_screen.dart';

import 'package:news_app/modules/sports/sport_screen.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>{
NewsCubit():super(NewsInitialState());
static NewsCubit get(context)=>BlocProvider.of(context);

int currentIndex=0;

List<BottomNavigationBarItem>bottomItems=[
  const BottomNavigationBarItem(
      icon:Icon(
        Icons.business,
      ),
    label: 'Business',


  ),
  const BottomNavigationBarItem(
    icon:Icon(
      Icons.sports,
    ),
    label: 'Sports',


  ),
  const BottomNavigationBarItem(
    icon:Icon(
      Icons.science,
    ),
    label: 'Science',


  ),

];
List<Widget>screens=[
  const BusinessScreen(),
  const SportScreen(),
  const ScienceScreen(),

];
void changeBottomNavBar(int index){
  currentIndex=index;
  if(index==0){getBusiness();}
  if(index==1){getSports();}
  if(index==2){getScience();}
  emit(NewsBottomNavState());
}
List<dynamic>business=[];
void getBusiness(){
  emit(NewsBusinessLoadingState());
  DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country':'eg',
        'category':'business',
        'apiKey':'87fffd0a3b67430b870a569522d54022',

      }).then((value){
    //print(value.data.toString());
    business=value.data['articles'];
    print(business[0]['title']);
    emit(NewsGetBusinessSuccessState());
  }).catchError((onError){
    print(onError.toString());
    emit(NewsGetBusinessErrorState(onError.toString()));
  });
}
List<dynamic>sports=[];
void getSports(){
  emit(NewsSportsLoadingState());
  if(sports.isEmpty){
    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country':'eg',
          'category':'sports',
          'apiKey':'87fffd0a3b67430b870a569522d54022',

        }).then((value){
      //print(value.data.toString());
      sports=value.data['articles'];
      print(sports[0]['title']);
      emit(NewsGetSportsSuccessState());
    }).catchError((onError){
      print(onError.toString());
      emit(NewsGetSportsErrorState(onError.toString()));
    });
  }else{
    emit(NewsGetSportsSuccessState());}

}
List<dynamic>science=[];
void getScience(){
  emit(NewsScienceLoadingState());
  if(science.isEmpty){
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country':'eg',
        'category':'science',
        'apiKey':'87fffd0a3b67430b870a569522d54022',

      }).then((value){
    //print(value.data.toString());
    science=value.data['articles'];
    print(science[0]['title']);
    emit(NewsGetScienceSuccessState());
  }).catchError((onError){
    print(onError.toString());
    emit(NewsGetScienceErrorState(onError));
  });}else{
    emit(NewsGetScienceSuccessState());
  }

}
List<dynamic>search=[];
void getSearch(String value){
  emit(NewsSearchLoadingState());
  search=[];
    DioHelper.getData(
        url: 'v2/everything',
        query: {

          'q':value,
          'apiKey':'87fffd0a3b67430b870a569522d54022',

        }).then((value){
      //print(value.data.toString());
      search=value.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    }).catchError((onError){
      print(onError.toString());
      emit(NewsGetSearchErrorState(onError));
    });

}

//bool isDark=false;
//void changeAppMode(){
  //isDark=!isDark;

  //emit(AppChangeModeState());
//}

}