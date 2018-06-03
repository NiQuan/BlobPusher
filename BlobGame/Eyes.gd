extends RigidBody2D

export (float) var attraction 

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	attraction = 100
	pass

func shouldDespawn():
	if ($VisibilityNotifier2D.is_on_screen() == false && $ImmuneTimer.is_stopped()):
		return  true
	else:
		return false