extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var spike = preload("res://scenes/spike.tscn")
@export var speed: float = 100
@export var jump_force: float = -200

var gravity: float = 980

enum States {IDLE, WALKING, JUMPING, FALLING, HIT}
var state: States = States.IDLE

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("spike"):
		instanciando_spike(get_global_mouse_position())
	gravity_force(delta)
	movement()
	jumping()
	change_state()
	move_and_slide()
	change_animation()
	flip_player()
func gravity_force(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = 0
			
func movement():
	var direction = Input.get_axis("ui_left","ui_right")
	velocity.x = direction * speed
	
func jumping():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
		
func change_state():
	if is_on_floor():
		if abs(velocity.x) > 0:
			state = States.WALKING
		else:
			state = States.IDLE
	else:
		if velocity.y < 0:
			state = States.JUMPING
		else:
			state = States.FALLING
			
func change_animation():
	var anim = ""
	
	match state:
		States.IDLE:
			anim = "idle"
		States.WALKING:
			anim = "walk"
		States.JUMPING:
			anim = "jump"
		States.FALLING:
			anim = "fall"
			
	if animation_player.current_animation != anim:
		animation_player.play(anim)

func flip_player():
	if velocity.x < 0:
		$Sprite.flip_h = true
	elif velocity.x > 0:
		$Sprite.flip_h = false
		
func instanciando_spike(pos):
	
	var node = spike.instantiate()
	node.global_position = pos
	add_child(node)
	
