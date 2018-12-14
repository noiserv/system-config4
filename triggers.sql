--###########--------------- a) ---------------###########
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
CREATE TRIGGER solicita_permit BEFORE INSERT OR UPDATE ON solicita
  FOR EACH ROW EXECUTE PROCEDURE solicita_permit();

--###########--------------- b) ---------------###########
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
CREATE TRIGGER accionado_before_alocado BEFORE INSERT OR UPDATE ON alocado
  FOR EACH ROW EXECUTE PROCEDURE accionado_before_alocado();