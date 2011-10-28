package reign.data
{
	/**
	 * 哈希表数据接口
	 * 可多个键对应一个值
	 * @author LOLO
	 */
	public interface IHashMap
	{
		/**通过键获取值*/
		function getValueByKey(key:*):*;
		/**通过索引获取值*/
		function getValueByIndex(index:uint):*;
		
		/**通过键获取索引*/
		function getIndexByKey(key:*):int;
		/**通过值获取索引*/
		function getIndexByValue(value:*):int;
		/**通过键列表获取索引*/
		function getIndexByKeys(keys:Array):int;
		
		/**通过索引获取键列表*/
		function getKeysByIndex(index:uint):Array;
		
		
		/**通过索引设置值*/
		function setValueByIndex(index:uint, value:*):void;
		/**通过键设置值*/
		function setValueByKey(key:*, value:*):void;
		
		
		/**移除某个键与值的映射关系*/
		function removeKey(key:*):void;
		/**通过键移除对应的键与值*/
		function removeByKey(key:*):void;
		/**通过索引移除对应的键与值*/
		function removeByIndex(index:uint):void;
		
		
		/**添加一个值，以及对应的键列表。并返回该值的索引*/
		function add(value:*, ...keys):uint;
		
		/**清空*/
		function clear():void;
		
		/**克隆*/
		function clone():IHashMap;
		
		
		/**值的数量*/
		function get length():uint;
		//
	}
}