package;

// Import libraries
import Player;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import networking.Network;
import networking.sessions.Session;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;

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
	var otherPlayers:FlxTypedGroup<FlxSprite>;
	var playerID:Int;
	var client:Session;

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

		// Creates the client
		client = Network.registerSession(NetworkMode.CLIENT, {ip: '127.0.0.1', port: 8888, flash_policy_file_url: "http://127.0.0.1:9999/crossdomain.xml"});
		// Event that starts when server sends a message
		client.addEventListener(NetworkEvent.CONNECTED, function(event:NetworkEvent)
		{
			trace("Welcome to Hyperia!");
			client.send({case1: "player_joined"});
		});
		client.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(event:NetworkEvent)
		{
			trace("Client received a message");
			// If case is new player, add a player
			if (event.data.case1 == "new_player")
			{
				trace("Message: new player");
				var playersArr:Array<FlxSprite> = event.data.players1;
				for (i in playersArr)
				{
					i.loadGraphic(AssetPaths.PlayerCharacter__png, true, 32, 32);
					otherPlayers.add(i);
				}
				playerID = event.data.playerID;
				trace("Player ID: " + playerID);
			}
		});
		client.start();

		// Add objects to the game
		add(roads);
		add(buildings);
		add(player);
		add(skovonNPCs);
		add(dialogueHUD);
		add(talkText);
		add(otherPlayers);

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
			client.send({id: playerID, x: player.x, y: player.y});
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
