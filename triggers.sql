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
        RAISE EXCEPTION 'restriction a) violated';
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

-- b) Um Meio de Apoio só pode ser alocado a Processos de Socorro para os quais tenha
-- sido accionado.

-- uma maneira alterativa de fazer isto seria adicionar uma foreign key a acciona
-- FOREIGN KEY(numMeio, nomeEntidade,numProcessoSocorro) REFERENCES alocado(numMeio, nomeEntidade,numProcessoSocorro)
-- em vez das outras foreign keys
-- FIXME perguntar aos profes se podemos alterar o modelo relacional para a restricao FIXME

CREATE OR REPLACE FUNCTION accionado_before_alocado() RETURNS TRIGGER AS $body$
    DECLARE success INT;
    DECLARE morada VARCHAR(255);
    BEGIN
    success := (SELECT count(*) FROM acciona
                WHERE new.numMeio = numMeio
                AND new.nomeEntidade = nomeEntidade
                AND new.numProcessoSocorro = numProcessoSocorro
            );
    IF success = 0 THEN
        RAISE EXCEPTION 'restriction b) violated';
    END IF;
    RETURN new;
  END;
$body$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS accionado_before_alocado on alocado;
CREATE TRIGGER accionado_before_alocado BEFORE INSERT ON alocado
  FOR EACH ROW EXECUTE PROCEDURE accionado_before_alocado();
