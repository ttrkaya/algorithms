package render
{
	public class ColorUtils
	{
		public function ColorUtils()
		{
		}
		
		public static function getColorWithRatio(color:uint, ratio:Number):uint
		{
			var red:uint = color >> 16;
			var green:uint = (color & 0x00ff00) >> 8;
			var blue:uint = color & 0x0000ff;
			
			red *=ratio;
			green *=ratio;
			blue *=ratio;
			
			var finalColor:uint = (red << 16) | (green << 8) | blue;
			return finalColor;
		}
	}
}