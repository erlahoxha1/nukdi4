import 'package:flutter/material.dart';
import 'package:nukdi2/common/widgets/single_product.dart';
import 'package:nukdi2/constants/global_variables.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  //temp list
  List list = [
    'https://unsplash.com/photos/V-YF3rkoHOk/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8Mnx8Y2FyJTIwcGFydHxlbnwwfHx8fDE3NDczNzM2MTB8MA&force=true',
    'https://unsplash.com/photos/V-YF3rkoHOk/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8Mnx8Y2FyJTIwcGFydHxlbnwwfHx8fDE3NDczNzM2MTB8MA&force=true',
    'https://unsplash.com/photos/V-YF3rkoHOk/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8Mnx8Y2FyJTIwcGFydHxlbnwwfHx8fDE3NDczNzM2MTB8MA&force=true',
    'https://unsplash.com/photos/V-YF3rkoHOk/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8Mnx8Y2FyJTIwcGFydHxlbnwwfHx8fDE3NDczNzM2MTB8MA&force=true',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              child: const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                'See all',
                style: TextStyle(color: GlobalVariables.selectedNavBarColor),
              ),
            ),
            // display orders
          ],
        ),
        Container(
          height: 170,
          padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return SingleProduct(image: list[index]);
            },
          ),
        ),
      ],
    );
  }
}
