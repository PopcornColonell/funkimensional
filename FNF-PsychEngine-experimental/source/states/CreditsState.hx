package states;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

import objects.AttachedSprite;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:FlxColor;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled) pushModCreditsToList(mod);
		#end

		var defaultList:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['            POSTROFF

			      (Director, Main Artist, 
			     Voice Actor, Animator)

			     "I must protect the weed... 
			for I am Postroff the Weedmaster..."',		'psodpso',		'https://twitter.com/Postroff1',								'',	'996699'],
			[''],
			[''],
			[''],
			['          ADRIX

			    (Artist, Animator) 

			"Im hungry but its okay"',		'adriadireaidewif',		'',								'https://twitter.com/Only_AdriX',	'66CCFF'],
			[''],
			[''],
			[''],
			['     PopcornColonel

			         (Coder)

			"Popcorn to the rescue"',		'popcorn',		'',								'https://twitter.com/PopcornColoneI',	'330066'],
			[''],
			[''],
			[''],
			['         Kamvoy

			      (Pixel Artist)

			"the pixelart of the menu was an excuse to be here"',		'kamkamakak',		'',								'https://twitter.com/KamvoyUwU',	'6666FF'],
			[''],
			[''],
			[''],
			['     Choco_Linaa

			       (Musician)

			"Hello, Ive had fun making a menu song in like 1 hour."',		'lina',		'',								'https://twitter.com/choco_linaa',	'330033'],
			[''],
			[''],
			[''],
			['          HeV

			(Secondary Animator, BG Artist, Musician)

			"monochromatism is my pasion... and also the music ig"',		'hehwehehwh',		'',								'https://twitter.com/Art4Henry',	'7E746A'],
			[''],
			[''],
			[''],
			['       Cris

			 (Main Charter)

			"i like duchshund"',		'crisnew',		'',								'',	'FF0033'],
			[''],
			[''],
			[''],
			['       Coquers_

				       (Musician)

			"tricky funkimensional fnf"',		'coqocqocqoqo',		'',								'https://twitter.com/Coquers1',	'000000'],
			[''],
			[''],
			[''],
			['         NATU

				        (Artist)

			"mordecai and rigby if you dont finish these sprites for madness day, YOURE FIRED"',		'natula',		'',								'',	'656565'],
			[''],
			[''],
			['']
		];
		
		for(i in defaultList) {
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(FlxG.width / 2 - 50, 150, creditsStuff[i][0], false);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			optionText.scaleX = 0.5;
			optionText.scaleY = 0.5;
			grpOptions.add(optionText);

			if (i == 0) {
				var overlay:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuCreditBG'));
				overlay.screenCenter();
				add(overlay);
			}

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Mods.currentModDirectory = creditsStuff[i][5];
				}

				var str:String = 'credits/missing_icon';
				var fileName = 'credits/' + creditsStuff[i][1];
				if (Paths.fileExists('images/$fileName.png', IMAGE)) str = fileName;
				else if (Paths.fileExists('images/$fileName-pixel.png', IMAGE)) str = fileName + '-pixel';

				var icon:AttachedSprite = new AttachedSprite(str);
				if(str.endsWith('-pixel')) icon.antialiasing = false;
				icon.screenCenter(X);
				if (fileName == 'credits/psodpso') {
					icon.xAdd = 550;
				}
				else if (fileName == 'credits/kamkamakak') {
					icon.xAdd = 490;
				}
				else if (fileName == 'credits/hehwehehwh') {
					icon.xAdd = 515;
				}
				else if (fileName == 'credits/crisnew') {
					icon.xAdd = 410;
				}
				else if (fileName == 'credits/coqocqocqoqo') {
					icon.xAdd = 480;
				}
				else if (fileName == 'credits/lina') {
					icon.xAdd = 475;
				}
				else if (fileName == 'credits/natula') {
					icon.xAdd = 495;
				}
				else {
					icon.xAdd = 450;
				}
				icon.yAdd = -120;
				icon.sprTracker = optionText;

				icon.scale.x = 0.7;
				icon.scale.y = 0.7;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Mods.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			//else optionText.alignment = CENTERED;
		}		

		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.WHITE);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		//add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		//add(descText);

		bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			item.screenCenter(X);
			item.x -= 100;
			/*if(!item.bold)
			{
				var lerpVal:Float = FlxMath.bound(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
				}
			}*/
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		trace('The BG color is: $newColor');
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				//item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}