
import 'package:flutter/material.dart';
// import 'package:techtesser/drag.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _urlImages = [
  "https://i.ibb.co/8dmR2RQ/download.jpg",
  "https://i.ibb.co/XWx0mDn/download.jpg",
  "https://i.ibb.co/WtfSrTb/download.jpg",
  "https://i.ibb.co/GQnGPnd/download.jpg"
  ];

  List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.grey,
    Colors.indigo
  ];
  bool isTextVisible = false;
  final _textControl = TextEditingController();
  String userInput = "";

  int _activeIndex = 0;
  PageController _pageController = PageController();
  int _currentPage = -1;
  double leftValue = 140;
  double topValue = 140;
  double rightValue = 140;
  double bottomValue = 140;
  double newLeftValue = 100;
  double newTopValue = 100;
  Color textColor = Colors.black;
  double _fontSize = 20;
  Future Sheet(context,Function(Color color)? onDone) async{
    await showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
              height: 200,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Change colors",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500
                        ),)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(_colors.length, (index) => InkWell(
                        onTap: (){
                          if(onDone != null) onDone(_colors[index]);

                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: _colors[index],
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ))
                    ],
                  ),
                ],
              )
          );
        });
  }


  void SliderSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
              height: 60,
              child: Slider(
                value: _fontSize,
                min: 20,
                max: 60,
                label: _fontSize.round().toString(),
                onChanged: (double value){
                  setState(() {
                   _fontSize = value;
                  });
                },
              )
          );
        });
  }
  
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? -1;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Carousel slider"),
         centerTitle: true,
       ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
              height: 600,
              width: double.maxFinite,
              child: PageView.builder(
                itemCount: _urlImages.length,
                pageSnapping: true,
                controller: _pageController,
                onPageChanged: (int index){
                  _currentPage = index;
                  setState(() {

                  });
                },
                itemBuilder: (context, pagePosition) {
                  return Container(

                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_urlImages[pagePosition]),
                        fit: BoxFit.fill
                      )
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: leftValue,
                          top: topValue,
                          child: GestureDetector(
                              onPanUpdate: (details){
                                setState(() {
                                  leftValue += details.delta.dx;
                                  topValue += details.delta.dy;
                                });
                              },
                              child: TextButton(
                                onPressed: () async{
                                  await Sheet(context, (color) {
                                  textColor = color;
                                  Navigator.of(context).pop();
                                  });
                                  setState(() {

                                  });},
                                child: Text("Drag me",
                                    style: TextStyle(
                                        fontSize: _fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: textColor
                                    )),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Visibility(
                            visible: isTextVisible,
                            child: TextField(
                              controller: _textControl,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "ADD TEXT",
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.done),
                                    onPressed: () {
                                      setState(() {
                                        userInput = _textControl.text;
                                        isTextVisible = false;
                                      });
                                    },
                                  ),
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        userInput = '';
                                        isTextVisible = false;
                                      });
                                    },
                                    icon: Icon(Icons.cancel),
                                  )),
                            ),
                          ),
                        ),
                        Positioned(
                          left: newLeftValue,
                          top: newTopValue,
                          child: GestureDetector(
                            onPanUpdate: (details) => setState(() {
                              newLeftValue += details.delta.dx;
                              newTopValue += details.delta.dy;
                            }),
                            child: Container(
                              alignment: Alignment.center,
                              height: 70,
                              color: Colors.transparent,
                              width: 300,
                              child: Text(
                                userInput,
                                style: TextStyle(
                                    fontSize: _fontSize,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        )
                        // Positioned(
                        //   right: rightValue,
                        //   bottom: bottomValue,
                        //   child: GestureDetector(
                        //       onPanUpdate: (detail){
                        //         setState(() {
                        //           rightValue -= detail.delta.dx;
                        //           bottomValue -= detail.delta.dy;
                        //         });
                        //       },
                        //       child: TextButton(
                        //         onPressed: () async{
                        //         await Sheet(context, (color) {
                        //         color = Colors.black;
                        //         Navigator.of(context).pop();
                        //         });
                        //         setState(() {
                        //
                        //         });},
                        //         child: Text("Drag it",
                        //           style: TextStyle(
                        //               fontSize: _fontSize,
                        //             fontWeight: FontWeight.bold,
                        //             color: textColor
                        //           ),),
                        //       )),
                        // )
                      ],
                    )
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    4,
                        (index) => Container(
                      margin: EdgeInsets.only(right: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _currentPage == index
                              ? Colors.blue
                              : Colors.grey),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
         onTap: (index){
           setState(() {
             index = _activeIndex;
           });
         },
         selectedItemColor: Colors.grey.shade600,
         items: [
           BottomNavigationBarItem(
               icon:IconButton(
                 icon: Icon(Icons.format_size),
                 onPressed: (){
             setState(() {
               SliderSheet(context);
             });
           },),label: "font size"),
           BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.color_lens),onPressed: (){},),label: "colors"),
           BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.create),onPressed: (){
             setState(() {
               isTextVisible = !isTextVisible;
             });
           },),label: "Add text")
         ],
       )
    );
  }
}
