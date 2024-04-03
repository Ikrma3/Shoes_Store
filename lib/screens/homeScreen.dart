import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/cartScreen.dart';
import 'package:shop_app/screens/loginScreen.dart';
import 'package:shop_app/screens/productScreen.dart';
import 'responsiveScreen.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> products = [];
  late PageController _pageController;
  int _currentPage = 0;
  int? _hoveredIndex; // Index of the product being hovered
  String? userId; // Variable to store the userId obtained from backend

  @override
  void initState() {
    super.initState();
    // Fetch product data from your backend
    fetchProductData();
    _pageController = PageController(initialPage: 0);
  }

  Future<void> fetchProductData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:4000/homePage'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<Map<String, dynamic>> productsData = List<Map<String, dynamic>>.from(responseData['products']);
        userId = responseData['userIp']; // Assuming user IP is received as user ID

        setState(() {
          products = productsData;
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void _showNextImage() {
    if (_currentPage < products.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showPreviousImage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(223, 255, 255, 255),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/background.png', // Path to your logo image
              height: 62,// Adjust the height as needed
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          IconButton( // Add IconButton for cart
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(userId: userId ?? ''), // Pass userId to CartScreen
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ResponsiveScreen(
              mobileLayout: Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: products.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          products[index]['imageUrl'],
                          fit: BoxFit.contain,
                        );
                      },
                      controller: _pageController,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: _showPreviousImage,
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: _showNextImage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              desktopLayout: Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: products.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          products[index]['imageUrl'],
                          fit: BoxFit.contain,
                        );
                      },
                      controller: _pageController,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: _showPreviousImage,
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: _showNextImage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the number of columns dynamically based on screen width
                int crossAxisCount =
                    constraints.maxWidth < 600 ? 2 : 4; // 2 columns for mobile, 4 columns for desktop
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.05, // Decreased aspect ratio for shorter cards
                    mainAxisExtent: 148 + 200, // Increased height by 248 pixels
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await fetchProductData(); 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(
                              productId: products[index]['_id'], 
                              userId: userId ?? '', // Pass userId to ProductScreen
                            ),
                          ),
                        );
                      },
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _hoveredIndex = index;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _hoveredIndex = null;
                          });
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: Duration(milliseconds: 500),
                                builder: (context, double value, child) {
                                  double scaleFactor = 1.0 + (value * (_hoveredIndex == index ? 0.1 : 0.0));
                                  return Transform.scale(
                                    scale: scaleFactor,
                                    child: child,
                                  );
                                },
                                child: Image.network(
                                  products[index]['imageUrl'],
                                  height: 300, // Adjusted height for shorter cards
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  products[index]['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '\$${products[index]['price']}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
