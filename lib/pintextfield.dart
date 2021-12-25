import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

class PinTextField extends StatefulWidget {
  final int number;
  final double width;
  final Function(String code) onComplete;
  final Function(String value) validator;
  final bool obscureText;
  final TextStyle style;
  final InputDecoration? decoration;
  final String validateErrorText;
  const PinTextField(
      {Key? key,
      required this.number,
      required this.onComplete,
      required this.validator,
      this.width = 50,
      this.obscureText = false,
      this.style = const TextStyle(color: Colors.grey),
      this.decoration,
      this.validateErrorText = 'Please Enter Complete Codes!'})
      : super(key: key);

  @override
  _PinTextFieldState createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focuses;
  bool isError = false;

  @override
  void initState() {
    controllers =
        List.generate(widget.number, (index) => TextEditingController());
    focuses = List.generate(widget.number, (index) => FocusNode());

    super.initState();
  }

  errorMessage(String? value) {
    if (value != null) {
      //check backspace
      if (!value.codeUnits.contains(0)) {
        return null;
      }
    }

    if (!isError) {
      widget.validator(widget.validateErrorText);
      isError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: controllers
          .mapIndexed((index, e) => SizedBox(
              width: widget.width,
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) {
                  if (event is RawKeyDownEvent) {
                    isError = false;
                    e.text = event.character!;
                  }
                  //next textfield focus
                  else if (event is RawKeyUpEvent) {
                    if (index == controllers.length - 1) {
                      FocusScope.of(context).unfocus();
                    } else {
                      //not backspace
                      if (event.logicalKey != LogicalKeyboardKey.backspace) {
                        context.nextEditableTextFocus();
                      }
                    }

                    String code = '';
                    for (var e in controllers) {
                      // 0 => backspace utf-16 code
                      if (!e.text.codeUnits.contains(0)) {
                        code = code + e.text;
                      }
                    }
                    if (code.length == widget.number) {
                      widget.onComplete(code);
                    }
                  }
                },
                child: TextFormField(
                  validator: (value) => errorMessage(value),
                  textAlign: TextAlign.center,
                  controller: e,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                  ],
                  obscureText: widget.obscureText,
                  style: widget.style,
                  focusNode: focuses[index],
                  decoration: widget.decoration ?? defaultInputDecoration(),
                ),
              )))
          .toList(),
    );
  }
}

InputDecoration defaultInputDecoration() {
  return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.orange,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      errorMaxLines: 2);
}

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (
        FocusScope.of(this).focusedChild?.context?.widget is! EditableText);
  }
}
