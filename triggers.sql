-- a) Um Coordenador só pode solicitar vídeos de câmaras colocadas num local cujo
-- accionamento de meios esteja a ser (ou tenha sido) auditado por ele próprio.

CREATE OR REPLACE FUNCTION solicita_permit() RETURNS TRIGGER AS $body$
    DECLARE success INT;
    BEGIN

    success :=  (SELECT count(*) FROM audita NATURAL JOIN eventoEmergencia
              NATURAL JOIN vigia
              WHERE idCoordenador = new.idcoordenador
             AND camNum = new.camnum);
    IF success = 0 THEN
        RAISE EXCEPTION 'restriction a) violated when inserting %', new ;
    ELSE
      RETURN new;
    END IF;
  END;
$body$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS solicita_permit on solicita;
CREATE TRIGGER solicita_permit BEFORE INSERT ON solicita
  FOR EACH ROW EXECUTE PROCEDURE solicita_permit();


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
	ELSE
		RETURN new;
    END IF;
  END;
$body$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS accionado_before_alocado on alocado;
CREATE TRIGGER accionado_before_alocado BEFORE INSERT ON alocado
  FOR EACH ROW EXECUTE PROCEDURE accionado_before_alocado();
