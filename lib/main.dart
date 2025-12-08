import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'services/alarm_service.dart';
import 'services/widget_service.dart';
import 'localization/app_localizations.dart';

// URL 스킴 처리 및 네비게이션 스택 관리
class UrlSchemeHandler {
  static const MethodChannel _channel = MethodChannel(
    'com.smileDragon.onetoday/url_scheme',
  );
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onUrlScheme') {
        final url = call.arguments as String?;
        if (url != null && url.startsWith('onetoday://')) {
          _handleUrlScheme(url);
        }
      }
    });
  }

  static void _handleUrlScheme(String url) {
    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      // 네비게이션 스택 초기화: 모든 라우트를 제거하고 HomeScreen만 남김
      navigator.popUntil((route) => route.isFirst);
    }
  }
}

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 스플래시 화면 유지
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 화면 방향을 세로 모드로 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 알람 서비스 초기화
  await AlarmService.initialize();

  // 위젯 서비스 초기화
  await WidgetService.initialize();

  // URL 스킴 핸들러 초기화
  UrlSchemeHandler.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 스플래시 화면 제거 (앱이 준비되면)
    FlutterNativeSplash.remove();

    // 화면 방향을 세로 모드로 고정 (앱 전체)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      navigatorKey: UrlSchemeHandler.navigatorKey,
      title: 'One Today',
      // 디버그 모드일 때만 디버그 배너 표시
      // flutter run (또는 --debug)  => 배너 표시
      // flutter run --profile / --release, flutter build apk --release => 배너 숨김
      debugShowCheckedModeBanner: kDebugMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
        Locale('en', 'US'), // 영어
      ],
      // 지원하지 않는 언어는 영어로 표시
      localeResolutionCallback: (locale, supportedLocales) {
        // 한국어나 영어가 지원되면 해당 언어 사용
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        // 지원하지 않는 언어는 영어로 기본값 설정
        return const Locale('en', 'US');
      },
      // 시스템 언어를 자동으로 감지 (한국어면 한국어, 영어면 영어로 표시)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansTextTheme(),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          titleTextStyle: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
      home: const HomeScreen(),
      // 중복 라우트 방지를 위한 observer 추가
      navigatorObservers: [_RouteObserver()],
    );
  }
}

// 중복 라우트 방지를 위한 RouteObserver
class _RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    // 같은 라우트(HomeScreen)가 중복으로 푸시되는 경우 방지
    if (previousRoute != null &&
        route.settings.name == previousRoute.settings.name &&
        route.settings.name == '/') {
      // 위젯에서 실행된 경우: 이전 라우트를 제거하여 중복 방지
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final navigator = UrlSchemeHandler.navigatorKey.currentState;
        if (navigator != null && navigator.canPop()) {
          // 첫 번째 라우트까지 모든 라우트를 제거하고 현재 라우트만 남김
          navigator.popUntil((r) => r == route || r.isFirst);
        }
      });
    }
  }
}
