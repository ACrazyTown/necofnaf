package;

import sys.FileSystem;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import openfl.filters.ShaderFilter;
import shader.PanoramaDistortionShader;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	public static var night:Int = 0;

	var officeBackground:FlxSprite;
	var centerObject:FlxSprite;

	var scrollCamera:FlxCamera; // for the background

	// dumbass 
	var leftScrollToggle:FlxSprite;
	var rightScrollToggle:FlxSprite;

	var canToggle:Bool = true;
	var camToggling:Bool = false;

	var camToggle:FlxSprite;

	override public function create()
	{
		FlxG.mouse.visible = true;

		FlxG.cameras.reset();

		scrollCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		scrollCamera.setFilters([new ShaderFilter(new PanoramaDistortionShader())]);
		FlxG.cameras.add(scrollCamera, false);

		FlxG.cameras.setDefaultDrawTarget(FlxG.camera, true);

		officeBackground = new FlxSprite().loadGraphic("assets/images/office.png");
		officeBackground.screenCenter();
		officeBackground.cameras = [scrollCamera];
		add(officeBackground);

		leftScrollToggle = new FlxSprite().makeGraphic(400, FlxG.height);
		leftScrollToggle.visible = false;
		add(leftScrollToggle);

		rightScrollToggle = new FlxSprite(880).makeGraphic(400, FlxG.height);
		rightScrollToggle.visible = false;
		add(rightScrollToggle);

		camToggle = new FlxSprite().loadGraphic("assets/images/cameratoggle.png");
		camToggle.screenCenter(X);
		camToggle.y = (FlxG.height - camToggle.height) - 25;
		add(camToggle);

		new FlxTimer().start(1.25, function(tmr:FlxTimer)
		{
			switch (night)
			{
				//case 1:
				//	FlxG.sound.play("assets/sounds/night1" + MenuState.audioFormat);
			}
		});

		super.create();
	}

	override public function update(elapsed:Float)
	{
		cameraScroll();

		super.update(elapsed);

		if (FlxG.mouse.overlaps(camToggle) || FlxG.keys.justPressed.S)
		{
			if (!camToggling && canToggle)
			{
				canToggle = false;
				super.openSubState(new CameraSubstate());
			}
		}
		else
		{
			canToggle = true;
		}

		if (canToggle == false)
		{
			camToggle.visible = false;
		}
		else {
			camToggle.visible = true;
		}
	}

	function cameraScroll()
	{
		trace(officeBackground.x, officeBackground.y);

		if (FlxG.mouse.overlaps(leftScrollToggle))
		{
			if (officeBackground.x <= 0)
				officeBackground.x += 14;

			if (officeBackground.x > 0)
				officeBackground.x = 0;
		}
		
		if (FlxG.mouse.overlaps(rightScrollToggle))
		{
			if (officeBackground.x >= -1120)
				officeBackground.x -= 14;

			if (officeBackground.x < -1120)
				officeBackground.x = -1120;
		}
	}
}
