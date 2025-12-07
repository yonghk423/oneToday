# 버전 관리 전략

이 프로젝트는 [Semantic Versioning (SemVer)](https://semver.org/) 규칙을 따릅니다.

## 📋 버전 형식

### 기본 형식
```
MAJOR.MINOR.PATCH+BUILD
예: 1.1.0+2
```

### 구성 요소

- **MAJOR** (주 버전): 하위 호환성 깨지는 변경
- **MINOR** (부 버전): 새 기능 추가 (하위 호환성 유지)
- **PATCH** (수정 버전): 버그 수정
- **BUILD** (빌드 번호): 빌드마다 자동 증가

### 예시
- `1.0.0+1` → 첫 정식 릴리즈
- `1.0.1+2` → 버그 수정 (PATCH 증가)
- `1.1.0+3` → 새 기능 추가 (MINOR 증가)
- `2.0.0+4` → 큰 변경 (MAJOR 증가)

---

## 🔢 버전 증가 규칙

### MAJOR 증가 (1.0.0 → 2.0.0)

**조건**:
- 하위 호환성 깨지는 변경
- API 변경
- 큰 리팩토링
- 데이터베이스 스키마 변경

**예시**:
- 앱 구조 대폭 변경
- 주요 기능 제거
- 사용자 데이터 형식 변경

### MINOR 증가 (1.0.0 → 1.1.0)

**조건**:
- 새 기능 추가
- 하위 호환성 유지
- 기능 개선

**예시**:
- 목표 히스토리 기능 추가
- 다크 모드 추가
- UI 개선

### PATCH 증가 (1.0.0 → 1.0.1)

**조건**:
- 버그 수정
- 보안 패치
- 작은 수정

**예시**:
- 알람이 작동하지 않는 버그 수정
- 크래시 수정
- 성능 최적화

### BUILD 증가 (+1, +2, +3...)

**조건**:
- 빌드마다 자동 증가
- 같은 버전이라도 빌드마다 고유 번호
- 배포 시마다 증가

**예시**:
- `1.1.0+1` → 첫 빌드
- `1.1.0+2` → 같은 버전, 다른 빌드
- `1.1.0+10` → 테스트 빌드 10개

---

## 🏷️ 태그 규칙

### 태그 형식
```
vMAJOR.MINOR.PATCH
예: v1.1.0
```

**중요**:
- BUILD 번호는 태그에 포함하지 않음
- `v` 접두사 필수
- 소문자만 사용

### 태그 생성 시점

1. **Release 브랜치 머지 시**
   ```bash
   release/v1.1.0 → master 머지
   → 태그: v1.1.0
   ```

2. **Hotfix 브랜치 머지 시**
   ```bash
   hotfix/v1.0.1 → master 머지
   → 태그: v1.0.1
   ```

### 태그 메시지 형식

```bash
git tag -a v1.1.0 -m "Release version 1.1.0

- 새 기능: 목표 히스토리 추가
- 버그 수정: 알람 오류 수정
- 성능 개선: 앱 시작 속도 향상"
```

---

## 📝 버전 업데이트 시점

### Release 브랜치

```bash
# 1. release/v1.1.0 브랜치 생성
git checkout -b release/v1.1.0

# 2. pubspec.yaml 버전 업데이트
# version: 1.0.0+5 → 1.1.0+1
# (MINOR 증가, BUILD는 1로 리셋)

# 3. master에 머지 후 태그 생성
git tag -a v1.1.0 -m "Release version 1.1.0"
```

### Hotfix 브랜치

```bash
# 1. hotfix/v1.0.1 브랜치 생성
git checkout -b hotfix/critical-bug

# 2. pubspec.yaml 버전 업데이트
# version: 1.0.0+5 → 1.0.1+1
# (PATCH 증가, BUILD는 1로 리셋)

# 3. master에 머지 후 태그 생성
git tag -a v1.0.1 -m "Hotfix: Critical bug fix"
```

### 롤백 시

```bash
# 1. 이전 안정 버전 확인
git tag -l  # v1.0.0 확인

# 2. 롤백 버전 생성
# version: 1.1.0+10 → 1.0.1+1
# (PATCH 증가, BUILD는 1로 리셋)

# 3. 태그 생성
git tag -a v1.0.1 -m "Hotfix: Rollback to v1.0.0"
```

---

## ✅ 버전 검증 규칙

### 1. 버전 형식 검증
- `MAJOR.MINOR.PATCH+BUILD` 형식 확인
- 숫자만 사용 (예: `1.1.0+2` ✅, `1.1.0-beta+2` ❌)

### 2. 브랜치명과 버전 일치
- `release/v1.1.0` → `pubspec.yaml: 1.1.0+X`
- `hotfix/v1.0.1` → `pubspec.yaml: 1.0.1+X`

### 3. 중복 버전 방지
- 이미 존재하는 태그와 중복 확인
- 같은 버전 재사용 금지

### 4. 버전 증가 규칙 준수
- 버전은 항상 증가 (감소 불가)
- 이전 버전보다 커야 함

---

## 🔄 버전 관리 워크플로우

### 새 기능 배포 (MINOR 증가)

```
1. develop에서 release/v1.1.0 생성
2. 버전 업데이트: 1.0.0+5 → 1.1.0+1
3. 최종 테스트
4. master에 머지
5. 태그 생성: v1.1.0
6. 배포
```

### 버그 수정 배포 (PATCH 증가)

```
1. develop에서 release/v1.0.1 생성
2. 버전 업데이트: 1.0.0+5 → 1.0.1+1
3. 최종 테스트
4. master에 머지
5. 태그 생성: v1.0.1
6. 배포
```

### 긴급 수정 (Hotfix)

```
1. master에서 hotfix/v1.0.1 생성
2. 버전 업데이트: 1.0.0+10 → 1.0.1+1
3. 수정 및 테스트
4. master에 머지
5. 태그 생성: v1.0.1
6. 긴급 배포
```

### 롤백

```
1. 문제 발견 (v1.1.0)
2. 이전 안정 버전 확인 (v1.0.0)
3. hotfix/rollback-to-v1.0.0 생성
4. 버전 업데이트: 1.0.1+1
5. master에 머지
6. 태그 생성: v1.0.1
7. 롤백 배포
```

---

## 📚 버전 관리 원칙

### 1. 태그는 삭제하지 않음
- 한 번 생성한 태그는 영구 보존
- 롤백 추적을 위해 필요

### 2. 버전은 항상 증가
- 이전 버전보다 커야 함
- 감소 불가

### 3. BUILD 번호는 자동 증가
- 같은 버전이라도 빌드마다 증가
- 배포 시마다 증가

### 4. 태그는 master에만 생성
- 배포된 버전만 태그 생성
- develop에는 태그 생성 안 함

### 5. 버전은 pubspec.yaml에만 관리
- 단일 소스 원칙
- 다른 곳에 중복 정의 금지

---

## 🛠️ 버전 관리 도구

### 수동 버전 업데이트

```bash
# pubspec.yaml 직접 수정
version: 1.1.0+1
```

### 버전 확인

```bash
# 현재 버전 확인
grep '^version:' pubspec.yaml

# 모든 태그 확인
git tag -l

# 특정 태그 정보
git show v1.1.0
```

### 태그 생성

```bash
# 주석 태그 생성
git tag -a v1.1.0 -m "Release version 1.1.0"

# 태그 푸시
git push origin v1.1.0

# 모든 태그 푸시
git push origin --tags
```

---

## 📖 참고 자료

- [Semantic Versioning](https://semver.org/)
- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Flutter Versioning](https://docs.flutter.dev/deployment/versioning)

---

## 🚨 중요 사항

1. **버전 번호는 신중하게 결정**
   - MAJOR 증가는 큰 결정
   - 사용자에게 영향이 큰 변경

2. **태그는 배포 시에만 생성**
   - 테스트 빌드에는 태그 생성 안 함
   - 프로덕션 배포 시에만 생성

3. **버전은 pubspec.yaml에만 관리**
   - 단일 소스 원칙 준수
   - 중복 정의 방지

4. **롤백 시에도 새 버전 생성**
   - v1.0.0으로 롤백 → v1.0.1 생성
   - 버전은 항상 증가

