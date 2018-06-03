extends Node
export (PackedScene) var Mob
export (PackedScene) var Pusher
export (PackedScene) var Eyes
export (PackedScene) var IronBlob
export (PackedScene) var Mother
export (PackedScene) var Baby
var score
var enemies = []
var enemyTypes = [] # 0 = mob, 1 = eyes
var nextDiff = 0
var diff_level = 0
var enemyProfiles = [[1, 0, 0, 0],[0.5, 0.5, 0, 0],[0.4, 0.4, 0.2, 0],[0.35, 0.35, 0.2, 0.1]]
var enemyProbs = enemyProfiles[0]
var motherExists = false
var gameOver = false

func _ready():
	randomize()
	$Player.start($StartPosition.position)
	score = 0
	$HUD.setScoreText(score)

func game_over():
	$MobTimer.stop()
	$HUD.game_over()
	gameOver = true

func new_game():
	score = 0
	$HUD.restart()
	$Player.start($StartPosition.position)
	$Player.show()
	$HUD.show_message("")
	gameOver = false
	$StartTimer.start()
	for i in range(enemies.size()-1,-1,-1):
		enemies[i].queue_free()
		enemies.remove(i)
		enemyTypes.remove(i)
		

func _on_StartTimer_timeout():
    $MobTimer.start()
    $DespawnTimer.start()




func _on_MobTimer_timeout():
	
	var randfloat
	var currentProbLower
	var enemyProfile
	var startSpeed
	
	if score >nextDiff:
		if(nextDiff/20 < 4):
			enemyProbs = enemyProfiles[int(nextDiff/20)]
			print(enemyProbs)
		
		nextDiff += 10
		$MobTimer.set_wait_time(2/log(score+2))
	
	enemyProfile = [] + enemyProbs
	for i in range(enemyProfile.size()):
		if i == 0:
			enemyProfile[i] = enemyProbs[i]
		else:
			enemyProfile[i] = enemyProfile[i-1] + enemyProbs[i] #Basically enemy profile is the cumulative probablility while the enemy probs is just the probablity for that specific enemy
		

	
	randfloat = randf()
	
	var newEnemy
	var enemyType
	if randfloat <= enemyProfile[0]:
		newEnemy = Mob.instance()
		enemyType = 0
	elif randfloat <= enemyProfile[1] && randfloat > enemyProfile[0]:
		newEnemy = Eyes.instance()
		enemyType = 1
	elif randfloat <= enemyProfile[2] && randfloat > enemyProfile[1]:
		newEnemy = IronBlob.instance()
		enemyType = 2
	elif randfloat <= enemyProfile[3] && randfloat > enemyProfile[2] && !motherExists:
		newEnemy = Mother.instance()
		motherExists = true
		enemyType = 3
	else:
		newEnemy = Mob.instance()
		enemyType = 0
	add_child(newEnemy)
	enemies.append(newEnemy)
	enemyTypes.append(enemyType)
	$MobPath/MobSpawnLocation.set_offset(randi())
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2
	newEnemy.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI/4, PI/4)
	
	if enemyType != 3:
		newEnemy.rotation = direction
	if enemyType == 2:
		startSpeed = 60
	else:
		startSpeed = 30
		
	newEnemy.set_linear_velocity(Vector2(startSpeed,0).rotated(direction))





 # replace with function body
func _process(delta):
	if Input.is_action_just_pressed("ui_select") && $PusherTimer.time_left == 0 && !gameOver:
		spawnPusher()
		$PusherTimer.start()
		
func spawnPusher():
	var pusher = Pusher.instance()
	var direction
	add_child(pusher)
	direction = $Player.playerDir
	pusher.position = $Player.position
	#$Player.position = $Player.position - 5*direction
	#pusher.rotation = atan2(direction.x,direction.y)
	pusher.set_linear_velocity(300*direction+$Player.playerVel)


func _on_DespawnTimer_timeout():
	
	var scoreUpdated
	#var tempEnemiesArray = enemies
	#var tempTypesArray = enemyTypes
	
	for i in range(enemies.size()-1,-1,-1):
		if enemies[i].shouldDespawn():
			if enemyTypes[i] == 3:
				motherExists = false
			elif enemyTypes[i] == 10:
				print("baby died")
			enemies[i].queue_free()
			enemies.remove(i)
			enemyTypes.remove(i)
			if !gameOver:
				score += 1
			scoreUpdated = true
	
	
	
	if scoreUpdated:
		$HUD.setScoreText(score)



func _on_EnemyAI_timeout():
	var mobPos
	var diffVect
	var enemy
	var newBaby
	
	for i in range(0, enemies.size()):
		#print(enemies[i].get_name()+"   "+ str(enemyTypes[i]))
		if enemyTypes[i] == 1:
			enemy = enemies[i]
			mobPos = enemy.position
			diffVect = $Player.position - mobPos
			enemy.apply_impulse(Vector2(0,0),diffVect.normalized()*enemy.attraction)
		elif enemyTypes[i] == 3:
			if enemies[i].cooldowned():
				enemy = enemies[i]
				mobPos = enemy.position
				diffVect = $Player.position - mobPos
				newBaby = Baby.instance()
				add_child(newBaby)
				newBaby.position = mobPos
				diffVect = $Player.position - mobPos
				newBaby.set_linear_velocity(200*diffVect.normalized())
				newBaby.set_angular_velocity(10)
				enemies.append(newBaby)
				enemyTypes.append(10)
			

func _on_HUD_start_game():
	new_game()
