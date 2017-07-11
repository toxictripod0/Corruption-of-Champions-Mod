/**
 * Coded by aimozg on 10.07.2017.
 */
package coc.view {
import coc.script.Eval;
import coc.view.UIUtils;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class CharView extends Sprite {
	[Embed(source="../../../res/model.xml", mimeType="application/octet-stream")]
	private static const XML_MODEL_CLASS:Class;

	private var xml:XML;
	private var bitmaps:Object = {}; // layer.@file -> BitmapData
	private var composite:CompositeImage;
	private var nfiles:int;
	private var nloaded:int;
	private var _width:uint;
	private var _height:uint;
	public function CharView() {
		var loader:URLLoader = new URLLoader();
		var req:URLRequest = new URLRequest('res/model.xml');
		loader.addEventListener(Event.COMPLETE, function (e:Event):void {
			init(XML(loader.data));
		});
		loader.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
			trace("File not found: " + e);
			nloaded++;
		});
		loader.load(req);
	}
	private function init(xml:XML):void {
		this.xml = xml;
		_width    = xml.@width;
		_height   = xml.@height;
		composite = new CompositeImage(_width, _height);
		for each(var item:XML in xml.layers.*) {
			loadBitmapsFrom(item);
		}
		nfiles         = -nfiles;
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 0);
		g.drawRect(0, 0, _width, _height);
		g.endFill();
	}
	private var _character:Object = {};
	public function setCharacter(value:Object):void {
		_character = value;
	}
	private function evaluate(root:*, expr:String):* {
		var f:Number = parseFloat(expr);
		if (!isNaN(f)) return f;
		if (expr in root) return root[expr];
		return undefined;
	}
	public function redraw():void {
		if (!xml || nfiles != nloaded) return;

		// Calcualte palette ( "hair" -> actual color }
		var palette:Object   = {};
		for each (var prop:XML in xml.palette.property) {
			var pn:String = prop.@name;
			var pv:String        = String(Eval.eval(_character, prop.@src));
			var colorval:XMLList = prop.color.(@name == pv);
			if (colorval.length() == 0) {
				trace("CharView: not found " + pn +".'"+pv+"'");
				colorval = prop.default;
			}
			if (colorval.length() > 0) palette[pn] = Color.convertColor(colorval[0].toString());
		}

		// Calculate colors ( key color -> actual color }
		var keyColors:Object = {};
		for each (var key:XML in xml.colorkeys.key) {
			var src:uint = Color.convertColor(key.@src.toString());
			var base:uint = palette[key.@base];
			var tf:String = key.@transform;
			if (tf) {
				var tfs:/*String*/Array = tf.split(";");
				for each (var transform:String in tfs) {
					var fn:Array = transform.match(/^(\w+)\(([\d.]+)\)/);
					var fname:String = fn?fn[1]:undefined;
					var fvalue:Number = fn?fn[2]:undefined;
					switch(fname){
						case "darken":
							base = Color.darken(base,fvalue);
							break;
						default:
							trace("Error: invalid color transform '"+transform+"'");
							break;
					}
				}
			}
			keyColors[src] = base & 0x00ffffff;
		}

		// Mark visible layers
		composite.hideAll();
		for each(var item:XML in xml.layers.*) {
			drawItem(item);
		}

		var bd:BitmapData = composite.draw(keyColors);
		var g:Graphics    = graphics;
		g.clear();
		g.beginBitmapFill(bd);
		g.drawRect(0, 0, _width, _height);
		g.endFill();
	}
	private function clear():void {
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 0);
		g.drawRect(0, 0, _width, _height);
		g.endFill();
	}
	private function layerId(x:XML):String {
		return x.@id || x.@file;
	}
	private function drawItem(x:XML):void {
		var testval:*;
		var layer:XML;
		switch (x.localName()) {
			case 'layer':
				const lid:String = layerId(x);
				composite.setVisibility(lid, true);
				break;
			case 'if':
				testval = Eval.eval(_character,x.@test.toString());
				if (testval) {
					for each (layer in x.*) drawItem(layer);
				}
				break;
			case 'switch':
				var found:Boolean = false;
				var xcase:XML;
				for each (xcase in x.elements("case")) {
					testval = Eval.eval(_character,xcase.@test.toString());
					if (testval) {
						found = true;
						for each (layer in xcase.*) {
							drawItem(layer);
						}
						break;
					}
				}
				if (!found) {
					for each (layer in x.elements("default").*) {
						drawItem(layer);
					}
				}
				break;
		}
	}
	private function loadBitmapsFrom(item:XML):void {
		var layer:XML;
		switch (item.localName()) {
			case 'layer':
				const filename:String = item.@file;
				if (filename in bitmaps) return;
				const lid:String = layerId(item);
				bitmaps[lid]     = new BitmapData(1, 1);
				composite.addLayer(filename, bitmaps[filename], false);
				var req:URLRequest = new URLRequest(xml.@dir + filename);
				trace('loading ' + req.url);
				nfiles--;
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void {
					var li:LoaderInfo = (e.target as LoaderInfo);
					var bmp:Bitmap    = li.content as Bitmap;
					if (!bmp) {
						trace("error: loaded " + li.url + " as " + li.contentType + " " + li.content);
						return;
					}
					bitmaps[lid] = bmp.bitmapData;
					composite.replaceLayer(filename, bitmaps[filename]);
					nloaded++;
//					if (nfiles == nloaded) redraw();
				});
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
					trace("File not found: " + e);
					nloaded++;
//					if (nfiles == nloaded) redraw();
				});
				loader.load(req);
				break;
			case 'if':
				for each (layer in item.*) {
					loadBitmapsFrom(layer);
				}
				break;
			case 'switch':
				for each (layer in item.elements("case").*) {
					loadBitmapsFrom(layer);
				}
				for each (layer in item.elements("default").*) {
					loadBitmapsFrom(layer);
				}
				break;
		}
	}

}
}

