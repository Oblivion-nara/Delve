extends Control

onready var scoretext = get_node("ScoreText");

func _ready():
	scoretext.text = "Score: 0"
	
func set_score_text(value):
	scoretext.text = "Score: " + str(value)
