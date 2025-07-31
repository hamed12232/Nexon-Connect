import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/audio_player_widget.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';

class ChatBubble extends StatefulWidget {
  final String? message, time, type, replyText, replyName;
  final bool? isMe, isReply;
  final String? pathRecord;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    required this.type,
    required this.replyText,
    required this.isReply,
    required this.replyName,
    this.pathRecord,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

  Color? chatBubbleReplyColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.grey[600];
    } else {
      return Colors.grey[50];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final align = widget.isMe!
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final radius = BorderRadius.circular(25);

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        if (widget.pathRecord == null)
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              gradient: widget.isMe!
                  ? LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(colors: [theme.cardColor, theme.cardColor]),
              borderRadius: radius,
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.3,
              minWidth: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                widget.isReply!
                    ? Container(
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        constraints: BoxConstraints(
                          minHeight: 25,
                          maxHeight: 100,
                          minWidth: 80,
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.isMe! ? "You" : widget.replyName!,
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 2.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.replyText!,
                                  style: TextStyle(
                                    color: theme.textTheme.bodyMedium?.color,
                                    fontSize: 10.0,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(width: 2.0),
                widget.isReply! ? SizedBox(height: 5) : SizedBox(),
                Padding(
                  padding: EdgeInsets.all(widget.type == "text" ? 5 : 0),
                  child: widget.type == "text"
                      ? !widget.isReply!
                            ? Text(
                                widget.message!,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: widget.isMe!
                                      ? theme.colorScheme.onPrimary
                                      : theme.textTheme.bodyLarge?.color,
                                ),
                              )
                            : Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.message!,
                                  style: TextStyle(
                                    color: widget.isMe!
                                        ? theme.colorScheme.onPrimary
                                        : theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                              )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            "${widget.message}",
                            height: 130,
                            width: MediaQuery.of(context).size.width / 1.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ],
            ),
          ),
        if (widget.pathRecord == null)
          Padding(
            padding: widget.isMe!
                ? EdgeInsets.only(right: 10, bottom: 10.0)
                : EdgeInsets.only(left: 10, bottom: 10.0),
            child: Text(
              widget.time!,
              style: TextStyle(color: Colors.black, fontSize: 10.0),
            ),
          ),
        if (widget.pathRecord != null)
          Padding(
            padding: EdgeInsets.only(
              left: widget.isMe! ? 0 : 10,
              right: widget.isMe! ? 10 : 0,
            ),
            child: AudioPlayerWidget(
              autoPlay:
                  false, // Whether to automatically start playback when the widget builds
              autoLoad:
                  true, // Whether to preload the audio before the user presses play
              audioPath: widget.pathRecord, // The path or URL of the audio file
              audioType: AudioType
                  .url, // Specifies if the audio is from a URL, asset, , file , or blobforWeb(for flutter web)
              playerStyle: PlayerStyle
                  .style5, // The visual style of the player (you can choose between different predefined styles)
              textDirection:
                  TextDirection.rtl, // Text direction for RTL or LTR languages
              size: 50, // Size of the play/pause button
              progressBarHeight: 5, // Height of the progress bar
              backgroundColor: widget.isMe!
                  ? theme.colorScheme.primary
                  : theme.cardColor, // Background color of the widget
              progressBarColor:
                  Colors.blue, // Color of the progress bar (played portion)
              progressBarBackgroundColor:
                  Colors.white, // Background color of the progress bar
              iconColor: Colors.white, // Color of the play/pause icon
              shapeType: PlayIconShapeType
                  .circular, // Shape of the play/pause button (e.g., circular or square)
              showProgressBar: true, // Whether to show the progress bar
              showTimer: true, // Whether to display the current time/duration
              width: 300, // Width of the whole audio player widget
              audioSpeeds: const [
                0.5,
                1.0,
                1.5,
                2.0,
                3.0,
              ], // Supported audio playback speeds
              // Callback when playback speed is changed
            ),
          ),
        SizedBox(height: 10),
        if (widget.pathRecord != null)
          Padding(
            padding: widget.isMe!
                ? EdgeInsets.only(right: 10, bottom: 10.0)
                : EdgeInsets.only(left: 10, bottom: 10.0),
            child: Text(
              widget.time!,
              style: TextStyle(color: Colors.black, fontSize: 10.0),
            ),
          ),
      ],
    );
  }
}
