# HKDSE SBA Event Ticketing System

- [HKDSE SBA Event Ticketing System](#hkdse-sba-event-ticketing-system)
- [Overview](#overview)
  - [Server](#server)
  - [Client](#client)
    - [Web](#web)
- [Details](#details)
  - [Database](#database)
  - [User Authentication](#user-authentication)
- [Documentation](#documentation)
  - [Server](#server-1)

# Overview
Event Ticketing System is denoted as `ETS`

This project consists of two main parts
- Frontend clients and backend server

## Server
- Backend
- Uses `pascal` for handling http api

## Client
### Web
- Frontend
- Uses flutter `dart` to create a web application
  - Communicates to server api
- Hosted by an express server `node.js`
> Note: for developing purposes, all dummy users has a purposefully set password of '20151529'

# Details
Details and features of ETS

## Database
- Database in ETS is custom made from scratch, using a `NoSQL` document-orientated data structure
- Database files are stored with a `json` file extension

## User Authentication
- Users are authenticated using a username or email with a password
- Passwords are not stored directly inside the custom database system, passwords are
  1. first **salted**
  2. and then **hashed**
- Server authenticate users by salting and hashing input password and compared to the original salted password
- This uses concepts in cryptography

# Documentation
## Server
A full documentation is available [here](server/documentation)
