## MiniGameBase.gd
## 모든 미니게임이 상속받는 기본 클래스

extends Node2D

class_name MiniGameBase

# ─── 시그널 ───────────────────────────────────────
signal minigame_completed(quality: float)   # 0.0 ~ 1.0 (요리 품질)
signal minigame_failed()

# ─── 설정값 ──────────────────────────────────────
@export var time_limit: float = 20.0        # 제한 시간 (초)
@export var recipe_id: String = ""          # 어떤 레시피용 미니게임인지

# ─── 내부 상태 ───────────────────────────────────
var _time_remaining: float = 0.0
var _is_active: bool = false
var _score: float = 0.0

@onready var timer_bar = $TimerBar
@onready var animator = $AnimationPlayer

# ─── 시작 ────────────────────────────────────────
func start_minigame(recipe: String = "") -> void:
	if recipe != "":
		recipe_id = recipe
	_time_remaining = time_limit
	_score = 0.0
	_is_active = true
	_on_start()

# ─── 하위 클래스에서 구현 ─────────────────────────
func _on_start() -> void:
	pass  # 각 미니게임에서 오버라이드

func _on_success() -> void:
	pass

func _on_fail() -> void:
	pass

# ─── 완료 처리 ───────────────────────────────────
func complete(quality: float) -> void:
	_is_active = false
	_score = clamp(quality, 0.0, 1.0)
	_on_success()
	minigame_completed.emit(_score)

func fail() -> void:
	_is_active = false
	_on_fail()
	minigame_failed.emit()

# ─── 타이머 ──────────────────────────────────────
func _process(delta: float) -> void:
	if not _is_active:
		return

	_time_remaining -= delta
	if timer_bar:
		timer_bar.value = _time_remaining / time_limit

	if _time_remaining <= 0:
		fail()
