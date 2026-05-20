## GameManager.gd
## 게임 전체 상태를 관리하는 싱글톤 (AutoLoad)
## 씬 전환, 저장/불러오기, 전역 데이터 관리

extends Node

# ─── 시그널 ───────────────────────────────────────
signal day_started(day_number: int)
signal day_ended(result: Dictionary)
signal gold_changed(amount: int)
signal gem_changed(amount: int)

# ─── 플레이어 데이터 ──────────────────────────────
var player_data: Dictionary = {
	"current_day": 1,
	"gold": 0,
	"gem": 0,
	"total_customers": 0,
	"total_revenue": 0,
	"unlocked_recipes": [],
	"unlocked_interiors": [],
	"episode_progress": {},  # { "customer_id": episode_step }
}

# ─── 오늘 하루 데이터 ────────────────────────────
var today_data: Dictionary = {
	"concept_day": "",   # "korean" | "western" | "japanese" | "chinese"
	"customers_served": 0,
	"revenue": 0,
	"satisfaction": 0.0,
}

# ─── 상수 ────────────────────────────────────────
const SAVE_PATH = "user://save_data.json"
const CONCEPT_DAYS = ["korean", "western", "japanese", "chinese"]

# ─── 초기화 ──────────────────────────────────────
func _ready() -> void:
	load_game()

# ─── 하루 시작 ───────────────────────────────────
func start_day() -> void:
	today_data = {
		"concept_day": _pick_concept_day(),
		"customers_served": 0,
		"revenue": 0,
		"satisfaction": 0.0,
	}
	day_started.emit(player_data["current_day"])

func _pick_concept_day() -> String:
	# TODO: 특정 날짜에 특정 컨셉 고정하는 로직 추가 가능
	return CONCEPT_DAYS[randi() % CONCEPT_DAYS.size()]

# ─── 하루 마감 ───────────────────────────────────
func end_day() -> void:
	player_data["current_day"] += 1
	player_data["total_customers"] += today_data["customers_served"]
	player_data["total_revenue"] += today_data["revenue"]
	day_ended.emit(today_data)
	save_game()

# ─── 재화 관리 ───────────────────────────────────
func add_gold(amount: int) -> void:
	player_data["gold"] += amount
	gold_changed.emit(player_data["gold"])

func spend_gold(amount: int) -> bool:
	if player_data["gold"] < amount:
		return false
	player_data["gold"] -= amount
	gold_changed.emit(player_data["gold"])
	return true

func add_gem(amount: int) -> void:
	player_data["gem"] += amount
	gem_changed.emit(player_data["gem"])

# ─── 저장 / 불러오기 ─────────────────────────────
func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(player_data))
		file.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		var result = json.parse(file.get_as_text())
		file.close()
		if result == OK:
			player_data.merge(json.get_data(), true)
