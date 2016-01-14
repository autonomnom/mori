package entitaeten.schatten;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import entitaeten.spielbare.Morikkel;
import welten.Mutterwelt;
import com.haxepunk.utils.Input;

class Sprechblase extends Entity
{
	/**
	 * Neue Sprechblase - Constructor.
	 * @param	x	x-Position.
	 * @param	y	y-Position.
	 * @param	r	Richtung, 1 = Nord, 2 = Ost, 3 = Süd, 4 = West.
	 * @param	s	Schattentyp, 0 = Groz, 1 = Lysop, 2 = Kiste.
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
			
			grozsprich.add("loop", [36,36,36, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36], 13, true);
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
			
			graphic = lysprich;
			
			lysprich.add("loop", [27,27,27, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26], 10, true);
			lysprich.add("start", [27], 0, true);
			
			lysprich.originY = lysprich.height; 
			
			//to find the right spot
			setHitbox(25, 134, 0, lysprich.height);			
		}
		else if (schattentyp == 2) {
			
			graphic = grozsprich;
			
			grozsprich.add("loop", [36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,], 12, true);
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
			
			//delay vom start der animation
			if (delay < 1) {
				
				delay += HXP.elapsed;
				grozsprich.play("start");
			} 
			else {
				
				grozsprich.play("loop");
			}
			
			this.layer = -Std.int(this.y + 30);
			
			//ende des redens *optional
			if ((G.sitzt && mori.genuggehoert) || !mori.anhoeren) {
				
				grozsprich.callbackFunc = enuff;
			}			
		}
		else if (schattentyp == 1) {
			
			//delay vom start der animation
			if (delay < 1) {
				
				delay += HXP.elapsed;
				lysprich.play("start");
			} 
			else {
				
				lysprich.play("loop");
			}
			
			this.layer = -5200;
			
			//ende des redens *optional
			if ((G.sitzt && mori.genuggehoert) || !mori.anhoeren) {
				
				lysprich.callbackFunc = enuff;
			}	
		}
		else if (schattentyp == 2) {
			
			//delay vom start der animation
			if (delay < 1) {
				
				delay += HXP.elapsed;
				grozsprich.play("start");
			} 
			else {
				
				grozsprich.play("loop");
			}
			
			this.layer = -5200;
			
			if (cast(HXP.scene, Mutterwelt).schattendealy <= 3) {
				
				grozsprich.callbackFunc = enuff;
			}
		}
	}
	
	private function enuff() {
		
		if (schattentyp == 0) {	grozsprich.callbackFunc = null; }
		else if (schattentyp == 1) { lysprich.callbackFunc = null; }
		else if(schattentyp == 2) { grozsprich.callbackFunc = null; }
		
		HXP.scene.remove(this);
	}
	
	override public function removed() {
		
		super.removed();
	}

	private var mori:Morikkel;
	private var grozsprich:Spritemap = new Spritemap("graphics/enties/sprich.png", 25, 134); 
	private var lysprich:Spritemap = new Spritemap("graphics/enties/lysopschsprich.png", 25, 110);
	private var delay:Float = 0;
	private var richtung:Int;
	
	private var schattentyp:Int;
}