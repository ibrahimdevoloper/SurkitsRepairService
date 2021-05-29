import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Cubits/RequestRepair/request_repair_cubit.dart';
import '../UIValuesFolder/blueColors.dart';

class RecordWidget extends StatelessWidget {
  const RecordWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestRepairCubit, RequestRepairState>(
      // bloc: BlocProvider.of<RequestRepairCubit>(context),
      buildWhen: (previous, current) {
        return current is RequestRepairInitial ||
            current is RequestRepairDefaultRecord ||
            current is RequestRepairRecording ||
            current is RequestRepairPlayRecord ||
            current is RequestRepairPlayingRecord;
      },
      builder: (context, state) {
        if (state is RequestRepairInitial ||
            state is RequestRepairDefaultRecord) {
          return FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.mic,
              color: myIconColor,
              size: 34,
            ),
            elevation: 15,
            onPressed: () async {
              await Permission.microphone.request();
              Directory dir = await getTemporaryDirectory();
              DateTime date = DateTime.now();
              var cubit = BlocProvider.of<RequestRepairCubit>(context);
              cubit.recordPath = "${dir.path}/$date.acc";
              cubit.recorder.startRecorder(
                toFile: cubit.recordPath,
              );
              var snackbar = SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Recording"),
                    Text("يتم التسجيل"),
                  ],
                ),
                duration: Duration(milliseconds: 600),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              BlocProvider.of<RequestRepairCubit>(context)
                  .emit(RequestRepairRecording());
            },
          );
          // CustomCardButton(
          //   englishTitle: "Record Voice",
          //   arabicTitle: "سجل رسالة صوتية",
          //   icon: Icons.mic,
          //   onPressed: () {
          //     BlocProvider.of<RequestRepairCubit>(context)
          //         .emit(RequestRepairRecording());
          //   });
        } else if (state is RequestRepairRecording) {
          return FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.stop,
              color: Colors.redAccent,
              size: 34,
            ),
            elevation: 15,
            onPressed: () {
              var cubit = BlocProvider.of<RequestRepairCubit>(context);
              if (cubit.recorder.isRecording) {
                cubit.recorder.stopRecorder();
                BlocProvider.of<RequestRepairCubit>(context)
                    .emit(RequestRepairPlayRecord());
              }
            },
          );
          // CustomCardButton(
          //   englishTitle: "Stop Recording",
          //   arabicTitle: "أوقف التسجيل",
          //   icon: Icons.stop,
          //   onPressed: () {
          //     BlocProvider.of<RequestRepairCubit>(context)
          //         .emit(RequestRepairPlayRecord());
          //   });
        } else if (state is RequestRepairPlayingRecord) {
          return FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.stop,
              color: Colors.redAccent,
              size: 34,
            ),
            elevation: 15,
            onPressed: () {
              var cubit = BlocProvider.of<RequestRepairCubit>(context);
              if (cubit.player.isPlaying) {
                cubit.player.stopPlayer();
                BlocProvider.of<RequestRepairCubit>(context)
                    .emit(RequestRepairPlayRecord());
              }
            },
          );
          // CustomCardButton(
          //   englishTitle: "Stop Recording",
          //   arabicTitle: "أوقف التسجيل",
          //   icon: Icons.stop,
          //   onPressed: () {
          //     BlocProvider.of<RequestRepairCubit>(context)
          //         .emit(RequestRepairPlayRecord());
          //   });
        } else if (state is RequestRepairPlayRecord) {
          return Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.delete,
                  color: myIconColor,
                  size: 34,
                ),
                elevation: 15,
                onPressed: () {
                  var cubit = BlocProvider.of<RequestRepairCubit>(context);
                  if (cubit.recordPath != null) {
                    cubit.recordPath = null;
                    BlocProvider.of<RequestRepairCubit>(context)
                        .emit(RequestRepairDefaultRecord());
                  }
                },
              ),
              SizedBox(
                width: 32,
              ),
              FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.play_arrow,
                  color: myIconColor,
                  size: 34,
                ),
                elevation: 15,
                onPressed: () {
                  var cubit = BlocProvider.of<RequestRepairCubit>(context);
                  if (cubit.recordPath != null) {
                    cubit.player.startPlayer(
                        fromURI: "file://${cubit.recordPath}",
                        whenFinished: () {
                          BlocProvider.of<RequestRepairCubit>(context)
                              .emit(RequestRepairPlayRecord());
                        });
                    BlocProvider.of<RequestRepairCubit>(context)
                        .emit(RequestRepairPlayingRecord());
                  }
                },
              ),

              // CustomCardButton(
              //     englishTitle: "Record Voice",
              //     arabicTitle: "سجل رسالة صوتية",
              //     icon: Icons.mic,
              //     onPressed: () {
              //       BlocProvider.of<RequestRepairCubit>(context)
              //           .emit(RequestRepairRecording());
              //     }),
              // CustomCardButton(
              //     englishTitle: "Play Record",
              //     arabicTitle: "أسمع رسالة صوتية",
              //     icon: Icons.play_arrow,
              //     onPressed: () {}),
            ],
          );
        }
      },
    );
  }
}
