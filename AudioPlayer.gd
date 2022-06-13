extends AudioStreamPlayer2D

var coinsfx = preload("res://Audio/coin.tres")

func play_coin_sfx():
	stream = coinsfx
	play()
