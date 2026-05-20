## Customer.gd
## 손님 기본 클래스. 모든 손님 캐릭터가 상속받음.

extends CharacterBody2D

class_name Customer

# ─── 시그널 ───────────────────────────────────────
signal order_placed(customer: Customer, recipe_id: String)
signal served(customer: Customer, satisfaction: float)
signal left_without_serving(customer: Customer)

# ─── 손님 상태 ───────────────────────────────────
enum State { ENTERING, WAITING_SEAT, ORDERING, WAITING_FOOD, EATING, LEAVING }

var state: State = State.ENTERING
var customer_id: String = ""
var customer_name: String = ""
var patience: float = 30.0        # 최대 대기 시간 (초)
var patience_remaining: float = 0.0
var ordered_recipe_id: String = ""
var satisfaction: float = 1.0     # 0.0 ~ 1.0

# ─── 에피소드 관련 ───────────────────────────────
var has_episode: bool = false
var episode_id: String = ""

# ─── 노드 참조 ───────────────────────────────────
@onready var patience_bar = $PatienceBar
@onready var speech_bubble = $SpeechBubble
@onready var animator = $AnimationPlayer

# ─── 초기화 ──────────────────────────────────────
func setup(data: Dictionary) -> void:
	customer_id = data.get("id", "unknown")
	customer_name = data.get("name", "손님")
	patience = data.get("patience", 30.0)
	has_episode = data.get("has_episode", false)
	episode_id = data.get("episode_id", "")

func _ready() -> void:
	patience_remaining = patience

# ─── 매 프레임 ───────────────────────────────────
func _process(delta: float) -> void:
	if state == State.WAITING_FOOD:
		patience_remaining -= delta
		_update_patience_bar()

		if patience_remaining <= 0:
			_leave_without_food()

func _update_patience_bar() -> void:
	if patience_bar:
		patience_bar.value = patience_remaining / patience

# ─── 주문 ────────────────────────────────────────
func place_order(recipe_id: String) -> void:
	ordered_recipe_id = recipe_id
	state = State.WAITING_FOOD
	order_placed.emit(self, recipe_id)

# ─── 서빙 받음 ───────────────────────────────────
func receive_food(quality: float) -> void:
	state = State.EATING
	# 기다린 시간에 따라 만족도 계산
	var wait_ratio = patience_remaining / patience
	satisfaction = clamp(quality * wait_ratio, 0.0, 1.0)
	served.emit(self, satisfaction)

# ─── 못 먹고 떠남 ────────────────────────────────
func _leave_without_food() -> void:
	state = State.LEAVING
	satisfaction = 0.0
	left_without_serving.emit(self)
