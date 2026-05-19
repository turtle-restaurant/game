# 🐢 거북이식당 — 게임 코드

> **turtle-restaurant / game** | Public  
> Godot 4 기반 힐링 아케이드 + 운영 시뮬레이션 게임

---

## 게임 소개

주인공 거북이가 되어 다양한 동물 손님들에게 음식을 만들어 대접하는 힐링 식당 게임.
파스텔+스케치톤 아트 스타일, 4종 미니게임, 손님별 에피소드 시스템.

**플랫폼**: iOS / Android (PC 추가 예정)  
**개발 상태**: 🚧 개발 중

---

## 기술 스택

| 항목 | 내용 |
|------|------|
| 엔진 | Godot 4 |
| 언어 | GDScript |
| AI 코드 생성 | Claude Code, Cursor |
| 타겟 플랫폼 | iOS, Android |

---

## 프로젝트 구조

```
game/
├── scenes/
│   ├── main/          # 타이틀, 메인메뉴
│   ├── restaurant/    # 식당 운영 메인 씬
│   ├── minigames/     # 미니게임 4종
│   └── shop/          # 상점
├── scripts/
│   ├── core/          # GameManager, DayManager, SaveManager
│   ├── characters/    # 손님 AI, 거북이 주인공
│   ├── minigames/     # 미니게임 로직
│   └── ui/            # HUD, 팝업, 상점 UI
├── assets/
│   ├── characters/    # 캐릭터 스프라이트
│   ├── food/          # 음식 아이템
│   ├── ui/            # UI 이미지
│   └── bgm/           # 배경음악, 효과음
└── data/
    ├── recipes.json   # 레시피 데이터
    ├── customers.json # 손님 데이터
    └── episodes.json  # 에피소드 스크립트
```

---

## 브랜치 전략

| 브랜치 | 용도 |
|--------|------|
| `main` | 안정 버전 (릴리즈) |
| `develop` | 통합 개발 브랜치 |
| `feature/*` | 기능 단위 작업 |
| `fix/*` | 버그 수정 |
| `release/*` | 출시 준비 |

---

## 관련 레포지토리

| 레포 | 설명 |
|------|------|
| [turtle-restaurant/docs](https://github.com/turtle-restaurant/docs) | 개발 문서, 개발일지 |
| [turtle-restaurant/design](https://github.com/turtle-restaurant/design) | 아트 에셋, UI 디자인 |
