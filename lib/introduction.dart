import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SkipButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
              ));
        },
        child: Text('Skip'),
      ),
    );
  }
}

class SimplePageView extends StatefulWidget {
  const SimplePageView({Key? key}) : super(key: key);

  @override
  _SimplePageViewState createState() => _SimplePageViewState();
}

class _SimplePageViewState extends State<SimplePageView> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      int next = _controller.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildPage(String text, Color color) {
    return Stack(
      children: [
        Container(color: color, child: Center(child: Text(text))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(), // Make pages not scrollable
              children: <Widget>[
                buildPage('Page 1', Colors.red),
                buildPage('Page 2', Colors.green),
                buildPage('Page 3', Colors.blue),
              ],
            ),
            SkipButton(),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const WormEffect(
                    dotHeight: 16,
                    dotWidth: 16,
                    type: WormType.thinUnderground,
                  ),
                ),
              ),
            ),
            if (_currentPage > 0)
              Positioned(
                bottom: 20,
                left: 20,
                child: ElevatedButton(
                  onPressed: () {
                    _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  child: Text('Previous'),
                ),
              ),
            if (_currentPage < 2)
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  child: Text('Next'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
