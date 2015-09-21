package entitaeten.schatten;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import welten.Mutterwelt;

class Uggel extends Schatten
{

	public function new(x:Int, y:Int) {
		
		super(x, y);
		
		_gox = x;
		_goy = y;
		
	}
	
	override public function added() {
		
		super.added();
		
		graphic = muggel;
		
		name = "muggel";
		setHitbox(26, 26, 13, 13);
		
		muggel.originX = muggel.width * .5;
		muggel.originY = muggel.height * .9;	
		
		bes = 20;
		_bes = bes;
		fri = .05;
		winkelaend = 1.4;
		maxSpeed = 55;
		
		spritesheet();
	}
	
	override public function removed() {
		
		super.removed();
		
		if (HPP <= 0) {
			
			cast(HXP.scene, Mutterwelt).add(new Uggel(_gox,_goy));
		}
	}	
	
	override public function update() {
		
		super.update();
		
		layer = -Std.int(this.y);
	
		animationen();
		
		muggel.play(gerani);
	}
	
	private function animationen() {
		
		if (!sitzend) {
			
			//damit sich grozn wieder hinsetzen kann
			setzen = true;
			
			if (geschwindX != 0 && geschwindY != 0) {
				if (richtung == 1) {
					gerani = "nord_gehen";
				}
				else if (richtung == 2) {
					gerani = "ost_gehen";
				}
				else if (richtung == 3) {
					gerani = "sud_gehen";
				}
				else if (richtung == 4) {
					gerani = "west_gehen";
				}
			}
			else {
				if (richtung == 1) {
					gerani = "nord_stehen";
				}
				else if (richtung == 2) {
					gerani = "ost_stehen";
				}
				else if (richtung == 3) {
					gerani = "sud_stehen";
				}
				else if (richtung == 4) {
					gerani = "west_stehen";
				}
			}
		} else {
			
			if (setzen) {
				
				if (richtung == 1) {
					gerani = "nord_setzen";
				}
				else if (richtung == 2) {
					gerani = "ost_setzen";
				}
				else if (richtung == 3) {
					gerani = "sud_setzen";
				}
				else if (richtung == 4) {
					gerani = "west_setzen";
				}
				
				if (!fugesetzt) {
					
					muggel.callbackFunc = hinsetzen;			
					fugesetzt = true;
				}
			} else {
				
				if (richtung == 1) {
					gerani = "nord_sitzen";
				}
				else if (richtung == 2) {
					gerani = "ost_sitzen";
				}
				else if (richtung == 3) {
					gerani = "sud_sitzen";
				}
				else if (richtung == 4) {
					gerani = "west_sitzen";
				}				
			}
		}
	}
	
	private function hinsetzen() {
		
		muggel.callbackFunc = null;
		setzen = false;
		fugesetzt = false;
	}
	
	private function spritesheet() {
		
		muggel.add("nord_gehen", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
		muggel.add("nord_stehen", [16], 0, false);
		muggel.add("sud_gehen", [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], 20, true);
		muggel.add("sud_stehen", [34, 35], 1.5, true);
		muggel.add("west_gehen", [36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51], 20, true);
		muggel.add("west_stehen", [52, 53], 1.5 , true);
		muggel.add("ost_gehen", [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69], 20, true);
		muggel.add("ost_stehen", [70, 71], 1.5, true);
		
		muggel.add("nord_setzen", [206, 207, 208, 209, 210, 211, 212, 213, 214, 215], 8, false);
		muggel.add("nord_sitzen", [233], 0, false);
		muggel.add("sud_setzen", [224, 225, 226, 227, 228, 229, 230], 6, false);
		muggel.add("sud_sitzen", [231, 232], 1, true);
		muggel.add("west_setzen", [170, 171, 172, 173, 174, 175, 176, 177, 178, 179], 9, false);
		muggel.add("west_sitzen", [142, 143], 1, true);
		muggel.add("ost_setzen", [188, 189, 190, 191, 192, 193, 194, 195, 196, 197], 9, false);
		muggel.add("ost_sitzen", [160, 161], 1, true);
	}
	
	private var muggel:Spritemap = new Spritemap("graphics/enties/morischatten.png", 34, 57);
	private var gerani:String = "";
	
	//für setzen/sitzen
	private var setzen:Bool = true;
	private var fugesetzt:Bool = false;
	
	//death cycle
	private var _gox:Int;
	private var _goy:Int;
}