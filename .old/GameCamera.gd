extends Camera2D

const MIN_ZOOM: float = 0.1
const MAX_ZOOM: float = 1.0
const ZOOM_INCREMENT: float = 0.1
const ZOOM_RATE: float = 8.0

var targetZoom: float = 1.0

func _ready():
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_RIGHT:
			position -= event.relative * zoom
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_in()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_out()

func zoom_in() -> void:
	targetZoom = max(targetZoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)

func zoom_out() -> void:
	targetZoom = min(targetZoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	zoom = lerp(
		zoom,
		targetZoom * Vector2.ONE,
		ZOOM_RATE * delta
	)
	set_physics_process(
		not is_equal_approx(zoom.x, targetZoom)
	)
