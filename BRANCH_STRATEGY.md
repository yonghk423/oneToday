# 브랜치 전략

이 프로젝트는 Git Flow를 기반으로 한 브랜치 전략을 사용합니다.

## 🌿 브랜치 구조

```
master      → 프로덕션 배포용 (항상 안정적)
├── develop → 개발 통합 브랜치
├── feature/* → 새 기능 개발
├── bugfix/*  → 버그 수정
├── release/* → 배포 준비
└── hotfix/*  → 긴급 수정/롤백
```

## 📋 브랜치 종류 및 규칙

### 1. Master
- **목적**: 프로덕션 배포용
- **규칙**: 
  - ❌ 직접 커밋 금지
  - ✅ PR을 통해서만 머지
  - ✅ 모든 CI 통과 필수
  - ✅ 배포 시 태그 생성 필수 (`v1.0.0` 형식)
  - ✅ 보호 규칙 적용

### 2. Develop
- **목적**: 개발 통합 브랜치
- **규칙**:
  - ✅ 모든 feature/bugfix 브랜치의 통합 지점
  - ✅ 안정적인 상태 유지
  - ✅ master로 머지 전 최종 테스트
  - ✅ 보호 규칙 적용 (선택)

### 3. Feature 브랜치
- **형식**: `feature/기능명` 또는 `feature/이슈번호-기능명`
- **예시**: 
  - `feature/add-goal-history`
  - `feature/123-dark-mode`
- **규칙**:
  - develop에서 분기
  - 완료 후 develop으로 PR
  - 머지 후 브랜치 삭제

### 4. Bugfix 브랜치
- **형식**: `bugfix/버그명` 또는 `bugfix/이슈번호-버그명`
- **예시**: 
  - `bugfix/fix-alarm-not-working`
  - `bugfix/456-crash-on-startup`
- **규칙**:
  - develop에서 분기
  - 완료 후 develop으로 PR

### 5. Release 브랜치
- **형식**: `release/v버전번호`
- **예시**: `release/v1.1.0`
- **규칙**:
  - develop에서 분기
  - pubspec.yaml 버전 번호 업데이트
  - 최종 테스트 및 버그 수정
  - master와 develop 양쪽에 머지
  - 머지 후 태그 생성

### 6. Hotfix 브랜치
- **형식**: `hotfix/버그명` 또는 `hotfix/v버전번호`
- **예시**: 
  - `hotfix/critical-crash`
  - `hotfix/v1.0.1`
- **규칙**:
  - master에서 분기 (긴급 수정)
  - 수정 후 master와 develop 양쪽에 머지
  - 새 버전 태그 생성

## 🔄 워크플로우

### 새 기능 개발
```bash
# 1. develop 최신화
git checkout develop
git pull origin develop

# 2. feature 브랜치 생성
git checkout -b feature/new-feature

# 3. 개발 작업
# ... 코드 작성 ...

# 4. 커밋 및 푸시
git add .
git commit -m "feat: 새 기능 추가"
git push origin feature/new-feature

# 5. GitHub에서 PR 생성
# develop ← feature/new-feature
# 리뷰 후 머지
```

### 버그 수정
```bash
# 1. develop 최신화
git checkout develop
git pull origin develop

# 2. bugfix 브랜치 생성
git checkout -b bugfix/fix-issue

# 3. 수정 작업
# ... 버그 수정 ...

# 4. 커밋 및 푸시
git add .
git commit -m "fix: 버그 수정"
git push origin bugfix/fix-issue

# 5. GitHub에서 PR 생성
# develop ← bugfix/fix-issue
```

### 배포 준비 (Release)
```bash
# 1. develop에서 release 브랜치 생성
git checkout develop
git pull origin develop
git checkout -b release/v1.1.0

# 2. 버전 업데이트
# pubspec.yaml: version: 1.1.0+2
git add pubspec.yaml
git commit -m "chore: bump version to 1.1.0+2"

# 3. 최종 테스트 및 버그 수정
# ... 테스트 ...

# 4. master에 머지
git checkout master
git pull origin master
git merge release/v1.1.0 --no-ff
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin master
git push origin v1.1.0

# 5. develop에도 머지
git checkout develop
git merge release/v1.1.0
git push origin develop

# 6. release 브랜치 삭제
git branch -d release/v1.1.0
git push origin --delete release/v1.1.0
```

### 긴급 수정 (Hotfix)
```bash
# 1. master에서 hotfix 브랜치 생성
git checkout master
git pull origin master
git checkout -b hotfix/critical-bug

# 2. 긴급 수정
# ... 수정 작업 ...

# 3. 버전 업데이트
# pubspec.yaml: version: 1.0.1+3

# 4. master에 머지
git checkout master
git merge hotfix/critical-bug --no-ff
git tag -a v1.0.1 -m "Hotfix: Critical bug fix"
git push origin master
git push origin v1.0.1

# 5. develop에도 머지
git checkout develop
git merge hotfix/critical-bug
git push origin develop

# 6. hotfix 브랜치 삭제
git branch -d hotfix/critical-bug
git push origin --delete hotfix/critical-bug
```

## 📝 커밋 메시지 규칙

- `feat`: 새 기능 추가
- `fix`: 버그 수정
- `docs`: 문서 수정
- `style`: 코드 포맷팅 (기능 변경 없음)
- `refactor`: 코드 리팩토링
- `test`: 테스트 추가/수정
- `chore`: 빌드 설정, 패키지 관리 등

**예시:**
- `feat: 목표 히스토리 기능 추가`
- `fix: 알람이 작동하지 않는 버그 수정`
- `chore: 버전 1.1.0으로 업데이트`

## 🚨 중요 규칙

1. **master 브랜치에 직접 푸시 금지**
   - 항상 PR을 통해서만 머지
   - 브랜치 보호 규칙 적용 필수

2. **태그는 master에만 생성**
   - 배포 시 반드시 태그 생성 (`v1.0.0` 형식)
   - 태그는 삭제하지 않음

3. **브랜치 머지 후 삭제**
   - feature, bugfix, release, hotfix 브랜치는 머지 후 삭제
   - 로컬과 원격 모두 삭제

4. **develop은 항상 최신 상태 유지**
   - master에 머지한 내용은 develop에도 머지
   - release와 hotfix는 양쪽에 머지

## 📚 참고 자료

- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Semantic Versioning](https://semver.org/)

