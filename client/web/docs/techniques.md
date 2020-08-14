# Techniques Used

## Database
- Database used in ETS is one custom made from scratch, using a `NoSQL` document-orientated data structure
- Database files are stored as `json` files

## User Authentication
- Users are authenticated using a username or email with a password
- Passwords are not stored directly inside the custom database system, passwords are
  1. first **salted**
  2. and then **hashed**
- Server authenticate users by salting and hashing input password and compared to the original salted password
- This uses various concepts in cryptography

## Custom Stack Tracer
Since Pascal doesn't really support runtime stacktrace, the custom stack tracer allows developers to view where went wrong easily