/**
 * ExternalInterfaceExample3.as by Lee Burrows
 * Aug 20, 2011
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
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	[SWF(frameRate="30", width="400", height="200", backgroundColor="#E0E0E0")]
	public class ExternalInterfaceExample3 extends Sprite
	{
		private var tf:TextField;
		private var timer:Timer;

		public function ExternalInterfaceExample3()
		{
			//build display
			var back:Sprite = buildSprite(0x996600, 300, 50);
			back.x = 50;
			back.y = 75;
			addChild(back);
			tf = buildLabel("",16);
			addChild(tf);
			//register method with javascript
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			timer.start();
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			ExternalInterface.addCallback("setFlashLabel", setLabel);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			timer.stop();
		}
		
		private function setLabel(value:String):void
		{
			//update textfield
			tf.text = value;
			//and recenter
			tf.x = int((400-tf.width)*0.5);
			tf.y = int((200-tf.height)*0.5);
		}

		//helper methods to build all the contents
		private function buildSprite(colour:uint, width:int, height:int):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(colour);
			sprite.graphics.drawRect(0, 0, width, height);
			sprite.graphics.endFill();
			return sprite;
		}
		private function buildLabel(label:String, size:int):TextField
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("_sans", size, 0xFFFFFF);
			tf.text = label;
			tf.autoSize = TextFieldAutoSize.LEFT;
			return tf;
		}

	}
}