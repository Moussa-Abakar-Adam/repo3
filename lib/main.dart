import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'signIn.dart' as sign_in;
import 'signUp.dart' as sign_up;
import 'calculator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD6sFXMfYWU3m3y0GkHFDXGfA4YFSlpsMY",
            authDomain: "calculatore-189c3.firebaseapp.com",
            projectId: "calculatore-189c3",
            storageBucket: "calculatore-189c3.appspot.com",
            messagingSenderId: "717388086187",
            appId: "1:717388086187:web:28bf6cbe008a3ef223f0ee"));
  } else {
    Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true; // Initial theme mode is dark mode
  bool _isConnected = true; // Initial internet connectivity state
  late Connectivity _connectivity;
  String _connectionStatus = ''; // Default connection status

  final ThemeData _lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.grey[200],
    primaryColor: Colors.blue[900],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );

  final ThemeData _darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.grey[900],
    primaryColor: Colors.blue[900],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
  );

  ThemeData getTheme() {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    // Initialize connectivity status
    _connectivity.checkConnectivity().then((connectivityResult) {
      setState(() {
        _isConnected = connectivityResult != ConnectivityResult.none;
        _connectionStatus = _isConnected ? 'Connected' : 'No Internet';
      });
    });
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
        _connectionStatus = _isConnected ? 'Connected' : 'No Internet';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: getTheme(),
      home: HomeScreen(
        toggleTheme: toggleTheme,
        isConnected: _isConnected,
        connectionStatus: _connectionStatus,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isConnected;
  final String connectionStatus;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isConnected,
    required this.connectionStatus,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("My App"),
            const SizedBox(width: 10),
            _buildConnectionStatusIndicator(),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: widget.toggleTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.login), text: 'Sign In'),
            Tab(icon: Icon(Icons.app_registration), text: 'Sign Up'),
            Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Sign In'),
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Sign Up'),
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Calculator'),
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(2);
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // Conditional rendering based on connectivity state
          if (!widget.isConnected)
            Center(
              child: Text(
                'No Internet Connection',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          const sign_in.SignInScreen(),
          const sign_up.SignUpScreen(),
          const CalculatorScreen(),
        ],
      ),
    );
  }

  Widget _buildConnectionStatusIndicator() {
    Color indicatorColor = widget.isConnected ? Colors.green : Colors.red;
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: indicatorColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        widget.connectionStatus,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
