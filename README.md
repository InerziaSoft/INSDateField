INSDateField
============

A Cocoa date field edited with a calendar on a sheet beneath.

It is a subclass of NSTextField that when clicked will show a sheet with a calendar view, where the user can select
the new date. The sheet has the standard 'OK' & 'Cancel' button, but also a 'No Date' button: in this case the returned
value is nil (it is possible to enable/disable this button).

INSDateField
------------
The true text field with added properties to handle the new features.

	mainWindow: IBOutlet to the window that will receive the sheet
				if not connected, the window of the dateField will be used
	
	minimumDate: the same meaning of the NSDatePicker property
	
	maximumDate: the same meaning of the NSDatePicker property
	
	noDateEnabled: a BOOL that control the availability of the 'No Date' button

The three properties are available for binding (as used by the enclosed appDelegate).

The sheet will be presented right beneath the dateField, as if it comes out of it. When the sheet closes on user event, the new date will used to update the model (that is, going up through the binding linked to the field).
