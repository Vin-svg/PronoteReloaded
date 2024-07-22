extends Resource
class_name Knight
 
var HP : int
var Strength : int
var Vitality : int
var Agility : int
var Defense : int
 
func _init():
	HP = 100
#	Strength = 7
	Vitality = 7
	Agility = 7
	Defense = 7
 
func set_base_stat(target):
	target.HP = HP

	target.Vitality = Vitality
	target.Agility = Agility
	target.Defense = Defense
 
func stat_growth(target):
	target.HP += 20
	#target.Strength = Strength
	target.Vitality += 2
	target.Agility += 1
	target.Defense += 5
