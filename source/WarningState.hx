package;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxState;

class WarningState extends FlxState
{
	var warning:FlxSprite;
    var transitionTimer:FlxTimer;

    override function create()
    {
        warning = new FlxSprite().loadGraphic("assets/images/warning.png");
        warning.screenCenter();
        add(warning);

		transitionTimer = new FlxTimer().start(5, function(tmr:FlxTimer)
		{
			transitionToMenu();
		});

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.justPressed) 
        {
            transitionTimer.cancel();
            transitionToMenu();
        }
    }

    function transitionToMenu()
    {
		FlxTween.tween(warning, {alpha: 0}, 1.25, {
			onComplete: function(t:FlxTween)
			{
				FlxG.switchState(new MenuState());
			}
		});
    }
}