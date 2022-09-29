import 'package:flutter/material.dart';
import 'package:news_app/cubit_app/states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:todo_list/modules/archived_tasks/archived_tasks_screen.dart';
//import 'package:todo_list/modules/done_tasks/done_tasks_screen.dart';
//import 'package:todo_list/modules/new_tasks/new_tasks_screen.dart';
//import 'package:todo_list/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  int currentIndex = 0;
  late Database database;
  List<Map>newTasks=[];
  List<Map>doneTasks=[];
  List<Map>archivedTasks=[];

  List<Widget> screens = [
  //  const NewTasksScreen(),
    //const DoneTasksScreen(),
    //const ArchivedTasksScreen(),


  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index){
    currentIndex=index;
    emit( AppChangeBottomNavBarState());

  }

  void createDataBase(){
     openDatabase(
      'toDo.db',
      version: 1,
      onCreate: (database, version) {

        print('dataBase created');

        database
            .execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KYE,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {

          print('table created');

        }).catchError((error) {

          print('Error when Creating Table ${error.toString()} ');

        });
      },
      onOpen: (database) {

        getDataFromDataBase(database);
        print('dataBase opened');


      },
    ).then((value) {
      database=value;
      emit(AppCreateDataBaseState());
     });
  }



  insertToDataBase(
      {required String title,
        required String time,
        required String date}) async {
     await  database.transaction((dynamic txn) async
    {
       txn
          .rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES($title,$date,$time,"new")')
          .then((value) {
            print('$value Inserted Successfully');
            emit(AppInsertDataBaseState());
            getDataFromDataBase(database);

      }).catchError((error) {

        print('Error when Inserting New Record ${error.toString()} ');

      });

    });
  }

  void getDataFromDataBase(database) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDataBaseLoadingState());

      database.rawQuery('SELECT * FROM tasks',[database]).then((value) {
        value.forEach((element) {
        if(element['status']=='new'){
          newTasks.add(element);
        }else if(element['status']=='done'){
          doneTasks.add(element);
        }else{ archivedTasks.add(element);}


      });
      emit(AppGetDataBaseState());
    });
  }
  
  void upData({
  required String status,
    required int id,
})  {
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, '$id']).then((value){
          getDataFromDataBase(database);
          emit(AppUpdateDataBaseState());

     });


  }

  void deleteData({
    required int id,
  })  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', ['id']
        ).then((value){
      getDataFromDataBase(database);
      emit(AppDeleteDataBaseState());

    });


  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetsState({
  required bool isShow,
    required IconData icon,
}){
    isBottomSheetShown=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());

  }

  bool isDark=false;
  void changeAppMode( {bool? fromShared}){
    if(fromShared!=null){
      isDark=fromShared;
      emit(AppChangeModeState());
    }
    else {
      isDark=!isDark;
      CacheHelper.putBoolData(key: 'isDark', value: isDark).then((value){
        emit(AppChangeModeState());
      });
    }


  }


}

