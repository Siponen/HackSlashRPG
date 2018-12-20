extends Control

var dialogueFile = {}

var characters = {
	player: Character("PlayerName", null),
	alchemist: Character("The Traveller", null)
}

var statements = [
	Statement("player","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
	Statement("alchemist", "")
]

func _init(entities,dialogueFile):
	self.dialogueFile = dialogueFile
	
	#Populate Characters
	#Populate tatements
	
	pass

func _ready():
	pass

class Character:
	var pawnId
	var charName
	var animPlayer
	
	func _init(characterName, characterAnimPlayer):
		charName = characterName
		animPlayer = characterAnimPlayer
		pass

class Statement:
	var character
	var text
	
	func _init(character,text):
		self.character = character
		self.text = text
		pass