import 'dart:math';

import 'package:flutter/cupertino.dart';
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.bounceIn,
            switchOutCurve: Curves.bounceOut,
            child: isFetchingQuote
                ? Container(
                    key: const ValueKey(false),
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: height * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )
                : Container(
                    key: const ValueKey(true),
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
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 80),
                        Text(
                          '- ${quote?.author ?? '- -'}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final rotate = Tween(begin: pi, end: 0.0).animate(animation);
              return AnimatedBuilder(
                animation: rotate,
                child: child,
                builder: (context, child) {
                  final angle = (ValueKey(isFetchingQuote) != widget.key)
                      ? min(rotate.value, pi / 2)
                      : rotate.value;
                  return Transform(
                    transform: Matrix4.rotationY(angle),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
              );
            },
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: isFetchingQuote ? null : _flipCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            child: isFetchingQuote
                ? const CupertinoActivityIndicator()
                : const Text('Get More Quotes'),
          ),
        ),
      ),
    );
  }

  void _flipCard() async {
    setState(() {
      isFetchingQuote = !isFetchingQuote;
    });
    getQuote();
  }

  QuoteModel? quote;
  bool isFetchingQuote = false;

  Future<void> getQuote() async {
    try {
      setState(
        () {
          isFetchingQuote = true;
        },
      );

      await Future.delayed(const Duration(milliseconds: 1500));

      quote = await QuoteService.getQuotes(url);
    } finally {
      setState(
        () {
          isFetchingQuote = false;
        },
      );
    }
  }
}
