/**
 * BezierCurvesExample1.as by Lee Burrows
 * Apr 06, 2011
 * Visit blog.leeburrows.com for more stuff
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/
package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Label;
	import com.bit101.components.VSlider;
	
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import parts.BezierCurve;
	import parts.DragPoint;
	import parts.Marker;
	
	[SWF(frameRate="30", width="550", height="400", backgroundColor="#E0E0E0")]
	public class BezierCurveViewer extends Sprite
	{
		static private const MAX_POINTS:uint = 20;
		static private const CURVE_NUMBER:uint = 500;
		
		private var cbPoints:CheckBox;
		private var cbLine:CheckBox;
		private var vsPosition:VSlider;
		private var lbPosition:Label;
		
		private var canvas:Shape;
		private var marker:Marker;
		private var points:Array;

		public function BezierCurveViewer()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			init();
		}
		
		private function init():void
		{
			//drawing area
			canvas = new Shape();
			addChild(canvas);
			//remove point area
			graphics.beginFill(0xCCCCCC);
			graphics.drawRect(0, 360, 450, 40);
			graphics.endFill();
			//form
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(450, 0, 100, 400);
			graphics.endFill();
			cbPoints = new CheckBox(this, 460, 20, "show points?");
			cbPoints.selected = true;
			cbLine = new CheckBox(this, 460, 50, "show line?");
			cbLine.selected = true;
			vsPosition = new VSlider(this, 460, 80);
			vsPosition.minimum = 0;
			vsPosition.maximum = 1;
			vsPosition.value = 0.75;
			vsPosition.tick = 0.01;
			vsPosition.height = 200;
			lbPosition = new Label(this, 473, 75, "0");
			//setup initial points
			points = [];
			addPoint(50, 50);
			addPoint(400, 50);
			addPoint(50, 310);
			addPoint(400, 310);
			//position marker
			marker = new Marker();
			addChild(marker);
			//listeners
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.CLICK, mouseHandler);
			
			for (var i:uint=0;i<30;i++)
				trace(i, BezierCurve.factoral(i));
		}
		
		private function addPoint(xpos:Number, ypos:Number):void
		{
			if (points.length<MAX_POINTS)
			{
				var dp:DragPoint = new DragPoint();
				dp.x = xpos;
				dp.y = ypos;
				points.push(addChild(dp));
			}
		}
		
		public function removePoint(dg:DragPoint):void
		{
			var len:uint = points.length;
			if (len>2)
			{
				removeChild(dg);
				var i:uint = 0;
				while (i<len)
				{
					if (dg==points[++i])
					{
						points.splice(i, 1);
						i = len;
					}
				}
			}
			else
				dg.y = stage.stageHeight-40;
		}
		
		private function loop(event:Event):void
		{
			var len:uint = points.length;
			var p:Point;
			canvas.graphics.clear();
			//line
			if (cbLine.selected)
			{
				canvas.graphics.lineStyle(0, 0x990000);
				canvas.graphics.moveTo(points[0].x, points[0].y);
				for (var i:uint=1;i<len;i++)
					canvas.graphics.lineTo(points[i].x, points[i].y);
			}
			//curve
			canvas.graphics.lineStyle(3, 0x000000, 1, false, "normal", CapsStyle.SQUARE);
			canvas.graphics.moveTo(points[0].x, points[0].y);
			var t:Number = 1/CURVE_NUMBER;
			var index:uint = 0;
			while (t<1)
			{
				p = BezierCurve.getPoint(t, points);
				canvas.graphics.lineTo(p.x, p.y);
				t += 1/CURVE_NUMBER;
			}
			canvas.graphics.lineTo(points[len-1].x, points[len-1].y);
			//show points?
			for each (var dg:DragPoint in points)
				dg.visible = cbPoints.selected;
			//marker
			addChild(marker);
			p = BezierCurve.getPoint(1-vsPosition.value, points);
			marker.x = p.x;
			marker.y = p.y;
			lbPosition.text = (1-vsPosition.value).toFixed(2);
		}
		
		private function mouseHandler(event:MouseEvent):void
		{
			if (event.target==stage)
				addPoint(event.stageX, event.stageY);
		}
		
	}
}