## DayManager.gd
## 하루 식당 운영 흐름 제어 (손님 스폰, 타이머, 마감)

extends Node

# ─── 시그널 ───────────────────────────────────────
signal customer_spawned(customer: Node)
signal all_customers_done()
signal day_timer_tick(seconds_left: int)

# ─── 설정값 (난이도별 조정 가능) ──────────────────
@export var day_duration_sec: float = 180.0      # 하루 영업 시간 (초)
@export var customer_interval_sec: float = 8.0   # 손님 간격 (초)
@export var max_customers_per_day: int = 15       # 하루 최대 손님 수

# ─── 내부 상태 ───────────────────────────────────
var _timer_remaining: float = 0.0
var _spawn_timer: float = 0.0
var _customers_spawned: int = 0
var _is_running: bool = false

@onready var customer_spawn_point = $CustomerSpawnPoint  # 씬에서 연결

# ─── 하루 시작 ───────────────────────────────────
func start_day() -> void:
	_timer_remaining = day_duration_sec
	_spawn_timer = 0.0
	_customers_spawned = 0
	_is_running = true

func stop_day() -> void:
	_is_running = false

# ─── 매 프레임 ───────────────────────────────────
func _process(delta: float) -> void:
	if not _is_running:
		return

	_timer_remaining -= delta
	day_timer_tick.emit(int(_timer_remaining))

	if _timer_remaining <= 0:
		_is_running = false
		all_customers_done.emit()
		return

	# 손님 스폰
	_spawn_timer -= delta
	if _spawn_timer <= 0 and _customers_spawned < max_customers_per_day:
		_spawn_timer = customer_interval_sec
		_spawn_customer()

func _spawn_customer() -> void:
	# TODO: CustomerManager에서 오늘 컨셉에 맞는 손님 풀에서 선택
	_customers_spawned += 1
	# customer_spawned.emit(customer_node)
	print("손님 스폰: %d번째" % _customers_spawned)
