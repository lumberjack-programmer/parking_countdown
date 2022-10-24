import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parking_countdown/painters/bottom_nav_bar.dart';
import 'package:parking_countdown/painters/countdown_circular.dart';
import 'package:parking_countdown/widgets/PositionedText.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'dart:math' as math;
import 'constants.dart';


void main() {
  runApp(const MyApp());
}
final GlobalKey<SlideActionState> _key = GlobalKey();
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  double targetValue = 0.0;
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 60);
  AnimationStatus animationStatus = AnimationStatus.dismissed;
  bool isRunTimer = false;
  late AnimationController _waveController;
  late Animation<double> _timerAnimation;
  late AnimationController _timerController;
  final String carImage = 'https://www.seekpng.com/png/full/79-799626_yellow-top-car-car-top-view-png.png';


  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> _animation = CurvedAnimation(
    curve: Curves.fastOutSlowIn, parent: _controller,
  );

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      vsync: this,
      lowerBound: 0.1,
      duration: const Duration(seconds: 1),
    );

    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    Tween<double> animationTween = Tween(begin: 0.0, end: 2 * math.pi);

    _timerAnimation = animationTween.animate(_timerController)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isRunTimer = false;
            _timerController.reset();
            resetTimer();
            if (_waveController.status == AnimationStatus.completed) {
              _waveController.reset();
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _waveController.dispose();
    _timerController.dispose();
    _key.currentState?.dispose();
    super.dispose();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountdown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(seconds: 0));
  }

  void setCountdown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    Widget _buildCircularContainer(double radius) {
      return AnimatedBuilder(
        animation: CurvedAnimation(parent: _waveController, curve: Curves.fastLinearToSlowEaseIn),
        builder: (context, child) {
          return Container(
            width: _waveController.value * radius,
            height: _waveController.value * radius,
            decoration: BoxDecoration(color: Colors.yellow.withOpacity(1 - _waveController.value), shape: BoxShape.circle),
          );
        },
      );
    }

    // Timer
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));


    final Size size = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('@lumberjack_programmer'),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        actions: const [
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),child: CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Icon(Icons.segment),
          ),),
        ],
      ),


      body: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: targetValue),
        duration: const Duration(seconds: 1),
        builder: (BuildContext context, double position, Widget? child) {
          return Stack(
            children: [
              Positioned(
                bottom: position,
                left: 0,
                child: SizedBox(
                  width: size.width,
                  height: 110.0,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(size.width, size.height),
                        painter: BottomNavBarPainter(),
                      ),

                      Center(
                        heightFactor: 0.1,
                        child: GestureDetector(
                          onTap: () {

                          },
                          child: SizedBox(
                            height: 60.0,
                            width: 60.0,
                            child: FloatingActionButton(
                              backgroundColor: kMainButtonColor,
                              child: Icon(Icons.lock_open, color: Colors.white, size: 25.0,),
                              onPressed: () {
                                setState(() {
                                  targetValue = targetValue == 100.0 ? 0.0 : 100.0;
                                  if (targetValue == 100.0) {
                                    _controller..upperBound..forward();
                                  }
                                  if (targetValue == 0.0) {
                                    _controller..lowerBound..reverse();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            color: kPrimaryColor,
                            child: InkWell(
                              child: const Icon(Icons.home, color: kIconColor, size: 28,),
                              onTap: () {
                                setState(() {
                                  // Do something for Home button
                                });
                              },
                            ),
                          ),
                          const Icon(Icons.location_pin, color: kIconColor, size: 28,),
                          Container(width: 20.0,),
                          const Icon(Icons.navigation, color: kIconColor, size: 28,),
                          const Icon(Icons.settings, color: kIconColor, size: 28,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 1,
                left: 0,
                child: SizedBox(
                  width: size.width,
                  height: position,
                  // color: Colors.white,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0,),
                        height: double.infinity,
                        color: kPrimaryColor,
                        child: ScaleTransition(
                          scale: _animation,
                          child: Builder(
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: isRunTimer == true ? SlideAction(
                                  sliderButtonIcon: const Icon(Icons.lock_open, color: Colors.black, size: 25.0,),
                                  sliderButtonIconPadding: 8.0,
                                  textStyle: const TextStyle(fontSize: 18.0, color: kPrimaryColor, wordSpacing: 1.2),
                                  text: 'End parking',
                                  height: 50.0,
                                  outerColor: kBackgroundColor,
                                  innerColor: kPrimaryColor,
                                  key: _key,
                                  onSubmit: () {
                                    Future.delayed(
                                        const Duration(seconds: 1),
                                            () {
                                          _timerController.reset();
                                          resetTimer();
                                          _key.currentState?.dispose();
                                        }
                                    );
                                  },
                                ) : Container(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 0,
                bottom: 350,
                child: Container(
                  width: size.width,
                  height: 100.0,
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: CountdownCircularPainter(
                            _timerAnimation.value
                        ),
                        size: Size(size.width, size.height),
                      ),

                      Center(child: Container(child: _buildCircularContainer(200))),
                      Center(child: Container(child: _buildCircularContainer(250))),
                      Center(child: Container( child: _buildCircularContainer(300))),

                      Center(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Image.network(carImage,
                            width: 200.0,
                          ),
                        ),
                      ),

                      Center(
                        child: isRunTimer == false ? IconButton(
                          icon: const Icon( Icons.play_circle,
                            color: kBackgroundColor, size: 39.0,),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              _waveController.forward();

                              if (_waveController.status == AnimationStatus.completed) {
                                _waveController.reset();
                              }

                              if (!isRunTimer) {
                                startTimer();
                                _timerController.forward();
                              }
                              if (isRunTimer) {
                                _timerController.reset();
                                resetTimer();
                              }
                              isRunTimer = !isRunTimer;
                            });
                          },
                        ) : Container(),
                      ),

                      PositionedText(left: size.width * .34, text: 'Parking Time', top: 390, fontSize: 20.0, color: kSecondaryColor,),
                      PositionedText(left: size.width / 3.5, text: '$hours:$minutes:$seconds', top: 410, fontSize: 39.0, color: Colors.white,),
                      PositionedText(left: size.width / 2.6, text: '10 KED', top: 450, fontSize: 24.0, color: kPrimaryColor,),

                    ],
                  ),
                ),
              ),


            ],
          );
        },

      ),
    );
  }


}










