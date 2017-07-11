/**
 * Coded by aimozg on 12.07.2017.
 */
package coc.script {
import classes.internals.Utils;

public class Eval {
	private var thiz:*;
	private var expr:String;
	private var src:String;
	public function Eval(thiz:*, expr:String) {
		this.thiz = thiz;
		this.src = expr;
		this.expr = expr;
	}

	private static const LA_INT:RegExp = /^(0x)?\d+/;
	private static const LA_ID:RegExp = /^[a-zA-Z_$][a-zA-Z_$0-9]*/;
	private static const LA_OPERATOR:RegExp = /^(>=?|<=?|!==?|={1,3})/;
	public static function eval(thiz:*, expr:String):* {
		return new Eval(thiz, expr).evalUntil();
	}
	private function evalPostExpr(x:*):* {
		var m:Array;
		while (true) {
			eatWs();
			if ((m = eat(LA_OPERATOR))) {
				var y:* = evalExpr();
				x = evalOp(x,m[0],y);
			} else if (eatStr('.')) {
				m = eat(LA_ID);
				if (!m) throw new Error("In expr: " + src + "\n" +
										"Identifier expected: " + expr);
				x = evalDot(x, m[0]);
			} else if (eatStr('[')) {
				var index:* = evalUntil("]");
				eatWs();
				expr = expr.substr(1);
				x = evalDot(x, index);
			} else break;
		}
		return x;
	}
	private function evalOp(x:*,op:String,y:*):* {
//		trace("Evaluating " + (typeof x) + " " + x + " " + op + " " + (typeof y) + " " + y);
		switch (op) {
			case '>':
				return x > y;
			case '>=':
				return x >= y;
			case '<':
				return x < y;
			case '<=':
				return x <= y;
			case '=':
			case '==':
				return x == y;
			case '===':
				return x === y;
			case '!=':
				return x != y;
			case '!==':
				return x !== y;
			default:
				throw new Error("In expr: " + src + "\n" +
								"Unregistered operator " + op);
		}
	}
	private function evalExpr():* {
		var m:Array;
		var x:*;
		eatWs();
		if ((m = eat(LA_INT))) {
			x = parseInt(m[0]);
		} else if ((m = eat(LA_ID))) {
			x = evalId(m[0]);
		} else if (eatStr('(')) {
			x = evalUntil(")");
			eatStr(")");
		} else {
			throw new Error("In expr: " + src+"\n" +
							"Not a sub-expr: " + expr);
			// return undefined;
		}
		return evalPostExpr(x);
	}
	private function evalUntil(until:String = ""):* {
		var x:* = evalExpr();
		if (expr == until || expr.charAt(0) == until) return x;
		if (until) throw new Error("In expr: " + src+"\n" +
								   "Operator or " + until + "expected: " + expr);
		throw new Error("In expr: " + src+"\n" +
						"Operator expected: " + expr);
	}
	private function eat(rex:RegExp):Array {
		var m:Array = expr.match(rex);
		if (m) expr = expr.substr(m[0].length);
		return m;
	}
	private function eatStr(s:String):Boolean {
		if (expr.substr(0,s.length).indexOf(s) == 0) {
			expr = expr.substr(s.length);
			return true;
		}
		return false;
	}
	private function eatWs():void {
		eat(/^\s+/);
	}
	private function evalId(id:String):* {
		if (id in thiz) return thiz[id];
//		trace("Not found key "+id);
		return undefined;
	}
	private function evalDot(obj:Object,key:String):* {
		return obj[key];
	}
}
}
