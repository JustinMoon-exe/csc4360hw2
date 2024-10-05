import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF282A36), // Dracula background
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _currentNumber = '';
  String _operation = '';
  int _firstNumber = 0;
  bool _isNewCalculation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _output,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF8F8F2), // Dracula foreground
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 19, // Removed one button (decimal point)
                  itemBuilder: (context, index) {
                    return _buildButton(_getButtonText(index), color: _getButtonColor(index));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String buttonText, {Color color = const Color(0xFF44475A)}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 24, color: Color(0xFFF8F8F2)),
      ),
      onPressed: () => _buttonPressed(buttonText),
    );
  }

  String _getButtonText(int index) {
    const buttonTexts = [
      'C', '+/-', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '0', '='
    ];
    return buttonTexts[index];
  }

  Color _getButtonColor(int index) {
    if (index % 4 == 3) return const Color(0xFFFF79C6); // Operators
    if (index < 3) return const Color(0xFF6272A4); // Top row
    if (index == 18) return const Color(0xFF50FA7B); // Equals
    return const Color(0xFF44475A); // Numbers and other buttons
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _clear();
      } else if (buttonText == '+/-') {
        _toggleSign();
      } else if (buttonText == '%') {
        _calculatePercentage();
      } else if ('+-×÷'.contains(buttonText)) {
        _setOperation(buttonText);
      } else if (buttonText == '=') {
        _calculateResult();
      } else {
        _appendNumber(buttonText);
      }
    });
  }

  void _clear() {
    _output = '0';
    _currentNumber = '';
    _operation = '';
    _firstNumber = 0;
    _isNewCalculation = true;
  }

  void _toggleSign() {
    if (_currentNumber.isNotEmpty) {
      int number = int.parse(_currentNumber);
      _currentNumber = (-number).toString();
      _output = _currentNumber;
    }
  }

  void _calculatePercentage() {
    if (_currentNumber.isNotEmpty) {
      int number = int.parse(_currentNumber);
      _currentNumber = (number / 100).toString();
      _output = _currentNumber;
    }
  }

  void _setOperation(String op) {
    if (_currentNumber.isNotEmpty) {
      _firstNumber = int.parse(_currentNumber);
      _currentNumber = '';
      _operation = op;
      _output = '$_firstNumber $_operation';
    }
  }

  void _calculateResult() {
    if (_currentNumber.isNotEmpty && _operation.isNotEmpty) {
      int secondNumber = int.parse(_currentNumber);
      double result;
      switch (_operation) {
        case '+':
          result = _firstNumber + secondNumber.toDouble();
          break;
        case '-':
          result = _firstNumber - secondNumber.toDouble();
          break;
        case '×':
          result = _firstNumber * secondNumber.toDouble();
          break;
        case '÷':
          if (secondNumber != 0) {
            result = _firstNumber / secondNumber;
          } else {
            _output = 'Error';
            return;
          }
          break;
        default:
          return;
      }
      _output = _formatResult(result);
      _firstNumber = result.round();
      _operation = '';
      _currentNumber = '';
      _isNewCalculation = true;
    }
  }

  void _appendNumber(String number) {
    if (_isNewCalculation) {
      _currentNumber = number;
      _isNewCalculation = false;
    } else {
      _currentNumber += number;
    }
    _output = _currentNumber;
  }

  String _formatResult(double result) {
    if (result == result.roundToDouble()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(2);
    }
  }
}