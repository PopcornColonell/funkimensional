package states.stages;

import states.stages.objects.*;
import objects.Character;
import hxcodec.flixel.FlxVideo as VideoHandler;

class Nevada extends BaseStage
{
	var sky:BGSprite;
	var floor:BGSprite;
	var leftmountain:BGSprite;
	var leftmountain2:BGSprite;
	var rightmountain:BGSprite;
	var rightmountain2:BGSprite;

	var suprise:BGSprite;
	var whiteScreen:FlxSprite;
	var blackScreen:FlxSprite;
	var redScreen:FlxSprite;

	var laugh:BGSprite;
	var trickyattack:BGSprite;

	var vagonfront:BGSprite;
	var vagonmiddle:BGSprite;
	var vagonback:BGSprite;   

	var hellbg:BGSprite;
	var jumpscare:BGSprite;
	var impact:BGSprite;

	var floatshit:Float = 0;
	var hell:Bool = false;

	override function create()
	{
		sky = new BGSprite('tricky/SKY', -600, -90, 0.9, 0.9);
		add(sky);
		floor = new BGSprite('tricky/floor', -800, 1200, 1, 1);
		add(floor);
		
		rightmountain = new BGSprite('tricky/right_mountain', 1550, -250, 0.9, 0.9, ['right mountain anim']);
		add(rightmountain);	
		rightmountain2 = new BGSprite('tricky/right_mountain2', 2700, 100, 0.9, 0.9, ['right mountain anim']);
		rightmountain2.setGraphicSize(Std.int(rightmountain2.width * 1.2));
		add(rightmountain2);	

		leftmountain = new BGSprite('tricky/left_mountain', -4485, -375, 1, 1, ['left mountain anim']);
		add(leftmountain);
		leftmountain2 = new BGSprite('tricky/left_mountain2', -5307, 510, 1, 1, ['left mountain anim']);
		leftmountain2.setGraphicSize(Std.int(leftmountain2.width * 1.3));
		add(leftmountain2);	

		suprise = new BGSprite('tricky/suprise', 850, -200, 0.9, 0.9, ['Símbolo 43']);
		suprise.visible = false;
		add(suprise);			

		whiteScreen = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.WHITE);
		add(whiteScreen);
		whiteScreen.alpha = 0;

		vagonfront = new BGSprite('tricky/vagon3', 1025, 842, 1, 1);
		add(vagonfront);
		vagonmiddle = new BGSprite('tricky/vagon2', 1100, 1190, 1, 1);
		add(vagonmiddle);
		vagonback = new BGSprite('tricky/vagon1', 1250, 1400, 1, 1);
		add(vagonback);

		laugh = new BGSprite('tricky/tricky_extra', 1180, 580, 1, 1, ['lmao']);
		laugh.visible = false;
		add(laugh);

		hellbg = new BGSprite('tricky/bghellclown', -800, 1200, 1, 1);
		add(hellbg);
		hellbg.visible = false;
	}

	override function countdownTick(count:Countdown, num:Int) everyoneDance();
	override function beatHit() everyoneDance();

	function everyoneDance()
		{
			leftmountain.dance(true);
			leftmountain2.dance(true);
			rightmountain.dance(true);
			rightmountain2.dance(true);
		}
	
	override function createPost()
	{
		dad.visible = false;
		blackScreen = new FlxSprite().makeGraphic(FlxG.width * 5, FlxG.height * 7, FlxColor.BLACK);
		blackScreen.x -= 1000;
		add(blackScreen);	
		blackScreen.alpha = 1;
		camHUD.alpha = 0;	

		trickyattack = new BGSprite('tricky/tricky_extra', 620, -550, 1, 1, ['attack']);
		trickyattack.visible = false;
		add(trickyattack);

		redScreen = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.RED);
		add(redScreen);
		redScreen.alpha = 0;

		jumpscare = new BGSprite('tricky/TRICKYJUMPSCARERISA', -1100, -700, 1, 1, ['Símbolo 1 instancia 1']);
		add(jumpscare);
		jumpscare.scale.x = 0.75;
		jumpscare.scale.y = 0.75;
		jumpscare.cameras = [camHUD];
		jumpscare.visible = false;

		impact = new BGSprite('tricky/impact', -800, 1150, 1, 1);
		add(impact);
		impact.visible = false;
	}

	override function update(elapsed:Float)
	{
		if (!hell) {
			floatshit += 0.2;
			vagonback.y += Math.sin(floatshit);
			boyfriend.y += Math.sin(floatshit);
			vagonmiddle.y += Math.sin(floatshit + 1);
			dad.y += Math.sin(floatshit + 1);
			laugh.y += Math.sin(floatshit + 1);
			trickyattack.y += Math.sin(floatshit + 1);
			vagonfront.y += Math.sin(floatshit + 2);
		}
	}

	
	/*override function countdownTick(count:BaseStage.Countdown, num:Int)
	{
		switch(count)
		{
			case THREE: //num 0
			case TWO: //num 1
			case ONE: //num 2
			case GO: //num 3
			case START: //num 4
		}
	}*/

	// Steps, Beats and Sections:
	//    curStep, curDecStep
	//    curBeat, curDecBeat
	//    curSection
	override function stepHit()
	{
		//
	}
	override function sectionHit()
	{
		// Code here
	}

	// Substates for pausing/resuming tweens and timers
	override function closeSubState()
	{
		if(paused)
		{
			//timer.active = true;
			//tween.active = true;
		}
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		if(paused)
		{
			//timer.active = false;
			//tween.active = false;
		}
	}

	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "Intro":
				FlxTween.tween(blackScreen, {alpha: 0}, 24, {
					ease: FlxEase.quadIn,
					onComplete:
					function(twn:FlxTween) {
						blackScreen.alpha = 0;
					}
				});
				FlxTween.tween(camHUD, {alpha: 1}, 16, {ease: FlxEase.quadIn});
			case "Suprise":
				suprise.visible = true;
				suprise.dance(true);
				new FlxTimer().start(0.9, function(tmr:FlxTimer)
					{				
						suprise.kill();	
						dad.visible = true;
					});
			case "Laugh":
				dad.visible = false;
				laugh.visible = true;
				laugh.dance(true);
				new FlxTimer().start(0.335, function(tmr:FlxTimer)
					{		
						laugh.dance(true);
						new FlxTimer().start(0.385, function(tmr:FlxTimer)
							{				
								laugh.kill();	
								dad.visible = true;
							});								
					});
			case "Mono":
				FlxTween.tween(whiteScreen, {alpha: 1}, 0.6, {ease: FlxEase.linear});
				FlxTween.color(vagonfront, 0.6, 0xFFFFFFFF, 0xFF000000);
				FlxTween.color(vagonmiddle, 0.6, 0xFFFFFFFF, 0xFF000000);
				FlxTween.color(vagonback, 0.6, 0xFFFFFFFF, 0xFF000000);
				FlxTween.color(dad, 0.6, 0xFFFFFFFF, 0xFF000000);
				FlxTween.color(boyfriend, 0.6, 0xFFFFFFFF, 0xFF000000);
			case "MonoEnd":
				FlxTween.tween(whiteScreen, {alpha: 0}, 0.6, {
					ease: FlxEase.linear,
					onComplete:
					function(twn:FlxTween) {
						whiteScreen.kill();
					}
				});
				FlxTween.color(vagonfront, 0.6, 0xFF000000, 0xFFFFFFFF);
				FlxTween.color(vagonmiddle, 0.6, 0xFF000000, 0xFFFFFFFF);
				FlxTween.color(vagonback, 0.6, 0xFF000000, 0xFFFFFFFF);
				FlxTween.color(dad, 0.6, 0xFF000000, 0xFFFFFFFF);
				FlxTween.color(boyfriend, 0.6, 0xFF000000, 0xFFFFFFFF);
			case "TrickyAttack":
				dad.visible = false;
				trickyattack.visible = true;
				trickyattack.dance(true);	
				boyfriend.skipDance = true;
				new FlxTimer().start(0.24, function(tmr:FlxTimer)
					{		
						boyfriend.playAnim('dodge', true);
						new FlxTimer().start(1.42, function(tmr:FlxTimer)
							{		
								boyfriend.playAnim('attack', true);			
								new FlxTimer().start(2.38, function(tmr:FlxTimer)
									{			
										trickyattack.kill();
										dad.visible = true;	
										boyfriend.skipDance = false;		
									});				
							});														
					});
			case "video":
				FlxTween.tween(blackScreen, {alpha: 1}, 0.5, {ease: FlxEase.linear});
			case "redstart":
				FlxTween.tween(redScreen, {alpha: 0.23}, 0.5, {ease: FlxEase.linear});
			case "redend":
				FlxTween.tween(redScreen, {alpha: 0}, 0.5, {
					ease: FlxEase.linear,
					onComplete:
					function(twn:FlxTween) {
						redScreen.kill();
					}
				});
			case "hell":
				sky.kill();
				floor.kill();
				rightmountain.kill();
				rightmountain2.kill();
				leftmountain.kill();
				leftmountain2.kill();
				vagonfront.kill();
				vagonmiddle.kill();
				vagonback.kill();

				hellbg.visible = true;
				hell = true;					
			case "hell2":
				dad.x -= 350;
				dad.y += 900;
				dad.scale.x = 1.8;
				dad.scale.y = 1.8;
				boyfriend.x -= 835;
				boyfriend.y += 925;			
				camHUD.alpha = 0;	
				FlxTween.tween(camHUD, {alpha: 0}, 0.5, {ease: FlxEase.linear});		
			case "hell3":
				blackScreen.alpha = 0;					
				boyfriend.skipDance = true;
				dad.skipDance = true;
				boyfriend.playAnim('reload', true);
				new FlxTimer().start(2.35, function(tmr:FlxTimer)
					{			
						dad.playAnim('meow', true);							
						new FlxTimer().start(1.5, function(tmr:FlxTimer)
							{		
								FlxTween.tween(camHUD, {alpha: 1}, 0.5, {ease: FlxEase.linear});	
								boyfriend.skipDance = false;
								dad.skipDance = false;
							});			
					});	
			case "jumpscare":
				FlxTween.tween(blackScreen, {alpha: 1}, 0.1, {ease: FlxEase.quadIn});
				jumpscare.dance(true);
				jumpscare.visible = true;
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
					{		
						FlxTween.tween(blackScreen, {alpha: 0}, 0.1, {ease: FlxEase.quadOut});
						jumpscare.kill();
					});		
			case "kill":
				dad.skipDance = true;
				dad.playAnim('BADASSLASER',true);
				new FlxTimer().start(0.15, function(tmr:FlxTimer)
					{		
						impact.visible = true;
						boyfriend.alpha = 0;
						new FlxTimer().start(0.15, function(tmr:FlxTimer)
							{		
								impact.visible = false;
								new FlxTimer().start(0.2, function(tmr:FlxTimer)
									{		
										FlxTween.tween(blackScreen, {alpha: 1}, 1, {ease: FlxEase.quadOut});
									});	
							});		
					});		
		}
	}
	override function eventPushed(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events that doesn't need different assets based on its values
		switch(event.event)
		{
			case "Suprise":
				precacheImage('tricky/suprise'); //preloads images/myImage.png
			case "Laugh" | "TrickyAttack":
				precacheImage('tricky/tricky_extra');
				//precacheSound('mySound') //preloads sounds/mySound.ogg
				//precacheMusic('myMusic') //preloads music/myMusic.ogg
		}
	}
	override function eventPushedUnique(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events where its values affect what assets should be preloaded
		switch(event.event)
		{
			case "My Event":
				switch(event.value1)
				{
					// If value 1 is "blah blah", it will preload these assets:
					case 'blah blah':
						//precacheImage('myImageOne') //preloads images/myImageOne.png
						//precacheSound('mySoundOne') //preloads sounds/mySoundOne.ogg
						//precacheMusic('myMusicOne') //preloads music/myMusicOne.ogg

					// If value 1 is "coolswag", it will preload these assets:
					case 'coolswag':
						//precacheImage('myImageTwo') //preloads images/myImageTwo.png
						//precacheSound('mySoundTwo') //preloads sounds/mySoundTwo.ogg
						//precacheMusic('myMusicTwo') //preloads music/myMusicTwo.ogg
					
					// If value 1 is not "blah blah" or "coolswag", it will preload these assets:
					default:
						//precacheImage('myImageThree') //preloads images/myImageThree.png
						//precacheSound('mySoundThree') //preloads sounds/mySoundThree.ogg
						//precacheMusic('myMusicThree') //preloads music/myMusicThree.ogg
				}
		}
	}
}