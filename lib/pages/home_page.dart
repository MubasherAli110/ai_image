// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:app_ai/network/api_class.dart';
import 'package:app_ai/pages/arts_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  bool isloding = false;
  Map<String, dynamic> dataList = {};

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text(
          "Image Generation App",
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyArtsPage(),
                  ),
                );
              },
              child: const Text(
                "My Arts",
                style: TextStyle(color: Colors.white),
              ))
        ],
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Expanded(
              child: dataList.isEmpty
                  ? const Center(
                      child: Text("Welcome"),
                    )
                  : ListView(
                      children: [
                        Screenshot(
                          controller: screenshotController,
                          child: Image(
                              image: NetworkImage(dataList["url"]),
                              loadingBuilder: (context, child, progress) {
                                return progress?.cumulativeBytesLoaded ==
                                        progress?.expectedTotalBytes
                                    ? child
                                    : Container(
                                        height: 400,
                                        color: Colors.grey.shade800,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: CircularProgressIndicator(
                                            value: progress!
                                                    .cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!,
                                            strokeWidth: 5,
                                          ),
                                        ),
                                      );
                              }),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(150, 40)),
                                onPressed: () {
                                  downloadImage();
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.download,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Download",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(150, 40)),
                                onPressed: () async {
                                  await shareImage();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Image Shares"),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Share",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Text(data["revised_prompt"])
                      ],
                    )),
          Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blueGrey.shade800,
                ),
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: "Enter your Prompt",
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              )),
              const SizedBox(width: 10),
              isloding
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        setState(() => isloding = true);

                        if (textController.text.toLowerCase() == "ai boy") {
                          dataList.addAll({
                            "url":
                                "https://miro.medium.com/v2/resize:fit:720/format:webp/0*YiZZkie0UpclVF11",
                            "revised_prompt": "Default image",
                          });
                          setState(() {});
                        } else {
                          sendRequest();
                        }
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
            ],
          )
        ]),
      ),
    );
  }

////////sendRequest

  sendRequest() async {
    setState(() {
      isloding = true;
    });
    final response = await Api.requestPost(prompt: textController.text);
    debugPrint("response : ${response.toString()}");
    setState(() {
      isloding = false;
    });
    debugPrint("response 1 : ${response.toString()}");
    if (response != null) {
      setState(() {
        dataList = response;
        textController.clear();
      });
    }
  }

  ///////// shareImage

  shareImage() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 100), pixelRatio: 1.0)
        .then((Uint8List? img) async {
      if (img != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        const fileName = "share.png";

        final imgpath = await File("$directory/$fileName").create();
        await imgpath.writeAsBytes(img);
        Share.shareFiles([imgpath.path],
            text: "Generated by AI - Mubasher Ali");
      } else {
        debugPrint("Faild to tack a screenshort");
      }
    });
  }

/////////////////// downloadImage

  downloadImage() async {
    var result = await Permission.storage.request();

    if (result.isGranted) {
      const folderName = "AI Image";
      final path = Directory("storage/emulated/0/$folderName");

      final fileName = "${DateTime.now().microsecondsSinceEpoch}.png";
      if (await path.exists()) {
        await screenshotController.captureAndSave(
          path.path,
          delay: const Duration(milliseconds: 100),
          fileName: fileName,
          pixelRatio: 1.0,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image Downloaded to ${path.path}"),
          ),
        );
      } else {
        await path.create();
        await screenshotController.captureAndSave(
          path.path,
          delay: const Duration(milliseconds: 100),
          fileName: fileName,
          pixelRatio: 1.0,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image Downloaded to ${path.path}"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permission denied"),
        ),
      );
    }
  }
}
