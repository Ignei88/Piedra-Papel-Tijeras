extends Node
"""
Piedra papel o tijeras 
Creador por Igel
"""
var vidas_Player: int = 3
var vidas_Enemy: int = 3
var offset_vidasE: int = 50#La separacion entre cada vida
var offset_vidasP: int = 50
var lista_vidasE = []
var lista_vidasP = []
var jugadas = [{1:"piedra", 2:"papel",3:"Tijeras"}]
@export var spr_player: PackedScene
@export var spr_enemy: PackedScene
var piedra: bool
var papel: bool
var tijeras: bool
var des: int

func _ready():
	crear_vidasP()
	crear_vidasE()
	play()


#Instancia las vidas y las actualiza
func crear_vidasP():
	for i in vidas_Player:
		var newVidaP = spr_player.instantiate()
		get_tree().get_nodes_in_group("GUI")[0].add_child(newVidaP)
		newVidaP.global_position.x += offset_vidasP * i
		lista_vidasP.append(newVidaP)

func crear_vidasE():
	for i in vidas_Enemy:
		var newVidaE = spr_enemy.instantiate()
		get_tree().get_nodes_in_group("GUI")[0].add_child(newVidaE)
		newVidaE.global_position.x += offset_vidasE * i
		lista_vidasE.append(newVidaE)

func quitar_vidas_player():
	vidas_Player -= 1
	lista_vidasP[vidas_Player].queue_free()

func quitar_vidas_enemy():
	vidas_Enemy -= 1
	lista_vidasE[vidas_Enemy].queue_free()

func play():
	var random = num_rand(49733,2749,randi() % 51 + 10,4)
	print(random)
	for i in range(3):#Tiempo
		await get_tree().create_timer(1).timeout
		$Label.text = str(i+1)
	if random <= 1 and random > 0.6666:
		$Player2.set_frame_and_progress(0,1.0)#Papel
		print("primer intervalo")
		print(piedra)
		if piedra == true:
			print("Empate")
			piedra = false
		elif papel == true:
			quitar_vidas_enemy()
			print("Ganaste")
			papel = false
		elif tijeras == true:
			quitar_vidas_player()
			print("Perdiste")
			tijeras = false
		else :
			quitar_vidas_player()
			print("No escogiste nada")
	elif random <= 0.6666 and random > 0.3333:
		$Player2.set_frame_and_progress(1,1.0)# Papel
		print("Segundo intervalo")
		print(papel)
		if piedra == true:
			quitar_vidas_player()
			print("Perdiste")
			piedra = false
		elif papel == true:
			print("Empate")
			papel = false
		elif tijeras == true:
			print("Perdiste")
			quitar_vidas_enemy()
			tijeras = false
		else :
			quitar_vidas_player()
			print("No escogiste nada")
	elif random <= 0.3333:
		$Player2.set_frame_and_progress(2,1.0)#Tijeras
		print("Tercer intervalo")
		print(tijeras)
		if piedra == true:
			quitar_vidas_enemy()
			print("Ganase")
			piedra = false
		elif papel == true:
			quitar_vidas_player()
			papel = false
		elif tijeras == true:
			print("Empate")
			tijeras = false
		else :
			quitar_vidas_player()
			print("No escogiste nada")
	await get_tree().create_timer(1).timeout
	$Player.set_frame_and_progress(3,1.0)
	$Player2.set_frame_and_progress(3,1.0)
	$Label.text = ""
	if vidas_Enemy != 0 and vidas_Player != 0:
		play()
	elif vidas_Player == 0:
		$Label.text = "Perdiste"
		await  get_tree().create_timer(5).timeout
		queue_free()
	elif vidas_Enemy == 0:
		$Label.text = "Ganaste"
		await  get_tree().create_timer(5).timeout
		queue_free()

func num_rand(x0: int,x1: int,n: int,k: int):#Generador de numeros aleatorios
#	var num: Array = []
	var num2: int
	var res: float
	for i in range(n):
		res = x0+x1*2*x0/x1
		if k == 3:
			x1 = x0
			x0 = num_mid(res,3)
			res = float(x0/1000.0)
		elif  k == 4:
			x1 = x0
			x0 = num_mid(res,4)
			res = float(x0/10000.0)
		elif  k == 5:
			x1 = x0
			x0 = num_mid(res,5)
			res = float(x0/100000.0)
		num2 = res
#		num.append(res)
#	print(num)
#	num.clear()
	return res

func num_mid(numero: int,len_number: int):#Funcion para obtener los numeros del medio
	var x_int: int = numero
	var x_str: String = str(x_int)
	var length: int = len(x_str)
	var middle_str: String = x_str.substr(length/2-2, len_number)
	var middle_int: int = middle_str.to_int()
	return middle_int

#Eleciones para cambiar el frame del jugador
func _on_piedra_pressed():
	print("Piedra")
	$Player.set_frame_and_progress(0,1.0)
	piedra = true
func _on_papel_pressed():
	print("papel")
	$Player.set_frame_and_progress(1,1.0)
	papel = true
func _on_tijera_pressed():
	print("Tijera")
	$Player.set_frame_and_progress(2,1.0)
	tijeras = true
