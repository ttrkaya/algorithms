package render
{
	import flash.display.Graphics;
	
	import math.Vec4;

	public class Sphere extends RenderObject
	{
		private var _centerVertexIndex:int;
		private var _r:Number
		private var _fillColor:uint;
		private var _lightedColor:uint;
		private var _alpha:Number
		
		public function Sphere(centerVertexIndex:int, r:Number, fillColor:uint, alpha:Number)
		{
			_centerVertexIndex = centerVertexIndex;
			_r = r;
			_fillColor = fillColor;
			_lightedColor = _fillColor;
			_alpha = alpha;
		}
		
		public override function updateSortZ(transformedVerticies:Vector.<Vec4>):void
		{
			sortZ = transformedVerticies[_centerVertexIndex].z;
		}
		
		public override function updateLightedColor(perspectedVerticies:Vector.<Vec4>,
										   lightDirection:Vec4, ambienLightRatio:Number):void
		{
			var center:Vec4 = perspectedVerticies[_centerVertexIndex];
			var dir:Vec4 = center.clone();
			dir.normalize();
			
			var directedLightPower:Number = 1 - Math.abs(lightDirection.dot(dir));
			directedLightPower /= 2;
			var totalLightPower:Number = ambienLightRatio + (1-ambienLightRatio)*directedLightPower;
			_lightedColor = ColorUtils.getColorWithRatio(_fillColor, totalLightPower);
		}
		
		public override function render(graphics:Graphics, perspectedVerticies:Vector.<Vec4>):void
		{
			var center:Vec4 = perspectedVerticies[_centerVertexIndex];
			
			graphics.lineStyle(1,0x0);
			graphics.beginFill(_lightedColor, _alpha);
			graphics.drawCircle(center.x, center.y, _r);
			graphics.endFill();
		}
	}
}