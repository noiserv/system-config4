﻿
-- a) Um Coordenador só pode solicitar vídeos de câmaras colocadas num local cujo
-- accionamento de meios esteja a ser (ou tenha sido) auditado por ele próprio.

CREATE OR REPLACE FUNCTION solicita_permit() RETURNS TRIGGER AS $body$
    DECLARE success INT;
    DECLARE morada VARCHAR(255);
    BEGIN
    morada  := (SELECT moradaLocal FROM vigia
                  WHERE new.camNum = camNum);
    success := (SELECT count(*) FROM audita NATURAL JOIN eventoEmergencia
              NATURAL JOIN vigia
              WHERE idCoordenador = new.idCoordenador
              AND   moradaLocal   = morada
              AND   dataAuditoria <= NOW()
            );
    IF success = 0 THEN
        RAISE EXCEPTION 'Update of time';
    END IF;
  END;
$body$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS solicita_permit on solicita;
CREATE TRIGGER solicita_permit BEFORE INSERT ON solicita
  FOR EACH ROW EXECUTE PROCEDURE solicita_permit();

INSERT INTO acciona VALUES ('30','EQETDSZEJF','45'); -- meio 30 acionado por processo 45
INSERT INTO solicita VALUES ('30','2018-08-12 10:00:00','45','2018-08-12 10:00:00','2018-08-12 10:59:59');

-- select * from vigia where camNum = 30;
-- SELECT * FROM audita NATURAL JOIN eventoEmergencia WHERE idCoordenador = 30


-- SELECT count(*) FROM audita NATURAL JOIN eventoEmergencia
   --           NATURAL JOIN vigia
     --         WHERE idCoordenador = 30
             -- AND   moradaLocal   = (select moradaLocal from vigia where camNum = 30)
;