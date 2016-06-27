package entitaeten.spielbare;

import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick;
import com.haxepunk.HXP;
import openfl.geom.Point;
import welten.Mutterwelt;
import entitaeten.schatten.Schatten;
import com.haxepunk.Sfx;

class Morikkel extends Entity
{

	public function new(x:Float = 0, y:Float = 0) {

		super(x, y);
	}

	override public function added() {

		super.added();

		type = "mori";

		richtung = G.letzterBlick;

		G.newborn = 5;

		inputDefinitionen();

		checkStucking = true;
		checkStuckSchat = true;

		cast(scene, Mutterwelt).triggered = false;
	}

	override public function update() {

		super.update();

		layer = -Std.int(this.y);

		if (G.newborn > 0) {

			G.newborn -= HXP.elapsed;
		}

		zuhoeren();
		stuckstuck();
		lebensverkuerzung();
		afterhour();

		//HXP.console.log([G.epoche, G.lifeclock]);
		//if (Input.pressed(Key.F)) { G.lifeclock = 1180;}
	}

	override public function removed() {

		super.removed();

		G.letzterBlick = richtung;
	}

	override public function moveCollideX(e:Entity):Bool {

		if (e.type == "schatten") {

			anne = HXP.angle(this.x, this.y, e.x, e.y);
			anne = anne * Math.PI / 180;

			if (ren != 1) {

				knock = 60; // 90

				var bbb:Schatten = cast(e, Schatten);
				if (bbb.HPP > 0) {

					--bbb.HPP;
				} else {

					HXP.scene.remove(bbb);
					--G.mlvl;
				}

				if (SP == SPmax && G.newborn <= 0) {
					GG = true;
				}
				else if (SP != SPmax) {
					SP += 2;
				}
			}

			return true;
		}
		else if (e.type == "mensch") {

			if (ren != 1) {

				anne = HXP.angle(this.x, this.y, e.x, e.y);
				anne = anne * Math.PI / 180;

				knock = 60; //90

				if (SP == SPmax && G.newborn <= 0) {
					GG = true;
				}
				else if (SP != SPmax) {
					SP += 2;
				}

				return true;
			}
			else return true;
		}
		else if (e.type == "solid") {

			return true;
		}
		else if (e.type == "interesting") {

			return true;
		}
		else return false;
	}

	override public function moveCollideY(e:Entity):Bool {

		if (e.type == "schatten") {

			anne = HXP.angle(this.x, this.y, e.x, e.y);
			anne = anne * Math.PI / 180;

			if (ren != 1) {

				knock = 60; // 90

				var bbb:Schatten = cast(e, Schatten);
				if (bbb.HPP > 0) {

					--bbb.HPP;
				} else {

					HXP.scene.remove(bbb);
					--G.mlvl;
				}

				if (SP == SPmax && G.newborn <= 0) {
					GG = true;
				}
				else if (SP != SPmax) {
					SP += 2;
				}
			}

			return true;
		}
		else if (e.type == "mensch") {

			if (ren != 1) {

				anne = HXP.angle(this.x, this.y, e.x, e.y);
				anne = anne * Math.PI / 180;

				knock = 60; // 90

				if (SP == SPmax && G.newborn <= 0) {
					GG = true;
				}
				else if (SP != SPmax) {
					SP += 2;
				}

				return true;
			}
			else return true;
		}
		else if (e.type == "solid") {

			return true;
		}
		else if (e.type == "interesting") {

			return true;
		}
		else return false;
	}

	public function inputDefinitionen() {

		Input.define("links", [Key.A, Key.LEFT]);
		Input.define("rechts", [Key.D, Key.RIGHT]);
		Input.define("hoch", [Key.W, Key.UP]);
		Input.define("runter", [Key.S, Key.DOWN]);
		Input.define("rennen", [Key.SHIFT]);
		Input.define("schlagen", [Key.L, Key.Q]);
	}

	public function bewegung() {

		// speX & speY Geschwindigkeit der einzelnen Achsen
		// bes Beschleunigung
		// fri Reibung

		moveBy(geschwindX, geschwindY, ["solid", "schatten", "mensch", "interesting"], true);

		speX = speXlinks + speXrechts + speXknock;
		speY = speYhoch + speYrunter + speYknock;

		geschwindX = speX * bes * fri * HXP.elapsed * ren;
		geschwindY = speY * bes * fri * HXP.elapsed * ren;
	}

	public function knockback() {

		if (knock > 50) {

			speXlinks = -0.1;
			speXrechts = 0.1;
			speYhoch = -0.1;
			speYrunter = 0.1;
		}

		if (knock > 2) {

			knock -= 1.7;
			bes = knock * knock * 0.3;

			speXknock = -Math.cos(anne);
			speYknock = Math.sin(anne);
		}
		else if (knock <= 2 && knock > 0) {
			bes = besGehen;
			knock = 0;
			speXknock = 0;
			speYknock = 0;
			ren = 1;
			speMAX = 60;
			speFakJ = 80;

			speXlinks = 0;
			speXrechts = 0;
			speYhoch = 0;
			speYrunter = 0;

			if (richtung == 4/*gerani == "knockO"*/) { richtung = 2; }				// weil die richtugn beim knockback verkehrt herum ist
			else if (richtung == 3/*gerani == "knockN"*/) { richtung = 1; }
			else if (richtung == 2/*gerani == "knockW"*/) { richtung = 4; }
			else if (richtung == 1/*gerani == "knockS"*/) { richtung = 3; }
		}
	}

	public function zuhoeren() {

		if (hoerdauer >= 6 && !genuggehoert) {								//vielleicht damit lösen, das die erzählanimation so lange dauert? #aufwendig

			// transform animation mori

			genuggehoert = true;
		}

		if (G.sitzt) {

			if (G.lyready || collide("schatten", this.x, this.y) != null) {

				if (!anhoeren) { anhoeren = true; }
			}
			else anhoeren = false;

			if (anhoeren) {

				hoerdauer += HXP.elapsed;
			}
		}
		else {

			anhoeren = false;
			hoerdauer = 0;
			genuggehoert = false;

			for (i in 0...erzaehler.length) {
				erzaehler.remove(erzaehler[i]);
			}
		}
	}

	private function stuckstuck() {

	//	if (collide("solid", this.x, this.y) != null) { checkStucking = true; }

		if (checkStucking) {

				if (collide("solid",this.x,this.y) != null) {//gridDetectiv("solid", 16, "welt")) {

					stuckSolve("solid", 2, 1, "schatten");
				}
				else checkStucking = false;
		}
	}

	private function lebensverkuerzung() {

		//kuerzeres leben ..
		// ..wenn rennen
		if (ren != 1) { G.lifeclock += HXP.elapsed * 0.1; }

		// ..wenn knockback
		if (knock > 0) { G.lifeclock += HXP.elapsed * 0.5; }

		// ..wenn multipliziert
		if (gerani == "bye") { G.lifeclock += HXP.elapsed * 2; }


		//längeres leben (?) ..
		if (cast(scene, Mutterwelt).triggered) { G.lifeclock -= HXP.elapsed * 0.1; }

		// ..wenn sitzen
		if (G.sitzt) { G.lifeclock -= HXP.elapsed * 0.5; }
	}

	private function afterhour() {

		if (G.lifeclock >= G.maxlife) {

			G.sitzt = false;
		}
	}

	//V
	//Bewegungphysik
	public var geschwindX:Float;
	public var geschwindY:Float;
	public var speX:Float 					= 0;
	public var speY:Float 					= 0;
	public var speXlinks:Float 				= 0;
	public var speXrechts:Float 			= 0;
	public var speYhoch:Float 				= 0;
	public var speYrunter:Float 			= 0;
	public var friXlinks:Bool 				= false;
	public var friXrechts:Bool 				= false;
	public var friYhoch:Bool 				= false;
	public var friYrunter:Bool 				= false;
	public var speFak:Float 				= 2;
	public var speFakJ:Float 				= 62;//80;
	public var speMAX:Float 				= 60;//60;  	//110
	public var bes:Float 					= 11;	//13 ??
	public static var besRennen:Float 		= 24;
	public static var besGehen:Float 		= 11;
	public var fri:Float 					= .05;
	public var ren:Float 					= 1;

	public var steht:Bool					= false;
	public var stehtzaehler:Float			= 0;

	//Knockback
	public var anne:Float					= 0;
	public var knock:Float					= 0;
	private var speXknock:Float 			= 0;
	private var speYknock:Float				= 0;

	//Angreifen
	public var angreifen:Int				= 0;
	public var angriffzurueck:Bool			= false;
	public var SP:Float						= 0; 			// Schattenpunkte
	public var SPmax:Int					= 10;
	public var SPmaxzaehler:Float			= 0;

	public var GG:Bool						= false;

	//Richtung
	public var richtung:Int 				= 1;

	//Zuhören
	public var erzaehler:Array<Dynamic>		= new Array();
	public var anhoeren:Bool				= false;
	public var hoerdauer:Float				= 0;
	public var genuggehoert:Bool	 		= false;

	//Grafik
	public var gerani:String				= "";

	// lufeclock ende
	public var amboden:Bool				= false;

	//stuckCheck
	public var checkStucking:Bool 			= false;
	public var checkStuckSchat:Bool 		= false;

	public var gesang:Sfx = new Sfx("audio/stimmen/w11.ogg");
	public var seufz:Sfx = new Sfx("audio/stimmen/w2.ogg");
	public var oneplay:Int = 0;
}
