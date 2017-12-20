package classes.display 
{
	import classes.display.BindDisplay;
	import coc.view.Block;
	import coc.view.CoCButton;
	import fl.containers.ScrollPane;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Provides a scrollable container for game settings.
	 * @author Kitteh6660
	 */
	public class SettingPane extends ScrollPane
	{	
		private var _stage:Stage;
		
		private var _content:Block;
		private var _contentChildren:int;

		private var _initialized:Boolean = false;
		private var _buttonDb:Array = []; 
		
		/**
		 * Initiate the BindingPane, setting the stage positioning and reference back to the input manager
		 * so we can generate function callbacks later.
		 * 
		 * @param	xPos			X position on the stage for the top-left corner of the ScrollPane
		 * @param	yPos			Y position on the stage for the top-left corner of the ScrollPane
		 * @param	width			Fixed width of the containing ScrollPane
		 * @param	height			Fixed height of the containing ScrollPane
		 */
		public function SettingPane(xPos:int, yPos:int, width:int, height:int)
		{
			move(xPos,yPos);
			setSize(width,height);
			
			// Cheap hack to remove the stupid styling elements of the stock ScrollPane
			var blank:MovieClip = new MovieClip();
			this.setStyle("upSkin", blank);
			
			// Initiate a new container for content that will be placed in the scroll pane
			_content = new Block({layoutConfig:{
				type: Block.LAYOUT_FLOW,
				direction: 'column',
				gap: 4
			}});
			_content.name = "controlContent";
			_content.addEventListener(Block.ON_LAYOUT,function(e:Event):void{
				if (source) {
					update();
				}
			});
			_contentChildren = 0;

			// Hook into some stuff so that we can fix some bugs that ScrollPane has
			this.addEventListener(Event.ADDED_TO_STAGE, AddedToStage);
			this.source = _content;
		}
		
		/**
		 * Cleanly get us a reference to the stage to add/remove other event listeners
		 * @param	e
		 */
		private function AddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, AddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, RemovedFromStage);
			
			_stage = this.stage;
			
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, MouseScrollEvent);
		}
		
		private function RemovedFromStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, RemovedFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE, AddedToStage);
			
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, MouseScrollEvent);
		}
		
		private function MouseScrollEvent(e:MouseEvent):void
		{
			this.verticalScrollPosition += -( e.delta * 8 );
		}
		
		public function get initialized():Boolean { return _initialized; }
		public function set initialized(bool:Boolean):void { _initialized = bool; }

		public function addHelpLabel():TextField {
			// Add a nice little instructional field at the top of the display.
			var _textFormatLabel:TextFormat = new TextFormat();
			_textFormatLabel.size = 20;
			// Make the help label.
			var helpLabel:TextField = new TextField();
			helpLabel.name = "helpLabel";
			helpLabel.x = 10;
			helpLabel.width = this.width - 40;
			helpLabel.defaultTextFormat = _textFormatLabel;
			helpLabel.multiline = true;
			helpLabel.wordWrap = true;
			helpLabel.autoSize = TextFieldAutoSize.LEFT; // With multiline enabled, this SHOULD force the textfield to resize itself vertically dependent on content.
			_content.addElement(helpLabel);
			return helpLabel;
		}
		
		public function addToggleSettings(label:String, args:Array):BindDisplay {
			_contentChildren++;
			
			var newLabel:BindDisplay = new BindDisplay(this.width - 20, 50, args.length);
			newLabel.label.multiline = true;
			newLabel.htmlText = "<b>" + label + ":</b>\n";
			for (var i:int = 0; i < args.length; i++) {
				trace(label + ": " + args[i][3]);
				newLabel.buttons[i].labelText = args[i][0];
				newLabel.buttons[i].callback = generateCallback(args[i][1]);
				//newLabel.buttons[i].disableIf(args[i][3]);
				_buttonDb.push(new Array(newLabel.buttons[i], newLabel.getChildIndex(), label, colourifyText(args[i][0]), args[i][2], args[i][3]));
			}
			_content.addElement(newLabel);
			return newLabel;
		}
		
		public function updateToggleSettings():SettingPane {
			trace(_buttonDb.length);
			for (var i:int = 0; i < _buttonDb.length; i++) {
				//_buttonDb[i][0].disableIf(_buttonDb[i][5]);
				_buttonDb[i][1].htmlText = "<b>" + _buttonDb[i][2] + ": " + _buttonDb[i][3] + "</b>\n" + _buttonDb[i][4];
			}
			update();
			trace("Update triggered.");
			return this;
		}
		
		private function generateCallback(func:Function):Function {
			return func;
		}
		
		private function colourifyText(text:String):String {
			if (text.toLowerCase() == "on" || text.toLowerCase() == "enabled") {
				text = "<font color=\"#008000\">" + text + "</font>";
			}
			else if (text.toLowerCase() == "off" || text.toLowerCase() == "disabled") {
				text = "<font color=\"#800000\">" + text + "</font>";
			}
			else if (text.toLowerCase() == "choose" || text.toLowerCase() == "enable") {
				text = "";
			}
			return text;
		}
	}
}
