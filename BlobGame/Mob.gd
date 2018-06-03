extends RigidBody2D




func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	
	$ImmuneTimer.start()


func shouldDespawn():
	if ($VisibilityNotifier2D.is_on_screen() == false && $ImmuneTimer.is_stopped()):
		return  true
	else:
		return false