DROP TABLE IF EXISTS factos;
DROP TABLE IF EXISTS d_evento;
DROP TABLE IF EXISTS d_meio;
DROP TABLE IF EXISTS d_tempo;

CREATE OR REPLACE FUNCTION getTime_id (tempo timestamp) RETURNS INTEGER AS $body$
  DECLARE dia INTEGER := extract( day FROM (tempo));
  DECLARE mes INTEGER := extract( month FROM (tempo));
  DECLARE ano INTEGER := extract( year FROM (tempo));
  BEGIN
    return dia  + mes*100 + ano * 10000 ;
  END;
$body$ LANGUAGE plpgsql;

/** Function that generates the time intervals from a given minimum to a given maximum from
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
  tempo_id INTEGER NOT NULL,
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

INSERT INTO d_evento(numTelefone,instanteChamada)
SELECT numTelefone, instanteChamada FROM eventoEmergencia;

INSERT INTO d_meio(numMeio,nomeMeio,nomeEntidade,tipo)
SELECT numMeio,nomeMeio, nomeEntidade,'Apoio' FROM meioApoio NATURAL JOIN meio;

INSERT INTO d_meio(numMeio,nomeMeio,nomeEntidade,tipo)
SELECT numMeio,nomeMeio, nomeEntidade,'Combate' FROM meioCombate  NATURAL JOIN meio;

INSERT INTO d_meio(numMeio,nomeMeio,nomeEntidade,tipo)
SELECT numMeio,nomeMeio, nomeEntidade,'Socorro' FROM meioSocorro  NATURAL JOIN meio;

INSERT INTO d_tempo(tempo_id,dia,mes,ano)
select getTime_id(timerange),
       extract(day FROM timerange),
       extract(month FROM timerange),
       extract(year FROM timerange)
from generate_series((SELECT min(instanteChamada) -- min
			FROM eventoEmergencia),
		      (SELECT max(instanteChamada)
			FROM eventoEmergencia), '1day') AS timerange;

INSERT INTO factos(idEvento,idMeio,tempo_id)
select idEvento,idMeio,getTime_id(instanteChamada) as tempo
FROM eventoEmergencia
NATURAL JOIN d_evento
JOIN d_tempo ON (getTime_id(eventoEmergencia.instanteChamada) = d_tempo.tempo_id)
NATURAL JOIN d_meio NATURAL JOIN acciona;