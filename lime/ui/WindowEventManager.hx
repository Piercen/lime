package lime.ui;


import lime.app.EventManager;
import lime.system.System;

#if js
import js.Browser;
#end


@:allow(lime.ui.Window)
class WindowEventManager extends EventManager<IWindowEventListener> {
	
	
	private static var instance:WindowEventManager;
	
	private var windowEvent:WindowEvent;
	
	
	public function new () {
		
		super ();
		
		instance = this;
		windowEvent = new WindowEvent ();
		
		#if (cpp || neko)
		
		lime_window_event_manager_register (handleEvent, windowEvent);
		
		#end
		
	}
	
	
	public static function addEventListener (listener:IWindowEventListener, priority:Int = 0):Void {
		
		if (instance != null) {
			
			instance._addEventListener (listener, priority);
			
		}
		
	}
	
	
	#if js
	private function handleDOMEvent (event:js.html.Event):Void {
		
		windowEvent.type = (event.type == "focus" ? WINDOW_ACTIVATE : WINDOW_DEACTIVATE);
		handleEvent (windowEvent);
		
	}
	#end
	
	
	private function handleEvent (event:WindowEvent):Void {
		
		var event = event.clone ();
		
		switch (event.type) {
			
			case WINDOW_ACTIVATE:
				
				for (listener in listeners) {
					
					listener.onWindowActivate (event);
					
				}
			
			case WINDOW_DEACTIVATE:
				
				for (listener in listeners) {
					
					listener.onWindowDeactivate (event);
					
				}
			
		}
		
	}
	
	
	private static function registerWindow (_):Void {
		
		if (instance != null) {
			
			#if js
			Browser.window.addEventListener ("focus", instance.handleDOMEvent, false);
			Browser.window.addEventListener ("blur", instance.handleDOMEvent, false);
			#end
			
		}
		
	}
	
	
	public static function removeEventListener (listener:IWindowEventListener):Void {
		
		if (instance != null) {
			
			instance._removeEventListener (listener);
			
		}
		
	}
	
	
	#if (cpp || neko)
	private static var lime_window_event_manager_register = System.load ("lime", "lime_window_event_manager_register", 2);
	#end
	
	
}