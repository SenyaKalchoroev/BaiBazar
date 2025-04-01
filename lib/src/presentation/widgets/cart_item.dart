import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CartItemWidget extends StatelessWidget {
  final String image;
  final String title;
  final String weight;
  final String price;

  const CartItemWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.weight,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 130,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.asset(
                image,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weight,
                          style: const TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          price,
                          style: const TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color(0xFF148A09),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFFF),
                        ),
                        child:  SvgPicture.asset(
                            'assets/ic_delete.svg'
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
