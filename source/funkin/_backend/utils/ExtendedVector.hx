package funkin._backend.utils;

import haxe.ds.Vector;

// RapperGF gave me the idea to do this. So props to her.

/**
 * @author BoloVEVO
 * 
 * Extended version of the haxe.ds.Vector
 * Exclusive use for handling notes in PlayState
 */
class ExtendedVector<T>
{
	public var curIndex:Int = 0;

	var vector:Vector<T>;

	var startIndex:Int = 0;

	public var length(get, never):Int;

	public function new(length:Int = 0)
	{
		vector = new Vector(length);

		curIndex = 0;
	}

	inline public function get_length():Int
	{
		return vector.length - startIndex;
	}

	public function set(index:Int, obj:T)
	{
		return vector.set(index, obj);
	}

	public function sort(f:(T, T) -> Int)
	{
		return vector.sort(f);
	}

	public function filter(f:T->Bool):Array<T>
	{
		return [
			for (i in 0...length)
				if (f(vector[i + startIndex])) vector[i + startIndex]

		];
	}

	public function indexOf(element:T):Int
	{
		for (i in 0...length)
		{
			var coolIndex = i + startIndex;
			if (vector[coolIndex] == element)
				return i;
		}
		return -1;
	}

	public function getByIndex(index:Int):T
	{
		var returnEl = vector[index + startIndex];

		return returnEl;
	}

	public function setCurrentIndexOffset(newIndex:Int)
	{
		startIndex = newIndex;
		curIndex = newIndex;
	}

	public function removeFirstMember()
	{
		startIndex++;
	}

	public function getNextMember():T
	{
		var daItem:T = vector[curIndex];

		if (curIndex < vector.length)
			curIndex++;

		return daItem;
	}

	public function setupFromArray(array:Array<T>):ExtendedVector<T>
	{
		vector = Vector.fromArrayCopy(array);
		return this;
	}
}
