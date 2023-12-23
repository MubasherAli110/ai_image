import 'dart:io';

import 'package:flutter/material.dart';

class MyArtsPage extends StatefulWidget {
  const MyArtsPage({super.key});

  @override
  State<MyArtsPage> createState() => _MyArtsPageState();
}

class _MyArtsPageState extends State<MyArtsPage> {
  List imageList = [];
  getimage() async {
    final directory = Directory("storage/emulated/0/AI image");
    imageList = directory.listSync();
  }

  @override
  void initState() {
    getimage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text(
          "My Arts",
        ),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: GridView.builder(
          itemCount: imageList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 300),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                popupImage(imageList[index]);
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Image.file(
                  imageList[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
    );
  }

  popupImage(filepath) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Image.file(
                  filepath,
                  fit: BoxFit.cover,
                ),
              ),
            ));
  }
}

/////////////////////////////////////////////////////////////////////////



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class MyArtsPage extends StatefulWidget {
//   const MyArtsPage({Key? key}) : super(key: key);

//   @override
//   State<MyArtsPage> createState() => _MyArtsPageState();
// }

// class _MyArtsPageState extends State<MyArtsPage> {
//   List<File> imageList = []; // Changed from dynamic to File type
//   final picker = ImagePicker();

//   getimage() async {
//     final directory = Directory("storage/emulated/0/AI image");
//     setState(() {
//       imageList = directory.listSync().map((item) => File(item.path)).toList();
//     });
//   }

//   Future<void> _pickImages() async {
//     final pickedFiles = await picker.pickMultiImage();

//     if (pickedFiles != null) {
//       setState(() {
//         imageList.addAll(pickedFiles.map((file) => File(file.path)).toList());
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getimage(); // Fetch images when the widget is initialized
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey.shade900,
//       appBar: AppBar(
//         title: const Text(
//           "My Arts",
//         ),
//         backgroundColor: Colors.blueGrey.shade800,
//       ),
//       body: GridView.builder(
//         itemCount: imageList.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//           mainAxisExtent: 300,
//         ),
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () {
//               popupImage(imageList[index]);
//             },
//             child: Container(
//               clipBehavior: Clip.antiAlias,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Image.file(
//                 imageList[index],
//                 fit: BoxFit.cover,
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _pickImages,
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   popupImage(File filepath) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Container(
//           clipBehavior: Clip.antiAlias,
//           height: 400,
//           width: 300,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Image.file(
//             filepath,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }
