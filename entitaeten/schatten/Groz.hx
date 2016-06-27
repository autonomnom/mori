package entitaeten.schatten;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;
import haxe.Json;
import welten.Mutterwelt;
import openfl.Assets;

class Groz extends Schatten
{

	public function new(x:Int, y:Int) {

		super(x, y);

		_gox = x;
		_goy = y;
	}

	override public function added() {

		super.added();

		spritesheet();

		name = "groz";

		graphic = grozn;

		setHitbox(26, 26, 13, 13);
		grozn.originX = grozn.width * .5;
		grozn.originY = grozn.height * .87;

		bes = 20;
		_bes = bes;
		fri = .05;
		winkelaend = 1.4;
		maxSpeed = 55;

		/* json test
		var nneeew:String = Assets.getText("text/grozgroz.json");
		var jj = Json.parse(nneeew);
		HXP.console.log([jj.furz[0].ti]);
		HXP.console.log([Json.stringify(Json.parse(nneeew))]);
		*/
	}

	override public function removed() {

		super.removed();

		if (HPP <= 0) {

			cast(HXP.scene, Mutterwelt).add(new Groz(_gox,_goy));
		}
	}

	override public function update() {

		super.update();

		layer = -Std.int(this.y);

		animationen();




		grozn.play(gerani);
	}

	private function animationen() {

		if (!sitzend) {

			//damit sich grozn wieder hinsetzen kann
			setzen = true;

			if (geschwindX != 0 && geschwindY != 0) {
				if (richtung == 1) {
					gerani = "gehenN";
				}
				else if (richtung == 2) {
					gerani = "gehenO";
				}
				else if (richtung == 3) {
					gerani = "gehenS";
				}
				else if (richtung == 4) {
					gerani = "gehenW";
				}
			}
			else {
				if (richtung == 1) {
					gerani = "stehenN";
				}
				else if (richtung == 2) {
					gerani = "stehenO";
				}
				else if (richtung == 3) {
					gerani = "stehenS";
				}
				else if (richtung == 4) {
					gerani = "stehenW";
				}
			}
		} else {

			if (setzen) {

				if (richtung == 1) {
					gerani = "setzenN";
				}
				else if (richtung == 2) {
					gerani = "setzenO";
				}
				else if (richtung == 3) {
					gerani = "setzenS";
				}
				else if (richtung == 4) {
					gerani = "setzenW";
				}

				if (!fugesetzt) {

					grozn.callbackFunc = hinsetzen;
					fugesetzt = true;
				}
			} else {

				if (richtung == 1) {
					gerani = "sitzenN";
				}
				else if (richtung == 2) {
					gerani = "sitzenO";
				}
				else if (richtung == 3) {
					gerani = "sitzenS";
				}
				else if (richtung == 4) {
					gerani = "sitzenW";
				}
			}
		}
	}

	private function hinsetzen() {

		grozn.callbackFunc = null;
		setzen = false;
		fugesetzt = false;
	}

	private function spritesheet() {

		//W
		grozn.add("stehenW", [0, 1], 1, true);
		grozn.add("gehenW", [2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		grozn.add("knockW", [10, 11, 12, 13, 14, 15, 16, 17, 18], 10, false);
		grozn.add("setzenW", [19, 20, 21, 22, 23, 24, 25, 26], 10, false);
		grozn.add("sitzenW", [27, 28], 1, true);

		//O
		grozn.add("stehenO", [ 31, 32], 1, true);
		grozn.add("gehenO", [33, 34, 35, 36, 37, 38, 39, 40], 10, true);
		grozn.add("knockO", [41, 42, 43, 44, 45, 46, 47, 48, 49], 10, false);
		grozn.add("setzenO", [50, 51, 52, 53, 54, 55, 56, 57], 10, false);
		grozn.add("sitzenO", [58, 59], 1, true);

		//S
		grozn.add("stehenS", [62, 63], 1, true);
		grozn.add("gehenS", [64, 65, 66, 67, 68, 69, 70, 71], 10, true);
		grozn.add("knockS", [72, 73, 74, 75, 76, 77, 78, 79, 80, 81], 10, false);
		grozn.add("setzenS", [82, 83, 84, 85, 86, 87, 88, 89], 10, false);
		grozn.add("sitzenS", [90, 91], 1, true);

		//N
		grozn.add("stehenN", [93, 94], 1, true);
		grozn.add("gehenN", [95, 96, 97, 98, 99, 100, 101, 102], 10, true);
		grozn.add("knockN", [103, 104, 105, 106, 107, 108, 109, 110, 111, 112], 10, false);
		grozn.add("setzenN", [113, 114, 115, 116, 117, 118, 119, 120], 10, false);
		grozn.add("sitzenN", [121, 122], 1, true);

		//Schlagen
		grozn.add("schlagen", [ 29, 30, 60, 61, 29, 30, 60, 61], 25, false);
	}


	public var grozn:Spritemap = new Spritemap("graphics/enties/grozspriteSCH.png", 45, 70);
	private var gerani:String = "stehenS";

	//für setzen/sitzen
	private var setzen:Bool = true;
	private var fugesetzt:Bool = false;

	//death cycle
	private var _gox:Int;
	private var _goy:Int;
}
