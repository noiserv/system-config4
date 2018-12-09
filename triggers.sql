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
              --AND   dataAuditoria <= NOW()
            );
    IF success = 0 THEN
        RAISE EXCEPTION 'Update of time';
    END IF;
    RETURN new;
  END;
$body$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS solicita_permit on solicita;
CREATE TRIGGER solicita_permit BEFORE INSERT ON solicita
  FOR EACH ROW EXECUTE PROCEDURE solicita_permit();

-- code for testing a)
INSERT INTO camara VALUES (140);
INSERT INTO video VALUES ('140','2018-08-12 10:00:00','2018-08-12 10:59:59');
INSERT INTO vigia VALUES ('Praça do Império, Frente Mosteiro dos Jerónimos', '140');
INSERT INTO acciona VALUES ('31','JGIWYABTIA','45'); -- meio 30 acionado por processo 45
INSERT INTO solicita VALUES ('31','2018-08-12 10:00:00','140','2018-08-12 10:00:00','2018-08-12 10:59:59');
