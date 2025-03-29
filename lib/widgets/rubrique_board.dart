import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RubriqueBoard extends StatelessWidget {
  final String text;
  final IconData? iconRubrique;
  final Widget? destination;
  final Color? bgcolor;
  final Color? textcolor;
  final double width;
  final double height;
  final double txtsize;
  final VoidCallback? onTapOverride;
  final Color? borderColor;

  const RubriqueBoard({
    super.key,
    required this.text,
    this.iconRubrique = LucideIcons.arrowUpRight,
    this.destination,
    this.bgcolor = const Color.fromARGB(255, 53, 172, 177),
    this.textcolor = Colors.white,
    this.height = 115,
    this.width = 170,
    this.txtsize = 10,
    this.onTapOverride,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTapOverride != null) {
          onTapOverride!();
        } else {
          if (destination != null) {
            Navigator.push(context,MaterialPageRoute(builder: (context) => destination!));
          }
        }
      },

      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.circular(30),
           border: borderColor != null ? Border.all(color: borderColor!, width: 2) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      text.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins( color: textcolor, fontSize: txtsize,fontWeight: FontWeight.w600, ),
                    ),
                  ),
                  if (iconRubrique != null) const SizedBox(height: 20),
                ],
              ),

              Positioned(
                bottom: 10,
                right: 1,
                child: iconRubrique != null
                    ? CircleAvatar( backgroundColor: Colors.black, radius: 20, child: Icon(iconRubrique, color: Colors.white, size: 20))
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
