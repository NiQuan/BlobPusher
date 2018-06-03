extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var SPEED  # how fast the player will move (pixels/sec)
export (Vector2) var playerDir
export (Vector2) var playerVel
var screensize 
signal hit

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	screensize = get_viewport_rect().size
	playerDir = Vector2(1,0)
	

func _process(delta):
    var dir
    var velocity = Vector2() # the player's movement vector
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    if velocity.length() > 0:
        dir = velocity.normalized()
        velocity = dir * SPEED
        playerVel = velocity
        playerDir = dir
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()
        playerVel = Vector2(0,0)
    position += velocity * delta
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)
	
	
func _on_Player_body_entered( body ):
    hide() # Player disappears after being hit
    emit_signal("hit")
    $CollisionShape2D.disabled = true
    pass

func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false



