import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  int _selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    // Sembunyikan UI sistem untuk pengalaman kamera layar penuh
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    // Gunakan kamera belakang (biasanya index 0) sebagai default
    await _setupCamera(0);
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (cameras == null || cameras!.isEmpty) {
      print("Kamera tidak ditemukan");
      return;
    }
    // Buang controller lama sebelum membuat yang baru
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(
      cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller!.initialize();
      if (mounted) {
        setState(() {
          _selectedCameraIdx = cameraIndex;
        });
      }
    } catch (e) {
      print("Error inisialisasi kamera: $e");
    }
  }

  void _switchCamera() {
    if (cameras == null || cameras!.length < 2) return;
    // Ganti kamera (0 -> 1, 1 -> 0)
    final nextIndex = (_selectedCameraIdx + 1) % cameras!.length;
    _setupCamera(nextIndex);
  }

  Future<void> _captureImage() async {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }
    try {
      final XFile file = await controller!.takePicture();
      // Kembalikan file gambar ke halaman sebelumnya
      if (mounted) {
        Navigator.pop(context, File(file.path));
      }
    } catch (e) {
      print("Gagal mengambil gambar: $e");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    // Kembalikan UI sistem seperti semula saat halaman ditutup
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      // Tampilkan loading jika kamera belum siap
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller!),
          // Tombol Ambil Foto
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _captureImage,
                backgroundColor: Colors.white,
                child: const Icon(Icons.camera_alt, color: Colors.black),
              ),
            ),
          ),
          // Tombol Ganti Kamera
          Positioned(
            bottom: 45,
            right: 40,
            child: IconButton(
              onPressed: _switchCamera,
              icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 36),
            ),
          )
        ],
      ),
    );
  }
}