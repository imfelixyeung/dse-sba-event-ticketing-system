# HKDSE ICT SBA Report

# Objective
**Event Ticketing System** (ETS) aims to
- provide users with ease when booking and reserving tickets for their favourite events
- provide users with a great **user experience** (UX) with the help of a **graphical user interface** (GUI)
- allow **multi-user support** for booking tickets

The Purpose of ETS is to 
- allow users to search and discover for events easily
- allow easy ticketing booking and reservation
- allow event organisers to generate analysis report based on their events

# Design and Implementation
## Program Functions Overview
- Show all events
  - events are listed out on the home page of the program
- Registration and Login
  - New users can register
  - Old users can login
- Joining events
  - Participators are able to join events
  - If the event is full, they will automatically be queued on the waiting list, and will automatically be moved to joined when space is available
- Creating Events
  - Organisers can create events by the help of a form
- Amendments of events
  - Organisers can edit event details later via the Created Events Page

## Crucial Features
- Database
  - Database used in ETS is one custom made from scratch, using a `NoSQL` document-orientated data structure
  - Database files are stored as `json` files

- User Authentication
  - Users are authenticated using a username or email with a password
  - Passwords are not stored directly inside the custom database system, passwords are
    1. first **salted**
    2. and then **hashed**
  - Server authenticate users by salting and hashing input password and compared to the original salted password
  - This uses various concepts in cryptography

- Custom Stack Tracer
  - Since Pascal doesn't really support runtime stacktrace, the custom stack tracer allows developers to view where went wrong easily

## Program Functions Detailed
### Graphical User Interface (GUI)
- Home Page

![alt text][ets-app_drawer-mobile-dark]
![alt text][ets-app_drawer-desktop-dark]

- Navigation System (App Drawer)
  - App drawer 
    - is present on the left side of the screen for non-mobile users
    - is accessible via the menu icon on the top left of the screen for mobile users

![alt text][ets-pages-home-mobile-dark]
![alt text][ets-pages-home-desktop-dark]

- Event Details Page

![alt text][ets-pages-event_details-desktop-dark]

- Accounts Page, Login Page and Registration Page
  - Accounts Page (Not Logged In)

  ![alt text][ets-pages-account-desktop-dark]

  - Login Page

  ![alt text][ets-pages-login-desktop-dark]

  - Register Page

  ![alt text][ets-pages-register-desktop-dark]

  - Accounts Page (Logged In)

  ![alt text][ets-pages-account_logged_in-desktop-dark]

# Testing and Evaluation

# Learning Process Reflection

------
> Notes to self: 
> Screenshots are captured at 800x800 pixels with device pixel ratio of 1.0




[ets-app_drawer-mobile-dark]: images/ets-app_drawer-mobile-dark.png "ETS App Drawer Mobile"
[ets-app_drawer-desktop-dark]: images/ets-app_drawer-desktop-dark.png "ETS App Drawer Desktop"
[ets-pages-home-mobile-dark]: images/ets-pages-home-mobile-dark.png "ETS App Drawer Mobile"
[ets-pages-home-desktop-dark]: images/ets-pages-home-desktop-dark.png "ETS App Drawer Mobile"
[ets-pages-event_details-desktop-dark]: images/ets-pages-event_details-desktop-dark.png "ETS App Drawer Mobile"
[ets-pages-account-desktop-dark]: images/ets-pages-account-desktop-dark.png "ETS App Drawer Mobile"
[ets-pages-login-desktop-dark]: images/ets-pages-login-desktop-dark.png "ETS App Drawer Mobile"
[ets-pages-register-desktop-dark]: images/ets-pages-register-desktop-dark.png "ETS App Drawer Mobile"
[ets-pages-account_logged_in-desktop-dark]: images/ets-pages-account_logged_in-desktop-dark.png "ETS App Drawer Mobile"
