extends CharacterBody2D

@export var speed=20
@export var limit=0.5
@export var MovePositon:Marker2D
@onready var animations= $AnimationPlayer
var startPosition: Vector2
var endPositon: Vector2

func _ready() -> void:
	startPosition=position
	endPositon=MovePositon.global_position

func updatePositon():
	var temp=endPositon
	endPositon=startPosition
	startPosition=temp;

func updateVelocity():
	var moveDirection=(endPositon-position)
	if moveDirection.length()<limit:
		updatePositon()
	velocity=moveDirection.normalized()*speed
func updateAnimation():
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "down"
		if velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
		animations.play(direction)

func _physics_process(_delta: float) -> void:
	updateVelocity()
	updateAnimation()
	move_and_slide()
