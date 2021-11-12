import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/shared/styles/color.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class StoreLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit, StoreAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = StoreAppCubit.get(context);
        return Scaffold(
          body: cubit.StoreScreens[cubit.currentIndex],
          bottomNavigationBar: TitledBottomNavigationBar(
            activeColor: Colors.yellowAccent[700],
            onTap: (index) => cubit.changeIndex(index),
            currentIndex: cubit.currentIndex,
            items: [
              TitledNavigationBarItem(title: Text(cubit.getTexts('layout1'), style: Theme.of(context).textTheme.subtitle1,), icon: MaterialCommunityIcons.home_account,backgroundColor: Theme.of(context).scaffoldBackgroundColor),
              TitledNavigationBarItem(title: Text(cubit.getTexts('layout2'),style: Theme.of(context).textTheme.subtitle1,), icon: Feather.rss,backgroundColor: Theme.of(context).scaffoldBackgroundColor),
              TitledNavigationBarItem(title: Text(cubit.getTexts('layout3'),style: Theme.of(context).textTheme.subtitle1,), icon: Feather.search,backgroundColor: Theme.of(context).scaffoldBackgroundColor),
              TitledNavigationBarItem(title: Text(cubit.getTexts('layout4'),style: Theme.of(context).textTheme.subtitle1,), icon: Feather.shopping_cart,backgroundColor: Theme.of(context).scaffoldBackgroundColor),
              TitledNavigationBarItem(title: Text(cubit.getTexts('layout5'),style: Theme.of(context).textTheme.subtitle1,), icon: Feather.user,backgroundColor: Theme.of(context).scaffoldBackgroundColor),
            ],
          ),
        );
      },
    );
  }
}
