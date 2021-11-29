package;

// Import libraries
import flixel.FlxSprite;

class NPC extends FlxSprite
{
	// Array with the dialogue text
	var dialogue:Array<String>;

	// Initialize the NPC
	public function new(x:Float = 0, y:Float = 0, image:String, dialogue:Array<String>)
	{
		super(x, y);
		this.dialogue = dialogue;
		loadGraphic(image, true, 32, 32);
	}

	// Update the NPC
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	// Getter and setter for the dialogue array
	public function setDialogue(dialogue:Array<String>)
	{
		this.dialogue = dialogue;
	}

	public function getDialogue():Array<String>
	{
		return dialogue;
	}
}
