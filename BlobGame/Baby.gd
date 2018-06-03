extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	passfunc shouldDespawn():
func shouldDespawn():
	if ($VisibilityNotifier2D.is_on_screen() == false && $ImmuneTimer.is_stopped()):
		return  true
	else:
		return false