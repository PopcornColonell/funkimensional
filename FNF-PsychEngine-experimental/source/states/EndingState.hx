package states;

import hxcodec.flixel.FlxVideo as VideoHandler;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

class EndingState extends MusicBeatState
{
    var defaultVol:Float = FlxG.sound.volume;
    
    override function create()
        {           
            FlxG.sound.volume = 0.7;
            new FlxTimer().start(1, function(tmr:FlxTimer)
                {		
                    playVid();
                });		

            super.create();
	    }

    function playVid() {
        var endvideo:VideoHandler = new VideoHandler();
        var filepath:String = Paths.video('lv_0_20231009230120');

        endvideo.play(filepath);
        endvideo.onEndReached.add(function()
            {
                FlxG.sound.volume = defaultVol;
                MusicBeatState.switchState(new MainMenuState());
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
            }, true);
    }
    
    override function update(elapsed:Float)
	{
        if (controls.ACCEPT) {
                FlxG.sound.volume = defaultVol;
                MusicBeatState.switchState(new MainMenuState());
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
            }

        super.update(elapsed);
    }
}