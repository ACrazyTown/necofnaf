package;

import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class CameraSubstate extends FlxSubState
{
	var canCamToggle:Bool = false;
	var camToggle:FlxSprite;

	var camTransitionActive:Bool = false;
	var camAnim:FlxSprite;

	var camHUD:FlxGroup;

    public function new()
    {
		super();

		camAnim = new FlxSprite(0, 0);
		camAnim.loadGraphic("assets/images/camera_flip.png", true, 1280, 720);
		camAnim.animation.add("flip", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 30, false);
		camAnim.animation.add("flipReverse", [9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 30, false);
		camAnim.animation.finishCallback = function(name:String)
		{
			if (name == "flip")
			{
				initCamSystem();
			}
			else
			{
				close();
			}
		};
		add(camAnim);

		camToggle = new FlxSprite().loadGraphic("assets/images/cameratoggle.png");
		camToggle.screenCenter(X);
		camToggle.y = (FlxG.height - camToggle.height) - 25;
		camToggle.visible = false;
		add(camToggle);

		canCamToggle = false;
		camTransitionActive = true;

		camHUD = new FlxGroup();
		add(camHUD);

		FlxG.sound.play("assets/sounds/camflip" + MenuState.audioFormat);
		camAnim.animation.play("flip");
    }

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(camToggle) || FlxG.keys.justPressed.S)
		{
			if (!camTransitionActive && canCamToggle)
			{
				canCamToggle = false;
				camTransitionActive = true;

				camHUD.visible = false; // replace with the ENTIRE cam hud
				FlxG.sound.play("assets/sounds/camflip" + MenuState.audioFormat);
				camAnim.animation.play("flipReverse");
			}
		}

		if (canCamToggle) 
			camToggle.visible = true;
		else 
			camToggle.visible = false;
	}

	function initCamSystem()
	{
		//canUseCams = true;
		camTransitionActive = false;
		canCamToggle = true;

		var cameraStatic:Static = new Static();
		cameraStatic.animation.play("static");
		cameraStatic.alpha = 0.25;
		camHUD.add(cameraStatic);
	}
}