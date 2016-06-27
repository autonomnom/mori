package entitaeten.schatten;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import entitaeten.spielbare.Morikkel;
import welten.Mutterwelt;
import com.haxepunk.utils.Input;
import com.haxepunk.Sfx;

class Sprechblase extends Entity
{
	/**
	 * Neue Sprechblase - Constructor.
	 * @param	x	x-Position.
	 * @param	y	y-Position.
	 * @param	r	Richtung, 1 = Nord, 2 = Ost, 3 = Süd, 4 = West.
	 * @param	s	Schattentyp, 0 = Groz, 1 = Mensch, 2 = Kiste.
	 */
	public function new(x:Float = 0, y:Float = 0, r:Int, s:Int){

		super(x, y);
		richtung = r;
		schattentyp = s;
		if (s == 1) { richtung = 1; }
	}

	override public function added() {

		super.added();

		if (schattentyp == 0) {

			graphic = grozsprich;

			grozsprich.add("loop", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 36, 36], 13, true);
			grozsprich.add("start", [36], 0, true);

			grozsprich.originY = grozsprich.height;

			//to find the right spot
			setHitbox(25, 134, 0, grozsprich.height);

			if (richtung == 1) { grozsprich.flipped = false; }
			if (richtung == 2) { grozsprich.flipped = true; }
			if (richtung == 3) { grozsprich.flipped = true; }
			if (richtung == 4) { grozsprich.flipped = false; }
		}
		else if (schattentyp == 1) {

			graphic = grozsprich;

			grozsprich.add("loop", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 36, 36], 13, true);
			grozsprich.add("start", [36], 0, true);

			grozsprich.originY = grozsprich.height;

			//to find the right spot
			setHitbox(25, 134, 0, grozsprich.height);

			if (richtung == 1) { grozsprich.flipped = false; }
			if (richtung == 2) { grozsprich.flipped = true; }
			if (richtung == 3) { grozsprich.flipped = true; }
			if (richtung == 4) { grozsprich.flipped = false; }
		}
		else if (schattentyp == 2) {

			graphic = grozsprich;
			delayMIN = 5;
			delayMAX = 10;

			//grozsprich.add("loop", [36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,], 12, true);
			grozsprich.add("loop", [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 ], 12, false);
			grozsprich.add("start", [36], 0, true);

			grozsprich.originY = grozsprich.height;

			//to find the right spot
			setHitbox(25, 134, 0, grozsprich.height);

			name = "sprichmitmir";
		}
	}

	override public function update() {

		super.update();

		mori = cast(HXP.scene.nearestToEntity("mori", this), Morikkel);

		if (schattentyp == 0) {

			//delay vorm start der animation
			if (delay < 1) {

				delay += HXP.elapsed;
				grozsprich.play("start");
				randomo = Math.random();
			}
			else {

				grozsprich.play("loop");
				if(oneplay) {

					oneplay = false;

					if (G.current == 0) {

						if (randomo < 0.33)	 													{ s5xx.play(); }
						else if (randomo >= 0.33 && randomo < 0.66) 	{ s6xx.play(); }
						else if (randomo >= 0.66) 										{ s4xx.play(); }
					}
					else if (G.current == 1) {

						if (randomo < 0.33) 													{ s1xx.play(); }
						else if (randomo >= 0.33 && randomo < 0.66)		{ s2xx.play(); }
						else if (randomo >= 0.66) 										{ s3xx.play(); }
					}
				}
			}

			this.layer = -Std.int(this.y + 30);

			//ende des redens *optional
			if ((G.sitzt && mori.genuggehoert) || !mori.anhoeren) {

				grozsprich.callbackFunc = enuff;
			}
		}
		else if (schattentyp == 1) {

			//delay vorm start der animation
			if (delay < 1) {

				delay += HXP.elapsed;
				grozsprich.play("start");
				randomo = Math.random();
			}
			else {

				grozsprich.play("loop");
				if(oneplay) {

					oneplay = false;
					m1xx.play();
				//	if (randomo < 0.33)	 													{ m1xx.play(); }
				//	else if (randomo >= 0.33 && randomo < 0.66) 	{ m2xx.play(); }
				//	else if (randomo >= 0.66) 										{ m3xx.play(); }
				}
			}

			this.layer = -Std.int(this.y + 30);

			//ende des redens *optional
			if ((G.sitzt && mori.genuggehoert) || !mori.anhoeren) {

				grozsprich.callbackFunc = enuff;
			}
		}
		else if (schattentyp == 2) {

			//delay vom start der animation
			if (delay < 3) {

				delay += HXP.elapsed;
				grozsprich.play("start");
			}
			else {

				if (delayTIMER > 0) {

					delayTIMER -= HXP.elapsed;
					grozsprich.play("loop");
					if (oneplay) {

						k1xx.play();
						oneplay = false;
					}
				}
				else {

					delayTIMER = (delayMAX - delayMIN) * Math.random() + delayMIN;
					grozsprich.restart();

					var randy:Float = Math.random();

					if(randy < 0.33) { k1xx.play(); }
					else if (randy >= 0.33 && randy < 0.66) { k2xx.play(); }
					else if (randy >= 0.66) { k3xx.play(); }
				}
			}

			this.layer = -5200;

			if (cast(HXP.scene, Mutterwelt).schattendealy <= 3) {

				grozsprich.callbackFunc = enuff;
			}
		}
	}

	private function enuff() {

		if (schattentyp == 0) {	grozsprich.callbackFunc = null; }
		else if (schattentyp == 1) { grozsprich.callbackFunc = null; }
		else if (schattentyp == 2) { grozsprich.callbackFunc = null; }

		HXP.scene.remove(this);
	}

	override public function removed() {

		super.removed();
	}

	private var mori:Morikkel;
	private var grozsprich:Spritemap = new Spritemap("graphics/enties/sprich.png", 25, 134);
	//private var lysprich:Spritemap = new Spritemap("graphics/enties/lysopschsprich.png", 25, 110);
	private var delay:Float = 0;
	private var richtung:Int;

	private var oneplay:Bool = true;
	private var randomo:Float;

	private var k1xx:Sfx = new Sfx("audio/stimmen/k11.ogg");
	private var k2xx:Sfx = new Sfx("audio/stimmen/k2.ogg");
	private var k3xx:Sfx = new Sfx("audio/stimmen/k3.ogg");

	private var s1xx:Sfx = new Sfx("audio/stimmen/s1.ogg");
	private var s2xx:Sfx = new Sfx("audio/stimmen/s2.ogg");
	private var s3xx:Sfx = new Sfx("audio/stimmen/s3.ogg");
	private var s4xx:Sfx = new Sfx("audio/stimmen/s4.ogg");
	private var s5xx:Sfx = new Sfx("audio/stimmen/s5.ogg");
	private var s6xx:Sfx = new Sfx("audio/stimmen/s6.ogg");
	private var s7xx:Sfx = new Sfx("audio/stimmen/s7.ogg");
	private var s8xx:Sfx = new Sfx("audio/stimmen/s8.ogg");

	private var m1xx:Sfx = new Sfx("audio/stimmen/m1.ogg");
	//private var m2xx:Sfx = new Sfx("audio/stimmen/m2.ogg");
	//private var m3xx:Sfx = new Sfx("audio/stimmen/m3.ogg");

	private var delayMIN:Float;
	private var delayMAX:Float;
	private var delayTIMER:Float = 6.5;

	private var schattentyp:Int;
}
