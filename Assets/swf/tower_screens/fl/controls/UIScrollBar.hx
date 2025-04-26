package fl.controls;

@:access(swf.exporters.animate)

class UIScrollBar extends fl.controls.ScrollBar
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(350);
		symbol.__init(library);

		super();
	}
}