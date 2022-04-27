import 'package:flutter/material.dart';

// GalleryPage affichera simplement des images, et peut être implémenté
// comme un StatelessWidget.
class GalleryPage extends StatelessWidget {
  // Ce VoidCallback se connectera à la méthode shouldLogOut dans CameraFlow.
  final VoidCallback shouldLogOut;
  // Ce VoidCallback mettra à jour l'indicateur _shouldShowCamera dans CameraFlow.
  final VoidCallback shouldShowCamera;

  GalleryPage({Key? key, required this.shouldLogOut, required this.shouldShowCamera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        actions: [
          // Notre bouton de déconnexion est implémenté comme une action dans
          // l'AppBar et appelle shouldLogOut lorsqu'il est tapé.
          // Log Out Button
          Padding(
            padding: const EdgeInsets.all(8),
            child:
            GestureDetector(child: Icon(Icons.logout), onTap: shouldLogOut),
          )
        ],
      ),
      // Ce FloatingActionButton déclenchera l'affichage de l'appareil photo
      // lorsqu'il sera activé.
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt), onPressed: shouldShowCamera),
      body: Container(child: _galleryGrid()),
    );
  }

  Widget _galleryGrid() {
    // Nos images seront affichées dans une mosaïque à deux colonnes.
    // Nous sommes actuellement en train de coder 3 éléments dans cette grille.
    return GridView.builder(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: 3,
        itemBuilder: (context, index) {
          // Nous allons mettre en place un widget de chargement d'images dans
          // le module Add Stroage. Entre-temps, nous utiliserons Placeholder
          // pour représenter les images.
          return Placeholder();
        });
  }
}