-- 2018-05-15 philipp.gressly@santis.ch
--
-- Create DB User
--
-- Wieder die selben Credentials, doch hier als
-- mysql-Anweisung.

-- ---------------------------------------


-- 
-- CREATE USER IF NOT EXISTS 'stammPHP'@'localhost' IDENTIFIED BY '123';

        GRANT SELECT, INSERT, DELETE, UPDATE, EXECUTE
           ON `Stamm`.*
           TO 'stammPHP'@'localhost'
IDENTIFIED BY '123';
