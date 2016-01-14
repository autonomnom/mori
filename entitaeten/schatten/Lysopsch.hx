package entitaeten.schatten;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import entitaeten.spielbare.Morikkel;
import com.haxepunk.HXP;

class Lysopsch extends Entity
{

	public function new(x:Float, y:Float) 	{
		
		super(x, y);
	}

/**	override public function added() {
		
		super.added();
		
		graphic = gesicht;
		type = "lyly";
		name = "lysopsch";
		
		setHitbox(34, 34, 18, 18);
		
		gesicht.originX = gesicht.width * .5;
		gesicht.originY = gesicht.height * .78;
		
		gesicht.add("lyly", [3,2], 1, true);// [14, 15],1, true);
		gesicht.add("schwebelyly", [0,1], 1, true);// [6, 7], 1, true);
		gesicht.add("rauf", [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4], 10, false);
		gesicht.add("runter", [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 10, false);
	}
	
	override public function update() {
		
		super.update();
		
		layer = Std.int( -this.y);
		
		behave();
		hittibox();
		
		gesicht.play(gerani);
	}
*/	
	/** Zum unten durchgehen.
	 * 
	 */
/**	private function hittibox() {
		
		if (sethittibox) {
			
			if (gerani == "schwebelyly") {
				
				type = "schwebelyly";
			}
			else if (gerani == "lyly") {
				
				type = "lyly";				
			}
		}
	}
	
	override public function removed() {
		
		super.removed();
	}
	
	private function behave() {
		
		//get mori
		mori = cast(HXP.scene.nearestToEntity("mori", this), Morikkel);
		
		//magic
		if (mori != null) {
			
			moridistance = HXP.distance(this.x, this.y, mori.x, mori.y);
			
			//schweben & sitzen
			if (moridistance <= 80 && !fertigbewegend) {
				
				gerani = "rauf";
				gesicht.callbackFunc = schwebend;
				bewegend = true;
			}
			else if (moridistance <= 80 && !bewegend && fertigbewegend) {
				
				gerani = "schwebelyly";
			}
			else if (moridistance > 80 && fertigbewegend) {
				
				gerani = "runter";
				gesicht.callbackFunc = sitzend;
				bewegend = true;
			}
			else if (moridistance > 80 && !bewegend && !fertigbewegend) {
				
				gerani = "lyly";
			}
			
			//talk
			if (gerani == "schwebelyly" && G.sitzt) {
				
				G.lyready = true;
				
				//sprechblase hier, schattentyp in added und update integrieren
				if (!blase) {
					
					HXP.scene.add(new Sprechblase(this.x - 25, this.y - 55, 1, 1));
					blase = true;
				}
				
				if (!erzaehlt) {
					
					mori.erzaehler.push(this);
					erzaehlt = true;
				}
			}
			else {
				
				G.lyready = false;
				erzaehlt = false;
			}
		}
	}
	
	private function schwebend() {
		
		gesicht.callbackFunc = null;
		fertigbewegend = true;
		bewegend = false;
		sethittibox = true;
	}
	
	private function sitzend() {
		
		gesicht.callbackFunc = null;
		fertigbewegend = false;
		bewegend = false;
		sethittibox = true;
	}
	
	private var mori:Morikkel;
	private var moridistance:Float;
	
	public var gesicht:Spritemap = new Spritemap("graphics/enties/morisprite.png", 66, 125);
	private var gerani:String = "";
	
	public var fertigbewegend:Bool = false;
	public var bewegend:Bool = false;
	
	private var sethittibox:Bool = false;
	private var erzaehlt:Bool = false;
	
	public var blase:Bool = false;
*/
}