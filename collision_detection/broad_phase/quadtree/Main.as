package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Main extends Sprite 
	{
		private static const GW:Number = 400;
		private static const GH:Number = 400;
		
		private static var NUM_BODDIES:int = 5;
		private var bodies:Vector.<AABB>;
		
		private var tf:TextField;
		private var numChecksBrute:int;
		private var numChecksQuad:int;
		private var collisionsBrute:Vector.<int> = new Vector.<int>;
		private var collisionsQuad:Vector.<int> = new Vector.<int>;
		private var tree:QuadNode;
		private var keys:Vector.<Boolean>;
		private static var MAX_TREE_LEVEL:int;
		
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
			
			keys = new Vector.<Boolean>;
			keys.length = NUM_BODDIES * (NUM_BODDIES - 1) / 2;
			
			MAX_TREE_LEVEL = Math.log(NUM_BODDIES);
			
			update();
		}
		
		private function onClickedDec(e:MouseEvent):void 
		{
			if (NUM_BODDIES == 1) return;
			
			NUM_BODDIES--;
			
			keys.length = NUM_BODDIES * (NUM_BODDIES - 1) / 2;
			
			MAX_TREE_LEVEL = Math.log(NUM_BODDIES);
			
			bodies.splice(bodies.length - 1, 1);
			
			randomizeBodies();
			update();
		}
		
		private function onClickedInc(e:MouseEvent):void 
		{
			NUM_BODDIES++;
			
			keys.length = NUM_BODDIES * (NUM_BODDIES - 1) / 2;
			
			MAX_TREE_LEVEL = Math.log(NUM_BODDIES);
		
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
			
			var size:Number = 200 / Math.sqrt(NUM_BODDIES);
			for (i = 0, l = bodies.length; i < l; i++)
			{
				var body:AABB = bodies[i];
				body.minX = (GW - size - 1) * Math.random();
				body.minY = (GH - size - 1) * Math.random();
				body.maxX = body.minX + 1 + size * Math.random();
				body.maxY = body.minY + 1 + size * Math.random();
			}
		}
		
		private function update():void
		{
			var i:int, l:int;
			
			updateCollisionsBrute();
			updateCollisionsQuad();
			tf.text = "";
			tf.appendText("Checks: " + numChecksBrute + " : " + numChecksQuad + "\n");
			tf.appendText("Col: " + collisionsBrute.length + " : " + collisionsQuad.length + "\n");
			tf.appendText("Collision keys:\n");
			l = Math.max(collisionsBrute.length, collisionsQuad.length);
			for (i = 0; i < l; i++)
			{
				tf.appendText(i < collisionsBrute.length ? String(collisionsBrute[i]) : "---");
				tf.appendText("\t:\t");
				tf.appendText(i < collisionsQuad.length ? String(collisionsQuad[i]) : "---");
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
			
			graphics.lineStyle(1, 0x00ff00, 1);
			drawNode(tree, new Point(GW/2, GH/2), 0);
			
			graphics.lineStyle(1, 0x00ffff);
			for (i = 0, l = bodies.length; i < l; i++)
			{
				var body:AABB = bodies[i];
				graphics.drawRect(body.minX, body.minY, body.maxX - body.minX, body.maxY - body.minY);
			}
		}
		
		private function drawNode(node:QuadNode, center:Point, level:int):void
		{
			if (!node.children) return;
			
			level++;
			var levelDivideScale:Number = Math.pow(0.5, level + 1);
			var offsetX:Number = GW * levelDivideScale;
			var offsetY:Number = GH * levelDivideScale;
			var center0:Point = new Point(center.x - offsetX, center.y - offsetY);
			var center1:Point = new Point(center.x + offsetX, center.y - offsetY);
			var center2:Point = new Point(center.x - offsetX, center.y + offsetY);
			var center3:Point = new Point(center.x + offsetX, center.y + offsetY);
			drawNode(node.children[0], center0, level);
			drawNode(node.children[1], center1, level);
			drawNode(node.children[2], center2, level);
			drawNode(node.children[3], center3, level);
			
			graphics.moveTo(center.x - 2 * offsetX, center.y);
			graphics.lineTo(center.x + 2 * offsetX, center.y);
			graphics.moveTo(center.x, center.y - 2 * offsetY);
			graphics.lineTo(center.x, center.y + 2 * offsetY);
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
		
		private function updateCollisionsQuad():void
		{
			var i:int, l:int;
			
			collisionsQuad.length = 0;
			numChecksQuad = 0;
			for (i = 0, l = NUM_BODDIES * (NUM_BODDIES - 1); i < l; i++) keys[i] = false;
			
			constructTree();
			insertCollisionsQuad(tree);
		}
		
		private function insertCollisionsQuad(node:QuadNode):void
		{
			var bodies:Vector.<AABB> = node.bodies;
			if (bodies)
			{
				var i:int, j:int, l:int = bodies.length;
				
				for (i = 0; i < l; i++)
				{
					var b1:AABB = bodies[i];
					for (j = i + 1; j < l; j++)
					{
						var b2:AABB = bodies[j];
						numChecksQuad++;
						if (b1.hits(b2))
						{
							var b1i:int = Math.min(b1.i, b2.i);
							var b2i:int = Math.max(b1.i, b2.i);
							var key:int = getKey(b1i, b2i, NUM_BODDIES);
							if (!keys[key])
							{
								keys[key] = true;
								collisionsQuad.push(key);
							}
						}
					}
				}
			}
			else
			{
				var children:Vector.<QuadNode> = node.children;
				insertCollisionsQuad(children[0]);
				insertCollisionsQuad(children[1]);
				insertCollisionsQuad(children[2]);
				insertCollisionsQuad(children[3]);
			}
		}
		
		private function constructTree():void
		{
			tree = new QuadNode();
			var center:Point = new Point(GW / 2, GH / 2);
			fillNode(tree, center, 0, bodies);
		}
		
		private function fillNode(node:QuadNode, center:Point, level:int, nodeBodies:Vector.<AABB>):void
		{
			var i:int, l:int = nodeBodies.length;
			
			if (l <= 1 || level == MAX_TREE_LEVEL)
			{
				node.bodies = nodeBodies;
				return;
			}
			
			var childrenBodies:Vector.<Vector.<AABB>> = new Vector.<Vector.<AABB>>(4);
			childrenBodies[0] = new Vector.<AABB>;
			childrenBodies[1] = new Vector.<AABB>;
			childrenBodies[2] = new Vector.<AABB>;
			childrenBodies[3] = new Vector.<AABB>;
			
			for (i = 0; i < l; i++ )
			{
				var seperated:AABB = nodeBodies[i];
				var isUp:Boolean = seperated.minY < center.y;
				var isDown:Boolean = seperated.maxY > center.y;
				var isLeft:Boolean = seperated.minX < center.x;
				var isRight:Boolean = seperated.maxX > center.x;
				
				if (isUp && isLeft) childrenBodies[0].push(seperated);
				if (isUp && isRight) childrenBodies[1].push(seperated);
				if (isDown && isLeft) childrenBodies[2].push(seperated);
				if (isDown && isRight) childrenBodies[3].push(seperated);
			}
			
			node.divide();
			level++;
			var levelDivideScale:Number = Math.pow(0.5, level + 1);
			var offsetX:Number = GW * levelDivideScale;
			var offsetY:Number = GH * levelDivideScale;
			var center0:Point = new Point(center.x - offsetX, center.y - offsetY);
			var center1:Point = new Point(center.x + offsetX, center.y - offsetY);
			var center2:Point = new Point(center.x - offsetX, center.y + offsetY);
			var center3:Point = new Point(center.x + offsetX, center.y + offsetY);
			fillNode(node.children[0], center0, level, childrenBodies[0]);
			fillNode(node.children[1], center1, level, childrenBodies[1]);
			fillNode(node.children[2], center2, level, childrenBodies[2]);
			fillNode(node.children[3], center3, level, childrenBodies[3]);
		}
		
		//returns a unique key for i < j < n
		private function getKey(i:int, j:int, n:int):int
		{
			return i * (2 * n - i - 3) / 2 + j - 1;
		}
	}
	
}