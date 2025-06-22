import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const BannerPage(),
    );
  }

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  bool _isInitialized = false;
  String _currentBannerType = 'default';

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

  void _changeBannerType(String bannerType) {
    setState(() {
      _currentBannerType = bannerType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeBannerType,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'default',
                child: Text('Default Banner'),
              ),
              const PopupMenuItem(
                value: 'hero',
                child: Text('Hero Banner'),
              ),
              const PopupMenuItem(
                value: 'minimal',
                child: Text('Minimal Banner'),
              ),
            ],
          ),
        ],
      ),
      body: _isInitialized
          ? Stac.fromNetwork(
              request: StacNetworkRequest(
                url: 'http://localhost:8000/banner_$_currentBannerType.json',
              ),
              context: context,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
