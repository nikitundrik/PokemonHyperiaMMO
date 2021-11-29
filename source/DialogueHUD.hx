package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DialogueHUD extends FlxTypedGroup<FlxSprite>
{
	// Variables
	var background:FlxSprite;
	var dialogueText:FlxText;
	var dialogueArr:Array<String>;
	var dialogueWhere:Int;

	// Variable that is true when the dialogue is visible
	public var isVisible:Bool;

	// Initialize the dialogue
	public function new()
	{
		super();
		background = new FlxSprite().makeGraphic(FlxG.width, 200, FlxColor.WHITE);
		background.visible = false;
		dialogueText = new FlxText(0, 0, 0, "Dialogue", 8);
		dialogueText.setColorTransform(0, 0, 0);
		dialogueText.visible = false;
		dialogueWhere = 0;
		add(background);
		add(dialogueText);
		isVisible = false;
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	// Sets the dialogue visible
	public function setVisible(text:Array<String>)
	{
		dialogueArr = text;
		dialogueText.text = dialogueArr[dialogueWhere];
		background.visible = true;
		dialogueText.visible = true;
		isVisible = true;
	}

	// Sets the dialogue invisible
	public function setInvisible()
	{
		background.visible = false;
		dialogueText.visible = false;
		isVisible = false;
		dialogueWhere = 0;
	}

	// Goes to the next value in the dialogueArr
	public function goNext()
	{
		dialogueWhere++;
		if (dialogueWhere >= dialogueArr.length)
			setInvisible();
		else
			dialogueText.text = dialogueArr[dialogueWhere];
	}
}
