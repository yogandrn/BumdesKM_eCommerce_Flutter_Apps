import 'package:flutter/material.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/review.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/long_text_widget.dart';
import 'package:bumdeskm/widgets/small_text.dart';

class ReviewItem extends StatelessWidget {
  Review review;
  var id;
  ReviewItem({Key? key, required this.review, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width - 20,
      height: 140,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor, width: 1.2),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(255, 170, 170, 170),
              offset: Offset(1, 4),
              blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 13,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(ApiService().imgURL + "${review.image}"),
                      radius: 11.5,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SmallText(
                    text: "${review.username}",
                    size: 13.5,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              SmallText(
                text: "${review.time}",
                size: 12,
                weight: FontWeight.w400,
                color: Color(0xFF505050),
              )
            ],
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: grey81,
          ),
          SizedBox(
            height: 4,
          ),
          LongText(
            text: "${review.comment}",
            color: grey40,
            size: 13.6,
            weight: FontWeight.w500,
          )
        ],
      ),
    );
  }
}
