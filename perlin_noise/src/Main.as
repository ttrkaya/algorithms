package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Main extends Sprite 
	{
		private const Ns:Vector.<int> = new <int>[4,8,16,32,64];
		private var grids:Vector.<Vector.<Vector.<Point>>>; // N => grid
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.resetAll();
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { resetAll(); } );
			this.buttonMode = true;
		}
		
		private function initGrids():void
		{
			var i:int, j:int, k:int;
			
			grids = new Vector.<Vector.<Vector.<Point>>>;
			for(k=0; k<Ns.length; k++)
			{
				var N:int = Ns[k];
				var grid:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>;
				grids.push(grid);
				for(i=0; i<N+1; i++)
				{
					var row:Vector.<Point> = new Vector.<Point>;
					grid.push(row);
					for(j=0; j<N+1; j++)
					{
						var angle:Number = Math.PI*2*Math.random();
						row.push(new Point(Math.cos(angle), Math.sin(angle)));
					}
				}
			}
		}
		
		private function samplePoint(grid:Vector.<Vector.<Point>>, N:int, x:Number, y:Number):Number
		{
			var i:int = Math.floor(y);
			var j:int = Math.floor(x);
			if(i>=N) i=N-1;
			if(j>=N) j=N-1;
			
			var g0:Point = grid[i][j];
			var g1:Point = grid[i][j+1];
			var g2:Point = grid[i+1][j];
			var g3:Point = grid[i+1][j+1];
			
			var k0:Point = new Point(j - x, i - y);
			var k1:Point = new Point(j+1 - x, i - y);
			var k2:Point = new Point(j - x, i+1 - y);
			var k3:Point = new Point(j+1 - x, i+1 - y);
			
			var v0:Number = g0.x * k0.x + g0.y * k0.y;
			var v1:Number = g1.x * k1.x + g1.y * k1.y;
			var v2:Number = g2.x * k2.x + g2.y * k2.y;
			var v3:Number = g3.x * k3.x + g3.y * k3.y;
			
			var horizatalRatio:Number = x-j;
			horizatalRatio = horizatalRatio*horizatalRatio*(3-(2*horizatalRatio));
			var m0:Number = (1-horizatalRatio) * v0 + horizatalRatio * v1;
			var m1:Number = (1-horizatalRatio) * v2 + horizatalRatio * v3;
			
			var verticalRatio:Number = y-i;
			verticalRatio = verticalRatio*verticalRatio*(3-(2*verticalRatio));
			return (1 - verticalRatio) * m0 + verticalRatio * m1;
		}
		
		private function draw():void
		{
			var x:Number, y:Number, k:int;
			
			var perlinValues:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>;
			for(y=0; y<400; y++)
			{
				perlinValues.push(new Vector.<Number>);
				for(x=0; x<400; x++)
				{
					perlinValues[perlinValues.length-1].push(0);
				}
			}
			
			var min:Number=Number.MAX_VALUE, max:Number=-Number.MAX_VALUE;
			for(y=0; y<400; y++)
			{
				for(x=0; x<400; x++)
				{
					var perlinValue:Number = 0;
					for(k=0; k<Ns.length; k++)
					{
						var N:int = Ns[k];
						perlinValue += this.samplePoint(grids[k], N, x*N/400, y*N/400) / N;
					}
					perlinValues[y][x] = perlinValue;
					if(perlinValue > max) max = perlinValue;
					if(perlinValue < min) min = perlinValue;
				}
			}
			trace("max: " + max + " | min: " + min);
			
			this.graphics.clear();
			this.graphics.beginFill(0x0);
			this.graphics.drawRect(0, 0, 400, 400);
			for(x=0; x<400; x++)
			{
				for(y=0; y<400; y++)
				{
					var perlinValueNormalized:Number = (perlinValues[y][x]-min) / (max-min);
					
					var color:uint = 255*perlinValueNormalized;
					this.graphics.beginFill(256*color);
					this.graphics.drawRect(x, y, 1, 1);
					this.graphics.endFill();
				}
			}
		}
		
		private function resetAll():void
		{
			initGrids();
			draw();
		}
		
	}
	
}