import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quote_flip/model/quote_model.dart';
import 'package:quote_flip/services/get_quote_service.dart';
import 'package:quote_flip/utils/app_constants.dart';

class QuoteFlip extends StatefulWidget {
  const QuoteFlip({super.key});

  @override
  State<QuoteFlip> createState() => _QuoteFlipState();
}

class _QuoteFlipState extends State<QuoteFlip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    getQuote();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // final angle = _controller.value * -pi;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isFetchingQuote
                    ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: height * 0.65,
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                    : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: height * 0.65,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            quote?.content ?? 'No Available Quote',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 80),
                          Text(
                            quote?.author ?? '- -',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                // TweenAnimationBuilder(
                //   tween: Tween<double>(begin: 0.0, end: angle),
                //   duration: const Duration(seconds: 1),
                //   builder: (context, val, _) {
                //     if (val >= (pi / 2)) {
                //       isBack = false;
                //     } else {
                //       isBack = true;
                //     }
                //     return Transform(
                //       alignment: Alignment.center,
                //       transform: Matrix4.identity()
                //         ..setEntry(3, 2, 0.001)
                //         ..rotateY(val),
                //       child: SizedBox(
                //         child: isBack
                //             ? Container(
                //                 margin: const EdgeInsets.symmetric(horizontal: 20),
                //                 padding: const EdgeInsets.symmetric(horizontal: 15),
                //                 height: height * 0.65,
                //                 width: double.infinity,
                //                 decoration: BoxDecoration(
                //                   color: Colors.grey.withOpacity(.2),
                //                   borderRadius: BorderRadius.circular(20),
                //                 ),
                //                 child: Column(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     Text(
                //                       quote?.content ?? 'No Available Quote',
                //                       textAlign: TextAlign.center,
                //                       style: const TextStyle(
                //                         fontWeight: FontWeight.w700,
                //                       ),
                //                     ),
                //                     const SizedBox(height: 80),
                //                     Text(
                //                       quote?.author ?? '- -',
                //                       textAlign: TextAlign.center,
                //                       style: const TextStyle(
                //                         fontWeight: FontWeight.w500,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               )
                //             : Transform(
                //                 alignment: Alignment.center,
                //                 transform: Matrix4.identity()..rotateY(pi),
                //                 child: Container(
                //                   width: double.infinity,
                //                   margin: const EdgeInsets.symmetric(horizontal: 20),
                //                   height: height * 0.65,
                //                   decoration: BoxDecoration(
                //                     color: Colors.pink.withOpacity(.1),
                //                     borderRadius: BorderRadius.circular(20),
                //                   ),
                //                 ),
                //               ),
                //       ),
                //     );
                //   },
                // ),
              ],
            );
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: SizedBox(
          height: 45,
          child: ElevatedButton(
            onPressed: isFetchingQuote ? null : _flipCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            child: isFetchingQuote
                ? const CircularProgressIndicator.adaptive()
                : const Text('Get More Quotes'),
          ),
        ),
      ),
    );
  }

  bool isFrontImage(double angle) {
    const degree90 = pi / 2;
    const degree270 = 3 * pi / 2;
    return angle <= degree90 || angle > -degree270;
  }

  void _flipCard() async {
    getQuote();
    await _controller.forward();
    // setState(() {
    //   Future.delayed(const Duration(seconds: 10), () {
    //     // angle = (angle + pi) % (2 * pi);
    //   });
    // });
  }

  QuoteModel? quote;
  bool isFetchingQuote = false;

  Future<void> getQuote() async {
    try {
      setState(() {
        isFetchingQuote = true;
      });

      await Future.delayed(const Duration(seconds: 3));

      quote = await QuoteService.getQuotes(url);
    } finally {
      setState(() {
        isFetchingQuote = false;
      });
    }
  }
}
