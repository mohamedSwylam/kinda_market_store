
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kinda_store/layout/cubit/cubit.dart';
import 'package:kinda_store/layout/cubit/states.dart';
class CategoriesScreen extends StatelessWidget {
  final int index;
  CategoriesScreen({Key key, this.index}) : super(key: key);
  List <Map<String,Object>> categories= [
    {
      'categoryName':'البان طبيعيه',
      'categoryImage':'https://arganzwina.com/files/photos/0b04c3ff-8b9b-4eaa-8093-7490fc808f86_02d6d9dff5b023c2496076a49e0a381c.jpg',
    },
    {
      'categoryName':'ماسك الطمي',
      'categoryImage':'https://arganzwina.com/files/photos/2de4b9d8-e4df-44db-bd6c-6602b0a54387_%D9%85%D8%A7%D8%B3%D9%83-%D8%A7%D9%84%D8%B7%D9%8A%D9%86-%D8%A7%D9%84%D9%85%D8%BA%D8%B1%D8%A8%D9%8A-%D8%A7%D9%8A-%D9%87%D9%8A%D8%B1%D8%A8.jpg',
    },
    {
      'categoryName':'الطين المغربي',
      'categoryImage':'https://arganzwina.com/files/photos/134b38c0-e3f8-40e1-9a60-ecfcd47219a4_%D9%85%D8%A7%D8%B3%D9%83-%D8%A7%D9%84%D8%B7%D9%8A%D9%86-%D8%A7%D9%84%D9%85%D8%BA%D8%B1%D8%A8%D9%8A-%D8%A7%D9%8A-%D9%87%D9%8A%D8%B1%D8%A8.jpg',
    },
    {
      'categoryName':'الغاسول المغربي',
      'categoryImage':'https://arganzwina.com/files/photos/af970cae-8a59-4e02-8437-84780d7b915a_%D8%A7%D9%84%D8%BA%D8%A7%D8%B3%D9%88%D9%84-%D8%A7%D9%84%D9%85%D8%BA%D8%B1%D8%A8%D9%8A.jpg',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreAppCubit,StoreAppStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(Feather.shopping_cart),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Text(
                  'جميع الاصناف',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          body:  SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  InkWell(
                  onTap: (){
              //navigateTo(context, ProductDetails());
        },
              child: Container(
                height: 200,
                child:   Column(
                  children: [
                    Expanded(
                      child: Image(
                        image: NetworkImage(categories[0]['categoryImage']),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            categories[0]['categoryName'],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ),
        ),
                  SizedBox(height: 30,),
                  InkWell(
                  onTap: (){
              //navigateTo(context, ProductDetails());
        },
              child: Container(
                height: 200,
                child:   Column(
                  children: [
                    Expanded(
                      child: Image(
                        image: NetworkImage(categories[2]['categoryImage']),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            categories[2]['categoryName'],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ),
        ),
                  SizedBox(height: 30,),
                  InkWell(
                  onTap: (){
              //navigateTo(context, ProductDetails());
        },
              child: Container(
                height: 200,
                child:   Column(
                  children: [
                    Expanded(
                      child: Image(
                        image: NetworkImage(categories[3]['categoryImage']),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            categories[3]['categoryName'],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ),
        ),
                  SizedBox(height: 30,),
                  InkWell(
                  onTap: (){
              //navigateTo(context, ProductDetails());
        },
              child: Container(
                height: 200,
                child:   Column(
                  children: [
                    Expanded(
                      child: Image(
                        image: NetworkImage(categories[1]['categoryImage']),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            categories[1]['categoryName'],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ),
        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
