import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  // Pour prendre une photo, nous devrons obtenir une instance de
  // CameraDescription qui sera fournie par le CameraFlow.
  final CameraDescription camera;
  // Ce ValueChanged fournira au CameraFlow le chemin local vers l'image prise
  // par l'appareil photo.
  final ValueChanged didProvideImagePath;

  CameraPage({Key? key, required this.camera, required this.didProvideImagePath})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Pour nous assurer que nous avons une instance de CameraController, nous
    // l'initialisons dans la méthode initState et nous initialisons
    // _initializeControllerFuture une fois terminée.
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // Le FutureBuilder surveille alors le moment où le Future est renvoyé
          // et montre soit un aperçu de ce que voit l'appareil photo, soit
          // un CircularProgressIndicator.
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(this._controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // Le FloatingActionButton déclenchera _takePicture() lorsqu'il est actionné.
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera), onPressed: _takePicture),
    );
  }

  // Cette méthode permet de construire un chemin temporaire vers l'emplacement
  // de l'image et de le renvoyer à CameraFlow par le biais de didProvideImagePath.
  void _takePicture() async {
    try {
      await _initializeControllerFuture;

      final tmpDirectory = await getTemporaryDirectory();
      final filePath = '${DateTime.now().millisecondsSinceEpoch}.png';
      final path = join(tmpDirectory.path, filePath);

      // await _controller.takePicture(path);

      widget.didProvideImagePath(_controller.takePicture().toString());
    } catch (e) {
      print(e);
    }
  }

  // Pour finir, nous devons nous assurer que le CameraController est supprimé
  // lorsque la page a été supprimée.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}