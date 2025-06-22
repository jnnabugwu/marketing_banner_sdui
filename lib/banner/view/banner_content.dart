import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_framework/stac_framework.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeStac();
  }

  Future<void> _initializeStac() async {
    await Stac.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _isInitialized
          ? Stac.fromNetwork(
              request: StacNetworkRequest(
                url: 'http://localhost:8000/banner_default.json',
              ),
              context: context,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
