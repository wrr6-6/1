extends CharacterBody2D

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.animation = "right"
		input_dir.x += 1
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.animation = "left"
		input_dir.x -= 1
	if Input.is_action_pressed("move_down"):
		$AnimatedSprite2D.animation = "down"
		input_dir.y += 1
	if Input.is_action_pressed("move_up"):
		$AnimatedSprite2D.animation = "up"
		input_dir.y -= 1

	if input_dir.length() > 0:
		velocity = input_dir.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	# 尝试移动
	move_and_collide(velocity * delta)

	# 根据碰撞情况调整速度
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		if normal.x > 0 and velocity.x < 0:
			velocity.x = 0
		elif normal.x < 0 and velocity.x > 0:
			velocity.x = 0
		if normal.y > 0 and velocity.y < 0:
			velocity.y = 0
		elif normal.y < 0 and velocity.y > 0:
			velocity.y = 0

	# 再次移动，使用调整后的速度
	move_and_slide()
