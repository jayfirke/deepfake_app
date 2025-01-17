import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:deepfake_app/blocs/theme.dart';
import 'package:deepfake_app/colors.dart';
import 'package:deepfake_app/localization/LangLocalization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:deepfake_app/globals.dart';
import 'package:dio/dio.dart';

class ClassifyScreen extends StatefulWidget {
  @override
  _ClassifyScreenState createState() => _ClassifyScreenState();
}

class _ClassifyScreenState extends State<ClassifyScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? chewieController;
  File? file;
  late bool isVideo;
  bool? isAPICalled;

  Dio dio = new Dio();

  @override
  void initState() {
    super.initState();
    this.isAPICalled = false;
  }

  _pickVideo() async {
    // final file = await FilePicker.getFile(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpeg', 'jpg', 'png', 'mp4'],
    // );
    final FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'jpg', 'png', 'mp4'],
    );


    if (file != null) {
      if (file.paths[0]!.split(".")[1] == "mp4") {
        _videoPlayerController = VideoPlayerController.file(File(file.paths[0]!));

        chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
          materialProgressColors: ChewieProgressColors(
            playedColor: DeepfakeTheme.darkTheme.primaryColor,
          ),
        );
        this.isVideo = true;
      } else {
        this.isVideo = false;
        print(file.paths);
      }
      setState(() {
        this.file = file as File?;
      });
    }
  }

  _sendToClassify() async {
    this.setState(() {
      this.isAPICalled = true;
    });
    FileStat stats = file!.statSync();
    String? text;
    var response;

    if (stats.size < MaxFileSizeinMB * 1024 * 1024) {
      if (file!.path.split(".")[1] == "mp4") {
        FormData formData = new FormData();
        formData.fields.add(MapEntry("userId", userId!));
        formData.files
            .add(MapEntry("video", await MultipartFile.fromFile(file!.path)));

        Options options = new Options(
            contentType: "form-data",
            headers: {'Authorization': 'Bearer ' + bearerToken!});

        response = await dio.post(serverURL + "/classify",
            data: formData, options: options);

        this.setState(() {
          this.file = null;
        });
        print("-------------------------");
        print(response.statusCode);
        print(response);
        print("-------------------------");

        if (response.statusCode == 200) {
          text = LangLocalization.of(context)!
              .getTranslatedValue('classify')!["vid_response200"];
        } else if (response.statusCode == 412 || response.statusCode == 413) {
          text = LangLocalization.of(context)!
              .getTranslatedValue('classify')!["vid_response412"];
        } else if (response.statusCode == 400) {
          text = LangLocalization.of(context)!
              .getTranslatedValue('classify')!["vid_response400"];
        } else if (response.statusCode == 422) {
          text = LangLocalization.of(context)!
              .getTranslatedValue('classify')!["vid_response422"];
        } else if (response.statusCode == 429) {
          text = LangLocalization.of(context)!
              .getTranslatedValue('classify')!["vid_response429"];
        } else {
          text = LangLocalization.of(context)!
              .getTranslatedValue('classify')!["vid_responseX"];
        }
      } else {
        FormData formData = new FormData();
        formData.fields.add(MapEntry("userId", userId!));
        formData.files
            .add(MapEntry("image", await MultipartFile.fromFile(file!.path)));

        Options options = new Options(
            contentType: "form-data",
            headers: {'Authorization': 'Bearer ' + bearerToken!});

        response = await dio.post(serverURL + "/get-image",
            data: formData, options: options);

        print("-------------------------");
        print(response.statusCode);
        print(response);
        print("-------------------------");

        if (response.statusCode == 200) {
          text = LangLocalization.of(context)!
              .getTranslatedValue('classify')!["img_response200"];
        } else if (response.statusCode == 429) {
          text = LangLocalization.of(context)!
              .getTranslatedValue('classify')!["img_response429"];
        } else {
          text = LangLocalization.of(context)!
              .getTranslatedValue('classify')!["img_responseX"];
        }
      }
    } else {
      text = LangLocalization.of(context)!
          .getTranslatedValue('classify')!["img_responseY"];
    }
    this.setState(() {
      this.isAPICalled = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        ThemeChanger _themeChanger = Provider.of(context);
        ThemeData _theme = _themeChanger.getTheme();
        return AlertDialog(
          backgroundColor: _theme.colorScheme.surface,
          content: Text(
            text!,
            style: TextStyle(
              color: _theme.colorScheme.onSurface,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text(
                LangLocalization.of(context)!
                    .getTranslatedValue('classify')!["dialog"],
                style: TextStyle(
                  color: _theme.colorScheme.onSurface,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) _videoPlayerController!.dispose();
    if (chewieController != null) chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          this.file == null
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    LangLocalization.of(context)!
                        .getTranslatedValue('classify')!["intro"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: _theme.colorScheme.onBackground,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: this.isVideo
                        ? Chewie(controller: chewieController!)
                        : Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.file(file!),
                          ),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _theme.colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
          const SizedBox(height: 40),
          (this.isAPICalled == false)
              ? RaisedButton(
                  color: _theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: this.file == null ? _pickVideo : _sendToClassify,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text(
                      this.file == null
                          ? LangLocalization.of(context)!
                              .getTranslatedValue('classify')!["upload"]
                          : LangLocalization.of(context)!
                              .getTranslatedValue('classify')!["classify"],
                      style: TextStyle(
                        color: _theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                )
              : CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    _theme.colorScheme.primary,
                  ),
                ),
        ],
      ),
    );
  }
}
