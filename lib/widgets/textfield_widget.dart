import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String? hint;
  bool? isObscure;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final int? maxLine;
  final TextInputType? inputType;
  final bool? isPassword;
  final bool? enabled;
  final String? Function(String?)? validator;
  final bool? isRequred;
  final Function? onChangeText;
  final List<TextInputFormatter>? inputFormatters;

  TextFieldWidget({
    super.key,
    required this.label,
    this.enabled = true,
    this.hint = '',
    required this.controller,
    this.isObscure = false,
    this.width = 300,
    this.height = 60,
    this.maxLine = 1,
    this.isPassword = false,
    this.isRequred = false,
    this.inputType = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.onChangeText,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Bold',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.isRequred!
                  ? const TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Bold',
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const TextSpan(
                      text: '',
                      style: TextStyle(
                        fontSize: 0,
                        fontFamily: 'Bold',
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
                enabled: widget.enabled,
                keyboardType: widget.inputType,
                onChanged: (value) {
                  if (widget.onChangeText != null) {
                    widget.onChangeText!();
                  }
                },
                inputFormatters: widget.inputFormatters,
                decoration: InputDecoration(
                  suffixIcon: widget.isPassword!
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              widget.isObscure = !widget.isObscure!;
                            });
                          },
                          icon: widget.isObscure!
                              ? const Icon(Icons.remove_red_eye)
                              : const Icon(Icons.visibility_off),
                        )
                      : const SizedBox(),
                  hintText: widget.hint,
                  border: InputBorder.none,
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  errorStyle:
                      const TextStyle(fontFamily: 'QBold', fontSize: 12),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                maxLines: widget.maxLine,
                obscureText: widget.isObscure!,
                controller: widget.controller,
                validator: widget.validator),
          ),
        ),
      ],
    );
  }
}
