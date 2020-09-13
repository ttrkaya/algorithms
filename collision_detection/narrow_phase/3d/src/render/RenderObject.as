package render
{
	import flash.display.Graphics;
	
	import math.Vec4;

	public class RenderObject
	{
		public var sortZ:Number;
		
		private static const ERROR_OVERRIDE:String = "This method is to be overridden";
		
		public function RenderObject()
		{
			
		}
		
		public function updateSortZ(transformedVerticies:Vector.<Vec4>):void
		{
			throw ERROR_OVERRIDE;
		}
		
		public function updateLightedColor(perspectedVerticies:Vector.<Vec4>,
										   lightDirection:Vec4, ambienLightRatio:Number):void
		{
			throw ERROR_OVERRIDE;
		}
		
		public function render(graphics:Graphics, perspectedVerticies:Vector.<Vec4>):void
		{
			throw ERROR_OVERRIDE;
		}
	}
}