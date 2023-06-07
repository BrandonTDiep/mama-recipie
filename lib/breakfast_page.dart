import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:mama_recipe_app/breakfast_recipe_add_page.dart';
import 'package:mama_recipe_app/breakfast_recipes.dart';
import 'package:mama_recipe_app/main.dart';
import 'package:mama_recipe_app/shopping_list.dart';
import 'breakfast_data.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BreakfastPage extends StatefulWidget {
  const BreakfastPage({Key? key}) : super(key: key);

  @override
  State<BreakfastPage> createState() => _BreakfastPageState();
}

class _BreakfastPageState extends State<BreakfastPage> {
  int _selectedIndex = 0;
  int _counter = 0;

  String searchValue = '';
  final List<String> _suggestions = ['Apple', 'Pear','Grape'];
  final List<String> meals = ["Breakfast", "Lunch", "Dinner"];

  List<Breakfast> breakfastRecipes = [];

  _BreakfastPageState() {
    Breakfast b1 = Breakfast("Pho",
        "https://media.timeout.com/images/105950096/750/422/image.jpg",
        "1 hr",  "2", "Broth\nnoodles\nmeat", "Step 1: Broil Broth\nStep 2: Cook meat");
    Breakfast b2 = Breakfast("Chicken Rice",
        "https://www.thespruceeats.com/thmb/_JsWPTIIvL9hvlnkyrqCfjzJf34=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/hainanese-chicken-rice-very-detailed-recipe-3030408-hero-01-91c4d305f0ae400198cf7c63d8b7261f.jpg",
        "30 minutes",
        "4", "rice\nchicken", "Step 1: Cook Rice\nStep 2: Cook chicken");

    breakfastRecipes = [b1, b2];
  }

  Future<List<String>> _fetchSuggestions(String searchValue) async {
    return _suggestions.where ((element){
      return element.toLowerCase().contains(searchValue.toLowerCase());
    }).toList();
  }

  Future<void> _addRecipe() async {
    final updatedRecipe = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  BreakfastRecipeAddPage(breakfastRecipes)),
    );

    if(updatedRecipe != null) {
      setState(() {
        breakfastRecipes = updatedRecipe;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex == 1){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShoppingListPage()),
        );
      }
      else{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (route) => false
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
          backgroundColor: Colors.red,
          title: const Text("Breakfast Recipes", style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
          onSearch: (value) => setState(() => searchValue = value),
          asyncSuggestions: (value) async =>
          await _fetchSuggestions(searchValue)
      ),
      body: ListView.builder(
          itemCount: breakfastRecipes.length,
          itemBuilder: (BuildContext context, int index) {
            print(breakfastRecipes.length);
            return  Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Ink.image(
                    image:  NetworkImage(breakfastRecipes[index].imgUrl),
                    height: 150,
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BreakfastRecipesPage(breakfastRecipes[index])),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: EdgeInsets.only(left: 8, bottom: 5),
                        child: Text(
                          breakfastRecipes[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: EdgeInsets.only(right: 8, bottom: 5),
                        child: Text(
                          breakfastRecipes[index].cookTime,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create_sharp),
            label: 'Shopping List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        //backgroundColor: Colors.red,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecipe,
        tooltip: 'Add Recipe',
        child: const Icon(Icons.add),
      ), // Th
    );
  }
}
