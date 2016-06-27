import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import openfl.system.System;
import welten.menu.Menu;
import openfl.ui.Mouse;
import welten.Mutterwelt;
import openfl.Assets;
import flash.display.Stage;

class Main extends Engine
{

	override public function init()	{

		super.init();

		//HXP.console.enable();
		HXP.console.visible = false;
		//HXP.console.toggleKey = Key.BACKSPACE;
		HXP.scene = new Menu();

		Mouse.hide();

		HXP.fullscreen = false;


	}

	public static function main() {

		new Main();
	}

	override public function update() {

		super.update();

		//FULLSCREEN
		if (Input.pressed(Key.F1)) {

			HXP.fullscreen = !HXP.fullscreen;
		}

		//GLOBAL MUTE
		if (Input.pressed(Key.F4)) {

			// HXP.volume = 0;
			/* not working */
		}

		// keep the screen ratio while windowed & fullscreen
		raatio();
	}

	public function raatio():Void {

		if (HXP.fullscreen) {

			if (HXP.screen.scaleX < HXP.screen.scaleY) {
				HXP.screen.scaleY = HXP.screen.scaleX;
			} else if (HXP.screen.scaleY < HXP.screen.scaleX) {
				HXP.screen.scaleX = HXP.screen.scaleY;
			}

			HXP.screen.x = Std.int( (HXP.stage.stageWidth - (640 * HXP.screen.scaleX)) / 2 );
			HXP.screen.y = Std.int( (HXP.stage.stageHeight - (400 * HXP.screen.scaleY)) / 2 );

			fullscreendelay = true;
		}
		else {

			var weite:Int = originalWeite;
			var hoehe:Int = originalHoehe;
			var whratio:Float;

			var wunschweite:Int;
			var wunschhoehe:Int;

			// kurzer delay to reset to original form
			if (fullscreendelay) {

				if (fullscrenndelayzahl < 0.3) {

					fullscrenndelayzahl += HXP.elapsed;

					// reset the fullscreen variables
					HXP.screen.scaleX = originalScale;
					HXP.screen.scaleY = originalScale;
					HXP.screen.x = 0;
					HXP.screen.y = 0;

				}
				else {

					fullscrenndelayzahl = 0;
					fullscreendelay = false;
				}
			}
			else {

				weite = HXP.stage.stageWidth;
				hoehe = HXP.stage.stageHeight;
				whratio = weite / hoehe;

				if (whratio != 1.6) {

					if (whratio > 1.6) {

						wunschhoehe = hoehe;
						wunschweite = Std.int(hoehe * 1.6);
					}
					else {

						wunschweite = weite;
						wunschhoehe = Std.int(weite / 1.6);
					}

					HXP.stage.resize(wunschweite, wunschhoehe);
				}
			}

			// to save scaleX of windowed mode
			originalScale = HXP.screen.scaleX;
		}
	}

	public function quit():Void {

		#if (flash || html5)
		System.exit(1);
		#else
		Sys.exit(1);
		#end
	}


	private var originalWeite:Int = 640;
	private var originalHoehe:Int = 400;
	private var originalScale:Float = 1;

	private var fullscrenndelayzahl:Float = 0;
	private var fullscreendelay:Bool = false;
}
