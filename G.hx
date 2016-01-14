package ;
import com.haxepunk.Scene;
import openfl.geom.Point;
import entitaeten.spielbare.Morikkel;
import com.haxepunk.Entity;

class G
{
	//erzählen
	public static var MoriSitzt:Point 				= new Point();
	public static var sitzt:Bool					= false;
	
	//wechsel
	public static var current:Int					= 0;				// 0 = Mori, 1 = Grozi, 2 = Lysop
	public static var letzterBlick:Int				= 3;				// 1 = Nord, 2 = Ost, 3 = Süd, 4 = West
	
	//positionen
	public static var mos:Point						= new Point(2936, 1867);
	public static var gros:Point;//					= new Point(2942, 1867);
	public static var beginpt:Point					= new Point(2936, 1876);
	
	//schattierung
	public static var erstesmal:Bool				= true;
	
	//sichtfeld
	public static var mlvl:Int 						= 5;	// zum klarere-veränderungen-test geändert, eigentlich 8
	
	//babyschutz
	public static var newborn:Float					= 8;
	
	//lysopsch
	public static var lyready:Bool					= false;
	public static var schwebt:Bool					= false;
	
	//kiste
	public static var kiste2pool:Bool				= false;
	
	//pause
	public static var pauseState:Int				= 0;			// 0 - Spielstart, 1 - keine Pause, 2 - zurück ins Game , 3 - neues Game, 4 - Menu, 6- totales Ende
	
	//alter
	public static var epoche:Int					= 0;			// 0 = start, 1 = _2, 2 = _3, 3 = _4, 4 = _5
	public static var lifeclock:Float				= 0;
	public static var maxlife:Float					= 1200;
	public static var humus:Bool					= false;
	
	//ogmo	
	
	//ASSETS
}