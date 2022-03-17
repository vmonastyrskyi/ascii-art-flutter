import 'dart:convert';
import 'dart:io';

import 'package:ascii_camera/app_colors.dart';
import 'package:ascii_camera/components/shared_widgets/app_bar_button.dart';
import 'package:ascii_camera/components/shared_widgets/ascii_app_bar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bloc/ascii_image/ascii_image_bloc.dart';
import 'bloc/options/options_bloc.dart';
import 'widgets/options_widget.dart';

class ASCIIImageScreen extends StatefulWidget {
  const ASCIIImageScreen({Key? key}) : super(key: key);

  @override
  _ASCIIImageScreenState createState() => _ASCIIImageScreenState();
}

class _ASCIIImageScreenState extends State<ASCIIImageScreen>
    with WidgetsBindingObserver {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.asciiImageBloc.openCamera();
    } else if (state == AppLifecycleState.paused) {
      context.asciiImageBloc.closeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Scaffold(
            appBar: ASCIIAppBar(
              title: 'ASCII Art',
              leading: [
                AppBarButton(
                  onPressed: context.optionsBloc.toggleOptionButtons,
                  iconData: Icons.tune_rounded,
                )
              ],
              actions: [
                AppBarButton(
                  onPressed: context.optionsBloc.toggleCameraPreview,
                  iconData: Icons.video_camera_front_rounded,
                )
              ],
            ),
            body: Stack(
              alignment: AlignmentDirectional.topCenter,
              fit: StackFit.expand,
              children: [
                _buildASCIIImage(),
                _buildCameraPreview(),
                _buildOptionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    context.asciiImageBloc.closeCamera(updateState: false);
    super.dispose();
  }

  Widget _buildASCIIImage() {
    return BlocSelector<ASCIIImageBloc, ASCIIImageState, String>(
      selector: (state) => state.asciiString,
      builder: (_, asciiString) {
        String divASCIIString = context.asciiImageBloc.state.asciiString;

        divASCIIString = divASCIIString.replaceAll(' ', '&nbsp;');
        divASCIIString = divASCIIString.replaceAll('\n', '<br/>');

        final script =
            'document.querySelector("#shape").innerHTML="$divASCIIString"';

        _webViewController?.runJavascript(script);

        return WebView(
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) async {
            _webViewController = webViewController;
            final htmlPage =
                await rootBundle.loadString('assets/index.html');
            _webViewController?.loadUrl(Uri.dataFromString(
              htmlPage,
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ).toString());
          },
        );
      },
    );
  }

  Widget _buildCameraPreview() {
    Widget buildCameraPreview() {
      return BlocSelector<ASCIIImageBloc, ASCIIImageState, CameraController?>(
        selector: (state) => state.cameraController,
        builder: (_, cameraController) {
          if (cameraController != null) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: AspectRatio(
                aspectRatio: 0.75,
                child: CameraPreview(cameraController),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
    }

    return BlocSelector<OptionsBloc, OptionsState, bool>(
      selector: (state) => state.showCameraPreview,
      builder: (_, showCameraPreview) {
        return Visibility(
          visible: showCameraPreview,
          child: Positioned(
            top: 8.0,
            right: 8.0,
            width: 96.0,
            child: buildCameraPreview(),
          ),
        );
      },
    );
  }

  Widget _buildOptionButtons() {
    return BlocSelector<OptionsBloc, OptionsState, bool>(
      selector: (state) => state.showOptionButtons,
      builder: (_, showOptionButtons) {
        return Visibility(
          visible: showOptionButtons,
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: OptionsWidget(),
          ),
        );
      },
    );
  }
}
