import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:koruko_app/core/path/string.router.dart';
import 'package:koruko_app/core/widgets/app_bar.dart';
import 'package:koruko_app/core/widgets/custom_cart.dart';
import 'package:koruko_app/core/widgets/grid_item.dart';
import 'package:koruko_app/presentation/home/model/grid_item.model.dart';
import 'package:koruko_app/service/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuthService().currentUser;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      context.go(RouterPath.login);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPressGridItem({required BuildContext context, required String path}) {
    if (path == '') return;
    if(path == '/logout') { 
      signOut(context);
      return;
    }
    context.push(path);
  }

  final List<String> images = [
    'assets/images/image_1.jpg',
    'assets/images/image_2.jpg',
    'assets/images/slideshow2.png',
    'assets/images/slideshow3.png',
  ];

  @override
  Widget build(BuildContext context) {
    //double mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Trang chủ',
        hideBackButton: true,
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Xin chào, ${currentUser!.email}' ?? '',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200.0,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () =>
                              context.push(RouterPath.listMedicalClinic),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                DotsIndicator(
                  dotsCount: images.length,
                  position: _currentPage,
                  decorator: DotsDecorator(
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomCard(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns
                    crossAxisSpacing: 4, // Horizontal space between cards
                    mainAxisSpacing: 4, // Vertical space betw  een cards
                  ),
                  shrinkWrap: true,
                  itemCount: listGridItem.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = listGridItem[index];
                    return GestureDetector(
                      onTap: () =>
                          onPressGridItem(context: context, path: item.path),
                      child: GridViewItem(
                        color: item.color,
                        icon: item.icon,
                        text: item.text,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
