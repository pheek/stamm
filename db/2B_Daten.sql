-- Stammbaum online
-- 2018-08-17 phi@gress.ly



USE `Stamm`;

SET NAMES         'utf8';
SET CHARACTER SET 'utf8';


INSERT INTO `Person`
(`ID`, `Geschlecht_fk`) VALUES
(   1, 1              ), -- Elisabeth
(   2, 2              ), -- Philipp
(   3, 2              ), -- Charles
(   4, 2              ); -- William


INSERT INTO `Name`
(`ID`, `Name`) VALUES
(   1, "Windsor"            ),
(   2, "Elisabeth"          ),
(   3, "Philipp"            ),
(   4, "Charles"            ),
(   5, "Battenberg"         ),
(   6, "Mountbatten"        ),
(   7, "Mountbatten-Windsor"),
(   8, "William"            );


INSERT INTO `Geburts_Vorname`
(`Person_fk`, `Name_fk`, `Laufnummer`) VALUES
(          1,         2,            1), -- elisabeth
(          2,         3,            1), -- philipp
(          3,         4,            1), -- charles
(          4,         8,            1); -- William

INSERT INTO `Geburts_Familienname`
(`Person_fk`, `Name_fk`, `Laufnummer`) VALUES
(          1,         1,            1), -- elisabeth
(          2,         5,            1), -- philipp
(          3,         7,            1), -- charles
(          4,         7,            1); -- william

INSERT INTO `Mutter`
(`Mutter_fk`, `Kind_fk`) VALUES
(          1, 3        );


INSERT INTO `Vater`
(`Vater_fk`, `Kind_fk`) VALUES
(         2, 3        ),
(         3, 4        );


INSERT INTO `Teildatum`
(`ID`, `Jahr`, `Monat`, `Tag`, `Kalender_fk`) VALUES
(   1,  1948, 11, 14, 1); -- prince charles

