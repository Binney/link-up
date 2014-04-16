== README

Welcome to the Link Up website, which helps you connect with your local community. This git repo is managed by Binney.

= A quick 101 guide to the backend!

The site is built around a model-view-controller framework (like all Rails sites), so each part of the site is split into these three parts. Model is "what it is". Controller is "what it does". View is "what it looks like". All the info is stored in tables in a SQL database with tables for, in alphabetical order:
- Articles - news items
- Diary entries - if a user clicks "attending" on an event one of these will be created and placed in their calendar for that week
- Events - the core of the info on the site!
- Favourites - if a user "favourites" an event means it will appear in their calendar every week until the end of time
- Logbook entries - to record when the user attends a club or has a mentor meeting
- Mentorships - links between two user accounts, one of which is the "mentor" and the other the "mentee"
- Messages - strings of messages can be sent between users; these messages appear in their inbox
- Password resets - if you forget your password one of these is created and a special token emailed to you; it is then deleted when the user creates a new password or after a certain length of time
- Relationships - between an Event and a Tag - e.g. Football Club is tagged with the Sport Tag <=> there exists a Relationship with Football Club and Sport
- Reviews - users can create reviews of events
- Sessions - login sessions
- Static pages - those not dynamically created depending on the database, such as the Home page or the Help page
- Tags - e.g. "Sport" or "Music" - each event can be tagged with a Relationship
- Timings - some clubs run multiple sessions in one week. So a "timing" is "Friday morning 10-11" or "Saturday afternoons 3-4", and Events have many Timings.
- Users - what it sounds like
- Venues - the venues for each event. Every event *must* have a venue which it occurs at, in order to be put on the map.