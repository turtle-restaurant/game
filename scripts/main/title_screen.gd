## title_screen.gd
## 타이틀 화면 스크립트
## 게임 시작, 설정, 크레딧 버튼 처리

extends Control

# ─── 노드 참조 ────────────────────────────────────
# Godot 에디터에서 버튼 노드 추가 후 아래 변수명과 연결
@onready var btn_start   = $VBoxContainer/BtnStart
@onready var btn_setting = $VBoxContainer/BtnSetting
@onready var btn_credit  = $VBoxContainer/BtnCredit
@onready var lbl_title   = $LblTitle
@onready var lbl_version = $LblVersion

# ─── 상수 ────────────────────────────────────────
const SCENE_RESTAURANT = "res://scenes/restaurant/restaurant.tscn"

# ─── 초기화 ──────────────────────────────────────
func _ready() -> void:
	# 버전 표시
	lbl_version.text = "v" + ProjectSettings.get_setting("application/config/version")

	# 버튼 시그널 연결
	btn_start.pressed.connect(_on_start_pressed)
	btn_setting.pressed.connect(_on_setting_pressed)
	btn_credit.pressed.connect(_on_credit_pressed)

	# 타이틀 등장 애니메이션 (간단한 페이드인)
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.8)

# ─── 버튼 이벤트 ──────────────────────────────────
func _on_start_pressed() -> void:
	# 버튼 비활성화 (중복 클릭 방지)
	btn_start.disabled = true

	# 페이드 아웃 후 씬 전환
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	tween.tween_callback(_go_to_restaurant)

func _go_to_restaurant() -> void:
	get_tree().change_scene_to_file(SCENE_RESTAURANT)

func _on_setting_pressed() -> void:
	# TODO: 설정 팝업 오픈
	print("설정 버튼 클릭 (미구현)")

func _on_credit_pressed() -> void:
	# TODO: 크레딧 팝업 오픈
	print("크레딧 버튼 클릭 (미구현)")
