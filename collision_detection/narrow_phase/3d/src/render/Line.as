package render 
{
	import flash.display.Graphics;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import math.Vec4;

	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Line extends RenderObject
	{
		private var _vertexIndex1:int;
		private var _vertexIndex2:int;
		private var _width:Number;
		private var _color:uint;
		private var _alpha:Number
		
		public function Line(vertexIndex1:int, vertexIndex2:int, width:Number, color:uint, alpha:Number) 
		{
			_vertexIndex1 = vertexIndex1;
			_vertexIndex2 = vertexIndex2;
			_width = width;
			_color = color;
			_alpha = alpha;
		}
		
		public override function updateSortZ(transformedVerticies:Vector.<Vec4>):void
		{
			this.sortZ = (transformedVerticies[_vertexIndex1].z + transformedVerticies[_vertexIndex2].z) / 2;
		}
		
		public override function updateLightedColor(perspectedVerticies:Vector.<Vec4>, 
													lightDirection:Vec4, ambienLightRatio:Number):void
		{
			//do nothing for now
		}
		
		public override function render(graphics:Graphics, perspectedVerticies:Vector.<Vec4>):void
		{
			var lineVertex1:Vec4 = perspectedVerticies[_vertexIndex1];
			var lineVertex2:Vec4 = perspectedVerticies[_vertexIndex2];
			
			graphics.lineStyle(_width, _color, _alpha);
			graphics.moveTo(lineVertex1.x, lineVertex1.y);
			graphics.lineTo(lineVertex2.x, lineVertex2.y);
		}
		
	}

}