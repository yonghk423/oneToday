# One Today

하루에 딱 하나, 오늘 반드시 끝낼 목표를 설정하는 Flutter 앱입니다.

## 📱 프로젝트 개요

**One Today**는 사용자가 하루에 하나의 목표를 설정하고, 자정까지 그 목표를 완료하도록 돕는 간단하고 효과적인 목표 관리 앱입니다. 

### 핵심 컨셉
- **하루에 하나의 목표**: 집중력을 높이기 위해 하루에 하나의 목표만 설정 가능
- **자정까지의 시간 제한**: 오늘 설정한 목표는 자정까지 완료해야 함
- **실시간 카운트다운**: 남은 시간을 실시간으로 표시하여 긴장감 유지
- **알람 기능**: 목표 완료를 위한 알람 설정 (선택사항)

## ✨ 주요 기능

### 1. 목표 설정
- 하루에 하나의 목표만 설정 가능
- 목표 이름 입력 (최대 50자)
- 목표 생성 시 오늘 남은 시간 표시

### 2. 실시간 시간 표시
- 자정까지 남은 시간을 실시간으로 카운트다운
- 시간과 분 단위로 표시
- 1초마다 업데이트

### 3. 알람 설정 (선택사항)
- 자정 기준 역산 방식으로 알람 시간 설정
- 예: 자정 1시간 30분 전 = 오후 10시 30분
- 여러 개의 알람 설정 가능
- 중복 알람 방지

### 4. 목표 완료/실패 처리
- **완료**: 사용자가 목표 완료 버튼 클릭 시 축하 화면 표시 (컨페티 효과)
- **실패**: 자정이 지나면 자동으로 실패 화면으로 이동
- 완료/실패 후 목표 자동 삭제

### 5. 다국어 지원
- 한국어 (기본)
- 영어
- 시스템 언어에 따라 자동 감지

### 6. UI/UX
- Material Design 3 적용
- 부드러운 애니메이션 효과 (flutter_animate)
- 그라데이션과 그림자 효과로 모던한 디자인
- Google Fonts (Noto Sans) 적용

## 🏗️ 프로젝트 구조

```
lib/
├── main.dart                          # 앱 진입점
├── models/
│   └── goal.dart                     # Goal 모델 (목표 데이터 구조)
├── screens/
│   ├── home_screen.dart              # 홈 화면 (목표 표시, 카운트다운)
│   ├── create_goal_screen.dart       # 목표 생성 화면
│   ├── completed_screen.dart         # 목표 완료 화면
│   └── failed_screen.dart            # 목표 실패 화면
├── services/
│   ├── goal_service.dart             # 목표 저장/로드 서비스 (SharedPreferences)
│   └── alarm_service.dart            # 알람 스케줄링 서비스
├── widgets/
│   ├── alarm_setting_widget.dart     # 알람 설정 위젯
│   └── analog_clock_widget.dart      # 아날로그 시계 위젯 (현재 미사용)
└── localization/
    └── app_localizations.dart        # 다국어 지원
```

## 🛠️ 기술 스택

### 핵심 프레임워크
- **Flutter** 3.10.0+
- **Dart** 3.10.0+

### 주요 패키지
- `shared_preferences: ^2.2.2` - 로컬 데이터 저장
- `flutter_local_notifications: ^17.0.0` - 로컬 알람 기능
- `timezone: ^0.9.2` - 타임존 처리
- `google_fonts: ^6.1.0` - Google Fonts 적용
- `flutter_animate: ^4.5.0` - 애니메이션 효과
- `numberpicker: ^2.1.2` - 숫자 선택기
- `confetti: ^0.7.0` - 축하 효과
- `intl: ^0.20.2` - 날짜/시간 포맷팅
- `flutter_localizations` - 다국어 지원

## 📋 데이터 모델

### Goal 모델
```dart
class Goal {
  final String name;              // 목표 이름
  final DateTime createdAt;      // 생성 시간
  final bool completed;          // 완료 여부
  final List<int> alarmMinutes;  // 알람 설정 (자정 기준 분 단위)
}
```

## 🔄 앱 플로우

1. **앱 시작** → 목표가 없으면 빈 상태 화면 표시
2. **목표 생성** → 목표 이름 입력 및 알람 설정 (선택)
3. **홈 화면** → 목표 표시 및 실시간 카운트다운
4. **목표 완료** → 완료 버튼 클릭 → 축하 화면 → 홈으로 복귀
5. **시간 만료** → 자정 지나면 자동으로 실패 화면 → 홈으로 복귀

## 🎯 주요 기능 상세

### 목표 관리
- 목표는 `SharedPreferences`에 JSON 형태로 저장
- 날짜가 바뀌면 자동으로 이전 목표 삭제
- 하루에 하나의 목표만 설정 가능 (중복 방지)

### 알람 시스템
- 자정 기준 역산 방식으로 알람 시간 계산
- 예: 자정 2시간 전 = 오후 10시
- 알람 메시지: "목표명 - X시간/분 남았습니다"
- 목표 완료 시 모든 알람 자동 취소

### 시간 관리
- 자정까지 남은 시간을 실시간으로 계산
- 1초마다 업데이트되는 타이머
- 시간 만료 시 자동으로 실패 처리

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK 3.10.0 이상
- Dart 3.10.0 이상
- Android Studio / VS Code
- iOS 개발 시 Xcode (macOS)

### 설치 및 실행

1. **저장소 클론**
```bash
git clone [repository-url]
cd oneToday
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **앱 실행**
```bash
flutter run
```

### 빌드

**Android APK 빌드**
```bash
flutter build apk --release
```

**iOS 빌드**
```bash
flutter build ios --release
```

## 📱 화면 구성

### 1. 홈 화면 (HomeScreen)
- 목표가 없을 때: 빈 상태 화면 + 목표 추가 버튼
- 목표가 있을 때: 목표 카드 + 남은 시간 표시 + 완료 버튼
- 목표 완료 시: 자동으로 완료 화면으로 이동

### 2. 목표 생성 화면 (CreateGoalScreen)
- 오늘 남은 시간 표시
- 목표 이름 입력 필드
- 알람 설정 위젯 (선택사항)
- 목표 생성 버튼

### 3. 완료 화면 (CompletedScreen)
- 축하 메시지 및 컨페티 효과
- 3초 후 자동으로 홈 화면으로 이동
- 수동 확인 버튼 제공

### 4. 실패 화면 (FailedScreen)
- 시간 만료 안내 메시지
- 내일 다시 도전하라는 격려 메시지
- 홈 화면으로 돌아가기 버튼

## 🎨 디자인 시스템

### 색상
- **Primary**: `#6366F1` (Indigo)
- **Secondary**: `#8B5CF6` (Purple)
- **Success**: `Colors.green.shade400`
- **Warning**: `Colors.orange.shade300`

### 폰트
- **기본 폰트**: Noto Sans (Google Fonts)
- **제목**: 24-32px, Bold
- **본문**: 16-18px, Regular
- **설명**: 14px, Regular

### 애니메이션
- 페이드 인/아웃
- 슬라이드 효과
- 스케일 효과
- 컨페티 효과 (완료 시)

## 🔐 데이터 저장

- **저장 위치**: SharedPreferences (로컬 저장소)
- **저장 형식**: JSON
- **저장 키**: `today_goal`
- **자동 삭제**: 날짜가 바뀌면 자동으로 삭제

## 🌍 다국어 지원

현재 지원 언어:
- 한국어 (ko_KR) - 기본
- 영어 (en_US)

새로운 언어 추가는 `lib/localization/app_localizations.dart` 파일에서 가능합니다.

## 📝 향후 개선 사항

- [ ] 목표 히스토리 기능
- [ ] 통계 및 분석 기능
- [ ] 다크 모드 지원
- [ ] 위젯 지원
- [ ] 소셜 공유 기능
- [ ] 목표 카테고리 분류
- [ ] 목표 완료 증명 기능 (사진 첨부 등)

## 📄 라이선스

이 프로젝트는 개인 프로젝트입니다.

## 👤 개발자

개발 및 기획: [Your Name]

---

**One Today** - 하루에 하나의 목표, 오늘을 완성하세요! 🎯
