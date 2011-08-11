[asdoc]: http://rafaelrinaldi.github.com/button/asdoc
[license]: https://github.com/rafaelrinaldi/button/raw/master/license.txt
[examples_folder]: https://github.com/rafaelrinaldi/button/blob/master/examples
[mauro]: https://github.com/maurodetarso

# button
Simple button manager. Easy to handle button interactions separated from the view with just a few lines of code.

Thanks to [Mauro de Tarso][mauro] for helping me with the API.

---
### Features
- Support for multiple callbacks (roll over, roll out, press, click and double click).
- Easy interaction control.
- You can change the view on-the-fly.
- Prevent duplicated callbacks.
- There's a interaction numeric count for each supported interaction.

---
### API
- `enable` - Enable interaction.
- `disable` - Disable interaction.
- `reset` - Reset Button.
- `view` - Button view.
- `hit` - Button hit.
- `hasView` - To know if the button has view or not.
- `onRollOver` - Roll over setter (you can set as much as you want).
- `onRollOut` - Roll out setter (you can set as much as you want).
- `onClick` - Click setter (you can set as much as you want).
- `onDoubleClick` - Double click setter (you can set as much as you want).
- `dispose` - Clear from memory.

---
### Usage

	var rectangle : Sprite = new Sprite;
	rectangle.graphics.beginFill(0xCC0000);
	rectangle.graphics.drawRect(0, 0, 150, 50);
	rectangle.graphics.endFill();
	addChild(rectangle);
	
	var button : Button = new Button(rectangle);
	button.onRollOver =  over;
	button.onRollOut = out;
	button.onPress = press;
	button.onClick = click;
	button.onDoubleClick = double;
	
	function over( p_button : Button ) : void {
			trace("over");
	}
	
	function out( p_button : Button ) : void {
			trace("out");
	}
	
	function press( p_button : Button ) : void {
			trace("press");
	}
	
	function click( p_button : Button ) : void {
			trace("click");
	}
	
	function double( p_button : Button ) : void {
			trace("double");
	}

Check the [examples][examples_folder].

For a complete code reference, check the [documentation][asdoc].

---
### TODO
- Add a hit setter.
- Create ToggleButton class.
- Apply an effect layer?
- Create ButtonEvent?
- Create onReleaseOutside?
- Create a layer just for the interactions?

---
### License
[WTFPL][license]