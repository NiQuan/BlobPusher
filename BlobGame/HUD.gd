extends CanvasLayer

signal start_game

var text_size = 1;
var firstUpdate = true
var baseScorePos
var baseScoreSize
var started = false
var is_game_over = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	baseScorePos = $ScoreLayer/ScoreLabel.rect_position
	baseScoreSize = $ScoreLayer/ScoreLabel.rect_size
	$ScoreLayer/ScoreLabel.hide()
	$MessageLabel.hide()
	pass
	
func setScoreText(score):
	$ScoreLayer/ScoreLabel.text = str(score)
	if !firstUpdate:
		text_size = 1.5
	else: firstUpdate = false
func _process(delta):

	if text_size > 1:
		text_size -= delta
		if text_size <1:
			text_size = 1
		$ScoreLayer/ScoreLabel.rect_scale = Vector2(text_size,text_size)
		$ScoreLayer/ScoreLabel.rect_position = Vector2(int(baseScorePos.x-baseScoreSize.x*text_size/2),baseScorePos.y)
	
	elif Input.is_action_just_pressed("ui_select"):
		if !started:
			start_game()
		elif is_game_over:
			get_tree().change_scene("res://Main.tscn")
	
#	pass


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	
func start_game():
	
	print("start")
	$StartButton.hide()
	$TitleScreen.hide()
	$ScoreLayer/ScoreLabel.show()
	$InstButton.hide()
	$Nicholas.hide()
	emit_signal("start_game")
	started = true

func _on_Button_pressed():
	start_game()

func restart():
	show_message("")
	setScoreText(0)
	
func game_over():
	show_message("Game Over \n Press Space to Restart")
	is_game_over = true
	#$StartButton.show()
	#started = false


func _on_InstButton_pressed():
	get_tree().change_scene("res://Instructions.tscn")
