import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projek_akhir/core/constants/colors.dart'; // Impor warna Anda

// Class helper untuk membawa data lokasi yang dipilih
class PickedLocation {
  final LatLng latLng;
  final String address;

  PickedLocation(this.latLng, this.address);
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _pickedLatLng;
  String? _pickedAddress;

  // Posisi awal kamera di tengah Indonesia
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-7.801367, 110.364757),
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Layanan lokasi dimatikan.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen.';
      }

      final position = await Geolocator.getCurrentPosition();
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _onTap(LatLng latlng) async {
    setState(() {
      _pickedLatLng = latlng;
      _pickedAddress = 'Memuat alamat...';
    });

    try {
      final placemarks =
          await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _pickedAddress =
              '${p.street}, ${p.subLocality}, ${p.locality}, ${p.postalCode}';
        });
      }
    } catch (e) {
      setState(() {
        _pickedAddress = 'Gagal mendapatkan alamat.';
      });
    }
  }

  // ✅ METHOD UNTUK KONFIRMASI DAN KEMBALI
  void _confirmAndReturnLocation() {
    // Pastikan lokasi dan alamat sudah terpilih sebelum kembali
    if (_pickedLatLng != null && _pickedAddress != null && _pickedAddress != 'Memuat alamat...') {
      final result = PickedLocation(_pickedLatLng!, _pickedAddress!);
      // Panggil Navigator.pop SATU KALI untuk kembali dan mengirim data 'result'
      Navigator.of(context).pop(result);
    } else {
      // Beri tahu pengguna jika belum ada alamat yang valid
       ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Tunggu alamat selesai dimuat atau pilih lokasi.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kInitialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: _onTap,
            markers: _pickedLatLng == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('picked-location'),
                      position: _pickedLatLng!,
                    ),
                  },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_pickedAddress != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _pickedAddress!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
        ],
      ),
      // ✅ Tombol "PILIH" diubah menjadi FloatingActionButton agar lebih jelas
      floatingActionButton: _pickedLatLng != null
          ? FloatingActionButton.extended(
              onPressed: _confirmAndReturnLocation, // Panggil method konfirmasi
              label: const Text('Pilih Lokasi Ini'),
              icon: const Icon(Icons.check),
              backgroundColor: AppColors.primaryGreen,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}