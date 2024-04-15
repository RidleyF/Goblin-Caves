extends ColorRect

signal correct()
signal incorrect()

var rw = ""
#right/wrong

var i = 0 #increment

const text = {
	"Gollum:\nLets us play a little riddle gameses, my precious!\nIf my precious wins, we eat you, if the Bagginses wins, my precious shall reveal the exit.\nOnly the wearer of my birthday present can leave.": [],
	"Bilbo:\nLets do it...": [],
	"Gollum:\nLets us start, my precious..\nWhat has roots as nobody sees,\nIs taller than trees Up, up, up it goes,\nAnd yet never grows?":["A Tree","A Mountain","Society","Influence"],
	"Gollum:\nCorrect, unfortunately...":[],
	"Bilbo:\nHmm... Okay,\nThirty white horses on a red hill,\nFirst they champ, Then they stamp, Then they stand still.":[],
	"Gollum:\nEasy! Teethses!":[],
	"Bilbo:\nCorrect!":[],
	"Gollum:\nIt cannot be seen, cannot be felt, Cannot be heard, cannot be smelt.\nIt lies behind stars and under hills, And empty holes it fills.\nIt comes first and follows after, Ends life, kills laughter.":["The Dark", "Air", "Mist", "Nothing"],
	"Gollum:\nTwo of two... My precious might only eat fishes...":[],
	"Bilbo:\nAlright,\nA box without hinges, key or lid,\nYet golden treasure inside is hid.":[],
	"Gollum:\nHmmm.. We need more time... Hmmmm.. An EGG! Yes.. That's it!":[],
	"Bilbo:\nYes, that's right..":[],
	"Gollum:\nWell theen.. Last one from my precious.\nThis thing all things devours: Birds, beasts, trees, flowers;\nGnaws iron, bites steel; Grinds hard stones to meal;\nSlays king, ruins town, And beats high mountain down.":["Rust", "Time", "Weather", "Snow"],
	"Gollum:\nNOOO! Only fishes for my precious! NOO!":[],
	"Bilbo:\nMy turn... Hmm... What have I got in my pocket? Hmm..":[],
	"Gollum:\nWhat does the hobbitses have in its pocketses?! My precious doesn't know!":[],
	"Gollum:\nWell a deal shall be a deal. Follow my precious.":[],
	"Gollum:\nNot quiteses. Now my precious feasts!":[],
	}

const answers = ["A Mountain", "The Dark", "Time"]

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	rw = ""
	i = 0
	$"../GameOver".hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	assignText()
	assignItems()
	var view = $"../../Player".get_viewport_rect().size
	size.x = view.x
	$"../GameOver".size.x = view.x
	$"../GameOver".size.y = view.y


func assignText():
	$Label.text = text.keys()[i]


func assignItems():
	var array = text.values()[i]
	if array == []:
		$ItemList.hide()
		$Space.show()
		if visible:
			if Input.is_action_just_pressed("ui_accept"):
				if i == 16:
					hide()
					$"../../Player".set_deferred("inCS", false)
					$"../../Gollum".leave()
				elif i == 17:
					hide()
					gameOver()
				else:
					i += 1
	else:
		if rw != "wrong":
			$ItemList.show()
			$Space.hide()
			$ItemList.clear()
			for r in range(array.size()):
				$ItemList.add_item(String.num(r + 1) + ") " + array[r])
		else:
			$ItemList.hide()
			$Space.show()


func start():
	show()


func attempt(index, _mousePos, _mouseType):
	var array = text.values()[i]
	var guess = array[index]
	if answers.has(guess):
		rw = "right"
		i += 1
	else:
		rw = "wrong"
		i = 17
		$ItemList.hide()


func gameOver():
	$"../../AudioStreamPlayer".stop()
	$"../GameOver".show()
	await get_tree().create_timer(2).timeout
	$"../../Player".reset()
	$"../../Player".title = true

