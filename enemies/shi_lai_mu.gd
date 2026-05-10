extends CharacterBody2D

@export var speed=20
@export var limit=0.5
@export var MovePositon:Marker2D
@onready var animated= $AnimatedSprite2D
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
	
func updateAnimated():
	var str2="up"
	if velocity.y>0:
		str2="down"
	animated.play(str2)

func _physics_process(_delta: float) -> void:
	updateVelocity()
	updateAnimated()
	move_and_slide()
