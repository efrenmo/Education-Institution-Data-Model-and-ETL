-- Run ONCE to set up
USE DATABASE snowflake;
CREATE DATABASE IF NOT EXISTS WCD_EDU;
DROP SCHEMA IF EXISTS PUBLIC; 
USE DATABASE WCD_EDU;
CREATE SCHEMA IF NOT EXISTS schlnd; -- creating schema FOR raw DATA FROM SYSTEM landing;
CREATE SCHEMA IF NOT EXISTS schanl; -- creating SCHEMA FOR DATA model   
