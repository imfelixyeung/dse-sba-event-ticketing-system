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
#### Home Page

<!-- ![alt text][ets-pages-home-mobile-dark] -->
![alt text][ets-pages-home-desktop-dark]

#### Navigation System (App Drawer)
- App drawer 
  - is present on the left side of the screen for non-mobile users
  - is accessible via the menu icon on the top left of the screen for mobile users

![alt text][ets-app_drawer-mobile-dark]
![alt text][ets-app_drawer-desktop-dark]

#### Event Details Page
This page shows event details and allow participants to select tickets and join

![alt text][ets-pages-event_details-desktop-1-dark]
![alt text][ets-pages-event_details-desktop-2-dark]

#### Accounts Page, Login Page and Registration Page
Accounts page lets users view their account details if logged in, else, login and register button is shown
##### Accounts Page (Not Logged In)

![alt text][ets-pages-account-desktop-dark]

##### Login Page

![alt text][ets-pages-login-desktop-dark]

##### Register Page

![alt text][ets-pages-register-desktop-dark]

##### Accounts Page (Logged In)

![alt text][ets-pages-account_logged_in-desktop-dark]

#### AI ChatBot Help Desk
This chat screen allows users to ask help from an AI ChatBot, This ChatBot uses machine learning to map user's dynamic questions to fixed answers
![alt text][ets-chatbot-mobile-dark]

## Implementation
### Overview
Event Ticketing System consist of two parts
1. Server (Backend)
   - ETS Rest API (Written in `objectpascal`)
   - ChatBot Rest API (Written in `javascript`)
   - HTTP & HTTPS Web/Proxy Server (Written in `javascript`)
2. Client (Frontend)
   - Web (Written in `dart`, `html`, `scss`, `javascript`)
   - Android (Written in `dart`)
   - Windows (Written in `javascript`)
   - MacOS (Written in `javascript`)

### Dataflow
1. User request responses from HTTP & HTTPS Web/Proxy Server
2. Server responses with resources

### Advantages
- Most ICT SBA Projects doesn't support multi-user since the program is only available to one user, if copied to another machine, they won't share the same resources
- Our Event Ticketing System uses client and server concepts so multiple clients can connect to the same server, allowing multi-user support
- Since our server is based on Rest APIs with `cross origin` enabled, any other developers can use the API to create their own frontend with our backend server

### Pascal HTTP Server
#### Intentional Disabled Features
To prevent double booking, the ETS Rest API HTTP Server has multi-thread disabled, i.e. one request at a time.

#### Use of classes
On the server, all everything queried from the custom database are collections of documents or just documents.
Users, Events, Tickets, etc are classes extending from collections, while
User, Event, Ticket, etc are classes extending from documents.

This prevents double written codes, all Users, Events, Tickets, etc inherits functions from the collection bases class,
same applies for User, Event, Ticket, etc

#### Use of Custom APIs
1. FeliStorageAPI
   - All queries from database, the code looks nicer and easier to maintain

2. FeliFileAPI
   - All reading and writing of files is simplified to just using this API

# Testing and Evaluation
## Data Validation
### Server
All new users and events are validated before inserting into database to prevent invalid requests
### Client
TextFields will automatically validate when submit buttons are pressed. Respective errors are displayed directly below the TextField for easy reading

## Custom Pascal Stack Tracer
This custom build stack tracer allows developers to trace procedures and functions easily during development

### On
![alt text][stack_tracer-on]
### Off
![alt text][stack_tracer-off]


# Learning Process Reflection

<!-- TODO: Complete Learning Process Reflection -->

------
> Notes to self: 
> Screenshots are captured at 800x800/400x800 pixels with device pixel ratio of 1.0




[ets-app_drawer-mobile-dark]: images/ets-app_drawer-mobile-dark.png "ETS App Drawer Mobile"
[ets-app_drawer-desktop-dark]: images/ets-app_drawer-desktop-dark.png "ETS App Drawer Desktop"
[ets-pages-home-mobile-dark]: images/ets-pages-home-mobile-dark.png "ETS Home Mobile"
[ets-pages-home-desktop-dark]: images/ets-pages-home-desktop-dark.png "ETS Home Desktop"
[ets-pages-event_details-desktop-1-dark]: images/ets-pages-event_details-desktop-1-dark.png "ETS Event Details"
[ets-pages-event_details-desktop-2-dark]: images/ets-pages-event_details-desktop-2-dark.png "ETS Event Details"
[ets-pages-account-desktop-dark]: images/ets-pages-account-desktop-dark.png "ETS Account"
[ets-pages-login-desktop-dark]: images/ets-pages-login-desktop-dark.png "ETS Login"
[ets-pages-register-desktop-dark]: images/ets-pages-register-desktop-dark.png "ETS Register"
[ets-pages-account_logged_in-desktop-dark]: images/ets-pages-account_logged_in-desktop-dark.png "ETS Accounts Logged in"
[ets-chatbot-mobile-dark]: images/ets-chatbot-mobile-dark.png "ETS AI ChatBot"

[stack_tracer-on]: images/stack_tracer-on.png "Stack Tracer turned on"
[stack_tracer-off]: images/stack_tracer-off.png "Stack Tracer turned off"
