import 'package:deepfake_app/blocs/theme.dart';
import 'package:deepfake_app/localization/LangLocalization.dart';
import 'package:deepfake_app/root.dart';
import 'package:deepfake_app/screens/classify_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  final Function? callback;

  const HomeScreen({Key? key, this.callback}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    this._controller = YoutubePlayerController(
      initialVideoId: 'C8FO0P2a3dA',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose(); //
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of(context);
    ThemeData _theme = _themeChanger.getTheme();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 2,
                color: _theme.cardColor,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Center(
                            child: YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _theme.colorScheme.primary,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              LangLocalization.of(context)!
                                  .getTranslatedValue('home')!["title"],
                              style: TextStyle(
                                color: _theme.colorScheme.onSurface,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: Text(
                              LangLocalization.of(context)!
                                  .getTranslatedValue('home')!["para"],
                              style: TextStyle(
                                color: _theme.colorScheme.onSurface,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                color: _theme.colorScheme.primary,
                onPressed: () => this.widget.callback!(1),
                child: Text(
                  LangLocalization.of(context)!
                      .getTranslatedValue('home')!["button"],
                  style: TextStyle(
                    color: _theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
