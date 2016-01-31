DROP TABLE users IF EXISTS;
DROP TABLE accounts IF EXISTS;
DROP TABLE account_histories IF EXISTS;
DROP TABLE roles IF EXISTS;

DROP SEQUENCE user_seq IF EXISTS;
DROP SEQUENCE account_seq IF EXISTS;
DROP SEQUENCE account_history_seq IF EXISTS;

CREATE SEQUENCE user_seq AS INTEGER START WITH 1;
CREATE SEQUENCE account_seq AS INTEGER START WITH 1;
CREATE SEQUENCE account_history_seq AS INTEGER START WITH 1;

CREATE TABLE users
(
  user_id INTEGER GENERATED BY DEFAULT AS SEQUENCE user_seq PRIMARY KEY,
  login VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  registered TIMESTAMP DEFAULT now(),
  enabled BOOLEAN DEFAULT TRUE
);
CREATE UNIQUE INDEX users_unique_email_idx ON USERS ( email );

CREATE TABLE account_histories
(
  operation_id INTEGER GENERATED BY DEFAULT AS SEQUENCE account_history_seq PRIMARY KEY,
  from_user_id INTEGER NOT NULL,
  to_user_id INTEGER NOT NULL,
  from_account_id INTEGER NOT NULL,
  to_account_id INTEGER NOT NULL,
  operation_time TIMESTAMP NOT NULL,
  sender_currency VARCHAR(3) NOT NULL,
  recipient_currency VARCHAR(3) NOT NULL,
  credit BOOLEAN DEFAULT TRUE NOT NULL,
  from_account_number VARCHAR(255) NOT NULL,
  to_account_number VARCHAR(255) NOT NULL,
  operation_amount DECIMAL NOT NULL,
  commission DECIMAL NOT NULL,
  amount_before_operation_on_sender DECIMAL NOT NULL,
  amount_after_operation_on_sender DECIMAL NOT NULL,
  amount_before_operation_on_recipient DECIMAL NOT NULL,
  amount_after_operation_in_recipient DECIMAL NOT NULL
);
CREATE UNIQUE INDEX histories_userId_accountId_idx ON account_histories (from_account_id, to_account_id, from_user_id, to_user_id);

CREATE TABLE roles
(
  user_id INTEGER NOT NULL,
  role VARCHAR(255),
  CONSTRAINT user_roles_idx UNIQUE (user_id, role),
  FOREIGN KEY ( user_id ) REFERENCES USERS ( user_id ) ON DELETE CASCADE
);

CREATE TABLE accounts
(
  account_id INTEGER GENERATED BY DEFAULT AS SEQUENCE account_seq PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  account_number VARCHAR(255) NOT NULL,
  currency VARCHAR(3),
  amount DECIMAL(20,2) NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY ( user_id ) REFERENCES USERS ( user_id ) ON DELETE CASCADE
);
CREATE UNIQUE INDEX account_user_numer_idx ON accounts(user_id, account_id);
