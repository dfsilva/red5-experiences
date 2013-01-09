package com.beauscott.examples
{
	import com.beauscott.examples.events.UserManagerEvent;
	import com.beauscott.examples.vo.UserVO;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.core.IFlexDisplayObject;
	import mx.events.ListEvent;
	import mx.events.ModuleEvent;
	import mx.managers.PopUpManager;
	import mx.modules.ModuleLoader;

	public class AppEntryPoint extends Container
	{
		public var defaultModule:String = "com.beauscott.examples.modules.LoginForm";
		
		protected var moduleLoader:ModuleLoader;
		
		public function AppEntryPoint()
		{
			super();
			UserManager.getInstance().addEventListener(UserManagerEvent.LOGIN, onUserManagerLogin);
			UserManager.getInstance().addEventListener(UserManagerEvent.LOGOUT, onUserManagerLogout);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			moduleLoader = new ModuleLoader();
			
			// You can do some other fancy event monitoring for progress, etc. See the langref page on ModuleLoader
			moduleLoader.addEventListener(ModuleEvent.ERROR, onModuleLoadFault);
			moduleLoader.addEventListener(ModuleEvent.READY, onModuleLoad);
			
			addChild(moduleLoader);
			// Load the default module (typically the login page)
			loadModule(defaultModule);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			moduleLoader.width = unscaledWidth;
			moduleLoader.height = unscaledHeight;
		}
		
		protected function onUserManagerLogin(event:Event) : void
		{
			var currentUser:UserVO = UserManager.getInstance().currentUser; 
			if(currentUser && currentUser.authorizedModules && currentUser.authorizedModules.length)
			{
				if(currentUser.authorizedModules.length > 1)
				{
					var appChooser:AppChooser = new AppChooser();
					appChooser.dataProvider = currentUser.authorizedModules;
					appChooser.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onAppChooserSelect);
					appChooser.width = 320;
					appChooser.height = 240;
					PopUpManager.addPopUp(appChooser, this, true);
					PopUpManager.centerPopUp(appChooser);
				}
				else
					loadModule(currentUser.authorizedModules[0].classname);
			}
			else
			{
				Alert.show('Bad user credentials', 'Error');
				UserManager.getInstance().logout();
			}
		}
		
		protected function onAppChooserSelect(event:ListEvent) : void
		{
			event.currentTarget.removeEventListener(ListEvent.ITEM_DOUBLE_CLICK, onAppChooserSelect);
			PopUpManager.removePopUp( event.currentTarget as IFlexDisplayObject );
			loadModule(event.itemRenderer.data.classname);
		}
		
		protected function onUserManagerLogout(event:Event) : void
		{
			loadModule(defaultModule);
		}
		
		protected function getModuleURLFromPackage(packageName:String) : String
		{
			return packageName.replace(/\./gi, '/') + '.swf';
		}
		
		public function loadModule(className:String) : void
		{
			moduleLoader.unloadModule();
			moduleLoader.url = getModuleURLFromPackage(className);;
			moduleLoader.loadModule();				
		}
		
		protected function onModuleLoad(event:ModuleEvent) : void
		{
			if(moduleLoader.child)
			{
				moduleLoader.child.width = moduleLoader.width;
				moduleLoader.child.height = moduleLoader.height;
			}
		}
		
		protected function onModuleLoadFault(event:ModuleEvent) : void
		{
			Alert.show(event.errorText, 'Module Load Error');
		}
		
	}
}