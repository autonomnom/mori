package welten;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.tweens.motion.LinearMotion;
import entitaeten.schatten.Mensch;
import entitaeten.schatten.Schatten;
import entitaeten.schatten.Sprechblase;
import entitaeten.schatten.Uggel;
import entitaeten.spielbare.Faust;
import entitaeten.spielbare.Grozi;
import entitaeten.spielbare.Mori;
import entitaeten.spielbare.Morikkel;
import entitaeten.schatten.Groz;
import com.haxepunk.masks.Grid;
import com.haxepunk.utils.Ease;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import entitaeten.Wurmsch;
import haxe.xml.Check;
import haxe.xml.Fast;
import openfl.Assets;
import openfl.geom.Point;
import welten.menu.Menu;
import com.haxepunk.utils.Joystick.XBOX_GAMEPAD;
import welten.menu.Button;
import openfl.system.System;


class Mutterwelt extends Scene
{

	public function new()
	{
		super();
	}

	override public function begin() {

		super.begin();

		add(_mori);

		loadMap("text/alabasa2.oel", "graphics/welt/alabsa2.png");
		loadEntities();
		wurmaufwachen();
	}

	override public function update() {

		super.update();

		//if(Input.pressed(Key.H)) { G.lifeclock = 1170; }

		kamera();
		sichtfeld();
		kischte();
		playEntities();
		kamerafahrt();
		faust();
		transformation();
		lebenszeit();
		malerei();
		wurmfest();

		if ((G.maxlife - G.lifeclock) < 15) { faaad = true; }
		if (faaad) {

			inthemiddle.volume -= HXP.elapsed / 13;
		}

		if (G.pauseState <= 1) {

			if (kistefade && !schattenriegel) {

				loadSchatten();
				schattenriegel = true;
			}

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed(XBOX_GAMEPAD.XBOX_BUTTON)) {

					rundgangstimerino = 0;

					//sammel alle entitaeten
					HXP.scene.getAll(alles);

					//deaktivier sie
					for (i in 0...alles.length) {

						alles[i].active = false;
					}

					//bilder sammeln
					HXP.scene.getType("mal", allebilder);

					//layer runtersetzen
					for (i in 0...allebilder.length) {

						allebilder[i].layer = 5000;
					}
					keinebilder = true;

					add(auge);
					zwinker.callbackFunc = augeZU;
					augzu = true;
				}
			}
			else if (Input.pressed(Key.ESCAPE)) {

				rundgangstimerino = 0;

				//sammel alle entitaeten
				HXP.scene.getAll(alles);

				//deaktivier sie
				for (i in 0...alles.length) {

					alles[i].active = false;
				}

				//bilder sammeln
				HXP.scene.getType("mal", allebilder);

				//layer runtersetzen
				for (i in 0...allebilder.length) {

					allebilder[i].layer = 5000;
				}
				keinebilder = true;

				add(auge);
				zwinker.callbackFunc = augeZU;
				augzu = true;
			}

			//
			// BUG WORKAROUND
			/*
			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed(XBOX_GAMEPAD.BACK_BUTTON)) {

					if (HXP.scene.nearestToEntity("schatten", _mori, true) != null) {

						var schatti:Schatten = cast(HXP.scene.nearestToEntity("schatten", _mori, true), Schatten);
						remove(schatti);
						add(new Groz(Std.int(schatti.x), Std.int(schatti.y)));
					}
				}
			}
			else if (Input.pressed(Key.F5)) {

				if (HXP.scene.nearestToEntity("schatten", _mori, true) != null) {

					var schatti:Schatten = cast(HXP.scene.nearestToEntity("schatten", _mori, true), Schatten);
					remove(schatti);
					add(new Groz(Std.int(schatti.x), Std.int(schatti.y)));
				}
			}	*/
		}
		else if (G.pauseState == 4) {

			menu();

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed(XBOX_GAMEPAD.XBOX_BUTTON)) {

					G.pauseState = 2;

					add(auge);
					zwinker.callbackFunc = augeZU;
					augzu = true;
				}
			}
			else if (Input.pressed(Key.ESCAPE)) {

				G.pauseState = 2;

				add(auge);
				zwinker.callbackFunc = augeZU;
				augzu = true;
			}
		}

		/**
		 * Ende,
		 */
		if (G.humus && !ende) {

			add(auge);
			zwinker.callbackFunc = augeZU;
			augzu = true;
			ende = true;

			if(oneplay2) { hhhh.play(); oneplay2 = false; }
		}
	}

	/*	// rundgangstimer
	private function rundgangTimer() {

		if (G.sitzt) {

			if (rundgangstimerino < 120 && G.pauseState != 4 && rundgangshebel && !kisteready) {

				rundgangstimerino += HXP.elapsed;
			}
			else if (rundgangstimerino >= 120) {

				rundgangstimerino = 0;

				HXP.scene.getAll(alles);

				//deaktivier sie
				for (i in 0...alles.length) {

					alles[i].active = false;
				}

				add(auge);
				zwinker.callbackFunc = augeZU;
				augzu = true;
				rundgangshebel = false;
			}
		}
		else {

			rundgangstimerino = 0;
		}
	}
	*/

	private function wurmaufwachen() {

		//set the positions
		wurmpositionen.push(new Point(2902, 1897));  //0   kiste
		wurmpositionen.push(new Point(1879, 1335));  //1		IIII IIIII IIII
		wurmpositionen.push(new Point(1469, 2348));  //2		maulwurfhuegel
		wurmpositionen.push(new Point(1583, 689));  // 3	schaedel
		wurmpositionen.push(new Point(1637, 1252)); //5		kleiner stammbewohner
		//wurmpositionen.push(new Point(2241,1634));  // 6	abgebrochener ast
	}

	private function wurmfest() {

		if (parteytime) {

			for (i in 0...wurmpositionen.length) {

				if (G.current == 0) {

					if (HXP.distance(_mori.x, _mori.y, wurmpositionen[i].x, wurmpositionen[i].y) < 100) {

						if (HXP.scene.nearestToPoint("wurm", wurmpositionen[i].x, wurmpositionen[i].y) == null) {

							add(new Wurmsch(wurmpositionen[i].x, wurmpositionen[i].y));
						}
					}
				}
				else if (G.current == 1) {

					if (HXP.distance(_grozi.x, _grozi.y, wurmpositionen[i].x, wurmpositionen[i].y) < 100) {

						if (HXP.scene.nearestToPoint("wurm", wurmpositionen[i].x, wurmpositionen[i].y) == null) {

							add(new Wurmsch(wurmpositionen[i].x, wurmpositionen[i].y));
						}
					}
				}
			}
		}
	}

	private function malerei() {

		//Input
		if (G.current == 0 && parteytime) {

			if (_mori.collide("mal", _mori.x, _mori.y) != null) {

				if (Input.joystick(0).connected) {

					if (Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON)) {

						if (!triggered) { triggered = true; }
						else { triggered = false; }
					}
				}
				else if (Input.pressed(Key.E) || Input.pressed(Key.K) || Input.pressed(Key.SPACE)) {

					if (!triggered) { triggered = true; }
					else { triggered = false; }
				}
			}
			else triggered = false;
		}
		else if (G.current == 1) {

			//G.lyready for [not stopping the stehzaehler ??????] checking distance for mensch / transformation back to mori
			if (_grozi.collide("mal", _grozi.x, _grozi.y) != null && !G.lyready) {

				if (Input.joystick(0).connected) {

					if (Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON)) {

						if (!triggered) { triggered = true; }
						else { triggered = false; }
					}
				}
				else if (Input.pressed(Key.E) || Input.pressed(Key.K) || Input.pressed(Key.SPACE)) {

					if (!triggered) { triggered = true; }
					else { triggered = false; }
				}
			}
			else triggered = false;
		}

		//Let the pictures roll
		if (triggered && !keinebilder) {

			if (G.current == 0) {

				var gemlaede:Entity = _mori.collide("mal", _mori.x, _mori.y);

				if (gemlaede.name == "home") {

					golo0_0.play("1");
					golo0.layer = -4999;
					golo0.x = HXP.camera.x;
					golo0.y = HXP.camera.y;
				}
				if (gemlaede.name == "strich") {

					golo1_1.play("1");
					golo1.layer = -4999;
					golo1.x = HXP.camera.x;
					golo1.y = HXP.camera.y;
				}
				if (gemlaede.name == "maul") {

					golo2_2.play("1");
					golo2.layer = -4999;
					golo2.x = HXP.camera.x;
					golo2.y = HXP.camera.y;
				}
				if (gemlaede.name == "scully") {

					golo3_3.play("1");
					golo3.layer = -4999;
					golo3.x = HXP.camera.x;
					golo3.y = HXP.camera.y;
				}
				if (gemlaede.name == "dunkel") {

					golo4_4.play("1");
					golo4.layer = -4999;
					golo4.x = HXP.camera.x;
					golo4.y = HXP.camera.y;
				}
			}
			else if (G.current == 1) {

				var gemlaede:Entity = _grozi.collide("mal", _grozi.x, _grozi.y);

				if (gemlaede.name == "home") {

					golo0_0.play("2");
					golo0.layer = -4999;
					golo0.x = HXP.camera.x;
					golo0.y = HXP.camera.y;
				}
				if (gemlaede.name == "strich") {

					golo1_1.play("2");
					golo1.layer = -4999;
					golo1.x = HXP.camera.x;
					golo1.y = HXP.camera.y;
				}
				if (gemlaede.name == "maul") {

					golo2_2.play("2");
					golo2.layer = -4999;
					golo2.x = HXP.camera.x;
					golo2.y = HXP.camera.y;
				}
				if (gemlaede.name == "scully") {

					golo3_3.play("2");
					golo3.layer = -4999;
					golo3.x = HXP.camera.x;
					golo3.y = HXP.camera.y;
				}
				if (gemlaede.name == "dunkel") {

					golo4_4.play("2");
					golo4.layer = -4999;
					golo4.x = HXP.camera.x;
					golo4.y = HXP.camera.y;
				}
			}
		}
		else {

			//hiding the paintings again
			golo0.layer = 5000;
			golo1.layer = 5000;
			golo2.layer = 5000;
			golo3.layer = 5000;
			golo4.layer = 5000;
		}
	}

	private function menu() {

		hintergrund.play("normal");
		staubsprite.play("flow");
		title.play("blinz");

		menuauswahl();
	}

	private function kischte() {

		/**
		 * Schatten der Kiste bei Beginn
		 */
		if (schattendealy > 5.5 && schattendealy <= 6) {

			schattendealy -= HXP.elapsed;
		}
		else if (schattendealy <= 5.5 && schattendealy > 4) {

			add(new Sprechblase(2880, 1845, 1, 2));
			schattendealy = 4;
		}
		else if (schattendealy > 3 && schattendealy <= 4) {

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed()) {

					schattendealy = 3;
				}
			}
			else if (Input.pressed(Key.ANY)) {

				schattendealy = 3;
			}
		}
		else if (schattendealy <= 3 && schattendealy > 0) {

			schattendealy -= HXP.elapsed;
			kistenschatten.alpha = schattendealy / 3;
		}
		else if (schattendealy <= 0 && schattendealy > -1) {

			schattendealy -= HXP.elapsed;
			kistenschatten.alpha = 0;

			if (!itmadded) {

				inthemiddle.loop(0.3);
				itmadded = true;
			}
		}
		else { schattendealy = -1; }


		if (kisteready && schattendealy == -1) {

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed()) {

					kistestart = true;
					kisteready = false;
				}
			}
			else if (Input.pressed(Key.ANY)) {

				kistestart = true;
				kisteready = false;
			}
		}
	}

	public function transformation() {

		if (_mori != null && _mori.hoerdauer >= 6 && !_mori.genuggehoert) {

			if (G.current == 0) {

				//remove
				remove(_mori);

				//add the new
				if (Std.string(_mori.erzaehler[0]) == "entitaeten.schatten.Groz") {					// _mori.erzaehler[0] == Groz 	would be more elegant, but doenst work. rework?

					G.gros = new Point(_mori.x, _mori.y);

					_grozi = new Grozi(_mori.x, _mori.y);
					add(_grozi);
					G.current = 1;
					++G.mlvl;

					_mensch = new Mensch(G.beginpt.x, G.beginpt.y - 10);
					add(_mensch);

					_mori.genuggehoert = true;
				}
				else if (Std.string(_mori.erzaehler[0]) == "entitaeten.schatten.Uggel") {					// _mori.erzaehler[0] == Groz 	would be more elegant, but doenst work. rework?

					_mori = new Mori(_mori.x, _mori.y);
					add(_mori);
					G.current = 0;
					++G.mlvl;

					_mori.genuggehoert = true;
				}
			}

			for (i in 0..._mori.erzaehler.length) {
				_mori.erzaehler.remove(_mori.erzaehler[i]);
			}
		}
		else if (_grozi != null && _grozi.hoerdauer >= 6 && !_grozi.genuggehoert) {

			if (G.current == 1) {

				//remove
				remove(_grozi);

				//den kistenschatten zuhören
				//grozi to mori
				if (Std.string(_grozi.erzaehler[0]) == "entitaeten.schatten.Mensch") {

					_mori = new Mori(_grozi.x, _grozi.y);
					add(_mori);
					G.current = 0;
					++G.mlvl;

					remove(_mensch);

					_grozi.genuggehoert = true;
				}
				//add the new
				else if (Std.string(_grozi.erzaehler[0]) == "entitaeten.schatten.Uggel") {					// _mori.erzaehler[0] == Groz 	would be more elegant, but doenst work. rework?

					_mori = new Mori(_grozi.x, _grozi.y);
					add(_mori);
					G.current = 0;
					++G.mlvl;

					remove(_mensch);

					_grozi.genuggehoert = true;
				}
				else if (Std.string(_grozi.erzaehler[0]) == "entitaeten.schatten.Groz") {					// _mori.erzaehler[0] == Groz 	would be more elegant, but doenst work. rework?

					G.gros = new Point(_grozi.x, _grozi.y);

					_grozi = new Grozi(_grozi.x, _grozi.y);
					add(_grozi);
					G.current = 1;
					++G.mlvl;

					_grozi.genuggehoert = true;
				}
			}

			for (i in 0..._grozi.erzaehler.length) {
				_grozi.erzaehler.remove(_grozi.erzaehler[i]);
			}
		}
	}

	public function sichtfeld() {

		//applying
		sichttraeger.graphic = sichtfelder;

		//position
		sichttraeger.x = HXP.camera.x -1;
		sichttraeger.y = HXP.camera.y -1;

		// position der rationbalken
		bal1.x = HXP.camera.x;
		bal1.y = HXP.camera.y;
		bal2.x = HXP.camera.x;
		bal2.y = HXP.camera.y;
		bal3.x = HXP.camera.x + 640;
		bal3.y = HXP.camera.y;
		bal4.x = HXP.camera.x;
		bal4.y = HXP.camera.y + 400;

		//changing
		if (G.mlvl == 2 && sichtfelder != s22 && sichtfelder != s23) { sichtfelder = s21; }
		if (G.mlvl == 3 && sichtfelder != s42 && sichtfelder != s43) { sichtfelder = s41; }			// 4
		if (G.mlvl == 4 && sichtfelder != s62 && sichtfelder != s63) { sichtfelder = s61; }			// 6
		if (G.mlvl == 5 && sichtfelder != s82 && sichtfelder != s83) { sichtfelder = s81; }			// 8
		if (G.mlvl == 6 && sichtfelder != s102 && sichtfelder != s103) { sichtfelder = s101; }		// 10
		if (G.mlvl == 7 && sichtfelder != s122 && sichtfelder != s123) { sichtfelder = s121; }		// 12
		if (G.mlvl == 8 && sichtfelder != s132 && sichtfelder != s133) { sichtfelder = s131; }		// 13

		//letztes blinzeln
		if (G.mlvl <= 1) {

			sichtfelder = s11blinz;
			s11blinz.play("blink");
		}

		//flickering
		lichtzaehler -= HXP.elapsed;

		//setting the interval
		if (G.current == 0 && _mori != null) {

			if (G.sitzt) { bescopy = 1; }
			else if (_mori.steht) { bescopy = 1.3; }
			else if (flying != null && flying.active) { bescopy = 2; }
			else if (_mori.ren == 1.9) { bescopy = 3; }
			else if (_mori.ren == 1 ) { bescopy = 2.7; }
		}
		else if (G.current == 1 && _grozi != null) {

			if (G.sitzt) { bescopy = 1; }
			else if (_grozi.steht) { bescopy = 1.3; }
			else if (flying != null && flying.active) { bescopy = 2.5; }
			else if (_grozi.ren == 1.9) { bescopy = 3.1; }
			else if (_grozi.ren == 1 ) { bescopy = 2.9; }
		}

		if (lichtzaehler <= bescopy) {

		//	if		(sichtfelder == s11) { sichtfelder = s12; lichtzaehler = 3.2; }
		//	else if	(sichtfelder == s12) { sichtfelder = s13; lichtzaehler = 3.2; }
		//	else if	(sichtfelder == s13) { sichtfelder = s11; lichtzaehler = 3.2; }
			if		(sichtfelder == s21) { sichtfelder = s22; lichtzaehler = 3.2; }
			else if	(sichtfelder == s22) { sichtfelder = s23; lichtzaehler = 3.2; }
			else if	(sichtfelder == s23) { sichtfelder = s21; lichtzaehler = 3.2; }
			else if	(sichtfelder == s31) { sichtfelder = s32; lichtzaehler = 3.2; }
			else if	(sichtfelder == s32) { sichtfelder = s33; lichtzaehler = 3.2; }
			else if	(sichtfelder == s33) { sichtfelder = s31; lichtzaehler = 3.2; }
			else if	(sichtfelder == s41) { sichtfelder = s42; lichtzaehler = 3.2; }
			else if	(sichtfelder == s42) { sichtfelder = s43; lichtzaehler = 3.2; }
			else if	(sichtfelder == s43) { sichtfelder = s41; lichtzaehler = 3.2; }
			else if	(sichtfelder == s51) { sichtfelder = s52; lichtzaehler = 3.2; }
			else if	(sichtfelder == s52) { sichtfelder = s53; lichtzaehler = 3.2; }
			else if	(sichtfelder == s53) { sichtfelder = s51; lichtzaehler = 3.2; }
			else if	(sichtfelder == s61) { sichtfelder = s62; lichtzaehler = 3.2; }
			else if	(sichtfelder == s62) { sichtfelder = s63; lichtzaehler = 3.2; }
			else if	(sichtfelder == s63) { sichtfelder = s61; lichtzaehler = 3.2; }
			else if	(sichtfelder == s71) { sichtfelder = s72; lichtzaehler = 3.2; }
			else if	(sichtfelder == s72) { sichtfelder = s73; lichtzaehler = 3.2; }
			else if	(sichtfelder == s73) { sichtfelder = s71; lichtzaehler = 3.2; }
			else if	(sichtfelder == s81) { sichtfelder = s82; lichtzaehler = 3.2; }
			else if	(sichtfelder == s82) { sichtfelder = s83; lichtzaehler = 3.2; }
			else if	(sichtfelder == s83) { sichtfelder = s81; lichtzaehler = 3.2; }
			else if	(sichtfelder == s91) { sichtfelder = s92; lichtzaehler = 3.2; }
			else if	(sichtfelder == s92) { sichtfelder = s93; lichtzaehler = 3.2; }
			else if	(sichtfelder == s93) { sichtfelder = s91; lichtzaehler = 3.2; }
			else if	(sichtfelder == s101) { sichtfelder = s102; lichtzaehler = 3.2; }
			else if	(sichtfelder == s102) { sichtfelder = s103; lichtzaehler = 3.2; }
			else if	(sichtfelder == s103) { sichtfelder = s101; lichtzaehler = 3.2; }
			else if	(sichtfelder == s111) { sichtfelder = s112; lichtzaehler = 3.2; }
			else if	(sichtfelder == s112) { sichtfelder = s113; lichtzaehler = 3.2; }
			else if	(sichtfelder == s113) { sichtfelder = s111; lichtzaehler = 3.2; }
			else if	(sichtfelder == s121) { sichtfelder = s122; lichtzaehler = 3.2; }
			else if	(sichtfelder == s122) { sichtfelder = s123; lichtzaehler = 3.2; }
			else if	(sichtfelder == s123) { sichtfelder = s121; lichtzaehler = 3.2; }
			else if	(sichtfelder == s131) { sichtfelder = s132; lichtzaehler = 3.2; }
			else if	(sichtfelder == s132) { sichtfelder = s133; lichtzaehler = 3.2; }
			else if	(sichtfelder == s133) { sichtfelder = s131; lichtzaehler = 3.2; }
		}
	}

	public function kamera():Void {

		if (flying != null && flying.active) {							// if no one to control is there

			HXP.camera.x = flying.x - 640 * 0.5;
			HXP.camera.y = flying.y - 400 * 0.5;
		}
		else if (_mori != null && G.current == 0) {						// if its mori who's there

			HXP.camera.x = _mori.x - 640 * 0.5;
			HXP.camera.y = _mori.y - 400 * 0.5;
		}
		else if (_grozi != null && G.current == 1) {					// if its _grozi who's there

			HXP.camera.x = _grozi.x - 640 * 0.5;
			HXP.camera.y = _grozi.y - 400 * 0.5;
		}
	}

	private function kamerafahrt():Void {

		if (kamerastart) {

			if (G.current == 0) {								// last one was mori

				flying = new LinearMotion(kameraende, TweenType.OneShot);
				flying.setMotion(_mori.x, _mori.y, G.mos.x, G.mos.y, 10, Ease.quadInOut);
				addTween(flying, true);
				kamerastart = false;
				kuerzerleben = true;
			}
			else if (G.current == 1) { 							// last one was grozi

				flying = new LinearMotion(kameraende, TweenType.OneShot);
				flying.setMotion(_grozi.x, _grozi.y, G.gros.x, G.gros.y, 10, Ease.quadInOut);
				addTween(flying, true);
				kamerastart = false;
				kuerzerleben = true;
			}
		}
	}

	private function kameraende(_:Dynamic) {

		if (G.current == 0) {
			_mori = new Mori(G.mos.x, G.mos.y);
			add(_mori);
		}
		else if (G.current == 1) {
			_grozi = new Grozi(G.gros.x, G.gros.y);
			add(_grozi);
		}

		kuerzerleben = false;
	}

	public function faust():Void {

		// Mori
		if (_mori != null && G.current == 0) {

			if (_mori.angreifen != 0) {

			//	add(_faust);

				if (_mori.angreifen == 1) { _faust.x = _mori.x - 15; _faust.y = _mori.y - 25; }
				else if (_mori.angreifen == 2) { _faust.x = _mori.x-5; _faust.y = _mori.y - 15; }
				else if (_mori.angreifen == 3) { _faust.x = _mori.x - 15; _faust.y = _mori.y-5; }
				else if (_mori.angreifen == 4) { _faust.x = _mori.x - 25; _faust.y = _mori.y - 15; }
			}
			else if (_faust != null) { remove(_faust); }
		}
	}

	private function loadMap(oelpath:String, bild:String) {

		//get the XML in 	//switched to main
		mapXML = Xml.parse(Assets.getText(oelpath));
		//create a Fast of it
		var map = new Fast(mapXML.firstElement());

		//get the bg image ready
		var image:Image = new Image(bild);
		image.smooth = false;

		// now going for the grid mask
		mapGrid = new Grid(Std.parseInt(map.att.width), Std.parseInt(map.att.height), 16, 16, 0, 0);
		mapGrid.loadFromString(map.node.solid.innerData, "", "\n");

		//and applying it to the background entity
		welt = new Entity(0, 0, image, mapGrid);
		welt.name = "welt";
		welt.type = "solid";
		welt.layer = 2000;
		add(welt);
	}

	private function lebenszeit() {

		G.lifeclock += HXP.elapsed;

		if (G.lifeclock > 240 && G.lifeclock <= 480) { G.epoche = 1; }
		else if (G.lifeclock > 480 && G.lifeclock <= 720) { G.epoche = 2; }
		else if (G.lifeclock > 720 && G.lifeclock <= 960) { G.epoche = 3; }
		else if (G.lifeclock > 960 && G.lifeclock <= G.maxlife) { G.epoche = 4; }


		//für die kamerfahrt
		if (kuerzerleben) {

			G.lifeclock += HXP.elapsed * 2;
		}
	}

	private function loadSchatten() {

		add(new Groz(518, 592));
		add(new Groz(1300, 566));
		add(new Groz(1014, 892));
		add(new Groz(1463, 1553));
		add(new Groz(1044, 1940));
		add(new Groz(1262, 2136));
		add(new Groz(1942, 1597));
		add(new Groz(2509, 1721));
		add(new Groz(2094, 2098));
		add(new Groz(1966, 2326));
		add(new Groz(2733, 2325));
	}

	/**
	 * Augenschlag AUF.
	 * Callback für Weltenwechsel, Auge.
	 */
	private function augeAUF() {

		remove(auge);
		zwinker.callbackFunc = null;

		//für spielstart
		if (G.pauseState == 0) { kisteready = true; }

		//für pausenmenu
		else if (G.pauseState > 1 && G.pauseState != 4) {

			G.pauseState = 1;

			for (i in 0...alles.length) {

				alles[i].active = true;
			}

			alles = new Array();

			keinebilder = false;
		}
	}

	/**
	 * Augenschlag ZU.
	 * Callback für Weltenwechsel, Auge.
	 */
	private function augeZU() {

		//Aus dem Schädel ins menu
		if (ende) {

			//kein schatten am anfang
			G.erstesmal = true;

			//current
			G.current = 0;

			//lvl
			G.mlvl = 5;

			//neue kiste
			G.kiste2pool = false;

			//not sure, aber global bool
			G.lyready = false;
			G.schwebt = false;
			G.newborn = 8;

			//refresh the state
			G.pauseState = 0;

			//alter resetten
			G.lifeclock = 0;
			G.humus = false;
			G.epoche = 0;

			HXP.scene = new Menu();

			//stop music
			inthemiddle.stop();
		}

		//Aus dem Game raus
		else if (G.pauseState <= 1) {

			//entitaeten reinladen
			setupMenu();

			//stop sound
			inthemiddle.stop();

			//damit das auge wieder aufgeht, ohne callback
			zwinker.callbackFunc = augeAUF;
			augzu = false;

			//menu state
			G.pauseState = 4;

			//RUNDGANG
			if (!rundgangshebel) {

				rundgangshebel = true;
			}
		}

		//ins Game zurück
		else if (G.pauseState == 2) {

			//hopefully continue sound
			if (itmadded && !inthemiddle.playing) { inthemiddle.resume(); }

			for (i in 0...allesmenu.length) {

				remove(allesmenu[i]);
			}

			allesmenu = new Array();

			zwinker.callbackFunc = augeAUF;
			augzu = false;
		}

		//neues Game
		else if (G.pauseState == 3) {

			//kein schatten am anfang
			G.erstesmal = true;

			//current
			G.current = 0;

			//lvl
			G.mlvl = 5;

			//neue kiste
			G.kiste2pool = false;

			//not sure, aber global bool
			G.lyready = false;
			G.schwebt = false;
			G.newborn = 8;

			//refresh the state
			G.pauseState = 0;

			//alter resetten
			G.lifeclock = 0;
			G.humus = false;
			G.epoche = 0;

			//stop music
			inthemiddle.stop();

			HXP.scene = new Mutterwelt();
		}

		//total end
		else if (G.pauseState == 6) {

			#if (flash || html5)
			System.exit(1);
			#else
			Sys.exit(1);
			#end
		}

		//HXP.scene = new Menu();
		//Wieder rein, nach dem Rungang
	}

	/**
	 * Callback für Neues Spiel Button im Menu.
	 * // Leitet keinen Augenschlag ein!
	 */
	private function neuesGame() {

		G.pauseState = 3;

		add(auge);
		zwinker.callbackFunc = augeZU;
		augzu = true;
	}

	/**
	 * Callback für Spielfortsetzung im Menu.
	 * // Leitet keinen Augenschlag ein!
	 */
	private function continueGame() {

		G.pauseState = 2;

		add(auge);
		zwinker.callbackFunc = augeZU;
		augzu = true;
	}

	/**
	 * Callback for ending the game.
	 */
	private function endeGame() {

		G.pauseState = 6;

		add(auge);
		zwinker.callbackFunc = augeZU;
		augzu = true;
	}

	private function loadEntities() {

		// malerei
			//0
			daddymommy = new Entity(2882, 1842);
			daddymommy.setHitbox(100, 50);
			daddymommy.type = "mal";
			daddymommy.name = "home";
			add(daddymommy);
			golo0 = new Entity(0, 0, golo0_0);
			golo0.layer = 5000;
			golo0_0.add("1", [1, 3, 5], 10);
			golo0_0.add("2", [0, 2, 4], 10);
			add(golo0);
			//1
			striche = new Entity(1846, 1265);
			striche.setHitbox(120, 90);
			striche.type = "mal";
			striche.name = "strich";
			add(striche);
			golo1 = new Entity(0, 0, golo1_1);
			golo1.layer = 5000;
			golo1_1.add("1", [6, 7, 8], 10);
			golo1_1.add("2", [0, 1, 2, 3, 4, 5], 10);
			add(golo1);
			//2
			maulwurf = new Entity(1445, 2327);
			maulwurf.setHitbox(40, 40);
			maulwurf.type = "mal";
			maulwurf.name = "maul";
			add(maulwurf);
			golo2 = new Entity(0, 0, golo2_2);
			golo2.layer = 5000;
			golo2_2.add("2", [0, 2, 4], 10);
			golo2_2.add("1", [1, 3, 5], 10);
			add(golo2);
			//3
			scully = new Entity(1470, 547);
			scully.setHitbox(260, 150);
			scully.type = "mal";
			scully.name = "scully";
			add(scully);
			golo3 = new Entity(0, 0, golo3_3);
			golo3.layer = 5000;
			golo3_3.add("2", [0, 2, 4], 10);
			golo3_3.add("1", [1, 3, 5], 10);
			add(golo3);
			//4
			dunkelwesen = new Entity(1609, 1210);
			dunkelwesen.setHitbox(65, 40);
			dunkelwesen.type = "mal";
			dunkelwesen.name = "dunkel";
			add(dunkelwesen);
			golo4 = new Entity(0, 0, golo4_4);
			golo4.layer = 5000;
			golo4_4.add("1", [1, 3, 5], 10);
			golo4_4.add("2", [0, 2, 4, 2], 10);
			add(golo4);


		// GRIDIES

			kiefer = new Entity(1494, 544);
			kiefer.setHitbox(42, 32,0,0);
			kiefer.type = "interesting";
			add(kiefer);

			astoben = new Entity(1456, 1013);
			astoben.setHitbox(176, 32, 0, 0);
			astoben.type = "pure";
			add(astoben);

			astunten = new Entity(1425, 1040);
			astunten.setHitbox(176, 128, 0, 0);
			astunten.type = "pure";
			add(astunten);

			astunten2 = new Entity(1489, 1168);
			astunten2.setHitbox(100, 16, 0, 0);
			astunten2.type = "pure";
			add(astunten2);

		// SICHTFELD

			sichtfelder = s81;
			sichttraeger = new Entity(0, 0, sichtfelder);
			sichttraeger.layer = -5000;
			add(sichttraeger);

			s11blinz.callbackFunc = augeZU;
			s11blinz.add("blink", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,17,17,17,17,17,17,17,17,17,17,17,17,17], 10, false);

		// TRANSITION

		auge = new Entity(0, 0, zwinker);
		zwinker.add("auf", [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 13, false);
		zwinker.add("zu", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 13, false);

		zwinker.callbackFunc = augeAUF;
		auge.layer = -8000;
		add(auge);

		// M AP
			ast = new Entity(1458, 2683, astIMG);
			astIMG.originY = astIMG.height;
			ast.layer = Std.int( -ast.y);
			add(ast);

			baum1 = new Entity(1587, 1206, baum1IMG);
			baum1IMG.originX = 400;
			baum1IMG.originY = 380;
			baum1.layer = Std.int( -baum1.y);
			add(baum1);

			baum2 = new Entity(1388, 1165, baum2IMG);
			baum2IMG.originY = 178;
			baum2.layer = Std.int( -baum2.y);
			add(baum2);

			monifix = new Entity(1442, 1016, monifixIMG);
			monifix.layer = -4000;
			add(monifix);

			baum1bruch = new Entity(2265, 1623, baum1bruchIMG);
			baum1bruchIMG.originX = baum1bruchIMG.width * 0.5;
			baum1bruchIMG.originY = baum1bruchIMG.height;
			baum1bruch.layer = Std.int( -baum1bruch.y);
			add(baum1bruch);

			baum1bruch2 = new Entity(3382, 2017, baum1bruch2IMG);
			baum1bruch2IMG.originX = baum1bruch2IMG.width * 0.5;
			baum1bruch2IMG.originY = baum1bruch2IMG.height;
			baum1bruch2.layer = Std.int( -(baum1bruch2.y - 5));
			add(baum1bruch2);

			baum1bruch3 = new Entity(2299, 1423, baum1bruch3IMG);
			baum1bruch3IMG.originX = baum1bruch3IMG.width * 0.5;
			baum1bruch3IMG.originY = baum1bruch3IMG.height;
			baum1bruch3.layer = Std.int( -(baum1bruch3.y + 50));
			add(baum1bruch3);

			pas_1 = new Entity(2327, 2027, pas_1IMG);
			pas_1IMG.originX = pas_1IMG.width * 0.5;
			pas_1IMG.originY = pas_1IMG.height;
			pas_1.layer = Std.int( -pas_1.y);
			add(pas_1);

			pas0 = new Entity(2827, 2033, pas0IMG);
			pas0IMG.originX = pas0IMG.width * 0.5;
			pas0IMG.originY = pas0IMG.height;
			pas0.layer = Std.int( -pas0.y);
			add(pas0);

			pas1 = new Entity(2779, 1688, pas1IMG);
			pas1IMG.originX = pas1IMG.width * 0.5;
			pas1IMG.originY = pas1IMG.height;
			pas1.layer = Std.int( -pas1.y);
			add(pas1);

			pas2 = new Entity(2642, 1780, pas2IMG);
			pas2IMG.originX = pas2IMG.width * 0.5;
			pas2IMG.originY = pas2IMG.height;
			pas2.layer = Std.int( -pas2.y);
			add(pas2);

			pas3 = new Entity(2535, 1588, pas3IMG);
			pas3IMG.originX = pas3IMG.width * 0.5;
			pas3IMG.originY = pas3IMG.height;
			pas3.layer = Std.int( -pas3.y);
			add(pas3);

			pas4 = new Entity(2122, 1665, pas4IMG);
			pas4IMG.originX = pas4IMG.width * 0.5;
			pas4IMG.originY = pas4IMG.height;
			pas4.layer = Std.int( -pas4.y);
			add(pas4);

			pas5 = new Entity(2010, 1959, pas5IMG);
			pas5IMG.originX = pas5IMG.width * 0.5;
			pas5IMG.originY = pas5IMG.height;
			pas5.layer = Std.int( -pas5.y);
			add(pas5);

			pas6 = new Entity(2930, 2340, pas6IMG);
			pas6IMG.originX = pas6IMG.width * 0.5;
			pas6IMG.originY = pas6IMG.height;
			pas6.layer = Std.int( -pas6.y);
			add(pas6);

			pas7 = new Entity(2702, 2185, pas7IMG);
			pas7IMG.originX = pas7IMG.width * 0.5;
			pas7IMG.originY = pas7IMG.height;
			pas7.layer = Std.int( -pas7.y);
			add(pas7);

			pas8 = new Entity(2552, 2411, pas8IMG);
			pas8IMG.originX = pas8IMG.width * 0.5;
			pas8IMG.originY = pas8IMG.height;
			pas8.layer = Std.int( -pas8.y);
			add(pas8);

			pas9 = new Entity(2296, 2523, pas9IMG);
			pas9IMG.originX = pas9IMG.width * 0.5;
			pas9IMG.originY = pas9IMG.height;
			pas9.layer = Std.int( -pas9.y);
			add(pas9);

			pas10 = new Entity(1881, 2611, pas10IMG);
			pas10IMG.originX = pas10IMG.width * 0.5;
			pas10IMG.originY = pas10IMG.height;
			pas10.layer = Std.int( -pas10.y);
			add(pas10);

			karott1 = new Entity(2043, 1491, karott1IMG);
			karott1IMG.originX = karott1IMG.width * 0.5;
			karott1IMG.originY = karott1IMG.height;
			karott1.layer = Std.int( -karott1.y);
			add(karott1);

			karott2 = new Entity(2173, 2284, karott2IMG);
			karott2IMG.originX = karott2IMG.width * 0.5;
			karott2IMG.originY = karott2IMG.height;
			karott2.layer = Std.int( -karott2.y);
			add(karott2);

			karott3 = new Entity(2056, 2489, karott3IMG);
			karott3IMG.originX = karott3IMG.width * 0.5;
			karott3IMG.originY = karott3IMG.height;
			karott3.layer = Std.int( -karott3.y);
			add(karott3);

			karott4 = new Entity(1777, 2440, karott4IMG);
			karott4IMG.originX = karott4IMG.width * 0.5;
			karott4IMG.originY = karott4IMG.height;
			karott4.layer = Std.int( -karott4.y);
			add(karott4);

			karto1 = new Entity(2393, 1689, karto1IMG);
			karto1IMG.originX = karto1IMG.width * 0.5;
			karto1IMG.originY = karto1IMG.height;
			karto1.layer = Std.int( -karto1.y);
			add(karto1);

			karto3 = new Entity(2252, 1821, karto3IMG);
			karto3IMG.originX = karto3IMG.width * 0.5;
			karto3IMG.originY = karto3IMG.height;
			karto3.layer = Std.int( -karto3.y);
			add(karto3);

			karto4 = new Entity(2458, 1916, karto4IMG);
			karto4IMG.originX = karto4IMG.width * 0.5;
			karto4IMG.originY = karto4IMG.height;
			karto4.layer = -Std.int( karto4.y - 26 );
			add(karto4);

			loew1 = new Entity(2570, 1642, loew1IMG);
			loew1IMG.originX = loew1IMG.width * 0.5;
			loew1IMG.originY = loew1IMG.height;
			loew1.layer = Std.int( -loew1.y);
			add(loew1);

			loew2 = new Entity(2359, 2125, loew2IMG);
			loew2IMG.originX = loew2IMG.width * 0.5;
			loew2IMG.originY = loew2IMG.height;
			loew2.layer = Std.int( -loew2.y);
			add(loew2);

			loew3 = new Entity(2380, 2140, loew3IMG);
			loew3IMG.originX = loew3IMG.width * 0.5;
			loew3IMG.originY = loew3IMG.height;
			loew3.layer = Std.int( -loew3.y);
			add(loew3);

			loew4 = new Entity(2102, 2379, loew4IMG);
			loew4IMG.originX = loew4IMG.width * 0.5;
			loew4IMG.originY = loew4IMG.height;
			loew4.layer = Std.int( -loew4.y);
			add(loew4);

			stein1 = new Entity(3068, 1840, stein1IMG);
			stein1IMG.originX = stein1IMG.width * 0.5;
			stein1IMG.originY = stein1IMG.height;
			stein1.layer = Std.int( -stein1.y);
			add(stein1);

			// new
			zahn = new Entity(1514, 637, zahnIMG);
			zahnIMG.originY = zahnIMG.height - 2;
			zahn.layer = Std.int( -zahn.y);
			add(zahn);

			stein2 = new Entity(1418, 2703, stein2IMG);
			stein2IMG.originY = stein2IMG.height;
			stein2.layer = Std.int( -stein2.y);
			add(stein2);

			pas11 = new Entity(1470, 1420, pas7IMG);
			pas11.layer = Std.int( -pas11.y);
			add(pas11);

			pas_6 = new Entity(889, 545, pas6IMG);
			pas_6.layer = Std.int( -pas_6.y);
			add(pas_6);

			pas12 = new Entity(1907, 873, pas2IMG);
			pas12.layer = Std.int( -pas12.y);
			add(pas12);

			karott5 = new Entity(1720, 1388, karott3IMG);
			karott5.layer = Std.int( -karott5.y);
			add(karott5);

			karott6 = new Entity(716, 756, karott4IMG);
			karott6.layer = Std.int( -karott6.y);
			add(karott6);

			astwest = new Entity(620, 2967, astwestIMG);
			astwestIMG.originY = astwestIMG.height;
			astwest.layer = Std.int( -astwest.y);
			add(astwest);

			knochen12 = new Entity(1458, 2207, knochen12IMG);
			knochen12IMG.originY = knochen12IMG.height;
			knochen12.layer = Std.int( -knochen12.y);
			add(knochen12);

			knochen11 = new Entity(1362, 2236, knochen11IMG);
			knochen11IMG.originY = knochen11IMG.height;
			knochen11.layer = Std.int( -knochen11.y);
			add(knochen11);

			knochen10 = new Entity(1790, 2140, knochen10IMG);
			knochen10IMG.originY = knochen10IMG.height;
			knochen10.layer = Std.int( -knochen10.y);
			add(knochen10);

			knochen9_11 = new Entity(1276, 2021, knochen9_11IMG);
			knochen9_11IMG.originY = knochen9_11IMG.height - 16;
			knochen9_11.layer = Std.int( -knochen9_11.y);
			add(knochen9_11);

			knochen9_12 = new Entity(1394, 2012, knochen9_12IMG);
			knochen9_12IMG.originY = knochen9_12IMG.height - 25;
			knochen9_12.layer = Std.int( -knochen9_12.y);
			add(knochen9_12);

			knochen9_2 = new Entity(1409, 1977, knochen9_2IMG);
			knochen9_2IMG.originY = knochen9_2IMG.height - 16;
			knochen9_2.layer = Std.int( -knochen9_2.y);
			add(knochen9_2);

			knochen8 = new Entity(2323, 1790, knochen8IMG);
			knochen8IMG.originY = knochen8IMG.height;
			knochen8.layer = Std.int( -knochen8.y);
			add(knochen8);

			knochen7 = new Entity(926, 1882, knochen7IMG);
			knochen7IMG.originY = knochen7IMG.height;
			knochen7.layer = Std.int( -knochen7.y);
			add(knochen7);

			knochen6 = new Entity(1625, 1666, knochen6IMG);
			knochen6IMG.originY = knochen6IMG.height;
			knochen6.layer = Std.int( -knochen6.y);
			add(knochen6);

			knochen5_1 = new Entity(1632, 825, knochen5_1IMG);
			knochen5_1IMG.originY = knochen5_1IMG.height;
			knochen5_1.layer = Std.int( -knochen5_1.y);
			add(knochen5_1);

			knochen5_2 = new Entity(1693, 873, knochen5_2IMG);
			knochen5_2IMG.originY = knochen5_2IMG.height;
			knochen5_2.layer = Std.int( -knochen5_2.y);
			add(knochen5_2);

			knochen5_3 = new Entity(1744, 944, knochen5_3IMG);
			knochen5_3IMG.originY = knochen5_3IMG.height;
			knochen5_3.layer = Std.int( -knochen5_3.y);
			add(knochen5_3);

			knochen4 = new Entity(1075, 766, knochen4IMG);
			knochen4IMG.originY = knochen4IMG.height;
			knochen4.layer = Std.int( -knochen4.y);
			add(knochen4);

			knochen3 = new Entity(894, 791, knochen3IMG);
			knochen3IMG.originY = knochen3IMG.height + 64;
			knochen3.layer = Std.int( -knochen3.y);
			add(knochen3);

			knochen1 = new Entity(503, 466, knochen1IMG);
			knochen1IMG.originY = knochen1IMG.height;
			knochen1.layer = Std.int( -knochen1.y);
			add(knochen1);

			schaedel = new Entity(1443, 535, schaedelIMG);
			schaedelIMG.originY = schaedelIMG.height;
			schaedel.layer = Std.int( -schaedel.y);
			add(schaedel);

			schaedel2 = new Entity(1477, 513, schaedel2IMG);
			schaedel2IMG.originY = schaedel2IMG.height;
			schaedel2.layer = Std.int( -schaedel2.y);
			add(schaedel2);

			schaedel3 = new Entity(1547, 615, schaedel3IMG);
			schaedel3IMG.originY = schaedel3IMG.height;
			schaedel3.layer = Std.int( -schaedel3.y);
			add(schaedel3);

			westfels_pas = new Entity(1176, 1879, westfels_pasIMG);
			westfels_pasIMG.originY = westfels_pasIMG.height;
			westfels_pas.layer = Std.int( -westfels_pas.y);
			add(westfels_pas);

			westfels_oben = new Entity(349, 1241, westfels_obenIMG);
			westfels_obenIMG.originY = westfels_obenIMG.height - 10;
			westfels_oben.layer = Std.int( -westfels_oben.y);
			add(westfels_oben);

			loch1 = new Entity(1443, 1169, loch1IMG);
			loch1IMG.originY = loch1IMG.height + 50;
			loch1.layer = Std.int( -loch1.y);
			add(loch1);

			loch2 = new Entity(1463, 1169, loch2IMG);
			loch2IMG.originY = loch2IMG.height + 48;
			loch2.layer = Std.int( -loch2.y);
			add(loch2);

			loch3 = new Entity(1483, 1171, loch3IMG);
			loch3IMG.originY = loch3IMG.height + 44;
			loch3.layer = Std.int( -loch3.y);
			add(loch3);

			loch4 = new Entity(1503, 1178, loch4IMG);
			loch4IMG.originY = loch4IMG.height + 44;
			loch4.layer = Std.int( -loch4.y);
			add(loch4);

			loch5 = new Entity(1523, 1192, loch5IMG);
			loch5IMG.originY = loch5IMG.height + 49;
			loch5.layer = Std.int( -loch5.y);
			add(loch5);

			loch6 = new Entity(1543, 1192, loch6IMG);
			loch6IMG.originY = loch6IMG.height + 37;
			loch6.layer = Std.int( -loch6.y);
			add(loch6);

			loch7 = new Entity(1563, 1192, loch7IMG);
			loch7IMG.originY = loch7IMG.height - 5;
			loch7.layer = Std.int( -loch7.y);
			add(loch7);

			flicken = new Entity(1380,1048, flickeIMG);
			flicken.layer = -4000;
			add(flicken);

			//animiert
			korkoimstamm = new Entity(1633, 1151, korkoimstammIMG);
			korkoimstamm.layer = -4000;
			korkoimstammIMG.add("spuk", [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 47, 47, 47, 47, 47, 47, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 56, 56, 56, 56, 56,56, 56, 56, 56, 56, 56, 56, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65], 8, true);
			add(korkoimstamm);

			wurminpas = new Entity(1995, 1834, wurminpasIMG);
			wurminpas.layer = -4000;
			wurminpasIMG.add("krabeel", [0, 1, 2, 3, 4, 5, 6, 7], 11, true);
			add(wurminpas);

			dickie = new Entity(425, 671, dickieIMG);
			dickie.layer = -4000;
			dickieIMG.add("dd", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], 5, true);
			add(dickie);

		// KISTE

		kiste = new Entity(2816, 1781, kistenholz);
		kiste.layer = -1900;
		kistenholz.add("vorne", [0, 1, 2, 3, 4], 7, false);
		kistenholz.callbackFunc = callkiste1;
		add(kiste);

		kiste2 = new Entity(2816, 1781, kistenholz2);
		kiste2.layer = -1865;
		kistenholz2.add("hinten", [0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 7, false);
		kistenholz2.add("still", [19], 0, true);
		kistenholz2.callbackFunc = callkiste2;
		add(kiste2);

		kiste3 = new Entity(2816, 1781, kistenschatten);
		kiste3.layer = -1910;
		add(kiste3);


		// ENDE
		adieu = new Entity(1514, 495);
		adieu.type = "ende";
		adieu.setHitbox(85, 60);
		add(adieu);


		//BALKEN
		balken1 = Image.createRect(1640, 500, 0x000000); // top
		balken2 = Image.createRect(500, 1400, 0x000000); // left
		balken3 = Image.createRect(500, 1400, 0x000000); // right
		balken4 = Image.createRect(1640, 500, 0x000000); // bottom
		bal1 = new Entity(0,0, balken1);
		bal1.layer = -8000;
		balken1.originY = balken1.height;
		balken1.originX = 500;
		add(bal1);
		bal2 = new Entity(0,0, balken2);
		bal2.layer = -8000;
		balken2.originX = balken2.width;
		balken2.originY = 500;
		add(bal2);
		bal3 = new Entity(0,0, balken3);
		bal3.layer = -8000;
		balken3.originY = 500;
		add(bal3);
		bal4 = new Entity(0,0, balken4);
		bal4.layer = -8000;
		balken4.originX = 500;
		add(bal4);
	}

	private function playEntities() {

		korkoimstammIMG.play("spuk");
		wurminpasIMG.play("krabeel");
		dickieIMG.play("dd");

		//zwinkern
		if (auge != null) {

			auge.x = HXP.camera.x;
			auge.y = HXP.camera.y;

			if (!augzu) {

				zwinker.play("auf");
			}
			else {

				zwinker.play("zu");
			}
		}

		//kiste
		if (kistestart) {

			if (kiste != null) {

				kistenholz.play("vorne");
				if (kistenholz.complete && oneplay) {

					bchrb.play();
				 	oneplay = false;
				}
			}

			if (kiste2 != null) {

				if (!G.sitzt && kistezahl == 0 && !kistefade) {

					kistezahl = 1;
					kiste2.layer = 1900;
				}

				if (!G.kiste2pool) {

					kistenholz2.play("hinten");
				}
				else {

					kistenholz2.play("still");

					if (kistezahl > 0 && kistezahl <= 2 && !kistefade) {

						kistezahl += HXP.elapsed;
					}
					else if (kistezahl > 2 && !kistefade) {

						kistefade = true;
						kistezahl = 1;
					}
				}
			}
		}

		if (kistefade) {

			kistezahl -= HXP.elapsed * 0.2;
			kistenholz2.alpha = kistezahl;

			if (kistezahl <= 0) {

				remove(kiste2);
				parteytime = true;
			}
		}
	}

	private function callkiste1() {

		remove(kiste);
	}

	private function callkiste2() {

		kistenholz2.callbackFunc = null;
		G.kiste2pool = true;
	}

	private function setupMenu() {

		//graphics
		if (G.pauseState == 0) {

			hintergrund.add("normal", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78], 5, true);

			staubsprite.add("flow", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78], 5, true);

			title.add("blinz", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3], 7);
		}

		//hintergrund
		hintern = new Entity(HXP.camera.x, HXP.camera.y, hintergrund);
		hintern.layer = -6000;
		hintergrund.scale = 1.666667;
		add(hintern);

		//staubkorn vorne
		staub = new Entity(HXP.camera.x + 294, HXP.camera.y + 244, staubsprite);
		staub.layer = -6200;
		staubsprite.scale = 1.666667;
		staubsprite.alpha = 0.3;
		add(staub);

		//titel
		titi = new Entity(HXP.camera.x + (640 / 2) - (title.width * 0.5 * 1.666666667 + 12), HXP.camera.y + (400 * 0.5 - 150), title);
		titi.layer = -6100;
		title.scale = 1.666667;
		add(titi);

		//buttons
		//continue
		contButt = new Button(continueGame, null, HXP.camera.x + (640 / 2), HXP.camera.y + 400 * 0.57);
		contButt.setSpritemap("graphics/menu/continue2.png", 125, 28);
		contButt.layer = -6100;
		add(contButt);
		contButt.chosen = true;

		//new
		newButt = new Button(neuesGame, null, HXP.camera.x + (640 / 2), HXP.camera.y + 400 * 0.66);
		newButt.setSpritemap("graphics/menu/new2.png", 58, 23);
		newButt.layer = -6100;
		add(newButt);

		//end
		endButt = new Button(endeGame, null, HXP.camera.x + (640 / 2), HXP.camera.y + 400 * 0.75);
		endButt.setSpritemap("graphics/menu/end2.png", 60, 28);
		endButt.layer = -6100;
		add(endButt);


		//alle ins array
		allesmenu.push(hintern);
		allesmenu.push(staub);
		allesmenu.push(titi);
		allesmenu.push(contButt);
		allesmenu.push(newButt);
		allesmenu.push(endButt);
	}

	private function menuauswahl() {

		if (contButt.chosen || newButt.chosen || endButt.chosen) {

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) >= 0.8 || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) >= 0.8 ) {

					if (hochrunterdelay < 0.5) {

						hochrunterdelay += HXP.elapsed;

						if (hochrunterschalte) {

							einsrunter = true;
							einshoch = false;
							hochrunterschalte = false;
						}
					}
					else {

						hochrunterdelay = 0;
						hochrunterschalte = true;
					}
				}
				else if (Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) <= -0.8 || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) <= -0.8 ) {

					if (hochrunterdelay < 0.5) {

						hochrunterdelay += HXP.elapsed;

						if (hochrunterschalte) {

							einsrunter = false;
							einshoch = true;
							hochrunterschalte = false;
						}
					}
					else {

						hochrunterdelay = 0;
						hochrunterschalte = true;
					}
				}
				else {

					hochrunterdelay = 0;
					hochrunterschalte = true;
					einshoch = false;
					einsrunter = false;
				}
			}
		}

		if (contButt.chosen) {

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed(XBOX_GAMEPAD.LB_BUTTON)) {

					endButt.chosen = true;
					contButt.chosen = false;

					klindging();
				}
				else if ( Input.joystick(0).pressed(XBOX_GAMEPAD.RB_BUTTON)) { // || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == -1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == -1)  {

					contButt.chosen = false;
					newButt.chosen = true;

					klindging();
				}

				if (einshoch) {

					endButt.chosen = true;
					contButt.chosen = false;
					einshoch = false;

					klindging();
				}
				else if (einsrunter) {

					contButt.chosen = false;
					newButt.chosen = true;
					einsrunter = false;

					klindging();
				}
			}
			else if (Input.pressed("Runter")) {

				contButt.chosen = false;
				newButt.chosen = true;

				klindging();
			}
			else if (Input.pressed("Hoch")) {

				endButt.chosen = true;
				contButt.chosen = false;

				klindging();
			}
		}
		else if (newButt.chosen) {

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed(XBOX_GAMEPAD.LB_BUTTON)) {

					contButt.chosen = true;
					newButt.chosen = false;

					klindging();
				}
				else if ( Input.joystick(0).pressed(XBOX_GAMEPAD.RB_BUTTON)) { // || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == -1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == -1)  {

					newButt.chosen = false;
					endButt.chosen = true;

					klindging();
				}

				if (einshoch) {

					contButt.chosen = true;
					newButt.chosen = false;
					einshoch = false;

					klindging();
				}
				else if (einsrunter) {

					newButt.chosen = false;
					endButt.chosen = true;
					einsrunter = false;

					klindging();
				}
			}
			else if (Input.pressed("Runter")) {

				newButt.chosen = false;
				endButt.chosen = true;

				klindging();
			}
			else if (Input.pressed("Hoch")) {

				contButt.chosen = true;
				newButt.chosen = false;

				klindging();
			}
		}
		else if (endButt.chosen) {

			if (Input.joystick(0).connected) {

				if (Input.joystick(0).pressed(XBOX_GAMEPAD.LB_BUTTON)) {

					endButt.chosen = false;
					newButt.chosen = true;

					klindging();
				}
				else if ( Input.joystick(0).pressed(XBOX_GAMEPAD.RB_BUTTON)) { // || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == 1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y) == -1 || Input.joystick(0).getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) == -1)  {

					endButt.chosen = false;
					contButt.chosen = true;

					klindging();
				}

				if (einshoch) {

					newButt.chosen = true;
					endButt.chosen = false;
					einshoch = false;

					klindging();
				}
				else if (einsrunter) {

					endButt.chosen = false;
					contButt.chosen = true;
					einsrunter = false;

					klindging();
				}
			}
			else if (Input.pressed("Runter")) {

				endButt.chosen = false;
				contButt.chosen = true;

				klindging();
			}
			else if (Input.pressed("Hoch")) {

				newButt.chosen = true;
				endButt.chosen = false;

				klindging();
			}
		}
	}

	private function klindging() {

		var hoho:Float = Math.random();

		if (hoho < 0.33) 											{ but1.play(); }
		else if (hoho >= 0.33 && hoho < 0.66) { but2.play(); }
		else if (hoho >= 0.66) 								{ but3.play(); }
	}


	public var _mori:Mori = new Mori(G.mos.x, G.mos.y);		//vorher ohne :Mori bei _mori:Mori
	public var _grozi:Grozi;
	public var _faust = new Faust();
	public var _mensch:Mensch;

	//kamera
	public var kamerastart:Bool	= false;
	public var flying:LinearMotion;

	private var balken1:Image;
	private var balken2:Image;
	private var balken3:Image;
	private var balken4:Image;
	private var bal1:Entity;
	private var bal2:Entity;
	private var bal3:Entity;
	private var bal4:Entity;

	//welt
	public var mapGrid:Grid;
	public var mapXML:Xml;
	public var welt:Entity;

	//musik
	public var inthemiddle:Sfx = new Sfx("audio/OST/inthemiddle2.ogg");
	public var itmadded:Bool = false;
	private var bchrb:Sfx = new Sfx("audio/stimmen/brchb.ogg");
	private var oneplay:Bool = true;
	private var oneplay2:Bool = true;
	private var hhhh:Sfx = new Sfx("audio/stimmen/hhhhh.ogg");

	private var but1:Sfx = new Sfx("audio/stimmen/but1.ogg");
	private var but2:Sfx = new Sfx("audio/stimmen/but2.ogg");
	private var but3:Sfx = new Sfx("audio/stimmen/but3.ogg");

	//sichtfeld
	public var sichtfelder:Image;
	public var sichttraeger:Entity;
	private var bescopy:Float;
	private var gesteht:Bool = false;
	private var fleht:Bool = false;
	public var lichtzaehler:Float = 2.5;
		//groeßen
		public var s11:Image = new Image("graphics/horizont/11.png");
		public var s12:Image = new Image("graphics/horizont/12.png");
		public var s13:Image = new Image("graphics/horizont/13.png");
		public var s21:Image = new Image("graphics/horizont/21.png");
		public var s22:Image = new Image("graphics/horizont/22.png");
		public var s23:Image = new Image("graphics/horizont/23.png");
		public var s31:Image = new Image("graphics/horizont/31.png");
		public var s32:Image = new Image("graphics/horizont/32.png");
		public var s33:Image = new Image("graphics/horizont/33.png");
		public var s41:Image = new Image("graphics/horizont/41.png");
		public var s42:Image = new Image("graphics/horizont/42.png");
		public var s43:Image = new Image("graphics/horizont/43.png");
		public var s51:Image = new Image("graphics/horizont/51.png");
		public var s52:Image = new Image("graphics/horizont/52.png");
		public var s53:Image = new Image("graphics/horizont/53.png");
		public var s61:Image = new Image("graphics/horizont/61.png");
		public var s62:Image = new Image("graphics/horizont/62.png");
		public var s63:Image = new Image("graphics/horizont/63.png");
		public var s71:Image = new Image("graphics/horizont/71.png");
		public var s72:Image = new Image("graphics/horizont/72.png");
		public var s73:Image = new Image("graphics/horizont/73.png");
		public var s81:Image = new Image("graphics/horizont/81.png");
		public var s82:Image = new Image("graphics/horizont/82.png");
		public var s83:Image = new Image("graphics/horizont/83.png");
		public var s91:Image = new Image("graphics/horizont/91.png");
		public var s92:Image = new Image("graphics/horizont/92.png");
		public var s93:Image = new Image("graphics/horizont/93.png");
		public var s101:Image = new Image("graphics/horizont/101.png");
		public var s102:Image = new Image("graphics/horizont/102.png");
		public var s103:Image = new Image("graphics/horizont/103.png");
		public var s111:Image = new Image("graphics/horizont/111.png");
		public var s112:Image = new Image("graphics/horizont/112.png");
		public var s113:Image = new Image("graphics/horizont/113.png");
		public var s121:Image = new Image("graphics/horizont/121.png");
		public var s122:Image = new Image("graphics/horizont/122.png");
		public var s123:Image = new Image("graphics/horizont/123.png");
		public var s131:Image = new Image("graphics/horizont/131.png");
		public var s132:Image = new Image("graphics/horizont/132.png");
		public var s133:Image = new Image("graphics/horizont/133.png");

	//transition
	private var auge:Entity;
	public var zwinker:Spritemap = new Spritemap("graphics/menu/zwink.png", 640, 400);
	private var augzu:Bool = false;
	private var s11blinz:Spritemap = new Spritemap("graphics/horizont/blinzeln2.png", 642, 402);

	//kiste
	private var kiste:Entity;
	private var kiste2:Entity;
	private var kistenholz:Spritemap = new Spritemap("graphics/welt/kistesprite.png", 261, 177);
	private var kistenholz2:Spritemap = new Spritemap("graphics/welt/kistesprite.png", 261, 177);
	private var kistezahl:Float = 0;
	private var kistestart:Bool = false;
	private var kisteready:Bool = false;
	private var kistefade:Bool = false;
	private var schattenriegel:Bool = false;
	private var kiste3:Entity;
	private var kistenschatten:Image = new Image("graphics/welt/kisteschatten.png");
	public var schattendealy:Float = 6;

	//Pause
	private var alles:Array<Entity> = new Array();
	private var allesmenu:Array<Entity> = new Array();
	private var fillthearray:Bool = true;
	private var einsrunter:Bool = false;
	private var einshoch:Bool = false;
	private var hochrunterdelay:Float = 0;
	private var hochrunterschalte:Bool = true;

	//menu
	private var staub:Entity;
	private var staubsprite:Spritemap = new Spritemap("graphics/menu/staubvorne.png", 28, 27);
	private var hintern:Entity;
	private var hintergrund:Spritemap = new Spritemap("graphics/menu/hintern.png", 384, 240);
	private var titi:Entity;
	private var title:Spritemap = new Spritemap("graphics/menu/headersprite.png", 138, 69);
	private var contButt:Button;
	private var newButt:Button;
	private var endButt:Button;

	//Ende
	private var adieu:Entity;
	private var ende:Bool = false;
	private var faaad:Bool = false;

	//timer
	private var rundgangstimerino:Float = 0;
	private var rundgangshebel:Bool = true;

	//altern
	private var kuerzerleben:Bool = false;

	//wurm
	private var wurmpositionen:Array<Point> = new Array();
	private var parteytime:Bool = false;

	//entitäten
		//gridies
		public var kiefer:Entity;
		public var astoben:Entity;
		public var astunten:Entity;
		public var astunten2:Entity;
		//alt
		public var ast:Entity;
		public var astIMG:Image = new Image("graphics/welt/entitaeten/ast.png");
		public var baum1:Entity;
		public var baum1IMG:Image = new Image("graphics/welt/entitaeten/baum11.png");
		public var baum2:Entity;
		public var baum2IMG:Image = new Image("graphics/welt/entitaeten/baum2.png");
		public var baum1bruch:Entity;
		public var baum1bruchIMG:Image = new Image("graphics/welt/entitaeten/baum1bruch.png");
		public var baum1bruch2:Entity;
		public var baum1bruch2IMG:Image = new Image("graphics/welt/entitaeten/baum1bruch2.png");
		public var baum1bruch3:Entity;
		public var baum1bruch3IMG:Image = new Image("graphics/welt/entitaeten/baum1bruch3.png");
		public var pas_1:Entity;
		public var pas_1IMG:Image = new Image("graphics/welt/entitaeten/pas_1.png");
		public var pas0:Entity;
		public var pas0IMG:Image = new Image("graphics/welt/entitaeten/pas0.png");
		public var pas1:Entity;
		public var pas1IMG:Image = new Image("graphics/welt/entitaeten/pas1.png");
		public var pas2:Entity;
		public var pas2IMG:Image = new Image("graphics/welt/entitaeten/pas2.png");
		public var pas3:Entity;
		public var pas3IMG:Image = new Image("graphics/welt/entitaeten/pas3.png");
		public var pas4:Entity;
		public var pas4IMG:Image = new Image("graphics/welt/entitaeten/pas4.png");
		public var pas5:Entity;
		public var pas5IMG:Image = new Image("graphics/welt/entitaeten/pas5.png");
		public var pas6:Entity;
		public var pas_6:Entity;
		public var pas6IMG:Image = new Image("graphics/welt/entitaeten/pas6.png");
		public var pas7:Entity;
		public var pas7IMG:Image = new Image("graphics/welt/entitaeten/pas7.png");
		public var pas8:Entity;
		public var pas8IMG:Image = new Image("graphics/welt/entitaeten/pas8.png");
		public var pas9:Entity;
		public var pas9IMG:Image = new Image("graphics/welt/entitaeten/pas9.png");
		public var pas10:Entity;
		public var pas10IMG:Image = new Image("graphics/welt/entitaeten/pas10.png");
		public var karott1:Entity;
		public var karott1IMG:Image = new Image("graphics/welt/entitaeten/karott1.png");
		public var karott2:Entity;
		public var karott2IMG:Image = new Image("graphics/welt/entitaeten/karott2.png");
		public var karott3:Entity;
		public var karott3IMG:Image = new Image("graphics/welt/entitaeten/karott3.png");
		public var karott4:Entity;
		public var karott4IMG:Image = new Image("graphics/welt/entitaeten/karott4.png");
		public var loew1:Entity;
		public var loew1IMG:Image = new Image("graphics/welt/entitaeten/loew1.png");
		public var loew2:Entity;
		public var loew2IMG:Image = new Image("graphics/welt/entitaeten/loew2.png");
		public var loew3:Entity;
		public var loew3IMG:Image = new Image("graphics/welt/entitaeten/loew3.png");
		public var loew4:Entity;
		public var loew4IMG:Image = new Image("graphics/welt/entitaeten/loew4.png");
		public var karto1:Entity;
		public var karto1IMG:Image = new Image("graphics/welt/entitaeten/karto1.png");
		public var karto3:Entity;
		public var karto3IMG:Image = new Image("graphics/welt/entitaeten/karto3.png");
		public var karto4:Entity;
		public var karto4IMG:Image = new Image("graphics/welt/entitaeten/karto4.png");
		public var stein1:Entity;
		public var stein1IMG:Image = new Image("graphics/welt/entitaeten/stein1.png");

		//neu
		public var zahn:Entity;
		public var zahnIMG:Image = new Image("graphics/welt/entitaeten/zahn.png");
		public var stein2:Entity;
		public var stein2IMG:Image = new Image("graphics/welt/entitaeten/stein2.png");
		public var pas11:Entity;
		public var pas12:Entity;
		public var karott5:Entity;
		public var karott6:Entity;
		public var astwest:Entity;
		public var astwestIMG:Image = new Image("graphics/welt/entitaeten/astwest.png");
		public var knochen12:Entity;
		public var knochen12IMG:Image = new Image("graphics/welt/entitaeten/knochen12.png");
		public var knochen11:Entity;
		public var knochen11IMG:Image = new Image("graphics/welt/entitaeten/knochen11.png");
		public var knochen10:Entity;
		public var knochen10IMG:Image = new Image("graphics/welt/entitaeten/knochen10.png");
		public var knochen9_11:Entity;
		public var knochen9_11IMG:Image = new Image("graphics/welt/entitaeten/knochen9_11.png");
		public var knochen9_12:Entity;
		public var knochen9_12IMG:Image = new Image("graphics/welt/entitaeten/knochen9_12.png");
		public var knochen9_2:Entity;
		public var knochen9_2IMG:Image = new Image("graphics/welt/entitaeten/knochen9_2.png");
		public var knochen8:Entity;
		public var knochen8IMG:Image = new Image("graphics/welt/entitaeten/knochen8.png");
		public var knochen7:Entity;
		public var knochen7IMG:Image = new Image("graphics/welt/entitaeten/knochen7.png");
		public var knochen6:Entity;
		public var knochen6IMG:Image = new Image("graphics/welt/entitaeten/knochen6.png");
		public var knochen5_1:Entity;
		public var knochen5_1IMG:Image = new Image("graphics/welt/entitaeten/knochen5_1.png");
		public var knochen5_2:Entity;
		public var knochen5_2IMG:Image = new Image("graphics/welt/entitaeten/knochen5_2.png");
		public var knochen5_3:Entity;
		public var knochen5_3IMG:Image = new Image("graphics/welt/entitaeten/knochen5_3.png");
		public var knochen4:Entity;
		public var knochen4IMG:Image = new Image("graphics/welt/entitaeten/knochen4.png");
		public var knochen3:Entity;
		public var knochen3IMG:Image = new Image("graphics/welt/entitaeten/knochen3.png");
		public var knochen1:Entity;
		public var knochen1IMG:Image = new Image("graphics/welt/entitaeten/knochen1.png");
		public var schaedel:Entity;
		public var schaedelIMG:Image = new Image("graphics/welt/entitaeten/schaedel.png");
		public var schaedel2:Entity;
		public var schaedel2IMG:Image = new Image("graphics/welt/entitaeten/schaedel2.png");
		public var schaedel3:Entity;
		public var schaedel3IMG:Image = new Image("graphics/welt/entitaeten/schaedel3.png");
		public var westfels_pas:Entity;
		public var westfels_pasIMG:Image = new Image("graphics/welt/entitaeten/westfels_pas.png");
		public var westfels_oben:Entity;
		public var westfels_obenIMG:Image = new Image("graphics/welt/entitaeten/westfels_oben.png");
		public var loch1:Entity;
		public var loch1IMG:Image = new Image("graphics/welt/entitaeten/loch1.png");
		public var loch2:Entity;
		public var loch2IMG:Image = new Image("graphics/welt/entitaeten/loch2.png");
		public var loch3:Entity;
		public var loch3IMG:Image = new Image("graphics/welt/entitaeten/loch3.png");
		public var loch4:Entity;
		public var loch4IMG:Image = new Image("graphics/welt/entitaeten/loch4.png");
		public var loch5:Entity;
		public var loch5IMG:Image = new Image("graphics/welt/entitaeten/loch5.png");
		public var loch6:Entity;
		public var loch6IMG:Image = new Image("graphics/welt/entitaeten/loch6.png");
		public var loch7:Entity;
		public var loch7IMG:Image = new Image("graphics/welt/entitaeten/loch7.png");
		public var monifix:Entity;
		public var monifixIMG:Image = new Image("graphics/welt/entitaeten/monifix.png");
		public var flicken:Entity;
		public var flickeIMG:Image = new Image("graphics/welt/entitaeten/flickenteppich1.png");


		//animiert
		public var korkoimstamm:Entity;
		public var korkoimstammIMG:Spritemap = new Spritemap("graphics/welt/entitaeten/sprites/korkoimstamm.png", 37, 9);
		public var wurminpas:Entity;
		public var wurminpasIMG:Spritemap = new Spritemap("graphics/welt/entitaeten/sprites/wurm.png", 79, 46);
		public var dickie:Entity;
		public var dickieIMG:Spritemap = new Spritemap("graphics/welt/entitaeten/sprites/dickie.png", 145, 153);


		//malerei
		public var triggered:Bool = false;
		private var allebilder:Array<Entity> = new Array();
		private var keinebilder:Bool = false;

		//0
		private var golo0_0:Spritemap = new Spritemap("graphics/malerei/GOLO0.png", 640, 400);
		private var daddymommy:Entity;
		private var golo0:Entity;
		//1
		private var golo1_1:Spritemap = new Spritemap("graphics/malerei/GOLO1.png", 640, 400);
		private var striche:Entity;
		private var golo1:Entity;
		//2
		private var golo2_2:Spritemap = new Spritemap("graphics/malerei/GOLO2.png", 640, 400);
		private var maulwurf:Entity;
		private var golo2:Entity;
		//3
		private var golo3_3:Spritemap = new Spritemap("graphics/malerei/GOLO3.png", 640, 400);
		private var scully:Entity;
		private var golo3:Entity;
		//4
		private var golo4_4:Spritemap = new Spritemap("graphics/malerei/GOLO4.png", 640, 400);
		private var dunkelwesen:Entity;
		private var golo4:Entity;
}
