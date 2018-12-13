DROP TABLE IF EXISTS factos;
DROP TABLE IF EXISTS d_evento;
DROP TABLE IF EXISTS d_meio;
DROP TABLE IF EXISTS d_tempo;


CREATE OR REPLACE FUNCTION getTime_id (tempo timestamp) RETURNS INTEGER AS $body$
  DECLARE dia INTEGER := extract( day FROM timestamp);
  DECLARE mes INTEGER := extract( month FROM timestamp);
  DECLARE ano INTEGER := extract( year FROM timestamp);
  BEGIN
    return dia  + mes*100 + ano * 10000 ;
  END;
$body$ LANGUAGE plpgsql;

/** Function that generates the time intervals from a given minimum to a given maximum from
 *
 **/
CREATE OR REPLACE FUNCTION genTimeIntervals(min timestamp,
                                            max timestamp) RETURNS TABLE (tempo timestamp) AS $body$
  BEGIN
	return QUERY SELECT current_date + i
		FROM generate_series(min - current_date,
			max - current_date ) i;
  END;
$body$ LANGUAGE plpgsql;

CREATE TABLE d_evento(
  idEvento SERIAL UNIQUE,
  numTelefone NUMERIC(255) NOT NULL,
  instanteChamada TIMESTAMP NOT NULL,
  PRIMARY KEY(idEvento)
);

CREATE TABLE d_meio(
  idMeio SERIAL UNIQUE,
  numMeio INTEGER NOT NULL,
  nomeMeio VARCHAR(255),
  nomeEntidade VARCHAR(255) NOT NULL,
  tipo VARCHAR(255) NOT NULL,
  PRIMARY KEY(idMeio)
);

CREATE TABLE d_tempo(
  tempo_id INTEGER NOT NULL, --SERIAL UNIQUE EM CASO DE SER SEQUENCIAL
  dia INTEGER NOT NULL ,
  mes INTEGER NOT NULL,
  ano INTEGER NOT NULL,
  PRIMARY KEY(tempo_id)
);

CREATE TABLE factos(
  idFacto SERIAL UNIQUE,
  idEvento INTEGER,
  idMeio INTEGER,
  tempo_id INTEGER,
  PRIMARY KEY(idFacto),
  FOREIGN KEY(idEvento) REFERENCES d_evento(idEvento),
  FOREIGN KEY(idMeio) REFERENCES d_meio(idMeio),
  FOREIGN KEY(tempo_id) REFERENCES d_tempo(tempo_id)
);
