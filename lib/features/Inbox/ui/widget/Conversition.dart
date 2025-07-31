import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/core/Components/Snak_bar.dart';
import 'package:myapp/features/Inbox/logic/cubit/chat_cubit.dart';
import 'package:myapp/features/Inbox/ui/widget/ChatInputBar.dart';
import 'package:myapp/features/Inbox/ui/widget/CustomChatStreamBuilder.dart';
import 'package:myapp/features/Inbox/ui/widget/CustomChatTitleAppBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_note_kit/recorder/voice_enums/voice_enums.dart';
import 'package:voice_note_kit/recorder/voice_recorder_widget.dart';

class Conversation extends StatefulWidget {
  final String? dp, name;
  final String chatId;
  final String senderId;

  const Conversation({
    super.key,
    required this.dp,
    required this.name,
    required this.chatId,
    required this.senderId,
  });
  @override
  // ignore: library_private_types_in_public_api
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final TextEditingController _textController = TextEditingController();
  FirebaseAuth currentUser = FirebaseAuth.instance;
  bool isRecording = true;
  File? recordedFile;
  String? recordedAudioBlobUrl;
  bool isRecordingStarted = false;

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset("assets/icons/back-arrow.svg"),
            ),
          ),
          titleSpacing: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          title: CustomChatTitleAppBar(widget: widget),
          actions: <Widget>[
            SvgPicture.asset("assets/icons/dots.svg", height: 5),
            SizedBox(width: 20),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.fill,
              ),
            ),
            Column(
              children: [
                CustomChatStreamBuilder(
                  widget: widget,
                  currentUser: currentUser,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomAppBar(
                    height: !isRecordingStarted ? height * 0.1 : height * 0.14,
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200), // مدة الانيميشن
                        height: !isRecordingStarted
                            ? height * 0.1
                            : height * 0.15,
                        child: !isRecordingStarted
                            ? ChatInputBar(
                                onSendMessage: (text) {
                                  context.read<ChatCubit>().sendMessage(
                                    chatId: widget.chatId,
                                    senderId: currentUser.currentUser!.uid,
                                    text: text,
                                  );
                                },
                                onStartRecording: () {
                                  setState(() {
                                    isRecordingStarted = true;
                                  });
                                },
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        isRecordingStarted = false;
                                      });
                                    },
                                  ),
                                  Expanded(child: voiceRecorder(context)),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Color(0xfff1f5f9),
      ),
    );
  }

  Widget customChatBottomAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.attach_file,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {},
        ),
        Flexible(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30), // ده المهم عشان الكيرف
            ),
            child: TextField(
              controller: _textController,
              onChanged: (value) => setState(() {
                isRecording = value.trim().isEmpty;
              }),
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                enabledBorder: InputBorder.none,
                border: InputBorder.none,

                hintText: "Write your message...",
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
              ),
              maxLines: null,
            ),
          ),
        ),
        isRecording
            ? Flexible(
                flex: 1,
                child: IconButton(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.mic, color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      isRecordingStarted = true;
                    });
                  },
                ),
              )
            : Flexible(
                flex: 1,
                child: IconButton(
                  icon: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                  onPressed: () {
                    if (_textController.text.trim().isNotEmpty) {
                      context.read<ChatCubit>().sendMessage(
                        chatId: widget.chatId,
                        senderId: currentUser.currentUser!.uid,
                        text: _textController.text.trim(),
                      );
                      _textController.clear();
                    }
                  },
                ),
              ),
      ],
    );
  }

  VoiceRecorderWidget voiceRecorder(BuildContext context) {
    return VoiceRecorderWidget(
      iconSize: 40, // تصغير حجم الأيقونة
      showTimerText: true,
      showSwipeLeftToCancel: true,
      style: VoiceUIStyle.compact,
      containerColor: Colors.transparent, // جعل الخلفية شفافة
      borderRadius: 30, // تدوير الحواف
      onRecorded: (file) {
        setState(() {
          recordedFile = file;
          isRecordingStarted = false; // إغلاق حالة التسجيل بعد الانتهاء
        });
        showInSnackBar("Recording saved", context);
        context.read<ChatCubit>().sendVoiceMessage(
          chatId: widget.chatId,
          senderId: currentUser.currentUser!.uid,
          audioUrl: recordedFile!.path, // استخدام مسار الملف المسجل
        );
      },
      onRecordedWeb: (url) {
        setState(() {
          recordedAudioBlobUrl = url;
        });
      },
      onError: (error) {
        showInSnackBar("Error: $error", context);
      },
      actionWhenCancel: () {
        setState(() {
          isRecordingStarted = false;
        });
        showInSnackBar("Recording cancelled", context);
      },
      maxRecordDuration: const Duration(seconds: 60),
      permissionNotGrantedMessage: 'Microphone permission required',
      dragToLeftText: "← Slide left  to cancel",
      dragToLeftTextStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      cancelDoneText: 'Cancelled',
      cancelHintColor: Colors.red,
      iconColor: Theme.of(context).primaryColor,
      timerFontSize: 14,
      idleWavesColor: Colors.grey[300],
      recordingWavesColor: Theme.of(context).primaryColor,
      wavesSpeed: const Duration(milliseconds: 200),
    );
  }
}
