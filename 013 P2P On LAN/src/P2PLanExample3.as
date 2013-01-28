/**
 * P2PLanExample3.as by Lee Burrows
 * Nov 24, 2011
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
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	[SWF(width="250",height="300",backgroundColor="#EEEEEE")]
	public class P2PLanExample3 extends Sprite
	{
		static private const CONNECTED:String = "connected";
		static private const DISCONNECTED:String = "disconnected";

		private var netConn:NetConnection;
		private var group:NetGroup;

		private var label:Label;
		private var inputText:InputText;
		private var outputText:TextArea;
		private var submitButton:PushButton;
		private var peerList:ComboBox;

		private var hasConnected:Boolean;

		public function P2PLanExample3()
		{
			//create UI (using minimalComps)
			label = new Label(this, 10, 10);
			label.width = 230;
			inputText = new InputText(this, 10, 35, "");
			inputText.width = 230;
			peerList = new ComboBox(this, 10, 60);
			peerList.width = 110;
			submitButton = new PushButton(this, 130, 60, "Send", btnHandler);
			submitButton.width = 110;
			submitButton.enabled = false;
			outputText = new TextArea(this, 10, 95, "");
			outputText.width = 230;
			outputText.height = 195;
			
			//setup list of users
			peerList.items = [{label:"ALL"}];
			peerList.selectedIndex = 0;
			
			//setup params
			hasConnected = false;
			
			//setup connection object
			netConn = new NetConnection();
			//listen for result of setup
			netConn.addEventListener(NetStatusEvent.NET_STATUS, netHandler);
			//connect to LAN
			netConn.connect("rtmfp:");			
		}

		private function btnHandler(event:MouseEvent):void
		{
			// Create an object to hold the data to send
			var obj:Object = createTextMessageObject(inputText.text);
			//update UI
			outputText.text += "[SENDING TO "+peerList.selectedItem.label+"]\n"+inputText.text+"\n";

			if (peerList.selectedItem.label=="ALL")
			{
				//send to everyone in group
				group.post(obj);
			}
			else
			{
				//get group address of peer
				var destination:String = group.convertPeerIDToGroupAddress(String(peerList.selectedItem.id));
				//save to message object
				obj.destination = destination;
				//send directed message
				group.sendToNearest(obj, destination);
			}
		}
		
		private function netHandler(event:NetStatusEvent):void
		{
			var obj:Object;
			//handle event
			switch(event.info.code)
			{
				//connection succeeded so setup a group
				case "NetConnection.Connect.Success":
					label.text = "ID: "+truncateString(netConn.nearID);
					setupGroup();
					break;
				//group setup succeeded so enable submit
				case "NetGroup.Connect.Success":
					submitButton.enabled = true;
					break;
				//posting received
				case "NetGroup.Posting.Notify":
					//handle status message
					if (event.info.message.status!=null)
					{
						//a peer has connected to group
						if (event.info.message.status==CONNECTED)
						{
							//store peer info
							addPeerToList(event.info.message.peerID);
							//send this peers' info back to originator
							obj = createStatusMessageObject(CONNECTED);
							obj.destination = group.convertPeerIDToGroupAddress(event.info.message.peerID);
							group.sendToNearest(obj, obj.destination);
						}
						//a peer has disconnected from group
						else if (event.info.message.status==DISCONNECTED)
						{
							//remove peer info
							removePeerFromList(event.info.message.peerID);
						}
					}
					//handle text message
					else
					{
						//add message to UI
						outputText.text += "[RECEIVED FROM "+truncateString(event.info.message.peerID)+"]\n"+event.info.message.txt+"\n";
					}
					break;
				//neighbour connected
				case "NetGroup.Neighbor.Connect":
					//see if this is first connect event
					if (!hasConnected)
					{
						//set flag
						hasConnected = true;
						//tell entire group about this instance
						obj = createStatusMessageObject(CONNECTED);
						group.post(obj);
					}
					break;
				//neighbour disconnected
				case "NetGroup.Neighbor.Disconnect":
					//remove peer info
					removePeerFromList(event.info.peerID);
					//tell entire group about peer disconnecting
					obj = createStatusMessageObject(DISCONNECTED);
					obj.peerID = event.info.peerID;
					group.post(obj);
					break;
				//directed message received so check if this is the final destination
				case "NetGroup.SendTo.Notify":
					//final destination reached
					if (event.info.fromLocal==true)
					{
						//handle status message
						if (event.info.message.status!=null && event.info.message.status==CONNECTED)
						{
							//store peer info
							addPeerToList(event.info.message.peerID);
						}
						//handle text message
						else
						{
							//add message to UI
							outputText.text += "[RECEIVED FROM "+truncateString(event.info.message.peerID)+"]\n"+event.info.message.txt+"\n";
						}
					}
					//not destination so re-send
					else
					{
						group.sendToNearest(event.info.message, event.info.message.destination);
					}
					break;
			}
		}

		//--------------------------------------------------
		//
		//	helper methods
		//
		//--------------------------------------------------

		private function setupGroup():void
		{
			//create a GroupSpecifier object
			var groupspec:GroupSpecifier = new GroupSpecifier("myGroup");
			//enable posting (to entire group)
			groupspec.postingEnabled = true;
			//enable direct routing (to individual peer)
			groupspec.routingEnabled = true;
			//allow data to be exchanged on IP multicast sockets
			groupspec.ipMulticastMemberUpdatesEnabled = true;
			//set the IP adress and port to use
			groupspec.addIPMulticastAddress("225.225.0.1:30000");
			//create NetGroup with our NetConnection using GroupSpecifier details
			group = new NetGroup(netConn, groupspec.groupspecWithAuthorizations());
			//listen for result of setup
			group.addEventListener(NetStatusEvent.NET_STATUS, netHandler);
		}

		private function truncateString(str:String):String
		{
			return str.substr(0, 10)+"...";
		}
		
		private function addPeerToList(id:String):void
		{
			removePeerFromList(id);
			var peer:Object = new Object();
			peer.id = id;
			peer.label = truncateString(id);
			peerList.addItem(peer);
		}

		private function removePeerFromList(id:String):void
		{
			var len:uint = peerList.items.length;
			for (var i:uint=0;i<len;i++)
			{
				if (peerList.items[i].id==id)
				{
					peerList.removeItemAt(i);
					break;
				}
			}
		}
		
		private function createTextMessageObject(txt:String):Object
		{
			var obj:Object = new Object();
			obj.txt = txt;
			obj.peerID = netConn.nearID;
			obj.id = new Date().time.toString()+(Math.random()*int.MAX_VALUE).toString();
			return obj;
		}

		private function createStatusMessageObject(status:String):Object
		{
			var obj:Object = new Object();
			obj.status = status;
			obj.peerID = netConn.nearID;
			obj.id = new Date().time.toString()+(Math.random()*int.MAX_VALUE).toString();
			return obj;
		}

	}
}