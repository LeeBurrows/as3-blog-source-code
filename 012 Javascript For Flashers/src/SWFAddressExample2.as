/**
 * SWFAddressExample2.as by Lee Burrows
 * Aug 18, 2011
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
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	[SWF(frameRate="30", width="550", height="400", backgroundColor="#E0E0E0")]
	public class SWFAddressExample2 extends Sprite
	{
		public var button1:SimpleButton;
		public var button2:SimpleButton;
		public var button3:SimpleButton;
		public var page1:Sprite;
		public var page2:Sprite;
		public var page3:Sprite;

		public function SWFAddressExample2()
		{
			//build buttons
			button1 = buildButton("Page 1");
			button1.name = "1";
			button1.x = 30;
			button1.y = 30;
			button1.addEventListener(MouseEvent.CLICK, clickHandler);
			addChild(button1);
			button2 = buildButton("Page 2");
			button2.name = "2";
			button2.x = 150;
			button2.y = 30;
			button2.addEventListener(MouseEvent.CLICK, clickHandler);
			addChild(button2);
			button3 = buildButton("Page 3");
			button3.name = "3";
			button3.x = 270;
			button3.y = 30;
			button3.addEventListener(MouseEvent.CLICK, clickHandler);
			addChild(button3);
			//build pages
			page1 = buildPage("This is page one", 0x990000);
			page1.x = 5;
			page1.y = 95;
			addChild(page1);
			page2 = buildPage("I am page two", 0x009900);
			page2.x = 5;
			page2.y = 95;
			addChild(page2);
			page3 = buildPage("Welcome to page three", 0x000099);
			page3.x = 5;
			page3.y = 95;
			addChild(page3);
			//setup SWFAddress
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, swfaddressHandler);
		}
		
		//listen for button mouse clicks
		private function clickHandler(event:MouseEvent):void
		{
			//tell SWFAddress which page to display
			SWFAddress.setValue("/"+event.target.name);
		}

		private function swfaddressHandler(event:SWFAddressEvent):void
		{
			//get page index from event
			var pageIndex:int = int(event.value.substr(1));
			//check if valid value
			if (pageIndex==0)
				pageIndex = 1;
			//set page to display
			showPage(pageIndex);
		}
		
		//set display to required page
		private function showPage(index:int):void
		{
			page1.visible = index==1;
			page2.visible = index==2;
			page3.visible = index==3;
		}
		
		//helper methods to build all the contents
		private function buildButton(label:String):SimpleButton
		{
			var tf:TextField;
			var upState:Sprite = buildSprite(0xCCCCCC, 100, 30);
			tf = buildLabel(label, 14);
			tf.x = int((100-tf.width)*0.5);
			tf.y = int((30-tf.height)*0.5);
			upState.addChild(tf);
			var overState:Sprite = buildSprite(0x999999, 100, 30);
			tf = buildLabel(label, 14);
			tf.x = int((100-tf.width)*0.5);
			tf.y = int((30-tf.height)*0.5);
			overState.addChild(tf);
			var downState:Sprite = buildSprite(0x666666, 100, 30);
			tf = buildLabel(label, 14);
			tf.x = int((100-tf.width)*0.5);
			tf.y = int((30-tf.height)*0.5);
			downState.addChild(tf);
			var hitState:Sprite = buildSprite(0xFF0000, 100, 30);
			return new SimpleButton(upState, overState, downState, hitState);
		}
		private function buildPage(text:String, colour:uint):Sprite
		{
			var sprite:Sprite = buildSprite(colour, 540, 300);
			var tf:TextField = buildLabel(text, 36);
			tf.x = int((540-tf.width)*0.5);
			tf.y = int((300-tf.height)*0.5);
			sprite.addChild(tf);
			return sprite;
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