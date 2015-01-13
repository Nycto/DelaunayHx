(function () { "use strict";
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var List = function() {
	this.length = 0;
};
List.__name__ = true;
List.prototype = {
	add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,__class__: List
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var _g = 0;
	var _g1 = window.document.querySelectorAll("canvas.delaunay");
	while(_g < _g1.length) {
		var canvasNode = _g1[_g];
		++_g;
		var canvas = [js.Boot.__cast(canvasNode , HTMLCanvasElement)];
		var nodes = new delaunay.Triangulate([]);
		var _g2 = 0;
		while(_g2 < 100) {
			var i = _g2++;
			nodes.add(new delaunay.RealPoint(Std.random(canvas[0].clientWidth),Std.random(canvas[0].clientHeight)));
		}
		var edges = [""];
		var context = [canvas[0].getContext("2d")];
		context[0].beginPath();
		nodes.eachEdge((function(context,edges,canvas) {
			return function(a,b) {
				edges[0] += Std.string(a) + " -> " + Std.string(b) + "\n";
				context[0].moveTo(a.x,canvas[0].clientHeight - a.y);
				context[0].lineTo(b.x,canvas[0].clientHeight - b.y);
			};
		})(context,edges,canvas));
		context[0].stroke();
		console.log(edges[0]);
	}
};
var IMap = function() { };
IMap.__name__ = true;
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std["int"] = function(x) {
	return x | 0;
};
Std.random = function(x) {
	if(x <= 0) return 0; else return Math.floor(Math.random() * x);
};
var delaunay = {};
delaunay._AngleSort = {};
delaunay._AngleSort.AngleSort_Impl_ = function() { };
delaunay._AngleSort.AngleSort_Impl_.__name__ = true;
delaunay._AngleSort.AngleSort_Impl_.angle = function(base,a,b) {
	var v1X = a.getX() - base.getX();
	var v1Y = a.getY() - base.getY();
	var v2X = b.getX() - base.getX();
	var v2Y = b.getY() - base.getY();
	var radians = Math.atan2(v2Y,v2X) - Math.atan2(v1Y,v1X);
	if(radians >= 0) return radians; else return 2 * Math.PI + radians;
};
delaunay._AngleSort.AngleSort_Impl_._new = function(base,reference,direction,points) {
	var this1;
	if(direction == delaunay.Direction.Clockwise) points = points.filter(function(point) {
		var angle;
		var v1X = reference.getX() - base.getX();
		var v1Y = reference.getY() - base.getY();
		var v2X = point.getX() - base.getX();
		var v2Y = point.getY() - base.getY();
		var radians = Math.atan2(v2Y,v2X) - Math.atan2(v1Y,v1X);
		if(radians >= 0) angle = radians; else angle = 2 * Math.PI + radians;
		return angle == 0 || angle > Math.PI;
	}); else points = points.filter(function(point1) {
		var angle1;
		var v1X1 = reference.getX() - base.getX();
		var v1Y1 = reference.getY() - base.getY();
		var v2X1 = point1.getX() - base.getX();
		var v2Y1 = point1.getY() - base.getY();
		var radians1 = Math.atan2(v2Y1,v2X1) - Math.atan2(v1Y1,v1X1);
		if(radians1 >= 0) angle1 = radians1; else angle1 = 2 * Math.PI + radians1;
		return angle1 == 0 || angle1 < Math.PI;
	});
	points.sort(function(a,b) {
		var angleToA;
		var v1X2 = reference.getX() - base.getX();
		var v1Y2 = reference.getY() - base.getY();
		var v2X2 = a.getX() - base.getX();
		var v2Y2 = a.getY() - base.getY();
		var radians2 = Math.atan2(v2Y2,v2X2) - Math.atan2(v1Y2,v1X2);
		if(radians2 >= 0) angleToA = radians2; else angleToA = 2 * Math.PI + radians2;
		var angleToB;
		var v1X3 = reference.getX() - base.getX();
		var v1Y3 = reference.getY() - base.getY();
		var v2X3 = b.getX() - base.getX();
		var v2Y3 = b.getY() - base.getY();
		var radians3 = Math.atan2(v2Y3,v2X3) - Math.atan2(v1Y3,v1X3);
		if(radians3 >= 0) angleToB = radians3; else angleToB = 2 * Math.PI + radians3;
		if(angleToA == angleToB) return 0; else if(angleToA == 0) return -1; else if(angleToB == 0) return 1; else if(direction == delaunay.Direction.Clockwise) if(angleToA < angleToB) return 1; else return -1; else if(angleToA < angleToB) return -1; else return 1;
	});
	this1 = points;
	return this1;
};
delaunay._AngleSort.AngleSort_Impl_.first = function(this1) {
	if(this1.length == 0) return null; else return this1[0];
};
delaunay.BuildingHashMap = function(hash,equal,build) {
	this.inner = new delaunay.HashMap(hash,equal);
	this.build = build;
};
delaunay.BuildingHashMap.__name__ = true;
delaunay.BuildingHashMap.prototype = {
	set: function(key,value) {
		this.inner.set(key,value);
	}
	,get: function(key) {
		var value = this.inner.get(key);
		if(value == null) {
			var built = this.build();
			this.inner.set(key,built);
			return built;
		} else return value;
	}
	,maybeGet: function(key) {
		return this.inner.get(key);
	}
	,keys: function() {
		return this.inner.keys();
	}
	,toString: function() {
		return this.inner.toString();
	}
	,__class__: delaunay.BuildingHashMap
};
delaunay.DhxPoint = function() { };
delaunay.DhxPoint.__name__ = true;
delaunay.DhxPoint.prototype = {
	__class__: delaunay.DhxPoint
};
delaunay.Direction = { __ename__ : true, __constructs__ : ["Clockwise","CounterClockwise"] };
delaunay.Direction.Clockwise = ["Clockwise",0];
delaunay.Direction.Clockwise.__enum__ = delaunay.Direction;
delaunay.Direction.CounterClockwise = ["CounterClockwise",1];
delaunay.Direction.CounterClockwise.__enum__ = delaunay.Direction;
delaunay.DivideAndConquer = function() { };
delaunay.DivideAndConquer.__name__ = true;
delaunay.DivideAndConquer.findCandidate = function(group,anchor,reference,points) {
	var iter = HxOverrides.iter(points);
	if(!iter.hasNext()) return null;
	var point = iter.next();
	while( iter.hasNext() ) {
		var next = iter.next();
		var isInCircle = delaunay.Triangle.isPointInCircumCircle(anchor,reference,point,next);
		if(isInCircle) {
			group.remove(anchor,point);
			point = next;
		} else break;
	}
	return point;
};
delaunay.DivideAndConquer.mergeWithBase = function(left,right,baseLeft,baseRight) {
	var leftCandidate = delaunay.DivideAndConquer.findCandidate(left,baseLeft,baseRight,left.connected(baseLeft,baseRight,delaunay.Direction.CounterClockwise));
	var rightCandidate = delaunay.DivideAndConquer.findCandidate(right,baseRight,baseLeft,right.connected(baseRight,baseLeft,delaunay.Direction.Clockwise));
	left.potentialBottom(baseLeft);
	left.potentialBottom(baseRight);
	left.connections.get(baseLeft).add(baseRight);
	left.connections.get(baseRight).add(baseLeft);
	left;
	if(rightCandidate == null && leftCandidate == null) return; else if(rightCandidate == null) delaunay.DivideAndConquer.mergeWithBase(left,right,leftCandidate,baseRight); else if(leftCandidate == null) delaunay.DivideAndConquer.mergeWithBase(left,right,baseLeft,rightCandidate); else if(delaunay.Triangle.isPointInCircumCircle(baseLeft,baseRight,leftCandidate,rightCandidate)) delaunay.DivideAndConquer.mergeWithBase(left,right,baseLeft,rightCandidate); else delaunay.DivideAndConquer.mergeWithBase(left,right,leftCandidate,baseRight);
};
delaunay.DivideAndConquer.chooseBase = function(group,direction,examine,reference) {
	if(reference.getY() == examine.getY()) return examine;
	var option;
	var this1 = group.connected(examine,reference,direction);
	if(this1.length == 0) option = null; else option = this1[0];
	if(option == null) return examine; else return delaunay.DivideAndConquer.chooseBase(group,direction,option,reference);
};
delaunay.DivideAndConquer.chooseBases = function(left,right,callback) {
	var leftBottomRight;
	if(left.bottom.length == 0) throw "EdgeGroup does not have any points in it";
	leftBottomRight = delaunay._Points.Points_Impl_.last(left.bottom);
	var baseRight = delaunay.DivideAndConquer.chooseBase(right,delaunay.Direction.CounterClockwise,(function($this) {
		var $r;
		if(right.bottom.length == 0) throw "EdgeGroup does not have any points in it";
		$r = right.bottom[0];
		return $r;
	}(this)),leftBottomRight);
	var baseLeft = delaunay.DivideAndConquer.chooseBase(left,delaunay.Direction.Clockwise,leftBottomRight,baseRight);
	var verifiedRight = delaunay.DivideAndConquer.chooseBase(right,delaunay.Direction.CounterClockwise,baseRight,baseLeft);
	callback(baseLeft,verifiedRight);
};
delaunay.DivideAndConquer.merge = function(left,right) {
	delaunay.DivideAndConquer.chooseBases(left,right,function(baseLeft,baseRight) {
		delaunay.DivideAndConquer.mergeWithBase(left,right,baseLeft,baseRight);
		left.addAll(right);
	});
	return left;
};
delaunay.Edge = function(one,two) {
	if(delaunay._Points.Points_Impl_.compare(one,two) <= 0) {
		this.one = one;
		this.two = two;
	} else {
		this.one = two;
		this.two = one;
	}
};
delaunay.Edge.__name__ = true;
delaunay.Edge.compare = function(a,b) {
	if(delaunay._Points.Points_Impl_.compare(a.one,b.one) != 0) return delaunay._Points.Points_Impl_.compare(a.one,b.one); else return delaunay._Points.Points_Impl_.compare(a.two,b.two);
};
delaunay.Edge.equal = function(a,b) {
	return delaunay.RealPoint.equal(a.one,b.one) && delaunay.RealPoint.equal(a.two,b.two);
};
delaunay.Edge.hash = function(edge) {
	return 41 * (41 + delaunay.RealPoint.hash(edge.one)) + delaunay.RealPoint.hash(edge.two);
};
delaunay.Edge.prototype = {
	toString: function() {
		return "(" + this.one.getX() + ", " + this.one.getY() + " -> " + this.two.getX() + ", " + this.two.getY() + ")";
	}
	,equals: function(other) {
		return delaunay.RealPoint.equal(this.one,other.one) && delaunay.RealPoint.equal(this.two,other.two);
	}
	,hashCode: function() {
		return 41 * (41 + delaunay.RealPoint.hash(this.one)) + delaunay.RealPoint.hash(this.two);
	}
	,__class__: delaunay.Edge
};
delaunay.EdgeGroup = function() {
	this.bottom = (function($this) {
		var $r;
		var this1;
		this1 = delaunay._Points.Points_Impl_.dedupe([]);
		this1.sort(delaunay._Points.Points_Impl_.compare);
		$r = this1;
		return $r;
	}(this));
	this.connections = new delaunay.BuildingHashMap(delaunay.RealPoint.hash,delaunay.RealPoint.equal,function() {
		return new delaunay.Set(delaunay.RealPoint.hash,delaunay.RealPoint.equal);
	});
};
delaunay.EdgeGroup.__name__ = true;
delaunay.EdgeGroup.prototype = {
	potentialBottom: function(point) {
		if(this.bottom.length == 0 || point.getY() == this.bottom[0].getY()) delaunay._Points.Points_Impl_.push(this.bottom,point); else if(point.getY() < this.bottom[0].getY()) {
			delaunay._Points.Points_Impl_.clear(this.bottom);
			delaunay._Points.Points_Impl_.push(this.bottom,point);
		}
	}
	,add: function(one,two) {
		this.potentialBottom(one);
		this.potentialBottom(two);
		this.connections.get(one).add(two);
		this.connections.get(two).add(one);
		return this;
	}
	,bottomRight: function() {
		if(this.bottom.length == 0) throw "EdgeGroup does not have any points in it";
		return delaunay._Points.Points_Impl_.last(this.bottom);
	}
	,bottomLeft: function() {
		if(this.bottom.length == 0) throw "EdgeGroup does not have any points in it";
		return this.bottom[0];
	}
	,connected: function(point,sortVersus,direction) {
		var points = this.connections.get(point).toArray();
		if(points.length == 0) throw "Point does not exist in EdgeGroup";
		var base = point;
		var reference = sortVersus;
		var direction1 = direction;
		var points1 = points;
		var this1;
		if(direction1 == delaunay.Direction.Clockwise) points1 = points1.filter(function(point1) {
			var angle;
			var v1X = reference.getX() - base.getX();
			var v1Y = reference.getY() - base.getY();
			var v2X = point1.getX() - base.getX();
			var v2Y = point1.getY() - base.getY();
			var radians = Math.atan2(v2Y,v2X) - Math.atan2(v1Y,v1X);
			if(radians >= 0) angle = radians; else angle = 2 * Math.PI + radians;
			return angle == 0 || angle > Math.PI;
		}); else points1 = points1.filter(function(point2) {
			var angle1;
			var v1X1 = reference.getX() - base.getX();
			var v1Y1 = reference.getY() - base.getY();
			var v2X1 = point2.getX() - base.getX();
			var v2Y1 = point2.getY() - base.getY();
			var radians1 = Math.atan2(v2Y1,v2X1) - Math.atan2(v1Y1,v1X1);
			if(radians1 >= 0) angle1 = radians1; else angle1 = 2 * Math.PI + radians1;
			return angle1 == 0 || angle1 < Math.PI;
		});
		points1.sort(function(a,b) {
			var angleToA;
			var v1X2 = reference.getX() - base.getX();
			var v1Y2 = reference.getY() - base.getY();
			var v2X2 = a.getX() - base.getX();
			var v2Y2 = a.getY() - base.getY();
			var radians2 = Math.atan2(v2Y2,v2X2) - Math.atan2(v1Y2,v1X2);
			if(radians2 >= 0) angleToA = radians2; else angleToA = 2 * Math.PI + radians2;
			var angleToB;
			var v1X3 = reference.getX() - base.getX();
			var v1Y3 = reference.getY() - base.getY();
			var v2X3 = b.getX() - base.getX();
			var v2Y3 = b.getY() - base.getY();
			var radians3 = Math.atan2(v2Y3,v2X3) - Math.atan2(v1Y3,v1X3);
			if(radians3 >= 0) angleToB = radians3; else angleToB = 2 * Math.PI + radians3;
			if(angleToA == angleToB) return 0; else if(angleToA == 0) return -1; else if(angleToB == 0) return 1; else if(direction1 == delaunay.Direction.Clockwise) if(angleToA < angleToB) return 1; else return -1; else if(angleToA < angleToB) return -1; else return 1;
		});
		this1 = points1;
		return this1;
	}
	,remove: function(one,two) {
		this.connections.get(one).remove(two);
		this.connections.get(two).remove(one);
	}
	,eachEdge: function(callback) {
		var seen = new delaunay.Set(delaunay.RealPoint.hash,delaunay.RealPoint.equal);
		var $it0 = this.connections.inner.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			seen.add(key);
			var $it1 = this.connections.get(key).iterator();
			while( $it1.hasNext() ) {
				var point = $it1.next();
				if(!seen.contains(point)) callback(key,point);
			}
		}
	}
	,toArray: function() {
		var result = [];
		this.eachEdge(function(a,b) {
			result.push(new delaunay.Edge(a,b));
		});
		return result;
	}
	,addAll: function(other) {
		var $it0 = other.connections.inner.keys();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			var thisSet = this.connections.inner.get(key);
			var otherSet = other.connections.get(key);
			if(thisSet == null) this.connections.inner.set(key,otherSet); else {
				var $it1 = otherSet.iterator();
				while( $it1.hasNext() ) {
					var point = $it1.next();
					thisSet.add(point);
				}
			}
		}
		if(this.bottom.length == 0 || this.bottom[0].getY() > other.bottom[0].getY()) this.bottom = other.bottom; else if(this.bottom[0].getY() == other.bottom[0].getY()) delaunay._Points.Points_Impl_.addAll(this.bottom,other.bottom);
	}
	,toString: function() {
		var points = [];
		this.eachEdge(function(a,b) {
			points.push(Std.string(a) + " -> " + Std.string(b));
		});
		return "EdgeGroup(" + points.join(", ") + ")";
	}
	,__class__: delaunay.EdgeGroup
};
delaunay.FlatIterator = function(outer) {
	this.innerIter = null;
	this.outerIter = outer;
};
delaunay.FlatIterator.__name__ = true;
delaunay.FlatIterator.prototype = {
	hasNext: function() {
		while(this.innerIter == null || !this.innerIter.hasNext()) if(!this.outerIter.hasNext()) return false; else this.innerIter = $iterator(this.outerIter.next())();
		return this.innerIter.hasNext();
	}
	,next: function() {
		if(this.innerIter == null || !this.innerIter.hasNext()) throw "Iterator has already been exhausted";
		return this.innerIter.next();
	}
	,__class__: delaunay.FlatIterator
};
delaunay._HashMap = {};
delaunay._HashMap.KeyValue = function(key,value) {
	this.key = key;
	this.value = value;
};
delaunay._HashMap.KeyValue.__name__ = true;
delaunay._HashMap.KeyValue.prototype = {
	__class__: delaunay._HashMap.KeyValue
};
delaunay.HashMap = function(hash,equal) {
	this.objs = new haxe.ds.IntMap();
	this.hash = hash;
	this.equal = equal;
};
delaunay.HashMap.__name__ = true;
delaunay.HashMap.prototype = {
	indexOf: function(list,key) {
		var result = null;
		var _g1 = 0;
		var _g = list.length;
		while(_g1 < _g) {
			var index = _g1++;
			if(this.equal(list[index].key,key)) {
				result = index;
				break;
			}
		}
		return result;
	}
	,set: function(key,value) {
		var hashCode = this.hash(key);
		var existing = this.objs.get(hashCode);
		var representation = new delaunay._HashMap.KeyValue(key,value);
		if(existing == null) this.objs.set(hashCode,[representation]); else {
			var index = this.indexOf(existing,key);
			if(index == null) existing.push(representation); else existing[index] = representation;
		}
	}
	,get: function(key) {
		var hashCode = this.hash(key);
		var existing = this.objs.get(hashCode);
		if(existing == null) return null; else {
			var index = this.indexOf(existing,key);
			if(index == null) return null; else return existing[index].value;
		}
	}
	,unset: function(key) {
		var hashCode = this.hash(key);
		var existing = this.objs.get(hashCode);
		if(existing != null) {
			var index = this.indexOf(existing,key);
			if(index != null) existing.splice(index,1);
		}
	}
	,keys: function() {
		var iterator = new delaunay.FlatIterator(this.objs.iterator());
		return { hasNext : function() {
			return iterator.hasNext();
		}, next : function() {
			return iterator.next().key;
		}};
	}
	,toString: function() {
		var result = new Array();
		var $it0 = new delaunay.FlatIterator(this.objs.iterator());
		while( $it0.hasNext() ) {
			var pair = $it0.next();
			result.push(Std.string(pair.key) + " -> " + Std.string(pair.value));
		}
		return "Map(" + result.join(", ") + ")";
	}
	,__class__: delaunay.HashMap
};
delaunay._Points = {};
delaunay._Points.Points_Impl_ = function() { };
delaunay._Points.Points_Impl_.__name__ = true;
delaunay._Points.Points_Impl_.dedupe = function(points) {
	var output = new Array();
	var seen = new delaunay.Set(delaunay.RealPoint.hash,delaunay.RealPoint.equal);
	var _g = 0;
	while(_g < points.length) {
		var point = points[_g];
		++_g;
		if(!seen.contains(point)) {
			output.push(point);
			seen.add(point);
		}
	}
	return output;
};
delaunay._Points.Points_Impl_.compare = function(a,b) {
	var aX = a.getX();
	var bX = b.getX();
	if(aX < bX) return -1; else if(aX > bX) return 1; else {
		var aY = a.getY();
		var bY = b.getY();
		if(aY < bY) return -1; else if(aY > bY) return 1; else return 0;
	}
};
delaunay._Points.Points_Impl_._new = function(points) {
	var this1;
	this1 = delaunay._Points.Points_Impl_.dedupe(points);
	this1.sort(delaunay._Points.Points_Impl_.compare);
	return this1;
};
delaunay._Points.Points_Impl_.fromArray = function(points) {
	var this1;
	this1 = delaunay._Points.Points_Impl_.dedupe(points);
	this1.sort(delaunay._Points.Points_Impl_.compare);
	return this1;
};
delaunay._Points.Points_Impl_.get = function(this1,index) {
	return this1[index];
};
delaunay._Points.Points_Impl_.slice = function(this1) {
	return new delaunay.SliceData(this1,0,this1.length);
};
delaunay._Points.Points_Impl_.push = function(this1,newPoint) {
	var _g = 0;
	while(_g < this1.length) {
		var point = this1[_g];
		++_g;
		if(point.getX() == newPoint.getX() && point.getY() == newPoint.getY()) return;
	}
	this1.push(newPoint);
	this1.sort(delaunay._Points.Points_Impl_.compare);
};
delaunay._Points.Points_Impl_.addAll = function(this1,other) {
	var existing = new delaunay.Set(delaunay.RealPoint.hash,delaunay.RealPoint.equal);
	var _g = 0;
	while(_g < this1.length) {
		var point = this1[_g];
		++_g;
		existing.add(point);
	}
	var $it0 = HxOverrides.iter(other);
	while( $it0.hasNext() ) {
		var newPoint = $it0.next();
		if(!existing.contains(newPoint)) this1.push(newPoint);
	}
	this1.sort(delaunay._Points.Points_Impl_.compare);
};
delaunay._Points.Points_Impl_.clear = function(this1) {
	this1.splice(0,this1.length);
};
delaunay._Points.Points_Impl_.last = function(this1) {
	if(this1.length == 0) throw "Point list is empty";
	return this1[this1.length - 1];
};
delaunay.RealPoint = function(x,y) {
	this.x = x;
	this.y = y;
};
delaunay.RealPoint.__name__ = true;
delaunay.RealPoint.__interfaces__ = [delaunay.DhxPoint];
delaunay.RealPoint.hash = function(pnt) {
	return 41 * (41 + Std["int"](pnt.getX())) + Std["int"](pnt.getY());
};
delaunay.RealPoint.equal = function(a,b) {
	return a.getX() == b.getX() && a.getY() == b.getY();
};
delaunay.RealPoint.prototype = {
	getX: function() {
		return this.x;
	}
	,getY: function() {
		return this.y;
	}
	,equals: function(other) {
		return this.getX() == other.getX() && this.getY() == other.getY();
	}
	,hashCode: function() {
		return 41 * (41 + Std["int"](this.getX())) + Std["int"](this.getY());
	}
	,toString: function() {
		return "Point(" + this.x + ", " + this.y + ")";
	}
	,__class__: delaunay.RealPoint
};
delaunay.Set = function(hash,equal) {
	this.objs = new haxe.ds.IntMap();
	this.hash = hash;
	this.equal = equal;
};
delaunay.Set.__name__ = true;
delaunay.Set.prototype = {
	listContains: function(list,item) {
		var result = false;
		var $it0 = list.iterator();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			if(this.equal(element,item)) {
				result = true;
				break;
			}
		}
		return result;
	}
	,add: function(value) {
		var hashCode = this.hash(value);
		var existing = this.objs.get(hashCode);
		if(existing == null) {
			var newList = new List();
			newList.add(value);
			this.objs.set(hashCode,newList);
		} else if(!this.listContains(existing,value)) existing.add(value);
		return this;
	}
	,contains: function(value) {
		var existing = this.objs.get(this.hash(value));
		if(existing == null) return false; else return this.listContains(existing,value);
	}
	,remove: function(value) {
		var existing = this.objs.get(this.hash(value));
		if(existing != null) {
			var $it0 = existing.iterator();
			while( $it0.hasNext() ) {
				var element = $it0.next();
				if(this.equal(value,element)) {
					existing.remove(element);
					break;
				}
			}
		}
	}
	,iterator: function() {
		return new delaunay.FlatIterator(this.objs.iterator());
	}
	,toArray: function() {
		var result = [];
		var $it0 = this.objs.iterator();
		while( $it0.hasNext() ) {
			var list = $it0.next();
			var $it1 = list.iterator();
			while( $it1.hasNext() ) {
				var value = $it1.next();
				result.push(value);
			}
		}
		return result;
	}
	,toString: function() {
		return "Set(" + this.toArray().join(", ") + ")";
	}
	,addAll: function(other) {
		var $it0 = other.objs.iterator();
		while( $it0.hasNext() ) {
			var list = $it0.next();
			var $it1 = list.iterator();
			while( $it1.hasNext() ) {
				var value = $it1.next();
				this.add(value);
			}
		}
	}
	,__class__: delaunay.Set
};
delaunay.SliceData = function(data,start,length) {
	this.data = data;
	this.start = start;
	this.end = start + length;
};
delaunay.SliceData.__name__ = true;
delaunay.SliceData.prototype = {
	__class__: delaunay.SliceData
};
delaunay._Slice = {};
delaunay._Slice.Slice_Impl_ = function() { };
delaunay._Slice.Slice_Impl_.__name__ = true;
delaunay._Slice.Slice_Impl_.fromArray = function(points) {
	var this1;
	var this2;
	this2 = delaunay._Points.Points_Impl_.dedupe(points);
	this2.sort(delaunay._Points.Points_Impl_.compare);
	this1 = this2;
	return new delaunay.SliceData(this1,0,this1.length);
};
delaunay._Slice.Slice_Impl_.$length = function(this1) {
	return this1.end - this1.start;
};
delaunay._Slice.Slice_Impl_.get = function(this1,index) {
	var actual = this1.start + index;
	if(index < 0 || actual >= this1.end) throw "Index out of bounds: " + index;
	return this1.data[actual];
};
delaunay._Slice.Slice_Impl_.iterator = function(this1) {
	var offset = this1.start;
	return { hasNext : function() {
		return offset < this1.end;
	}, next : function() {
		return this1.data[offset++];
	}};
};
delaunay._Slice.Slice_Impl_.slice = function(this1,start,len) {
	if(start < 0 || start >= this1.end - this1.start) throw "Slice starting index out of bounds: " + start; else if(start + len > this1.end - this1.start) throw "Slice length out of bounds: " + len;
	return new delaunay.SliceData(this1.data,this1.start + start,len);
};
delaunay._Slice.Slice_Impl_.toArray = function(this1) {
	var output = new Array();
	var $it0 = $iterator(delaunay._Slice.Slice_Impl_)(this1);
	while( $it0.hasNext() ) {
		var point = $it0.next();
		output.push(point);
	}
	return output;
};
delaunay._Slice.Slice_Impl_.canSplit = function(this1) {
	return this1.end - this1.start >= 4;
};
delaunay._Slice.Slice_Impl_.splitLeft = function(this1) {
	if(!(this1.end - this1.start >= 4)) throw "Slice is too small to split";
	var len = Math.ceil((this1.end - this1.start) / 2);
	if(0 >= this1.end - this1.start) throw "Slice starting index out of bounds: " + 0; else if(len > this1.end - this1.start) throw "Slice length out of bounds: " + len;
	return new delaunay.SliceData(this1.data,this1.start,len);
};
delaunay._Slice.Slice_Impl_.splitRight = function(this1) {
	if(!(this1.end - this1.start >= 4)) throw "Slice is too small to split";
	var halfway = (this1.end - this1.start) / 2;
	var start = Math.ceil(halfway);
	var len = Math.floor(halfway);
	if(start < 0 || start >= this1.end - this1.start) throw "Slice starting index out of bounds: " + start; else if(start + len > this1.end - this1.start) throw "Slice length out of bounds: " + len;
	return new delaunay.SliceData(this1.data,this1.start + start,len);
};
delaunay.Triangle = function() {
};
delaunay.Triangle.__name__ = true;
delaunay.Triangle.isTriangle = function(a,b,c) {
	var x1 = a.getX();
	var y1 = a.getY();
	var x2 = b.getX();
	var y2 = b.getY();
	var x3 = c.getX();
	var y3 = c.getY();
	return (y2 - y1) * (x3 - x2) != (y3 - y2) * (x2 - x1);
};
delaunay.Triangle.isPointInCircumCircle = function(a,b,c,d) {
	var x1 = a.getX();
	var y1 = a.getY();
	var x2 = b.getX();
	var y2 = b.getY();
	var x3 = c.getX();
	var y3 = c.getY();
	if(x1 == x2 && y1 == y2 || x2 == x3 && y2 == y3) throw "Trying to find circumcircle with two duplicate points";
	var x4 = d.getX();
	var y4 = d.getY();
	var slope1 = -1 * ((x2 - x1) / (y2 - y1));
	var slope2 = -1 * ((x3 - x2) / (y3 - y2));
	if(slope1 == slope2) throw "Given points don't form a triangle: " + Std.string(a) + ", " + Std.string(b) + ", " + Std.string(c);
	if(y1 == y2 || y2 == y3) return delaunay.Triangle.isPointInCircumCircle(c,a,b,d);
	var yintercept1 = (-1 * slope1 * (x1 + x2) + y1 + y2) / 2;
	var yintercept2 = (-1 * slope2 * (x2 + x3) + y2 + y3) / 2;
	var centerx = (yintercept2 - yintercept1) / (slope1 - slope2);
	var centery = slope1 * centerx + yintercept1;
	var radius = (centerx - x1) * (centerx - x1) + (centery - y1) * (centery - y1);
	var distance = (centerx - x4) * (centerx - x4) + (centery - y4) * (centery - y4);
	return distance < radius;
};
delaunay.Triangle.prototype = {
	__class__: delaunay.Triangle
};
delaunay.Triangulate = function(points) {
	this.points = points;
};
delaunay.Triangulate.__name__ = true;
delaunay.Triangulate.getTrinary = function(points) {
	var a;
	var actual = points.start;
	if(actual >= points.end) throw "Index out of bounds: " + 0;
	a = points.data[actual];
	var b;
	var actual1 = points.start + 1;
	if(actual1 >= points.end) throw "Index out of bounds: " + 1;
	b = points.data[actual1];
	var c;
	var actual2 = points.start + 2;
	if(actual2 >= points.end) throw "Index out of bounds: " + 2;
	c = points.data[actual2];
	if(delaunay.Triangle.isTriangle(a,b,c)) return new delaunay.EdgeGroup().add(a,b).add(b,c).add(a,c); else return new delaunay.EdgeGroup().add(a,b).add(b,c);
};
delaunay.Triangulate.calculate = function(points) {
	var _g = points.end - points.start;
	switch(_g) {
	case 0:
		throw "Can not triangulate without any points";
		break;
	case 1:
		throw "Can not triangulate with only one point";
		break;
	case 2:
		return new delaunay.EdgeGroup().add((function($this) {
			var $r;
			var actual = points.start;
			if(actual >= points.end) throw "Index out of bounds: " + 0;
			$r = points.data[actual];
			return $r;
		}(this)),(function($this) {
			var $r;
			var actual1 = points.start + 1;
			if(actual1 >= points.end) throw "Index out of bounds: " + 1;
			$r = points.data[actual1];
			return $r;
		}(this)));
	case 3:
		return delaunay.Triangulate.getTrinary(points);
	default:
		return delaunay.DivideAndConquer.merge(delaunay.Triangulate.calculate((function($this) {
			var $r;
			if(!(points.end - points.start >= 4)) throw "Slice is too small to split";
			$r = (function($this) {
				var $r;
				var len = Math.ceil((points.end - points.start) / 2);
				if(0 >= points.end - points.start) throw "Slice starting index out of bounds: " + 0; else if(len > points.end - points.start) throw "Slice length out of bounds: " + len;
				$r = new delaunay.SliceData(points.data,points.start,len);
				return $r;
			}($this));
			return $r;
		}(this))),delaunay.Triangulate.calculate((function($this) {
			var $r;
			if(!(points.end - points.start >= 4)) throw "Slice is too small to split";
			var halfway = (points.end - points.start) / 2;
			$r = (function($this) {
				var $r;
				var start = Math.ceil(halfway);
				var len1 = Math.floor(halfway);
				if(start < 0 || start >= points.end - points.start) throw "Slice starting index out of bounds: " + start; else if(start + len1 > points.end - points.start) throw "Slice length out of bounds: " + len1;
				$r = new delaunay.SliceData(points.data,points.start + start,len1);
				return $r;
			}($this));
			return $r;
		}(this))));
	}
};
delaunay.Triangulate.prototype = {
	add: function(point) {
		this.points.push(point);
	}
	,eachEdge: function(callback) {
		if(this.points.length > 1) delaunay.Triangulate.calculate((function($this) {
			var $r;
			var this1;
			{
				var this2;
				this2 = delaunay._Points.Points_Impl_.dedupe($this.points);
				this2.sort(delaunay._Points.Points_Impl_.compare);
				this1 = this2;
			}
			$r = new delaunay.SliceData(this1,0,this1.length);
			return $r;
		}(this))).eachEdge(callback);
	}
	,getEdges: function() {
		if(this.points.length <= 1) return []; else return delaunay.Triangulate.calculate((function($this) {
			var $r;
			var this1;
			{
				var this2;
				this2 = delaunay._Points.Points_Impl_.dedupe($this.points);
				this2.sort(delaunay._Points.Points_Impl_.compare);
				this1 = this2;
			}
			$r = new delaunay.SliceData(this1,0,this1.length);
			return $r;
		}(this))).toArray();
	}
	,__class__: delaunay.Triangulate
};
var haxe = {};
haxe.ds = {};
haxe.ds.IntMap = function() {
	this.h = { };
};
haxe.ds.IntMap.__name__ = true;
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,__class__: haxe.ds.IntMap
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = true;
js.Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
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
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js.Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
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
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) str2 += ", \n";
		str2 += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js.Boot.__interfLoop(js.Boot.getClass(o),cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
if(Array.prototype.filter == null) Array.prototype.filter = function(f1) {
	var a1 = [];
	var _g11 = 0;
	var _g2 = this.length;
	while(_g11 < _g2) {
		var i1 = _g11++;
		var e = this[i1];
		if(f1(e)) a1.push(e);
	}
	return a1;
};
Main.main();
})();
