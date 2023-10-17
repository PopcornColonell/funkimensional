package states;

import backend.WeekData;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import states.editors.MasterEditorMenu;
import options.OptionsState;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.1h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;

	var tiky:FlxSprite;
	var joke:FlxSprite;
	var arrows:FlxSprite;

	var randomizer:Int = FlxG.random.int(1, 10);
	
	var optionShit:Array<String> = [
		'story_mode',
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);	

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, 0);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		tiky = new FlxSprite(0, 0);
		tiky.frames = Paths.getSparrowAtlas('mainmenu/tricky/tiky');
		tiky.animation.addByPrefix('idle', "tiky");
		tiky.scale.x = 0.53;
		tiky.scale.y = 0.53;
		tiky.screenCenter();
		tiky.x += 400;
		tiky.y += 105;
		tiky.scrollFactor.set(0, 0);

		joke = new FlxSprite(0, 0);
		joke.frames = Paths.getSparrowAtlas('mainmenu/tricky/joke');
		joke.animation.addByPrefix('idle', "Símbolo 2 instancia 1");
		joke.scale.x = 0.53;
		joke.scale.y = 0.53;
		joke.screenCenter();
		joke.x += 400;
		joke.y += 95;
		joke.scrollFactor.set(0, 0);

		if (randomizer == 10) {
			add(joke);
		}
		else {
			add(tiky);
		}

		var box:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/tricky/MENUTRIKpantalla'));
		box.setGraphicSize(Std.int(box.width * 0.75));
		box.scrollFactor.set(0, 0);
		box.screenCenter();
		box.x += 90;
		box.y -= 5;
		add(box);

		var clown:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/tricky/Clowntext'));
		clown.setGraphicSize(Std.int(clown.width * 0.75));
		clown.scrollFactor.set(0, 0);
		clown.screenCenter();
		clown.x += 60;
		clown.y += 0;
		add(clown);

		var credits:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/tricky/CreditsText'));
		credits.setGraphicSize(Std.int(credits.width * 0.75));
		credits.scrollFactor.set(0, 0);
		credits.screenCenter();
		credits.x += 60;
		credits.y += 5;
		add(credits);

		var options:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/tricky/OptionsText'));
		options.setGraphicSize(Std.int(options.width * 0.75));
		options.scrollFactor.set(0, 0);
		options.screenCenter();
		options.x += 60;
		options.y += 20;
		add(options);

		arrows = new FlxSprite(0, 0);
		arrows.frames = Paths.getSparrowAtlas('mainmenu/tricky/MENUTRIKflecha');
		arrows.animation.addByPrefix('1', "first");
		arrows.animation.addByPrefix('2', "second");
		arrows.animation.addByPrefix('3', "third");
		arrows.screenCenter();
		arrows.x += 150;
		arrows.y = 105;
		arrows.scrollFactor.set(0, 0);
		add(arrows);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItem.x -= 150;
			menuItems.add(menuItem);
			menuItem.alpha = 0;
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollow, null, 0);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.data.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										//MusicBeatState.switchState(new StoryMenuState());
										PlayState.storyPlaylist = ['hellish-chuckle'];
										PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
										PlayState.campaignScore = 0;
										PlayState.campaignMisses = 0;
										LoadingState.loadAndSwitchState(new PlayState(), true);
										FreeplayState.destroyFreeplayVocals();
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());									
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										LoadingState.loadAndSwitchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new OptionsState());
										OptionsState.onPlayState = false;
										if (PlayState.SONG != null)
										{
											PlayState.SONG.arrowSkin = null;
											PlayState.SONG.splashSkin = null;
										}
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (controls.justPressed('debug_1'))
			{
				//selectedSomethin = true;
				//MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		tiky.animation.play('idle');
		joke.animation.play('idle');

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		if (curSelected == 0) {
			arrows.animation.play('1');
			arrows.y = 105;
		}
		else if (curSelected == 1) {
			arrows.animation.play('2');
			arrows.y = 125;
		}
		else if (curSelected == 2) {
			arrows.animation.play('3');
			arrows.y = 155;
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
