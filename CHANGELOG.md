# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2025-12-07

### Added
- 버전 관리 전략 문서 (VERSION_MANAGEMENT.md)
- CI/CD 워크플로우 구성
  - 의존성 검사
  - 코드 분석
  - 포맷팅 검사
  - 테스트 실행
  - 버전 검증
  - 빌드 자동화
  - 자동 태그 및 Release 생성

### Changed
- 브랜치 전략 문서화
- 코드 포맷팅 적용
- 위젯으로 앱 활성화 시 불필요한 UI 리렌더링 개선

### Fixed
- YAML 파서 오류 수정
- GitHub Actions 워크플로우 오류 수정

## [1.1.0] - 2024-01-XX

### Added
- 홈 화면 위젯 기능 (iOS 및 Android)
- 다국어 지원 (한국어, 영어)
- 알람 기능
- 목표 완료/실패 처리
- 스플래시 화면

### Changed
- UI/UX 개선
- Material Design 3 적용
- Google Fonts (Noto Sans) 적용

### Fixed
- 알람 관련 버그 수정

## [1.0.0] - 2024-01-XX

### Added
- 초기 릴리즈
- 목표 설정 기능
- 실시간 카운트다운
- 목표 완료 화면
- 목표 실패 화면

---

## Changelog 작성 규칙

### 카테고리

- **Added**: 새로 추가된 기능
- **Changed**: 기존 기능의 변경
- **Deprecated**: 곧 제거될 기능
- **Removed**: 제거된 기능
- **Fixed**: 버그 수정
- **Security**: 보안 관련 수정

### 작성 예시

```markdown
## [1.2.0] - 2024-02-15

### Added
- 목표 히스토리 기능
- 다크 모드 지원

### Changed
- UI 개선
- 성능 최적화

### Fixed
- 알람이 작동하지 않는 버그 수정
- 크래시 수정
```

### 작성 시점

- Release 브랜치 생성 시 작성
- 배포 전 최종 확인
- master 머지 시 함께 커밋

