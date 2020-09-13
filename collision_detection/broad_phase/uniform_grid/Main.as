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
		private static const GRID_SIZE:Number = 50;
		private static const GRID_W:int = GW / GRID_SIZE;
		private static const GRID_H:int = GH / GRID_SIZE;
		private static const NUM_BUCKETS:int = GRID_W * GRID_H;
		private var buckets:Vector.<Vector.<AABB>>;
		
		private static var NUM_BODDIES:int = 35;
		private var bodies:Vector.<AABB>;
		
		private var tf:TextField;
		private var numChecksBrute:int;
		private var numChecksGrid:int;
		private var collisionsBrute:Vector.<int> = new Vector.<int>;
		private var collisionsGrid:Vector.<int> = new Vector.<int>;
		private var gridCheck:Vector.<Boolean>;
		private static var NUM_PAIRS:int = NUM_BODDIES * (NUM_BODDIES - 1) / 2;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			var i:int, j:int;
			var n:int = 10
			for (i = 0; i < n; i++)
			{
				for (j = i + 1; j < n; j++)
				{
					var key:int = i * (2 * n - i - 3) / 2 + j - 1;
					trace(key);
				}
			}
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
			
			buckets = new Vector.<Vector.<AABB>>(NUM_BUCKETS);
			for (i = 0; i < NUM_BUCKETS; i++)
			{
				buckets[i] = new Vector.<AABB>;
			}
			
			collisionsBrute = new Vector.<int>;
			collisionsGrid = new Vector.<int>;
			gridCheck = new Vector.<Boolean>(NUM_PAIRS);
			
			update();
		}
		
		private function onClickedDec(e:MouseEvent):void 
		{
			if (NUM_BODDIES == 0) return;
			
			NUM_BODDIES--;
			NUM_PAIRS = NUM_BODDIES * (NUM_BODDIES - 1) / 2;
			gridCheck.length = NUM_PAIRS;
			
			bodies.splice(bodies.length - 1, 1);
			
			randomizeBodies();
			update();
		}
		
		private function onClickedInc(e:MouseEvent):void 
		{
			NUM_BODDIES++;
			NUM_PAIRS = NUM_BODDIES * (NUM_BODDIES - 1) / 2;
			gridCheck.length = NUM_PAIRS;
		
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
			var i:int;
			
			updateCollisionsBrute();
			for (i = 0; i < NUM_PAIRS; i++) gridCheck[i] = false;
			updateCollisionsGrid();
			tf.text = "";
			tf.appendText("Checks: " + numChecksBrute + " : " + numChecksGrid + "\n");
			tf.appendText("Col: " + collisionsBrute.length + " : " + collisionsGrid.length + "\n");
			tf.appendText("Collision keys:\n");
			for (i = 0; i < collisionsBrute.length; i++)
			{
				tf.appendText(collisionsBrute[i] + "\t:\t" + collisionsGrid[i] + "\n");
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
			
			graphics.lineStyle(1, 0x888888);
			for (i = 0; i <= GW; i += GRID_SIZE)
			{
				graphics.moveTo(i , 0);
				graphics.lineTo(i, GH);
			}
			for (i = 0; i <= GH; i += GRID_SIZE)
			{
				graphics.moveTo(0, i);
				graphics.lineTo(GW, i);
			}
			
			graphics.lineStyle(1, 0x00ffff);
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
		
		private function updateCollisionsGrid():void
		{
			var i:int, j:int, l:int;
			
			collisionsGrid.length = 0;
			numChecksGrid = 0;
			
			for (i = 0; i < NUM_BUCKETS; i++)
			{
				buckets[i].length = 0;
			}
			
			l = bodies.length;
			for (i = 0; i < l; i++)
			{
				var body:AABB = bodies[i];
				var gxs:int = Math.floor(body.minX / GRID_SIZE);
				var gxe:int = Math.floor(body.maxX / GRID_SIZE);
				var gys:int = Math.floor(body.minY / GRID_SIZE);
				var gye:int = Math.floor(body.maxY / GRID_SIZE);
				for (var gy:int = gys; gy <= gye; gy++)
				{
					for (var gx:int = gxs; gx <= gxe; gx++)
					{
						addAndCheckBucket(body, gx, gy);
					}
				}
			}
		}
		
		private function addAndCheckBucket(body:AABB, gx:int, gy:int):void
		{
			var i:int, l:int;
			
			var bucket:Vector.<AABB> = buckets[gy * GRID_W + gx];
			for (i = 0, l = bucket.length; i < l; i++)
			{
				var bodyInBucket:AABB = bucket[i];
				
				numChecksGrid++;
				if (bodyInBucket.hits(body))
				{
					var key:int = getKey(bodyInBucket.i, body.i, NUM_BODDIES);
					if (gridCheck[key]) continue;
					gridCheck[key] = true;
					collisionsGrid.push(key);
				}
			}
			
			bucket.push(body);
		}
		
		//returns a unique key for i < j < n
		private function getKey(i:int, j:int, n:int):int
		{
			return i * (2 * n - i - 3) / 2 + j - 1;
		}
	}
	
}