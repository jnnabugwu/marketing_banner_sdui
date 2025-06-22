import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketing_banner_sdui/analytics/analytics_service.dart';
import 'package:marketing_banner_sdui/banner/banner.dart';
import 'package:mocktail/mocktail.dart';

class MockBannerRepository extends Mock implements BannerRepository {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  group('BannerBloc', () {
    late BannerRepository bannerRepository;
    late AnalyticsService analyticsService;
    late BannerBloc bannerBloc;

    const testBanner = BannerConfig(
      id: 'test-banner',
      type: 'default',
      priority: 1,
      config: {'type': 'Container'},
    );

    setUp(() {
      bannerRepository = MockBannerRepository();
      analyticsService = MockAnalyticsService();
      bannerBloc = BannerBloc(
        bannerRepository: bannerRepository,
        analyticsService: analyticsService,
      );
    });

    tearDown(() {
      bannerBloc.close();
    });

    test('initial state is correct', () {
      expect(bannerBloc.state, const BannerState());
    });

    group('BannerRequested', () {
      blocTest<BannerBloc, BannerState>(
        'emits [loading, success] when banner is fetched successfully',
        build: () {
          when(() => bannerRepository.fetchBanner(any()))
              .thenAnswer((_) async => testBanner);
          when(
            () => analyticsService.trackBannerView(
              bannerId: any(named: 'bannerId'),
              bannerType: any(named: 'bannerType'),
            ),
          ).thenAnswer((_) async {});
          return bannerBloc;
        },
        act: (bloc) => bloc.add(const BannerRequested('default')),
        expect: () => [
          const BannerState(status: BannerStatus.loading),
          const BannerState(
            status: BannerStatus.success,
            banner: testBanner,
          ),
        ],
        verify: (_) {
          verify(() => bannerRepository.fetchBanner('default')).called(1);
          verify(
            () => analyticsService.trackBannerView(
              bannerId: 'test-banner',
              bannerType: 'default',
            ),
          ).called(1);
        },
      );

      blocTest<BannerBloc, BannerState>(
        'emits [loading, failure] when fetching fails',
        build: () {
          when(() => bannerRepository.fetchBanner(any()))
              .thenThrow(const BannerFetchException('Network error'));
          return bannerBloc;
        },
        act: (bloc) => bloc.add(const BannerRequested('default')),
        expect: () => [
          const BannerState(status: BannerStatus.loading),
          const BannerState(
            status: BannerStatus.failure,
            error: 'BannerFetchException: Network error',
          ),
        ],
      );
    });
  });
}
