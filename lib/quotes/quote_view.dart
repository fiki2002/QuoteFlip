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

class _QuoteFlipState extends State<QuoteFlip> {
  bool isBack = false;

  double angle = 0;
  @override
  void initState() {
    getQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: angle),
            duration: const Duration(seconds: 1),
            builder: (context, val, _) {
              if (val >= (pi / 2)) {
                isBack = false;
              } else {
                isBack = true;
              }
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(val),
                child: SizedBox(
                  child: isBack
                      ? Container(
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
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(pi),
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: height * 0.65,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: SizedBox(
          height: 45,
          child: ElevatedButton(
            onPressed: _flipCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(.1),
            ),
            child: const Text('Get More Quotes'),
          ),
        ),
      ),
    );
  }

  void _flipCard() {
    getQuote();
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  QuoteModel? quote;
  Future<void> getQuote() async {
    Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      isBack = true;
    });
    quote = await QuoteService.getQuotes(url);
  }
}
