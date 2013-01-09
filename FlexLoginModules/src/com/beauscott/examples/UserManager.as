package com.beauscott.examples
{
	import com.beauscott.examples.events.UserManagerEvent;
	import com.beauscott.examples.vo.UserVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="login", type="com.beauscott.examples.events.UserManagerEvent")]
	[Event(name="logout", type="com.beauscott.examples.events.UserManagerEvent")]

	public class UserManager extends EventDispatcher
	{
		/**
		 * Storage for the global instance of UserManager
		 */
		private static var _instance:UserManager;
		
		/**
		 * Storage for loggedIn
		 */
		private var _loggedIn:Boolean = false;
		
		[Bindable('loggedInChanged')]
		/**
		 * Flag indicating the current login status of the user
		 * @readonly
		 */
		public function get loggedIn() : Boolean
		{
			return _loggedIn;
		}
		
		/**
		 * Storage for currentUser
		 */
		private var _currentUser:UserVO;
		
		[Bindable('currentUserChanged')]
		/**
		 * The application's current user
		 * @readonly
		 */
		public function get currentUser() : UserVO
		{
			return _currentUser;
		}
		
		public function UserManager()
		{
			if(!_instance)
				super();	
			else
				throw new Error('Only one UserManager can exist! Use UserManager.getInstance()');
		}
		
		/**
		 * Gets the global instance of UserManager
		 */
		public static function getInstance() : UserManager
		{
			if(!_instance)
			{
				_instance = new UserManager();
			}
			return _instance;
		}
		
		/**
		 * Sets the given UserVO as the application's current user, sets the loggedIn status to true,
		 * and dispatches the login event.
		 */
		public function login(userInfo:UserVO) : void
		{
			if(userInfo != null && !loggedIn)
			{
				_currentUser = userInfo;
				_loggedIn = true;
				dispatchEvent(new Event('loggedInChanged'));
				dispatchEvent(new Event('currentUserChanged'));
				dispatchEvent(new UserManagerEvent(UserManagerEvent.LOGIN));
			}
		}
		
		/**
		 * Clears the current user and sets the login status to false, then dispatches the logout event.
		 */
		public function logout() : void
		{
			if(loggedIn)
			{
				_currentUser = null;
				_loggedIn = false;
				dispatchEvent(new Event('loggedInChanged'));
				dispatchEvent(new Event('currentUserChanged'));
				dispatchEvent(new UserManagerEvent(UserManagerEvent.LOGOUT));
			}
		}
	}
}