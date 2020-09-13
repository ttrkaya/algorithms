package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Main extends Sprite 
	{
		private static const GW:Number = 400;
		private static const GH:Number = 400;
		
		private static var NUM_BODDIES:int = 3;
		private var bodies:Vector.<AABB>;
		
		private var tf:TextField;
		private var numChecksBrute:int;
		private var numChecksSas:int;
		private var collisionsBrute:Vector.<int>;
		private var collisionsSaS:Vector.<int>;
		private var sasCount:Vector.<int>;
		private var sasX:Vector.<Mark>;
		private var sasY:Vector.<Mark>;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			var i:int;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			tf = getTF('');
			tf.y = 430;
			addChild(tf);
			
			var buttonRandom:Sprite = getButton(0x888888);
			buttonRandom.x = 5;
			buttonRandom.y = 405;
			addChild(buttonRandom);
			var buttonRandomText:TextField = getTF("Random");
			buttonRandomText.x = buttonRandom.x;
			buttonRandomText.y = buttonRandom.y;
			addChild(buttonRandomText);
			buttonRandom.addEventListener(MouseEvent.MOUSE_DOWN, onClickedRandom);
			
			var buttonInc:Sprite = getButton(0x008800);
			buttonInc.x = 105;
			buttonInc.y = 405;
			addChild(buttonInc);
			var buttonIncText:TextField = getTF("Increment");
			buttonIncText.x = buttonInc.x;
			buttonIncText.y = buttonInc.y;
			addChild(buttonIncText);
			buttonInc.addEventListener(MouseEvent.MOUSE_DOWN, onClickedInc);
			
			var buttonDec:Sprite = getButton(0x880000);
			buttonDec.x = 205;
			buttonDec.y = 405;
			addChild(buttonDec);
			var buttonDecText:TextField = getTF("Decrement");
			buttonDecText.x = buttonDec.x;
			buttonDecText.y = buttonDec.y;
			addChild(buttonDecText);
			buttonDec.addEventListener(MouseEvent.MOUSE_DOWN, onClickedDec);
			
			bodies = new Vector.<AABB>;
			for (i = 0; i < NUM_BODDIES; i++)
			{
				var body:AABB = new AABB(0, 0, 0, 0);
				body.i = i;
				bodies.push(body);
			}
			randomizeBodies();
			
			collisionsBrute = new Vector.<int>;
			collisionsSaS = new Vector.<int>;
			sasCount = new Vector.<int>;
			sasX = new Vector.<Mark>;
			sasY = new Vector.<Mark>;
			
			update();
		}
		
		private function onClickedDec(e:MouseEvent):void 
		{
			if (NUM_BODDIES == 0) return;
			
			NUM_BODDIES--;
			
			bodies.splice(bodies.length - 1, 1);
			
			randomizeBodies();
			update();
		}
		
		private function onClickedInc(e:MouseEvent):void 
		{
			NUM_BODDIES++;
		
			var newBody:AABB = new AABB(0, 0, 0, 0);
			newBody.i = bodies.length;
			bodies.push(newBody);
			
			randomizeBodies();
			update();
		}
		
		private function getTF(text:String):TextField
		{
			var tf:TextField = new TextField();
			tf.x = 0;
			tf.width = 400;
			tf.height = 900;
			tf.textColor = 0xffffff;
			tf.mouseEnabled = false;
			tf.text = text;
			return tf;
		}
		
		private function getButton(color:uint):Sprite
		{	
			var button:Sprite = new Sprite();
			button.graphics.beginFill(color);
			button.graphics.drawRoundRect(0, 0, 90, 20, 15);
			button.buttonMode = true;
			return button;
		}
		
		private function onClickedRandom(e:MouseEvent):void 
		{
			randomizeBodies();
			update();
		}
		
		private function randomizeBodies():void
		{
			var i:int, l:int;
			
			for (i = 0, l = bodies.length; i < l; i++)
			{
				var body:AABB = bodies[i];
				body.minX = 350 * Math.random();
				body.minY = 350 * Math.random();
				body.maxX = body.minX + 5 + 45 * Math.random();
				body.maxY = body.minY + 5 + 45 * Math.random();
			}
		}
		
		private function update():void
		{
			var i:int, l:int;
			
			updateCollisionsBrute();
			updateCollisionsSas();
			
			tf.text = "";
			tf.appendText("Checks: " + numChecksBrute + " : " + numChecksSas + "\n");
			tf.appendText("Col: " + collisionsBrute.length + " : " + collisionsSaS.length + "\n");
			tf.appendText("Collision keys:\n");
			l = Math.max(collisionsBrute.length, collisionsSaS.length)
			for (i = 0; i < l; i++)
			{
				tf.appendText(i < collisionsBrute.length ? String(collisionsBrute[i]) : "---");
				tf.appendText("\t:\t");
				tf.appendText(i < collisionsSaS.length ? String(collisionsSaS[i]) : "---");
				tf.appendText("\n");
			}
			
			render();
		}
		
		private function render():void
		{
			var i:int, l:int;
			
			graphics.clear();
			
			graphics.beginFill(0x0);
			graphics.drawRect(0, 0, 400, 800);
			graphics.endFill();
			
			l = bodies.length * 2;
			for (i = 0; i < l; i++)
			{
				var markX:Mark = sasX[i];
				graphics.lineStyle(1, markX.isBegin ? 0x00ffff : 0xffff00);
				graphics.drawCircle(markX.value, GH, 3);
				graphics.lineStyle(1, 0xffffff, 0.2);
				graphics.moveTo(markX.value, GH);
				graphics.lineTo(markX.value, 0);
			}
			for (i = 0; i < l; i++)
			{
				var markY:Mark = sasY[i];
				graphics.lineStyle(1, markY.isBegin ? 0x00ffff : 0xffff00);
				graphics.drawCircle(3, markY.value, 3);
				graphics.lineStyle(1, 0xffffff, 0.2);
				graphics.moveTo(3, markY.value);
				graphics.lineTo(GW, markY.value);
			}
			
			graphics.lineStyle(1, 0x0000ff);
			for (i = 0, l = bodies.length; i < l; i++)
			{
				var body:AABB = bodies[i];
				graphics.drawRect(body.minX, body.minY, body.maxX - body.minX, body.maxY - body.minY);
			}
		}
		
		private function updateCollisionsBrute():void
		{
			var i:int, j:int, l:int;
			
			collisionsBrute.length = 0;
			numChecksBrute = 0;
			
			l = bodies.length;
			for (i = 0; i < l; i++)
			{
				var bodyi:AABB = bodies[i];
				for (j = i + 1; j < l; j++)
				{
					var bodyj:AABB = bodies[j];
					
					numChecksBrute++;
					if (bodyi.hits(bodyj))
					{
						var key:int = getKey(i, j, NUM_BODDIES);
						collisionsBrute.push(key);
					}
				}
			}
		}
		
		private function updateCollisionsSas():void
		{
			var i:int, j:int, l:int, lj:int;
			
			collisionsSaS.length = 0;
			numChecksSas = 0;
			
			var numPairs:int = NUM_BODDIES * (NUM_BODDIES - 1) / 2;
			sasCount.length = numPairs;
			sasX.length = NUM_BODDIES * 2;
			sasY.length = NUM_BODDIES * 2;
			
			for (i = 0; i < numPairs; i++) sasCount[i] = 0;
			
			for (i = 0; i < NUM_BODDIES; i++)
			{
				var marker:AABB = bodies[i];
				sasX[2 * i] = new Mark(marker, true, true);
				sasX[2 * i + 1] = new Mark(marker, false, true);
				sasY[2 * i] = new Mark(marker, true, false);
				sasY[2 * i + 1] = new Mark(marker, false, false);
			}
			
			sasX = sasX.sort(sortHelper);
			sasY = sasY.sort(sortHelper);
			
			var sweeper:Vector.<Mark> = new Vector.<Mark>;
			l = NUM_BODDIES * 2;
			for (i = 0; i < l; i++)
			{
				var markX:Mark = sasX[i];
				if (markX.isBegin)
				{
					for (j = 0, lj = sweeper.length; j < lj; j++)
					{
						numChecksSas++;
						var markX2:Mark = sweeper[j];
						var iix:int = Math.min(markX.body.i, markX2.body.i);
						var jjx:int = Math.max(markX.body.i, markX2.body.i);
						var keyx:int = getKey(iix, jjx, NUM_BODDIES);
						sasCount[keyx]++;
					}
					sweeper.push(markX);
				}
				else
				{
					for (j = 0, lj = sweeper.length; j < lj; j++)
					{
						if (markX.body.i == sweeper[j].body.i)
						{
							sweeper.splice(j, 1);
							break;
						}
					}
					if(j == lj) throw "wtf";
				}
			}
			if (sweeper.length > 0) throw "wtf";
			for (i = 0; i < l; i++)
			{
				var markY:Mark = sasY[i];
				if (markY.isBegin)
				{
					for (j = 0, lj = sweeper.length; j < lj; j++)
					{
						numChecksSas++;
						var markY2:Mark = sweeper[j];
						var iiy:int = Math.min(markY.body.i, markY2.body.i);
						var jjy:int = Math.max(markY.body.i, markY2.body.i);
						var keyy:int = getKey(iiy, jjy, NUM_BODDIES);
						if (sasCount[keyy] == 1)
						{
							collisionsSaS.push(keyy);
						}
					}
					sweeper.push(markY);
				}
				else
				{
					for (j = 0, lj = sweeper.length; j < lj; j++)
					{
						if (markY.body.i == sweeper[j].body.i)
						{
							sweeper.splice(j, 1);
							break;
						}
					}
					if(j == lj) throw "wtf";
				}
			}
		}
		
		private function sortHelper(a:Mark, b:Mark):Number
		{
			return (a.value > b.value) ? 1 : -1;
		}
		
		//returns a unique key for i < j < n
		private function getKey(i:int, j:int, n:int):int
		{
			return i * (2 * n - i - 3) / 2 + j - 1;
		}
	}
	
}