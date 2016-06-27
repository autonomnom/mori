package entitaeten.schatten;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import entitaeten.spielbare.Morikkel;
import com.haxepunk.HXP;

class Mensch extends Entity
{

	public function new(x:Float, y:Float) 	{

		super(x, y);
	}

	override public function added() {

		super.added();

		graphic = gesicht;
		type = "mensch";

		setHitbox(26, 26, 13, 13);

		gesicht.originX = gesicht.width * .5;
		gesicht.originY = gesicht.height * .8;

		gesicht.add("sud_sitzen", [231, 232], 1, true);
	}

	override public function update() {

		super.update();

		layer = Std.int( -this.y);

		behave();

		gesicht.play("sud_sitzen");
	}

	override public function removed() {

		super.removed();

		G.lyready = false;
	}

	private function behave() {

		//get mori
		grozi = cast(HXP.scene.nearestToEntity("mori", this), Morikkel);

		//magic
		if (grozi != null) {

			moridistance = HXP.distance(this.x, this.y, grozi.x, grozi.y);

			//talk
			if (moridistance < 60 && G.sitzt) {

				//sprechblase hier, schattentyp in added und update integrieren
				if (!blase) {

					HXP.scene.add(new Sprechblase(this.x - 28, this.y - 17, 1, 1));
					blase = true;
				}

				if (!erzaehlt) {

					grozi.erzaehler.push(this);
					G.lyready = true;
					erzaehlt = true;
				}
			}
			else if (moridistance >= 60 || !G.sitzt) {

				erzaehlt = false;
				blase = false;
				G.lyready = false;
			}
		}
	}


	private var grozi:Morikkel;
	private var moridistance:Float;

	public var gesicht:Spritemap = new Spritemap("graphics/enties/morischatten2.png", 34, 57);

	private var sethittibox:Bool = false;
	private var erzaehlt:Bool = false;

	public var blase:Bool = false;
}
