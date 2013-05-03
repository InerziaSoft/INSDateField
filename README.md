INSDateField
============

A Cocoa date field edited with a calendar on a sheet beneath.

It is a subclass of NSTextField that when clicked will show a sheet with a calendar view, where the user can select
the new date. The sheet has the standard 'OK' & 'Cancel' button, but also a 'No Date' button: in this case the returned
value is nil.
