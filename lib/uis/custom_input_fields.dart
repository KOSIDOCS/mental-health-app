import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_health_care_app/core/theme/app_colors.dart';
import 'package:mental_health_care_app/core/theme/brand_images.dart';
import 'package:mental_health_care_app/uis/spacing.dart';

class CustomInputTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputformatters;
  final String? hintText;
  const CustomInputTextField(
      {Key? key,
      this.controller,
      this.keyboardType,
      required this.obscureText,
      this.validator,
      this.inputformatters, this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CustomSpacing.kBottomSmall),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: inputformatters,
        decoration: InputDecoration(
              hintText: hintText,
            ),
      ),
    );
  }
}

class CustomInputPassword extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String obscuringCharacter;
  final String? hintText;
  const CustomInputPassword(
      {Key? key,
      this.controller,
      required this.keyboardType,
      this.validator,
      required this.obscuringCharacter,
      this.hintText})
      : super(key: key);

  @override
  State<CustomInputPassword> createState() => _CustomInputPasswordState();
}

class _CustomInputPasswordState extends State<CustomInputPassword> {
  late AnimateIconController animateCon;

  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    animateCon = AnimateIconController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: obscureText,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscuringCharacter: widget.obscuringCharacter,
            decoration: InputDecoration(
              hintText: widget.hintText,
            ),
          ),
        ),
        Positioned(
          top: -1.0,
          right: -6.0,
          child: SizedBox(
            child: AnimateIcons(
              startIcon: Icons.visibility_off,
              endIcon: Icons.visibility,
              size: 28.0,
              controller: animateCon,
              onStartIconPress: () {
                setState(() {
                  obscureText = false;
                });
                return true;
              },
              onEndIconPress: () {
                setState(() {
                  obscureText = true;
                });
                return true;
              },
              duration: const Duration(milliseconds: 500),
              startIconColor: AppColors.mentalBorderColor,
              endIconColor: AppColors.mentalBorderColor,
              clockwise: false,
            ),
          ),
        )
      ],
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? placeholder;
  final void Function(String?)? onChanged;
  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.placeholder,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.04),
      width: MediaQuery.of(context).size.width * 0.87,
      height: 47.0,
      decoration: BoxDecoration(
        color: AppColors.mentalSearchBar,
        borderRadius: BorderRadius.circular(28.5),
        border: Border.all(color: AppColors.mentalSearchBar),
      ),
      child: Transform.translate(
        offset: Offset(MediaQuery.of(context).size.width * 0.32,
            MediaQuery.of(context).size.height * 0.01),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: AppColors.mentalBrandColor,
          enableSuggestions: true,
          autocorrect: true,
          decoration: InputDecoration(
              prefixIcon: Transform.translate(
                offset: const Offset(-120.0, -8.0),
                child: Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Image.asset(
                    'assets/images/${BrandImages.kSearchIcon}',
                    width: 21.43,
                    height: 21.43,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 31.43,
                maxWidth: 31.43,
              ),
              contentPadding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 25.0,
                bottom: 25.0,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.5),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.5),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.5),
                  borderSide: BorderSide.none),
              hintText: placeholder,
              hintStyle: Theme.of(context).textTheme.headline3!.copyWith(
                  color: AppColors.mentalBarUnselected,
                  fontWeight: FontWeight.w400)),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class CustomChatField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? placeholder;
  final void Function(String?)? onChanged;
  final void Function()? openGiphy;
  final bool? hideEmojiBtn;

  const CustomChatField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.placeholder,
    this.onChanged,
    this.openGiphy, this.hideEmojiBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.67,
            height: 45.0,
            decoration: BoxDecoration(
              color: AppColors.mentalPureWhite,
              borderRadius: BorderRadius.circular(28.5),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              cursorColor: AppColors.mentalBrandColor,
              enableSuggestions: true,
              autocorrect: true,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                prefixIconConstraints: const BoxConstraints(
                  maxHeight: 16.43,
                  maxWidth: 16.43,
                ),
                contentPadding: const EdgeInsets.only(
                  left: 16.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.5),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.5),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.5),
                    borderSide: BorderSide.none),
                hintText: placeholder,
                hintStyle: Theme.of(context).textTheme.headline3!.copyWith(
                      color: AppColors.mentalBarUnselected,
                      fontWeight: FontWeight.w400,
                      fontSize: 13.0,
                    ),
                // suffixIcon: Transform.translate(
                //   offset: const Offset(-15.0, 0.0),
                //   child: Image.asset(
                //     'assets/images/${BrandImages.kIconSticker}',
                //     height: 18.8,
                //     width: 18.8,
                //   ),
                // ),
                suffixIconConstraints: BoxConstraints(
                  maxHeight: 18.8,
                  maxWidth: 18.8,
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: onChanged,
            ),
          ),
        ),
        hideEmojiBtn! ? Container() : Positioned(
          right: 13.0,
          top: 13.0,
          child: GestureDetector(
            onTap: openGiphy,
            child: Image.asset(
              'assets/images/${BrandImages.kIconSticker}',
              height: 18.8,
              width: 18.8,
            ),
          ),
        ),
      ],
    );
  }
}
