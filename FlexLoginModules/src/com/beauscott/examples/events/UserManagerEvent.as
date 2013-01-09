package com.beauscott.examples.events
{
	import flash.events.Event;

	public class UserManagerEvent extends Event
	{
		public static const LOGOUT:String = 'logout';
		public static const LOGIN:String = 'login';
		
		public function UserManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}