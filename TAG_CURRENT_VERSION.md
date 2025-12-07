# 현재 버전 태그 생성 가이드

이 문서는 현재 시점에서 버전을 명시적으로 관리하기 위한 Git 태그 생성 가이드를 제공합니다.

## 현재 상태

- **현재 버전**: `1.1.0+2` (pubspec.yaml)
- **현재 태그**: 없음
- **목표**: 현재 및 이전 배포 버전에 태그 생성

---

## 태그 생성 방법

### 방법 1: 현재 master 브랜치에 태그 생성 (권장)

현재 master 브랜치가 배포된 버전이라면:

```bash
# 1. master 브랜치로 이동
git checkout master
git pull origin master

# 2. 현재 버전 확인
grep '^version:' pubspec.yaml
# 출력: version: 1.1.0+2

# 3. v1.1.0 태그 생성 (BUILD 번호 제외)
git tag -a v1.1.0 -m "Release version 1.1.0

- 홈 화면 위젯 기능 (iOS 및 Android)
- 다국어 지원 (한국어, 영어)
- 알람 기능
- 목표 완료/실패 처리
- UI/UX 개선"

# 4. 태그 푸시
git push origin v1.1.0

# 5. 모든 태그 확인
git tag -l
```

---

### 방법 2: 특정 커밋에 태그 생성

특정 커밋이 배포된 버전이라면:

```bash
# 1. 배포된 커밋 찾기
git log --oneline
# 예: ac29f47 feat: 버전 관리 전략 및 CD 워크플로우 추가

# 2. 해당 커밋에 태그 생성
git tag -a v1.1.0 ac29f47 -m "Release version 1.1.0"

# 3. 태그 푸시
git push origin v1.1.0
```

---

### 방법 3: 이전 버전에도 태그 생성

이전에 배포한 버전이 있다면:

```bash
# 1. 이전 버전의 커밋 찾기
git log --oneline --all
# 예: v1.0.0에 해당하는 커밋 찾기

# 2. 해당 커밋에 태그 생성
git tag -a v1.0.0 [커밋해시] -m "Release version 1.0.0

- 초기 릴리즈
- 목표 설정 기능
- 실시간 카운트다운
- 목표 완료/실패 처리"

# 3. 태그 푸시
git push origin v1.0.0
```

---

## 현재 버전 태그 생성 스크립트

다음 스크립트를 실행하면 현재 master의 버전에 자동으로 태그를 생성합니다:

```bash
#!/bin/bash

# master 브랜치로 이동
git checkout master
git pull origin master

# 현재 버전 확인
VERSION=$(grep '^version:' pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)
TAG="v$VERSION"

# 태그가 이미 있는지 확인
if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "⚠️  Tag $TAG already exists!"
  read -p "Overwrite? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
  git tag -d "$TAG"
  git push origin :refs/tags/"$TAG"
fi

# 태그 생성
git tag -a "$TAG" -m "Release version $VERSION

Current release version.
Tagged on $(date +%Y-%m-%d)"

# 태그 푸시
git push origin "$TAG"

echo "✅ Tag $TAG created and pushed"
```

---

## 태그 생성 후 확인

```bash
# 모든 태그 확인
git tag -l

# 태그 정보 확인
git show v1.1.0

# 태그가 가리키는 커밋 확인
git log v1.1.0 --oneline -1
```

---

## 중요 사항

1. **태그는 삭제하지 않음**
   - 한 번 생성한 태그는 영구 보존
   - 롤백 추적을 위해 필요

2. **태그는 master에만 생성**
   - 배포된 버전만 태그 생성
   - develop에는 태그 생성 안 함

3. **BUILD 번호는 태그에 포함 안 함**
   - 태그: `v1.1.0` (BUILD 번호 제외)
   - pubspec.yaml: `1.1.0+2` (BUILD 번호 포함)

4. **태그 메시지는 명확하게**
   - 배포 내용 요약
   - 주요 변경사항 포함

---

## 다음 단계

태그 생성 후:

1. GitHub에서 태그 확인
   - https://github.com/[사용자명]/oneToday/releases
   - 또는 Tags 탭에서 확인

2. 빌드 자동화 확인
   - 태그 푸시 시 `06-build-on-tag` 워크플로우 실행
   - 자동으로 APK/AAB 빌드 생성

3. Release 확인
   - `07-auto-tag-release` 워크플로우가 Release 생성
   - 또는 수동으로 Release 생성 가능

