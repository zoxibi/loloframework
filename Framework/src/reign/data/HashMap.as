package reign.data
{
	import flash.utils.Dictionary;
	
	import reign.utils.ObjectUtil;

	/**
	 * 哈希表数据
	 * 可多个键对应一个值
	 * @author LOLO
	 */
	public class HashMap implements IHashMap
	{
		/**值列表*/
		private var _values:Array;
		/**与值列表对应的键列表*/
		private var _keys:Dictionary;
		
		
		
		/**
		 * 构造一个哈希表数据
		 * @param values 初始的值列表
		 * @param keys 与值列表对应的键列表
		 */
		public function HashMap(values:Array=null, keys:Dictionary=null)
		{
			_values = (values == null) ? [] : values;
			_keys = (keys == null) ? new Dictionary() : keys;
		}
		
		
		/**通过键获取值*/
		public function getValueByKey(key:*):*
		{
			return getValueByIndex(_keys[key]);
		}
		
		/**通过索引获取值*/
		public function getValueByIndex(index:uint):*
		{
			return _values[index];
		}
		
		
		/**通过键获取索引。如果没有对应的value，将返回-1*/
		public function getIndexByKey(key:*):int
		{
			return (_keys[key] != undefined) ? _keys[key] : -1;
		}
		
		/**通过值获取索引。如果没有对应的value，将返回-1*/
		public function getIndexByValue(value:*):int
		{
			for(var i:int = 0; i < _values.length; i++) {
				if(_values[i] == value) return i;
			}
			return -1;
		}
		
		/**通过键列表获取索引。如果没有keys对应的index，将返回-1*/
		public function getIndexByKeys(keys:Array):int
		{
			if(keys == null || keys.length == 0) return -1;
			
			var index:int = -1;
			var key:*;
			for(var i:int = 0; i < keys.length; i++) {
				key = keys[i];
				
				if(_keys[key] == undefined) return -1;//没有这个key
				
				if(index != -1) {
					if(_keys[key] != index) return -1;//列表中的key不一致
				}else {
					index = _keys[key];
				}
			}
			return index;
		}
		
		
		/**通过索引获取键列表*/
		public function getKeysByIndex(index:uint):Array
		{
			var keys:Array = [];
			for(var key:* in _keys) {
				if(_keys[key] == index) keys.push(key);
			}
			return keys;
		}
		
		
		/**通过索引设置值*/
		public function setValueByIndex(index:uint, value:*):void
		{
			_values[index] = value;
		}
		
		/**通过键设置值*/
		public function setValueByKey(key:*, value:*):void
		{
			if(_keys[key] != undefined) setValueByIndex(_keys[key], value);
		}
		
		
		/**移除某个键与值的映射关系*/
		public function removeKey(key:*):void
		{
			delete _keys[key];
		}
		
		/**通过键移除对应的键与值*/
		public function removeByKey(key:*):void
		{
			if(_keys[key] != undefined) removeByIndex(_keys[key]);
		}
		
		/**通过索引移除对应的键与值*/
		public function removeByIndex(index:uint):void
		{
			_values.splice(index, 1);
			
			var keys:Dictionary = ObjectUtil.baseClone(_keys);
			for(var key:* in keys)
			{
				//移除相关的key
				if(_keys[key] == index) {
					_keys[key] = undefined;
				}
				//后面的索引递减一次
				else if(_keys[key] > index) {
					_keys[key]--;
				}
			}
		}
		
		
		/**添加一个值，以及对应的键列表。并返回该值的索引*/
		public function add(value:*, ...keys):uint
		{
			var index:int = _values.length;
			_values.push(value);
			for(var i:int = 0; i < keys.length; i++) _keys[keys[i]] = index;
			return index;
		}
		
		
		/**清空*/
		public function clear():void
		{
			_values = [];
			_keys = new Dictionary();
		}
		
		/**克隆*/
		public function clone():IHashMap
		{
			return new HashMap(_values.concat(), ObjectUtil.baseClone(_keys));
		}
		
		/**值的数量*/
		public function get length():uint
		{
			return _values.length;
		}
		//
	}
}