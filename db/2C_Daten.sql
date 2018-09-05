-- Stammbaum online
-- 2018-08-17 phi@gress.ly


USE `Stamm`;

SET NAMES         'utf8';
SET CHARACTER SET 'utf8';


CALL SP_createPerson('Windsor'            , 'Elisabeth', 'w', NULL        , NULL      , @idElisabeth);
CALL SP_createPerson('Battenberg'         , 'Philipp'  , 'm', NULL        , NULL      , @idPhilipp  );

CALL SP_createPerson('Mountbatten-Windsor', 'Charles'  , 'm', @idElisabeth, @idPhilipp, @idCharles  ); 
CALL SP_createPerson('Mountbatten-Windsor', 'William'  , 'm', NULL        , @idCharles, @idWilliam  );


INSERT INTO `Teildatum`
(`ID`, `Jahr`, `Monat`, `Tag`, `Kalender_fk`) VALUES
(   1,  1948, 11, 14, 1); -- prince charles


