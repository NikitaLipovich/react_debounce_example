import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _formattedValue = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onInputChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onInputChange);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onInputChange() {
    final String inputValue = _controller.text.replaceAll(',', '');
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 3000), () {
      if (RegExp(r'^[0-9]*\.?[0-9]*$').hasMatch(inputValue)) {
        setState(() {
          _formattedValue = _formatNumber(inputValue);
          _controller.value = _controller.value.copyWith(
            text: _formattedValue,
            selection: TextSelection.collapsed(offset: _formattedValue.length),
          );
        });
        _fetchData(inputValue);
      }
    });
  }

  Future<void> _fetchData(String value) async {
    // Здесь нужно добавить логику запроса к серверу
    print('Fetching data for: $value');
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return '';
    final parts = value.split('.');
    parts[0] = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (Match match) => ',');
    return parts.join('.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Введите число',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
