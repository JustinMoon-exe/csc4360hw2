// CSC 4360
// Justin Moonjeli

import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key); // Constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App', // Title of the app
      theme: ThemeData(
        // Define the theme data for the application
        scaffoldBackgroundColor: const Color(0xFF282A36), // Background color for the app
      ),
      home: const CalculatorScreen(), // Set the home screen to CalculatorScreen
    );
  }
}

// Stateful widget representing the calculator screen.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key); // Constructor

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState(); // Create the state for this widget
}

// State for the CalculatorScreen that holds the calculator's logic.
class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0'; // Current output displayed on the calculator
  String _currentNumber = ''; // Holds the current number being input
  String _operation = ''; // Holds the current operation (e.g., +, -, etc.)
  int _firstNumber = 0; // Stores the first number for calculations
  bool _isNewCalculation = true; // Indicates if a new calculation is starting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300), // Max width for the calculator
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
              children: [
                // Display output
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _output, // Output text
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF8F8F2), // Output text color
                    ),
                  ),
                ),
                // Grid view for calculator buttons
                GridView.builder(
                  shrinkWrap: true, // Ensure the grid view doesn't take more space than necessary
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Number of buttons per row
                    childAspectRatio: 1, // Aspect ratio of buttons
                    crossAxisSpacing: 8, // Space between buttons in a row
                    mainAxisSpacing: 8, // Space between buttons in a column
                  ),
                  itemCount: 20, // Total number of buttons (excluding the decimal point) + 2 to support the having my name
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

  // Method to create a button widget.
  Widget _buildButton(String buttonText, {Color color = const Color(0xFF44475A)}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Background color of the button
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
        padding: EdgeInsets.zero, // No padding
      ),
      child: Text(
        buttonText, // Text displayed on the button
        style: const TextStyle(fontSize: 24, color: Color(0xFFF8F8F2)), // Button text style
      ),
      onPressed: () => _buttonPressed(buttonText), // Button click handler
    );
  }

  // Method to get the text for a specific button based on its index.
  String _getButtonText(int index) {
    const buttonTexts = [
      'C', '+/-', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '0', '=', 'J', 'M',
    ];
    return buttonTexts[index]; // Return the corresponding button text
  }

  // Method to determine the color of a button based on its index.
  // Follows my favorite color scheme, Dracula
  Color _getButtonColor(int index) {
    if (index >= 18) return const Color(0xFFBD93F9); // Color for 'J' and 'M' buttons
    if (index % 4 == 3) return const Color(0xFFFF79C6); // Color for operator buttons
    if (index < 3) return const Color(0xFF6272A4); // Color for top row buttons
    return const Color(0xFF44475A); // Default color for number buttons
  }

  // Method to handle button presses.
  void _buttonPressed(String buttonText) {
    setState(() {
      // Update state based on the button pressed
      if (buttonText == 'C') {
        _clear(); // Clear all values
      } else if (buttonText == '+/-') {
        _toggleSign(); // Toggle the sign of the current number
      } else if (buttonText == '%') {
        _calculatePercentage(); // Calculate the percentage
      } else if ('+-×÷'.contains(buttonText)) {
        _setOperation(buttonText); // Set the current operation
      } else if (buttonText == '=') {
        _calculateResult(); // Calculate the result
      } else {
        _appendNumber(buttonText); // Append number to the current input
      }
    });
  }

  // Method to clear all values and reset the calculator.
  void _clear() {
    _output = '0'; // Reset output
    _currentNumber = ''; // Reset current number
    _operation = ''; // Reset operation
    _firstNumber = 0; // Reset first number
    _isNewCalculation = true; // Indicate a new calculation has started
  }

  // Method to toggle the sign of the current number.
  void _toggleSign() {
    if (_currentNumber.isNotEmpty) { // Check if there's a current number
      int number = int.parse(_currentNumber); // Convert current number to an integer
      _currentNumber = (-number).toString(); // Toggle sign
      _output = _currentNumber; // Update output
    }
  }

  // Method to calculate the percentage of the current number.
  void _calculatePercentage() {
    if (_currentNumber.isNotEmpty) { // Check if there's a current number
      int number = int.parse(_currentNumber); // Convert current number to an integer
      _currentNumber = (number / 100).toString(); // Calculate percentage
      _output = _currentNumber; // Update output
    }
  }

  // Method to set the current operation for the calculation.
  void _setOperation(String op) {
    if (_currentNumber.isNotEmpty) { // Check if there's a current number
      _firstNumber = int.parse(_currentNumber); // Store the first number
      _currentNumber = ''; // Reset current number
      _operation = op; // Set the operation
      _output = '$_firstNumber $_operation'; // Update output to show operation
    }
  }

  // Method to calculate the result based on the first number, second number, and operation.
  void _calculateResult() {
    if (_currentNumber.isNotEmpty && _operation.isNotEmpty) { // Ensure both numbers and operation are set
      int secondNumber = int.parse(_currentNumber); // Convert current number to integer
      double result;
      switch (_operation) { // Determine operation to perform
        case '+':
          result = _firstNumber + secondNumber.toDouble(); // Addition
          break;
        case '-':
          result = _firstNumber - secondNumber.toDouble(); // Subtraction
          break;
        case '×':
          result = _firstNumber * secondNumber.toDouble(); // Multiplication
          break;
        case '÷':
          if (secondNumber != 0) { // Check for division by zero
            result = _firstNumber / secondNumber; // Division
          } else {
            _output = 'Error'; // Display error for division by zero
            return; // Exit method to prevent further calculations
          }
          break;
        default:
          return; // Exit method if no valid operation
      }
      _output = _formatResult(result);
      _firstNumber = result.round(); // Store the result as the first number for future operations
      _operation = '';
      _currentNumber = '';
      _isNewCalculation = true;
    }
  }

  // Method to append a number to the current input.
  void _appendNumber(String number) {
    if (_isNewCalculation) {
      _currentNumber = number; // Set current number
      _isNewCalculation = false; // Reset new calculation flag
    } else {
      _currentNumber += number; // Append number to current input
    }
    _output = _currentNumber; // Update output
  }

   String _formatResult(double result) {
    // Check if the result is a whole number and format accordingly
    if (result == result.roundToDouble()) {
      return result.toInt().toString(); // Return as integer
    } else {
      return result.toStringAsFixed(2); // Return as a string with 2 decimal places
    }
  }
}
