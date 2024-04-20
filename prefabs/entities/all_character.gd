extends Node2D

@onready var cult_heads = $All_Skeleton/Heads/Cult_Heads
@onready var hero_heads = $All_Skeleton/Heads/Hero_Heads
@onready var peon_heads = $All_Skeleton/Heads/Peon_Heads

@onready var all_hands = $All_Skeleton/AllHands

@onready var all_body = $All_Skeleton/AllBody
#@onready var peon_aapron = $All_Skeleton/Peon_Aapron

# 0 - Player | 1 - Cultist | 2 - HERO Guard 
# 3 - HERO Archer | 4 - HERO Wizard | 5 - Peon
var character = 0

# 0 - Pink | 1 - Ginger | 2 - Brown
var skin_color:int = 0
var head_id:int = 0
var clothes_id:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_character()
	if character != 0:
		generate_character()

# Draws character from collection of assets
func generate_character():
	all_hands.visible = true
	skin_color = randi() % 3
	all_hands.frame = skin_color
	if character == 1:
		draw_cultist()
	elif character > 1 and character < 5:
		draw_hero()
	elif character == 5:
		draw_peon()

func draw_cultist():
	cult_heads.visible = true
	head_id = randi() % 4
	cult_heads.frame = ((head_id * 3) + skin_color)
	all_body.frame = 1

func draw_hero():
	hero_heads.visible = true
	if character == 2:
		draw_hero_guard()
	elif character == 3:
		draw_hero_archer()
	elif character == 4:
		draw_hero_wizard()

func draw_hero_guard():
	hero_heads.visible = true
	head_id = randi() % 4
	#print("skin: ", skin_color)
	#print("head: ", head_id)
	hero_heads.frame = skin_color
	clothes_id = randi() % 2
	all_body.frame = 2 + clothes_id

func draw_hero_archer():
	hero_heads.visible = true
	head_id = randi() % 4
	#print("skin: ", skin_color)
	#print("head: ", head_id)
	hero_heads.frame = ((head_id * 3) + skin_color)
	clothes_id = randi() % 2
	all_body.frame = 4 + clothes_id

func draw_hero_wizard():
	hero_heads.visible = true
	head_id = 0
	hero_heads.frame = skin_color
	clothes_id = randi() % 2
	all_body.frame = 6 + clothes_id

func draw_peon():
	peon_heads.visible = true
	head_id = randi() % 4
	peon_heads.frame = ((head_id * 3) + skin_color)
	clothes_id = randi() % 6
	all_body.frame = 8 + clothes_id

func clear_character():
	all_body.visible = true
	all_hands.visible = false
	cult_heads.visible = false
	hero_heads.visible = false
	peon_heads.visible = false
	all_hands.frame = 0
	cult_heads.frame = 0
	hero_heads.frame = 0
	peon_heads.frame = 0

func play_idle():
	if $AnimationPlayer.is_playing() == false or ($AnimationPlayer.is_playing() and $AnimationPlayer.current_animation != "Idle"):
		$AnimationPlayer.play("Idle")
	$Walk_Trail.emitting = false
	return true
##

func play_waddle():
	if $AnimationPlayer.is_playing() == false or ($AnimationPlayer.is_playing() and $AnimationPlayer.current_animation != "Walk"):
		$AnimationPlayer.play("Walk")
	$Walk_Trail.emitting = true
	return true
##

func flash():
	$FlashTimer.start()
	$All_Skeleton/AllBody.material.set_shader_parameter("hit_opacity", 0.6)
	$All_Skeleton/Heads/Cult_Heads.material.set_shader_parameter("hit_opacity", 0.6)
	$All_Skeleton/Heads/Hero_Heads.material.set_shader_parameter("hit_opacity", 0.6)
	$All_Skeleton/Heads/Peon_Heads.material.set_shader_parameter("hit_opacity", 0.6)
	$All_Skeleton/AllBody.material.set_shader_parameter("hit_opacity", 0.6)
##

func _flash_over():
	$All_Skeleton/AllBody.material.set_shader_parameter("hit_opacity", 0)
	$All_Skeleton/Heads/Cult_Heads.material.set_shader_parameter("hit_opacity", 0)
	$All_Skeleton/Heads/Hero_Heads.material.set_shader_parameter("hit_opacity", 0)
	$All_Skeleton/Heads/Peon_Heads.material.set_shader_parameter("hit_opacity", 0)
	$All_Skeleton/AllBody.material.set_shader_parameter("hit_opacity", 0)
##
