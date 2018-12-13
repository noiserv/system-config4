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

/* Creation of the Facts Table */

INSERT INTO factos(idEvento,idMeio,tempo_id)
select idEvento,idMeio,getTime_id(timerange)
from generate_series((SELECT min(instanteChamada) -- min
			FROM eventoEmergencia),
		      (SELECT max(instanteChamada)
			FROM eventoEmergencia), '1day') AS timerange
NATURAL JOIN eventoEmergencia NATURAL JOIN d_evento
NATURAL JOIN d_meio NATURAL JOIN acciona;
select * from factos;
select * from d_meio;
select * from d_evento;
