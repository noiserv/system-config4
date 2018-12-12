INSERT INTO d_evento(numTelefone,instanteChamada)
SELECT numTelefone, instanteChamada FROM eventoEmergencia;

INSERT INTO d_meio(numMeio,nomeEntidade,tipo)
SELECT numMeio, nomeEntidade,'Apoio' FROM meioApoio;

INSERT INTO d_meio(numMeio,nomeEntidade,tipo)
SELECT numMeio, nomeEntidade,'Combate' FROM meioCombate;

INSERT INTO d_meio(numMeio,nomeEntidade,tipo)
SELECT numMeio, nomeEntidade,'Socorro' FROM meioSocorro;


/* insertion of the time range from the oldest instantechamada to the newest */
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
/*
INSERT INTO factos(idEvento,idMeio,tempo_id)
SELECT e.idEvento,m.idMeio,t.tempo_id
FROM d_evento e
INNER JOIN d_meio m ON e.idEvento=m.idMeio
INNER JOIN d_tempo t ON m.idMeio=t.tempo_id --colocar data, usar produto das cartesianas??
*/