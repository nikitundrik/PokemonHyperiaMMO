package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	// Variable that is true when the player can walk
	public var canWalk:Bool;

	// Initialize the player
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.PlayerCharacter__png, true, 32, 32);
		animation.add("walk_down", [1, 0, 2, 0], 5, true);
		animation.add("walk_up", [7, 6, 8, 6], 5, true);
		animation.add("walk_left", [4, 3, 5, 3], 5, true);
		animation.add("walk_right", [10, 9, 11, 9], 5, true);
		animation.add("idle_down", [0], 5, true);
		animation.add("idle_up", [6], 5, true);
		animation.add("idle_left", [3], 5, true);
		animation.add("idle_right", [9], 5, true);
		canWalk = true;
	}

	// Player's update function
	override public function update(elapsed:Float):Void
	{
		// Checks if player can walk, if he can, then he can walk
		if (canWalk)
		{
			super.update(elapsed);
			if (FlxG.keys.pressed.LEFT)
			{
				animation.play("walk_left");
				velocity.x = -100;
				velocity.y = 0;
			}
			else if (FlxG.keys.pressed.RIGHT)
			{
				animation.play("walk_right");
				velocity.x = 100;
				velocity.y = 0;
			}
			else if (FlxG.keys.pressed.UP)
			{
				animation.play("walk_up");
				velocity.y = -100;
				velocity.x = 0;
			}
			else if (FlxG.keys.pressed.DOWN)
			{
				animation.play("walk_down");
				velocity.y = 100;
				velocity.x = 0;
			}
			else
			{
				animation.stop();
				velocity.x = 0;
				velocity.y = 0;
			}
		}
	}
}
