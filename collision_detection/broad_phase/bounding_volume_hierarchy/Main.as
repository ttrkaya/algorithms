package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Microphone;
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
		private var numChecksBVH:int;
		private var collisionsBrute:Vector.<int> = new Vector.<int>;
		private var collisionsBVH:Vector.<int> = new Vector.<int>;
		private var tree:BVHNode;
		
		private var levelButtons:Vector.<Sprite>;
		private var levelToShow:int;
		
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
			
			levelButtons = new Vector.<Sprite>;
			levelToShow = -1;
			for (i = 0; i < 13; i++)
			{
				var buttonLevel:Sprite = getButton(0x0000ff);
				buttonLevel.x = 305;
				buttonLevel.y = 405 + i * 30;
				addChild(buttonLevel);
				levelButtons.push(buttonLevel);
				var buttonLevelString:String = i == 0 ? "All levels" : "Level " + (i - 1);
				var buttonLevelText:TextField = getTF(buttonLevelString);
				buttonLevelText.x = buttonLevel.x;
				buttonLevelText.y = buttonLevel.y;
				addChild(buttonLevelText);
				buttonLevel.addEventListener(MouseEvent.MOUSE_DOWN, onClickedLevel);
			}
			
			bodies = new Vector.<AABB>;
			for (i = 0; i < NUM_BODDIES; i++)
			{
				var body:AABB = new AABB(0, 0, 0, 0);
				body.i = i;
				bodies.push(body);
			}
			randomizeBodies();
			
			collisionsBrute = new Vector.<int>;
			collisionsBVH = new Vector.<int>;
			
			update();
		}
		
		private function onClickedLevel(e:MouseEvent):void 
		{
			for (levelToShow = 0; levelToShow < levelButtons.length; levelToShow++)
			{
				if (levelButtons[levelToShow] == e.target) break;
			}
			levelToShow--;
			
			render();
		}
		
		private function onClickedDec(e:MouseEvent):void 
		{
			if (NUM_BODDIES == 2) return;
			
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
			
			var size:Number = 200 / Math.sqrt(NUM_BODDIES);
			for (i = 0, l = bodies.length; i < l; i++)
			{
				var body:AABB = bodies[i];
				body.minX = 350 * Math.random();
				body.minY = 350 * Math.random();
				body.maxX = body.minX + 1 + size * Math.random();
				body.maxY = body.minY + 1 + size * Math.random();
			}
		}
		
		private function update():void
		{
			var i:int, l:int;
			
			updateCollisionsBrute();
			updateCollisionsBVH();
			tf.text = "";
			tf.appendText("Checks: " + numChecksBrute + " : " + numChecksBVH + "\n");
			tf.appendText("Col: " + collisionsBrute.length + " : " + collisionsBVH.length + "\n");
			tf.appendText("Collision keys:\n");
			l = Math.max(collisionsBrute.length, collisionsBVH.length);
			for (i = 0; i < l; i++)
			{
				tf.appendText(i < collisionsBrute.length ? String(collisionsBrute[i]) : "---");
				tf.appendText("\t:\t");
				tf.appendText(i < collisionsBVH.length ? String(collisionsBVH[i]) : "---");
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
			
			graphics.lineStyle(3, 0x00ff00, levelToShow < 0 ? 0.2 : 1);
			drawNode(tree, 0);
			
			graphics.lineStyle(1, 0x00ffff);
			for (i = 0, l = bodies.length; i < l; i++)
			{
				var body:AABB = bodies[i];
				graphics.drawRect(body.minX, body.minY, body.maxX - body.minX, body.maxY - body.minY);
			}
		}
		
		private function drawNode(node:BVHNode, level:int):void
		{
			if (node.body) return;
			
			if (levelToShow < 0 || level == levelToShow)
			{
				var area:AABB = node.area;
				graphics.drawRect(area.minX, area.minY, area.maxX - area.minX, area.maxY - area.minY);
			}
			
			level++;
			drawNode(node.child0, level);
			drawNode(node.child1, level);
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
		
		private function updateCollisionsBVH():void
		{
			var i:int, j:int, l:int;
			
			collisionsBVH.length = 0;
			numChecksBVH = 0;
			
			constructTree();
			insertAllCollsisionsOfNode(tree);
		}
		
		private function insertAllCollsisionsOfNode(node:BVHNode):void
		{
			if (node.body) return;
			
			insertAllCollisionsOfBranches(node.child0, node.child1);
			
			insertAllCollsisionsOfNode(node.child0);
			insertAllCollsisionsOfNode(node.child1);
		}
		
		private function insertAllCollisionsOfBranches(node0:BVHNode, node1:BVHNode):void
		{
			numChecksBVH++;
			
			if (!node0.area.hits(node1.area))
			{
				return;
			}
			
			if (node0.body && node1.body && node0.body.hits(node1.body))
			{
				var i:int = node0.body.i;
				var j:int = node1.body.i;
				if (i > j)
				{
					var t:int = i;
					i = j;
					j = t;
				}
				var key:int = getKey(i, j, NUM_BODDIES);
				collisionsBVH.push(key);
			}
			else if (node1.body || (!node0.body && node0.area.getArea() > node1.area.getArea()))
			{
				insertAllCollisionsOfBranches(node1, node0.child0);
				insertAllCollisionsOfBranches(node1, node0.child1);
			}
			else
			{
				insertAllCollisionsOfBranches(node0, node1.child0);
				insertAllCollisionsOfBranches(node0, node1.child1);
			}
		}
		
		private function constructTree():void
		{
			tree = new BVHNode();
			fillNode(tree, bodies);
		}
		
		private function fillNode(node:BVHNode, nodeBodies:Vector.<AABB>):void
		{
			var i:int, l:int;
			
			if (nodeBodies.length == 1)
			{
				node.body = nodeBodies[0];
				node.area.copy(node.body);
				return;
			}
			
			var area:AABB = node.area;
			for (i = 0, l = nodeBodies.length; i < l; i++)
			{
				var sizer:AABB = nodeBodies[i];
				if (sizer.maxX > area.maxX) area.maxX = sizer.maxX;
				if (sizer.minX < area.minX) area.minX = sizer.minX;
				if (sizer.maxY > area.maxY) area.maxY = sizer.maxY;
				if (sizer.minY < area.minY) area.minY = sizer.minY;
			}
			
			var child0Boddies:Vector.<AABB> = new Vector.<AABB>;
			var child1Boddies:Vector.<AABB> = new Vector.<AABB>;
			
			var areaW:Number = area.maxX - area.minX;
			var areaH:Number = area.maxY - area.minY;
			if (areaW > areaH)
			{
				var averageX:Number = 0;
				for (i = 0, l = nodeBodies.length; i < l; i++)
				{
					averageX += nodeBodies[i].minX;
				}
				averageX /= nodeBodies.length;
				
				for (i = 0, l = nodeBodies.length; i < l; i++)
				{
					var bodySX:AABB = nodeBodies[i];
					if (bodySX.minX < averageX) child0Boddies.push(bodySX);
					else child1Boddies.push(bodySX);
				}
			}
			else
			{
				var averageY:Number = 0;
				for (i = 0, l = nodeBodies.length; i < l; i++)
				{
					averageY += nodeBodies[i].minY;
				}
				averageY /= nodeBodies.length;
				
				for (i = 0, l = nodeBodies.length; i < l; i++)
				{
					var bodySY:AABB = nodeBodies[i];
					if (bodySY.minY < averageY) child0Boddies.push(bodySY);
					else child1Boddies.push(bodySY);
				}
			}
			
			if (child0Boddies.length == 0)
			{
				child0Boddies.push(child1Boddies.pop());
			}
			else if (child1Boddies.length == 0)
			{
				child1Boddies.push(child0Boddies.pop());
			}
			
			node.child0 = new BVHNode();
			node.child1 = new BVHNode();
			fillNode(node.child0, child0Boddies);
			fillNode(node.child1, child1Boddies);
		}
		
		//returns a unique key for i < j < n
		private function getKey(i:int, j:int, n:int):int
		{
			return i * (2 * n - i - 3) / 2 + j - 1;
		}
	}
	
}