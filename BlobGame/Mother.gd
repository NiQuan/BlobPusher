extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$AnimatedSprite.play()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func shouldDespawn():
	if ($VisibilityNotifier2D.is_on_screen() == false && $ImmuneTimer.is_stopped()):
		return  true
	return false
		
func cooldowned():
	if $BabyCooldown.time_left == 0:
		return true
	return false