package;

// Import libraries
import Player;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	// Initialize variables
	var map:FlxOgmo3Loader;
	var roads:FlxTilemap;
	var buildings:FlxTilemap;
	var player:Player;
	var skovonNPCs:FlxTypedGroup<NPC>;
	var isTextOnScreen:Bool;
	var dialogueHUD:DialogueHUD;
	var talkText:FlxText;

	override public function create()
	{
		// Loads map
		map = new FlxOgmo3Loader(AssetPaths.HyperiaMaps__ogmo, AssetPaths.SkovonCity__json);
		roads = map.loadTilemap(AssetPaths.Tileset__png, "roads");
		buildings = map.loadTilemap(AssetPaths.Tileset__png, "buildings");
		roads.follow();

		// Initialization of player
		player = new Player();

		// Initialization of NPCs in Skovon City
		skovonNPCs = new FlxTypedGroup<NPC>();

		// Loading of entities
		map.loadEntities(placeEntities, "entities");

		// Add NPCs to their group
		addSkovonNPCs();

		// Initialization of DialogueHUD
		dialogueHUD = new DialogueHUD();

		// Initialization of "Press Z to talk" text
		talkText = new FlxText(0, 200, "Press Z to talk");
		talkText.scrollFactor.set(0, 0);
		talkText.visible = false;

		// Add objects to the game
		add(roads);
		add(buildings);
		add(player);
		add(skovonNPCs);
		add(dialogueHUD);
		add(talkText);

		// Make the camera follow player
		FlxG.camera.follow(player, TOPDOWN, 1);

		// Make talkText not visible by default
		isTextOnScreen = false;

		// Calling create function from parent class
		super.create();
	}

	// Function to add NPCs to Skovon City Group
	function addSkovonNPCs()
	{
		skovonNPCs.add(new NPC(480, 160, "assets/images/NPCCasual1.png", ["Technology is amazing!", "Now you can play entire games in browser!"]));
		skovonNPCs.add(new NPC(256, 336, "assets/images/NPCCasual1.png", ["I heard that professor Pinewood is coming to the city", "I'm so excited!"]));
		skovonNPCs.add(new NPC(96, 448, "assets/images/NPCCasual1.png", ["Soon we can travel across the regions on the train"]));
	}

	// Place entities to the map
	function placeEntities(entity:EntityData)
	{
		if (entity.name == "player")
		{
			player.setPosition(entity.x, entity.y);
		}
	}

	// Function that updates the state
	override public function update(elapsed:Float)
	{
		// Calling update function from the parent class
		super.update(elapsed);
		// Do this if isTextOnScreen == true
		if (isTextOnScreen)
		{
			// Do this if player pressed Z
			if (FlxG.keys.justPressed.Z)
			{
				// Go to the next value in dialogueArr
				dialogueHUD.goNext();
				// If dialogueHUD is not visible do this
				if (!dialogueHUD.isVisible)
				{
					isTextOnScreen = false;
					player.canWalk = true;
				}
			}
		}
		// Do this if it's not equal true
		else
		{
			// Collision with buildings
			FlxG.collide(player, buildings);
			// Camera folloew the player
			FlxG.camera.follow(player, TOPDOWN, 1);
			// COllision with NPCs
			FlxG.overlap(player, skovonNPCs, talkWithNPC);
			if (!FlxG.overlap(player, skovonNPCs))
				talkText.visible = false;
		}
	}

	// Function that initialises the dialogue
	function talkWithNPC(player:Player, npc:NPC)
	{
		talkText.visible = true;
		if (player.alive && player.exists && npc.alive && npc.exists && !isTextOnScreen && FlxG.keys.justPressed.Z)
		{
			dialogueHUD.setVisible(npc.getDialogue());
			isTextOnScreen = true;
			player.canWalk = false;
			talkText.visible = false;
		}
	}
}
