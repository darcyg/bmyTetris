(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
var beatMy = {}
beatMy.MainTetris = function(mainContent) {
	this.board = new beatMy.tetris.ModelBoard();
	this.view = new beatMy.tetris.UserView(mainContent,this.board);
	this.playerModel = new beatMy.tetris.UserStateModel();
	this.playerControler = new beatMy.tetris.UserControler(this.playerModel,mainContent);
	this.view.resize();
	this.playerControler.start();
	haxe.Timer.delay($bind(this,this.evtGameLoop),300);
};
beatMy.MainTetris.__name__ = true;
beatMy.MainTetris.main = function() {
	console.log("Debug infos for all debug compiles");
	createjs.Ticker.useRAF = false;
	createjs.Ticker.setFPS(30);
	beatMy.MainTetris.mainContent = js.Browser.document.getElementById("mainContent");
	beatMy.MainTetris.mainContent.oncontextmenu = function(e) {
		e.stopPropagation();
		return false;
	};
	var container = beatMy.MainTetris.mainContent.parentElement;
	js.Browser.document.getElementById("loader").className = "";
	beatMy.MainTetris.loadQueue = new createjs.LoadQueue(false);
	beatMy.MainTetris.loadQueue.addEventListener("complete",beatMy.MainTetris.evt_fileLoadComplete);
	beatMy.MainTetris.loadQueue.addEventListener("progress",beatMy.MainTetris.evt_fileLoadProgress);
	beatMy.MainTetris.loadQueue.addEventListener("error",beatMy.MainTetris.evt_fileLoadError);
	beatMy.MainTetris.loadQueue.setMaxConnections(5);
	container.oncontextmenu = beatMy.MainTetris.onContextMenu;
	beatMy.MainTetris._main = new beatMy.MainTetris(beatMy.MainTetris.mainContent);
	createjs.Ticker.addListener(($_=beatMy.MainTetris._main,$bind($_,$_.tickHandler)));
}
beatMy.MainTetris.evt_fileLoadError = function(e) {
	console.log("ERROR : evt_fileLoadError");
}
beatMy.MainTetris.evt_fileLoadProgress = function(e) {
	console.log("TOTAL: " + beatMy.MainTetris.loadQueue.progress);
	var perc = beatMy.MainTetris.loadQueue.progress * 100;
	new js.JQuery("#loadingFill").animate({ width : perc + "%"},2);
	js.Browser.document.getElementById("loader").className = "loader";
}
beatMy.MainTetris.evt_fileLoadComplete = function(e) {
	console.log("evt_fileLoadComplete TOTAL: " + beatMy.MainTetris.loadQueue.progress);
	js.Browser.document.getElementById("loader").className = "";
	if(beatMy.MainTetris._main != null) {
	}
}
beatMy.MainTetris.onContextMenu = function(e) {
	console.log("contextMenu" + e.type);
}
beatMy.MainTetris.prototype = {
	tickHandler: function() {
		this.view.update();
	}
	,evtGameLoop: function() {
		if(this.playerModel.bLEFT) this.board.left();
		if(this.playerModel.bRIGHT) this.board.right();
		if(this.playerModel.bROTATE) this.board.rotate();
		if(!this.playerModel.bLEFT && !this.playerModel.bRIGHT && !this.playerModel.bLEFT && !this.playerModel.bROTATE) this.board.tick();
		if(this.board.lose) {
			this.playerControler.stop();
			return;
		}
		if(this.playerModel.bDROP) haxe.Timer.delay($bind(this,this.evtGameLoop),50); else haxe.Timer.delay($bind(this,this.evtGameLoop),150);
	}
}
beatMy.tetris = {}
beatMy.tetris.ModelBoard = function() {
	this.newItem = false;
	this.lineDrop = 0;
	this.lose = false;
	this.helper_builder();
	this.current = this.newCurrent();
};
beatMy.tetris.ModelBoard.__name__ = true;
beatMy.tetris.ModelBoard.prototype = {
	tick: function() {
		this.lose = false;
		this.lineDrop = 0;
		this.newItem = false;
		if(this.valide(this.current,0,1)) this.current.y++; else {
			this.freeze(this.current);
			this.lineDrop = this.clearLines();
			this.current = this.newCurrent();
			this.newItem = true;
			this.lose = !this.valide(this.current,0,0);
		}
	}
	,freeze: function(piece) {
		var _g1 = 0, _g = piece.forme.length;
		while(_g1 < _g) {
			var y = _g1++;
			var _g3 = 0, _g2 = piece.forme[y].length;
			while(_g3 < _g2) {
				var x = _g3++;
				if(piece.forme[y][x] == beatMy.tetris.ModelData.FILL) this.board[piece.y + y][piece.x + x] = piece.forme[y][x];
			}
		}
	}
	,clearLines: function() {
		var ret = 0;
		var _y = -(beatMy.tetris.ModelData.ROWS - 1);
		while(_y != 0) {
			var row = true;
			var _g1 = 0, _g = beatMy.tetris.ModelData.COLS;
			while(_g1 < _g) {
				var x = _g1++;
				if(this.board[-_y][x] == 0) {
					row = false;
					break;
				}
			}
			if(row) {
				var _g = _y;
				while(_g < 0) {
					var _yy = _g++;
					var _g2 = 0, _g1 = beatMy.tetris.ModelData.COLS;
					while(_g2 < _g1) {
						var x = _g2++;
						this.board[-_yy][x] = this.board[-_yy - 1][x];
						this.board[-_yy - 1][x] = 0;
					}
				}
				ret++;
			} else _y++;
		}
		return ret;
	}
	,valide: function(piece,offsetX,offsetY) {
		if(offsetY == null) offsetY = 0;
		if(offsetX == null) offsetX = 0;
		var _g1 = 0, _g = piece.forme.length;
		while(_g1 < _g) {
			var y = _g1++;
			var _g3 = 0, _g2 = piece.forme[y].length;
			while(_g3 < _g2) {
				var x = _g3++;
				if(piece.forme[y][x] == beatMy.tetris.ModelData.FILL) {
					var ny = piece.y + y + offsetY;
					var nx = piece.x + x + offsetX;
					if(ny < 0 || ny >= beatMy.tetris.ModelData.ROWS || nx < 0 || nx >= beatMy.tetris.ModelData.COLS || this.board[ny][nx] != 0) return false;
				}
			}
		}
		return true;
	}
	,right: function() {
		if(this.valide(this.current,1)) {
			this.current.x++;
			return true;
		}
		return false;
	}
	,left: function() {
		if(this.valide(this.current,-1)) {
			this.current.x--;
			return true;
		}
		return false;
	}
	,rotate: function() {
		var cloneCurrent = this.current.clone_rotate();
		if(this.valide(cloneCurrent)) {
			this.current = cloneCurrent;
			return true;
		} else if(this.valide(cloneCurrent,1)) {
			this.current = cloneCurrent;
			this.current.x++;
			return true;
		} else if(this.valide(cloneCurrent,-1)) {
			this.current = cloneCurrent;
			this.current.x--;
			return true;
		}
		return false;
	}
	,newCurrent: function() {
		var id = Math.floor(Math.random() * beatMy.tetris.ModelData.me().shapes.length);
		var ret = new beatMy.tetris.ModelPiece(id);
		ret.x = 2;
		ret.y = 0;
		return ret;
	}
	,helper_builder: function() {
		this.board = new Array();
		var _g1 = 0, _g = beatMy.tetris.ModelData.ROWS;
		while(_g1 < _g) {
			var y = _g1++;
			this.board[y] = new Array();
			var _g3 = 0, _g2 = beatMy.tetris.ModelData.COLS;
			while(_g3 < _g2) {
				var x = _g3++;
				this.board[y][x] = 0;
			}
		}
	}
	,get_current: function() {
		return this.current;
	}
	,get_piece: function(x,y) {
		return this.board[y][x];
	}
}
beatMy.tetris.ModelData = function() {
	this.intShapes();
	this.initColors();
};
beatMy.tetris.ModelData.__name__ = true;
beatMy.tetris.ModelData.me = function() {
	if(beatMy.tetris.ModelData._me != null) return beatMy.tetris.ModelData._me;
	beatMy.tetris.ModelData._me = new beatMy.tetris.ModelData();
	return beatMy.tetris.ModelData._me;
}
beatMy.tetris.ModelData.prototype = {
	initColors: function() {
		this.colors = ["cyan","orange","blue","yellow","red","green","purple"];
	}
	,intShapes: function() {
		this.shapes = [[1,1,1,1],[1,1,1,0,1],[1,1,1,0,0,0,1],[1,1,0,0,1,1],[1,1,0,0,0,1,1],[0,1,1,0,1,1],[1,1,1,0,0,1]];
	}
}
beatMy.tetris.ModelPiece = function(id) {
	if(id != null) this.helper_builder(id); else {
	}
};
beatMy.tetris.ModelPiece.__name__ = true;
beatMy.tetris.ModelPiece.prototype = {
	clone: function() {
		var ret = new beatMy.tetris.ModelPiece();
		ret.x = this.x;
		ret.y = this.y;
		ret.id = this.id;
		ret.forme = new Array();
		var _g = 0, _g1 = this.forme;
		while(_g < _g1.length) {
			var r = _g1[_g];
			++_g;
			var row = new Array();
			ret.forme.push(row);
			var ci = 0;
			var _g2 = 0;
			while(_g2 < r.length) {
				var c = r[_g2];
				++_g2;
				row[ci] = c;
				ci++;
			}
		}
		return ret;
	}
	,clone_rotate: function() {
		var ret = new beatMy.tetris.ModelPiece();
		ret.x = this.x;
		ret.y = this.y;
		ret.id = this.id;
		ret.forme = new Array();
		var _g1 = 0, _g = this.forme.length;
		while(_g1 < _g) {
			var yy = _g1++;
			var _g3 = 0, _g2 = this.forme[yy].length;
			while(_g3 < _g2) {
				var xx = _g3++;
				if(ret.forme[beatMy.tetris.ModelData.SHAPE_WIDTH - xx - 1] == null) ret.forme[beatMy.tetris.ModelData.SHAPE_WIDTH - xx - 1] = new Array();
				ret.forme[beatMy.tetris.ModelData.SHAPE_WIDTH - xx - 1][yy] = this.forme[yy][xx];
			}
		}
		var _y = 0;
		while(_y < ret.forme.length) if(ret.forme[_y] == null) ret.forme.splice(_y,1); else _y++;
		return ret;
	}
	,helper_builder: function(id) {
		this.id = id;
		var shape = beatMy.tetris.ModelData.me().shapes[id];
		this.forme = new Array();
		var yy = 0;
		var xx = 0;
		this.forme[yy] = new Array();
		var _g = 0;
		while(_g < shape.length) {
			var i = shape[_g];
			++_g;
			switch(i) {
			case beatMy.tetris.ModelData.FILL:
				this.forme[yy][xx] = beatMy.tetris.ModelData.FILL;
				break;
			default:
				this.forme[yy][xx] = beatMy.tetris.ModelData.EMPTY;
			}
			xx++;
			if(xx == beatMy.tetris.ModelData.SHAPE_WIDTH) {
				xx = 0;
				yy++;
				this.forme[yy] = new Array();
			}
		}
	}
}
beatMy.tetris.ACTIONKEY = { __ename__ : true, __constructs__ : ["DROP","ROTATE","LEFT","RIGHT"] }
beatMy.tetris.ACTIONKEY.DROP = ["DROP",0];
beatMy.tetris.ACTIONKEY.DROP.toString = $estr;
beatMy.tetris.ACTIONKEY.DROP.__enum__ = beatMy.tetris.ACTIONKEY;
beatMy.tetris.ACTIONKEY.ROTATE = ["ROTATE",1];
beatMy.tetris.ACTIONKEY.ROTATE.toString = $estr;
beatMy.tetris.ACTIONKEY.ROTATE.__enum__ = beatMy.tetris.ACTIONKEY;
beatMy.tetris.ACTIONKEY.LEFT = ["LEFT",2];
beatMy.tetris.ACTIONKEY.LEFT.toString = $estr;
beatMy.tetris.ACTIONKEY.LEFT.__enum__ = beatMy.tetris.ACTIONKEY;
beatMy.tetris.ACTIONKEY.RIGHT = ["RIGHT",3];
beatMy.tetris.ACTIONKEY.RIGHT.toString = $estr;
beatMy.tetris.ACTIONKEY.RIGHT.__enum__ = beatMy.tetris.ACTIONKEY;
beatMy.tetris.UserControler = function(model,focusElement) {
	this.model = model;
	if(focusElement == null) this.focusElement = js.Browser.document; else this.focusElement = focusElement;
	this.initKeyMap();
};
beatMy.tetris.UserControler.__name__ = true;
beatMy.tetris.UserControler.prototype = {
	evt_keyUp: function(e) {
		console.log("evt_keyUp" + Std.string(e.keyCode));
		if(!(function($this) {
			var $r;
			var key = e.keyCode;
			$r = $this.keyMap.exists(key);
			return $r;
		}(this))) return;
		var _g = (function($this) {
			var $r;
			var key = e.keyCode;
			$r = $this.keyMap.get(key);
			return $r;
		}(this));
		switch( (_g)[1] ) {
		case 3:
			this.model.bRIGHT = false;
			break;
		case 2:
			this.model.bLEFT = false;
			break;
		case 0:
			this.model.bDROP = false;
			break;
		case 1:
			this.model.bROTATE = false;
			break;
		}
		if(e.preventDefault) e.preventDefault(); else e.returnValue = false;
	}
	,evt_keyDown: function(e) {
		console.log("evt_keyDown" + Std.string(e.keyCode));
		if(!(function($this) {
			var $r;
			var key = e.keyCode;
			$r = $this.keyMap.exists(key);
			return $r;
		}(this))) return;
		var _g = (function($this) {
			var $r;
			var key = e.keyCode;
			$r = $this.keyMap.get(key);
			return $r;
		}(this));
		switch( (_g)[1] ) {
		case 3:
			this.model.bRIGHT = true;
			break;
		case 2:
			this.model.bLEFT = true;
			break;
		case 0:
			this.model.bDROP = true;
			break;
		case 1:
			this.model.bROTATE = true;
			break;
		}
		if(e.preventDefault) e.preventDefault(); else e.returnValue = false;
	}
	,stop_listenners: function() {
		js.Browser.document.removeEventListener("keydown",$bind(this,this.evt_keyDown));
		js.Browser.document.removeEventListener("keyup",$bind(this,this.evt_keyUp));
	}
	,start_listenners: function() {
		js.Browser.document.addEventListener("keydown",$bind(this,this.evt_keyDown));
		js.Browser.document.addEventListener("keyup",$bind(this,this.evt_keyUp));
	}
	,stop: function() {
		this.stop_listenners();
	}
	,start: function() {
		this.start_listenners();
	}
	,initKeyMap: function() {
		this.keyMap = new haxe.ds.IntMap();
		this.keyMap.set(39,beatMy.tetris.ACTIONKEY.RIGHT);
		this.keyMap.set(37,beatMy.tetris.ACTIONKEY.LEFT);
		this.keyMap.set(40,beatMy.tetris.ACTIONKEY.DROP);
		this.keyMap.set(38,beatMy.tetris.ACTIONKEY.ROTATE);
	}
}
beatMy.tetris.UserStateModel = function() {
	this.bDROP = false;
	this.bRIGHT = false;
	this.bLEFT = false;
	this.bROTATE = false;
};
beatMy.tetris.UserStateModel.__name__ = true;
beatMy.tetris.UserStateModel.prototype = {
	clear: function() {
		this.bROTATE = this.bLEFT = this.bRIGHT = false;
	}
}
beatMy.tetris.UserView = function(mainContent,board) {
	this.H = 600;
	this.W = 300;
	this._stage = new createjs.Stage(mainContent);
	this._board = board;
};
beatMy.tetris.UserView.__name__ = true;
beatMy.tetris.UserView.prototype = {
	render_piece: function(current) {
		var _g1 = 0, _g = current.forme.length;
		while(_g1 < _g) {
			var y = _g1++;
			var _g3 = 0, _g2 = current.forme[y].length;
			while(_g3 < _g2) {
				var x = _g3++;
				var _g4 = current.forme[y][x];
				switch(_g4) {
				case beatMy.tetris.ModelData.FILL:
					var block = this.drawBlock(current.x + x,current.y + y,beatMy.tetris.ModelData.me().colors[current.id]);
					this._stage.addChild(block);
					break;
				default:
				}
			}
		}
	}
	,drawBlock: function(x,y,fill,border) {
		if(border == null) border = "#FFCC00";
		if(fill == null) fill = "#FFCC00";
		if(y == null) y = 0;
		if(x == null) x = 0;
		var b = new createjs.Shape();
		b.graphics.beginFill(fill).beginStroke(border).rect(0,0,this.BLOCK_W - 1,this.BLOCK_H - 1).closePath();
		b.x = x * this.BLOCK_W;
		b.y = y * this.BLOCK_H;
		return b;
	}
	,render_boardBlocks: function() {
		var _g1 = 0, _g = beatMy.tetris.ModelData.ROWS;
		while(_g1 < _g) {
			var y = _g1++;
			var _g3 = 0, _g2 = beatMy.tetris.ModelData.COLS;
			while(_g3 < _g2) {
				var x = _g3++;
				var piece = this._board.get_piece(x,y);
				var _g4 = this._board.get_piece(x,y);
				switch(_g4) {
				case beatMy.tetris.ModelData.EMPTY:
					var block = this.drawBlock(x,y,"black","white");
					this._stage.addChild(block);
					break;
				case beatMy.tetris.ModelData.FILL:
					var block = this.drawBlock(x,y,"green");
					this._stage.addChild(block);
					break;
				default:
				}
			}
		}
	}
	,render_board: function() {
		var b = new createjs.Shape();
		b.graphics.beginStroke("green").rect(0,0,this.W - 1,this.H - 1).closePath();
		this._stage.addChild(b);
	}
	,update: function() {
		this._stage.removeAllChildren();
		this._stage.clear();
		this.render_board();
		this.render_boardBlocks();
		this.render_piece(this._board.get_current());
		this._stage.update();
	}
	,resize: function() {
		this.BLOCK_W = this.W / beatMy.tetris.ModelData.COLS;
		this.BLOCK_H = this.H / beatMy.tetris.ModelData.ROWS;
	}
}
var events = {}
events.Key = function() { }
events.Key.__name__ = true;
events.PreloadJS = function() { }
events.PreloadJS.__name__ = true;
var haxe = {}
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = true;
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
haxe.Timer.prototype = {
	run: function() {
		console.log("run");
	}
	,stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
}
haxe.ds = {}
haxe.ds.IntMap = function() {
	this.h = { };
};
haxe.ds.IntMap.__name__ = true;
haxe.ds.IntMap.prototype = {
	exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
}
var js = {}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Browser = function() { }
js.Browser.__name__ = true;
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.__name__ = true;
Array.__name__ = true;
var q = window.jQuery;
js.JQuery = q;
beatMy.tetris.ModelData.EMPTY = 0;
beatMy.tetris.ModelData.FILL = 1;
beatMy.tetris.ModelData.POWER = 2;
beatMy.tetris.ModelData.COLS = 10;
beatMy.tetris.ModelData.ROWS = 20;
beatMy.tetris.ModelData.SHAPE_WIDTH = 4;
beatMy.tetris.ModelData.SHAPE_HEIGHT = 4;
js.Browser.document = typeof window != "undefined" ? window.document : null;
beatMy.MainTetris.main();
})();

//@ sourceMappingURL=TetrisAdventure.js.map