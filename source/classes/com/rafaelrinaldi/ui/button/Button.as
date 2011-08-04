package com.rafaelrinaldi.ui.button
{
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * Simple button manager.
	 * 
	 * @author Rafael Rinaldi (rafaelrinaldi.com)
	 * @since Jun 1, 2010 
	 * 
	 */

	// TODO: Add a hit setter.
	// TODO: Create ToggleButton class.
	// TODO: Apply an effect layer?
	// TODO: Create ButtonEvent?
	// TODO: Create onReleaseOutside?
	// TODO: Create a layer just for the interactions?
	public class Button
	{
		/** Roll over listeners. **/
		protected var rollOverListeners : Vector.<Function>;
		
		/** Roll out listeners. **/
		protected var rollOutListeners : Vector.<Function>;
		
		/** Press handlers. **/
		protected var pressHandlers : Vector.<Function>;
		
		/** Click listeners. **/
		protected var clickListeners : Vector.<Function>;
		
		/** Double click listeners. **/
		protected var doubleClickListeners : Vector.<Function>;
		
		/** Roll over interaction count. **/
		public var rollOverCount : int;
		
		/** Roll out interaction count. **/
		public var rollOutCount : int;
		
		/** Press interaction count. **/
		public var pressCount : int;
		
		/** Click interaction count. **/
		public var clickCount : int;
		
		/** Double click interaction count. **/
		public var doubleClickCount : int;
		
		/** Is button enabled? **/
		public var enabled : Boolean;
		
		/** @private **/
		protected var _view : *;
		
		/** @private **/
		protected var _hit : *;
		
		/** @param p_view The button view. **/
		public function Button( p_view : * = null )
		{
			rollOverListeners = new Vector.<Function>();
			rollOutListeners = new Vector.<Function>();
			pressHandlers = new Vector.<Function>();
			clickListeners = new Vector.<Function>();
			doubleClickListeners = new Vector.<Function>();
			
			rollOverCount = 0;
			rollOutCount = 0;
			pressCount = 0;
			clickCount = 0;
			doubleClickCount = 0;
			
			view = p_view;
		}
		
		/** Enable interaction. **/
		public function enable() : void
		{
			if(!hasView || enabled) return;

			enabled = true;
				
			if(doubleClickListeners.length > 0) hit.doubleClickEnabled = true;
			
			if(hit.hasOwnProperty("mouseChildren")) hit.mouseChildren = false;
			if(hit.hasOwnProperty("buttonMode")) hit.buttonMode = true;
		}
		
		/** Disable interaction. **/
		public function disable() : void
		{
			if(!hasView || !enabled) return;
			
			enabled = false;
			
			if(doubleClickListeners.length > 0) hit.doubleClickEnabled = false;
			
			if(hit.hasOwnProperty("mouseChildren")) hit.mouseChildren = true;
			if(hit.hasOwnProperty("buttonMode")) hit.buttonMode = false;
		}
		
		/** Reset listeners, counts and everything else. **/
		public function reset() : void
		{
			if(!hasView) return;
			
			disable();
			
			// Reseting interaction count.
			rollOverCount = 0;
			rollOutCount = 0;
			pressCount = 0;
			clickCount = 0;
			doubleClickCount = 0;
			
			// Removing existing listeners.
			hit.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			hit.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			hit.removeEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			hit.removeEventListener(MouseEvent.CLICK, clickHandler);
			hit.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			
			// Reseting all the listeners.
			resetListeners(rollOverListeners, MouseEvent.ROLL_OVER, rollOverHandler);
			resetListeners(rollOutListeners, MouseEvent.ROLL_OUT, rollOutHandler);
			resetListeners(pressHandlers, MouseEvent.MOUSE_DOWN, pressHandler);
			resetListeners(clickListeners, MouseEvent.CLICK, clickHandler);
			resetListeners(doubleClickListeners, MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			
			enable();
		}
		
		/**
		 * 
		 * Add a new listener.
		 * 
		 * @param p_listeners Listeners list.
		 * @param p_listener Listener callback.
		 * @param p_type Event type.
		 * @param p_handler Event handler.
		 * 
		 */
		protected function addListener( p_listeners : Vector.<Function>, p_listener : Function, p_type : String, p_handler : Function ) : void
		{
			// Preventing duplicated callbacks.
			const isDuplicated : Boolean = p_listeners.some(function( p_item : Function, ...rest ) : Boolean {
				return p_item === p_listener;
			});
			
			if(isDuplicated) return;
			
			p_listeners.push(p_listener);
			
			// Just enable double click if onDoubleClick was called at least once.
			if(p_type == MouseEvent.DOUBLE_CLICK) view.doubleClickEnabled = true;
			
			hit.addEventListener(p_type, p_handler);
		}
		
		/**
		 * 
		 * Reset all the listeners.
		 * 
		 * @param p_listeners Listeners list.
		 * @param p_type Event type.
		 * @param p_handler Event handler.
		 * 
		 */
		protected function resetListeners( p_listeners : Vector.<Function>, p_type : String, p_handler : Function ) : void
		{
			if(p_listeners.length == 0) return;
			
			hit.addEventListener(p_type, p_handler); 
		}
		
		/**
		 * 
		 * Dispatch events from a listeners list.
		 * 
		 * @param p_listeners Listeners list.
		 * 
		 */
		protected function dispatchListeners( p_listeners : Vector.<Function> ) : void
		{
			const button : Button = this;
			
			if(!enabled) return;
			
			p_listeners.forEach(function( p_listener : Function, ...rest ) : void {
				// Passing current Button instance as a listener argument.
				if(p_listener != null) p_listener.apply(view, [].concat(button));
			});
		}
		
		/**
		 * 
		 * Remove all listeners from a listeners list.
		 * 
		 * @param p_listeners Listeners list.
		 * @param p_type Event type.
		 * @param p_handler Event handler.
		 * 
		 */
		protected function removeListeners( p_listeners : Vector.<Function>, p_type : String, p_handler : Function ) : void
		{
			p_listeners.length = 0;
			p_listeners = null;
			
			hit.removeEventListener(p_type, p_handler);
		}
		
		public function get view() : *
		{
			return _view;
		}
		
		/** View setter. **/
		public function set view( value : * ) : void
		{
			if(value == null) return;
			
			_view = value;
			
			reset();
		}
		
		/** Hit getter. If there's no object named as "hit", the hit will be the view. **/
		public function get hit() : *
		{
			return view.hasOwnProperty("hit") ? view["hit"] : view;
		}
		
		/** @return True if view value is different to null, false otherwise. **/
		public function get hasView() : Boolean
		{
			return Boolean(view != null);
		}
		
		/**
		 * Listener setters.
		 */
		
		/** Roll over setter. **/
		public function set onRollOver( value : Function ) : void
		{
			addListener(rollOverListeners, value, MouseEvent.ROLL_OVER, rollOverHandler);
		}
		
		/** Roll out setter. **/
		public function set onRollOut( value : Function ) : void
		{
			addListener(rollOutListeners, value, MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		/** Press setter. **/
		public function set onPress( value : Function ) : void
		{
			addListener(pressHandlers, value, MouseEvent.MOUSE_DOWN, pressHandler);
		}
		
		/** Click setter. **/
		public function set onClick( value : Function ) : void
		{
			addListener(clickListeners, value, MouseEvent.CLICK, clickHandler);
		}
		
		/** Double click setter. **/
		public function set onDoubleClick( value : Function ) : void
		{
			addListener(doubleClickListeners, value, MouseEvent.DOUBLE_CLICK, doubleClickHandler);
		}
		
		/**
		 * Event handlers.
		 */

		/** @private **/
		protected function rollOverHandler( event : MouseEvent ) : void
		{
			dispatchListeners(rollOverListeners);
			++rollOverCount;
		}
		
		/** @private **/
		protected function rollOutHandler( event : MouseEvent ) : void
		{
			dispatchListeners(rollOutListeners);
			++rollOutCount;
		}
		
		/** @private **/
		protected function pressHandler( event : MouseEvent ) : void
		{
			dispatchListeners(pressHandlers);
			++pressCount;
		}

		/** @private **/
		protected function clickHandler( event : MouseEvent ) : void
		{
			dispatchListeners(clickListeners);
			++clickCount;
		}
		
		/** @private **/
		protected function doubleClickHandler( event : MouseEvent ) : void
		{
			dispatchListeners(doubleClickListeners);
			++doubleClickCount;
		}
		
		/** Clear from memory. **/
		public function dispose() : void
		{
			disable();
			
			removeListeners(rollOverListeners, MouseEvent.ROLL_OVER, rollOverHandler);
			removeListeners(rollOutListeners, MouseEvent.ROLL_OUT, rollOutHandler);
			removeListeners(clickListeners, MouseEvent.CLICK, clickHandler);
			removeListeners(doubleClickListeners, MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			
			_view = null;
		}
	
	}

}