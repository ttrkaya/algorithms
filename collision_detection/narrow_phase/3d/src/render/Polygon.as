package render 
{
	import flash.display.Graphics;
	
	import math.Vec4;

	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Polygon extends RenderObject
	{
		private var _vertexIndicies:Vector.<int>;
		private var _fillColor:uint;
		private var _lightedColor:uint;
		private var _alpha:Number
		
		private static const X_Y_TO_MEANZ_FACTOR:Number = 0.00000001;
		
		public function Polygon(vertexIndicies:Vector.<int>, fillColor:uint, alpha:Number) 
		{
			_vertexIndicies = vertexIndicies;
			_fillColor = fillColor;
			_lightedColor = _fillColor;
			_alpha = alpha;
		}
		
		public override function updateSortZ(transformedVerticies:Vector.<Vec4>):void
		{
			var i:int, li:int;
			
			this.sortZ = 0;
			for(i=0, li=_vertexIndicies.length; i<li; i++)
			{
				var vertex:Vec4 = transformedVerticies[this._vertexIndicies[i]];
				this.sortZ += vertex.z + Math.abs(vertex.x)*X_Y_TO_MEANZ_FACTOR + Math.abs(vertex.y)*X_Y_TO_MEANZ_FACTOR;
			}
			this.sortZ /= li;
		}
		
		public override function updateLightedColor(perspectedVerticies:Vector.<Vec4>, 
													lightDirection:Vec4, ambienLightRatio:Number):void
		{
			var normal:Vec4 = this.getNormal(perspectedVerticies);
			var directedLightPower:Number = Math.max(0, normal.dot(lightDirection));
			var totalLightPower:Number = ambienLightRatio + (1-ambienLightRatio)*directedLightPower;
			_lightedColor = ColorUtils.getColorWithRatio(_fillColor, totalLightPower);
		}
		
		public override function render(graphics:Graphics, perspectedVerticies:Vector.<Vec4>):void
		{
			var i:int, li:int;
			
			graphics.lineStyle(1,0x0);
			graphics.beginFill(_lightedColor, _alpha);
			var index0:int = _vertexIndicies[0];
			graphics.moveTo(perspectedVerticies[index0].x, perspectedVerticies[index0].y);
			for(i=1, li=_vertexIndicies.length; i<li; i++)
			{
				var vertex:Vec4 = perspectedVerticies[_vertexIndicies[i]];
				graphics.lineTo(vertex.x, vertex.y);
			}
			graphics.endFill();
		}
		
		private function getNormal(transformedVerticies:Vector.<Vec4>):Vec4
		{
			var vertex0:Vec4 = transformedVerticies[_vertexIndicies[0]];
			var vertex1:Vec4 = transformedVerticies[_vertexIndicies[1]];
			var vertex2:Vec4 = transformedVerticies[_vertexIndicies[2]];
			
			var edge0:Vec4 = vertex1.getSubbed(vertex0);
			var edge1:Vec4 = vertex2.getSubbed(vertex0);
			
			var normal:Vec4 = edge0.cross(edge1);
			normal.normalize();
			
			return normal;
		}
		
	}

}