/**
 * ExternalInterfaceExample2.as by Lee Burrows
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
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	[SWF(frameRate="30", width="400", height="200", backgroundColor="#E0E0E0")]
	public class ExternalInterfaceExample2 extends Sprite
	{
		private var button:SimpleButton;
		
		private var flag:Boolean;

		public function ExternalInterfaceExample2()
		{
			//build button
			button = buildButton("talk to javascript");
			button.x = 100;
			button.y = 75;
			button.addEventListener(MouseEvent.CLICK, clickHandler);
			addChild(button);
			//set flag
			flag = true;
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			//switch flag
			flag = !flag;
			//is ExternalInterface available?
			if (ExternalInterface.available)
				//call js myFabFunction(colour)
				ExternalInterface.call("myFabFunction", flag ? "#FFFFFF" : "#FF0000");
		}
		
		//helper methods to build all the contents
		private function buildButton(label:String):SimpleButton
		{
			var tf:TextField;
			var upState:Sprite = buildSprite(0x990000, 200, 50);
			tf = buildLabel(label, 14);
			tf.x = int((200-tf.width)*0.5);
			tf.y = int((50-tf.height)*0.5);
			upState.addChild(tf);
			var overState:Sprite = buildSprite(0x660000, 200, 50);
			tf = buildLabel(label, 14);
			tf.x = int((200-tf.width)*0.5);
			tf.y = int((50-tf.height)*0.5);
			overState.addChild(tf);
			var downState:Sprite = buildSprite(0x330000, 200, 50);
			tf = buildLabel(label, 14);
			tf.x = int((200-tf.width)*0.5);
			tf.y = int((50-tf.height)*0.5);
			downState.addChild(tf);
			var hitState:Sprite = buildSprite(0xFF0000, 200, 50);
			return new SimpleButton(upState, overState, downState, hitState);
		}

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