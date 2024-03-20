# Aadat Overview

## SpeechRecognizer folder (Main milestone feature)
Implements a machine learning model that, with permission, records audio and analyzes. 
Outputs the most likely spoken language. For automatic Task starting, create a 
Task with the name of the language you want to detect (say, English) and the Task 
will automatically start when a couple seconds of English is detected.

WARNING: due to using an external API, there are limits on data usage. This means 
you may see in console a return of NIL when you hit the periodic data limit. It 
takes quite a long time, but is possible if the model is running for a long time. 
Otherwise it will output what language it hears to console for debug.

## Root, Home View
RootView is a View which allows switching between the main 3 Views: 
HomeView, StatsView, and CalendarView.

HomeView uses a PinnedView OR AllTasksView depending on user's current 
view option. It uses SessionsView, AddTaskOrSessionButtonView, and 
TaskOrSessionFormView for interact-able components of the HomeView.

## Models (Task + Session)
In Models folder we have the Class description for Tasks and Sessions, 
our main 2 custom data structures for time tracking

## Objects (TaskView + SessionView, misc. components)
In Objects, we have components that may be used in multiple areas. Namely, a 
TaskView and SessionView, as well as some extraneous display or settings related objects.

## CalendarView and StatsView
CalendarView folder contains all of our work using Dates and displaying 
stored Session information onto a Calendar. 

## CustomModifiers
Contains app-wide common UI functionality to prevent file bloat and to 
allow faster consistency of universal changes like color scheme.

# Build Instructions
Hitting the play button alone should be sufficient for this app
