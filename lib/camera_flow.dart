import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_app/camera_page.dart';
import 'package:flutter_aws_app/gallery_page.dart';

class CameraFlow extends StatefulWidget {
  // CameraFlow devra se déclencher lorsque l'utilisateur se déconnecte et
  // mettre à jour l'état dans main.dart. Nous implémenterons cette
  // fonctionnalité peu après la création de GalleryPage.
  final VoidCallback shouldLogOut;

  CameraFlow({required Key key, required this.shouldLogOut}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {
  late CameraDescription _camera;
  // Cet indicateur agira comme l'état qui décidera du moment où la caméra devra
  // ou non s'afficher.
  bool _shouldShowCamera = false;

  // Pour s'assurer que notre Navigator est mis à jour lorsque _shouldShowCamera
  // est mis à jour, nous utilisons une propriété de calcul qui renvoie la pile
  // de navigation correspondante en fonction de l'état actuel. Nous utilisons
  // des pages Placeholder pour l'instant.
  List<MaterialPage> get _pages {
    return [
      // Show Gallery Page
      MaterialPage(child: GalleryPage(
        shouldLogOut: widget.shouldLogOut,
        shouldShowCamera: () => _toggleCameraOpen(true),
      )),

      // Show Camera Page
      if (_shouldShowCamera) MaterialPage(child: CameraPage(
        camera: _camera,
        didProvideImagePath: (imagePath){
          this._toggleCameraOpen(false);
        },
      ))
    ];
  }

  @override
  void initState() {
    super.initState();
    _getCamera();
  }

  @override
  Widget build(BuildContext context) {
    // Comme pour _MyAppState, nous utilisons un widget Navigator pour
    // déterminer quelle page doit être affichée à un moment donné
    // pour une session.
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  // Cette méthode nous permettra de basculer si la caméra est affichée ou non
  // sans avoir à déployer setState() sur le site de l'appel.
  void _toggleCameraOpen(bool isOpen) {
    setState(() {
      this._shouldShowCamera = isOpen;
    });
  }

  void _getCamera() async {
    final camerasList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      this._camera = firstCamera;
    });
  }
}
