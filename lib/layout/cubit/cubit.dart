import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_moh/layout/cubit/states.dart';
import 'package:news_app_moh/modules/business/business_screen.dart';
import 'package:news_app_moh/modules/science/science_screen.dart';
import 'package:news_app_moh/modules/sport/sports_screen.dart';
import 'package:news_app_moh/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems =
  [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
  ];

  List<Widget> screens =
  [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBar(int index)
  {
    currentIndex = index;
    if(index == 1)
      getSports();
    if(index == 2)
      getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];
  int selectedBusinessItem = 0;
  bool isDesktop = false;
  //List<bool> businessSelectedItem = [];

  void setDesktop(bool value)
  {
    isDesktop = value;
    emit(NewsSetDesktopState());
  }

  void getBusiness()
  {
    emit(NewsGetBusinessLoadingState());

    DioHelper.getData(
      url: 'v2/top-headlines',
      query:
      {
        'country':'eg',
        'category':'business',
        'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then((value)
    {
      //print(value.data['articles'][0]['title']);
      business = value.data['articles'];
      // business.forEach((element)
      // {
      //   businessSelectedItem.add(false);
      // });
      print(business[0]['title']);

      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  void selectBusinessItem(index)
  {
    // for(int i = 0 ; i < businessSelectedItem.length ; i ++)
    // {
    //   if(i == index)
    //     businessSelectedItem[i] = true;
    //   else
    //     businessSelectedItem[i] = false;
    // }
    selectedBusinessItem = index;

    emit(NewsSelectBusinessItemState());
  }

  List<dynamic> sports = [];

  void getSports()
  {
    emit(NewsGetSportsLoadingState());

    if(sports.length == 0)
    {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query:
        {
          'country':'eg',
          'category':'sports',
          'apiKey':'a583b95a86524282a13297888332b0e3',
        },
      ).then((value)
      {
        //print(value.data['articles'][0]['title']);
        sports = value.data['articles'];
        print(sports[0]['title']);

        emit(NewsGetSportsSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else
    {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> science = [];

  void getScience()
  {
    emit(NewsGetScienceLoadingState());

    if(science.length == 0)
    {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query:
        {
          'country':'eg',
          'category':'science',
          'apiKey':'a583b95a86524282a13297888332b0e3',
        },
      ).then((value)
      {
        //print(value.data['articles'][0]['title']);
        science = value.data['articles'];
        print(science[0]['title']);

        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    } else
    {
      emit(NewsGetScienceSuccessState());
    }
  }

  List<dynamic> search = [];

  void getSearch(String value)
  {
    emit(NewsGetSearchLoadingState());

    DioHelper.getData(
      url: 'v2/everything',
      query:
      {
        'q':'$value',
        'apiKey':'a583b95a86524282a13297888332b0e3',
      },
    ).then((value)
    {
      //print(value.data['articles'][0]['title']);
      search = value.data['articles'];
      print(search[0]['title']);

      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }
}