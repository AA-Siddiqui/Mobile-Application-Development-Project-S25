import 'dart:async';
import 'package:flutter/material.dart';

class DebouncedTextField extends StatefulWidget {
  final String initialValue;
  final Future<void> Function(int) action;

  const DebouncedTextField({
    super.key,
    required this.initialValue,
    required this.action,
  });

  @override
  State<DebouncedTextField> createState() => _DebouncedTextFieldState();
}

class _DebouncedTextFieldState extends State<DebouncedTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Timer? _debounce;
  bool _isUpdating = false;
  String _previous = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue,
    );
    _focusNode = FocusNode();

    // Trigger update on focus loss
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _updateMarks(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(seconds: 5), () {
      if (!_isUpdating) {
        _updateMarks(value.isEmpty ? "0" : value);
      }
    });
  }

  void _onSubmitted(String value) {
    _debounce?.cancel(); // Cancel pending debounce
    _updateMarks(value); // Immediate update on Enter
  }

  Future<void> _updateMarks(String value) async {
    if (_previous == value) return;
    if (_isUpdating) return;

    final int? newMarks = int.tryParse(value);
    if (newMarks == null) return;

    setState(() {
      _isUpdating = true;
    });
    try {
      await widget.action(newMarks);
      _previous = value;
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.end,
      enabled: !_isUpdating,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),
      controller: _controller,
      focusNode: _focusNode,
      onChanged: _onChanged,
      onSubmitted: _onSubmitted,
    );
  }
}
