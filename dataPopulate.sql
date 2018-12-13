INSERT INTO d_evento(numTelefone,instanteChamada)
SELECT numTelefone, instanteChamada FROM eventoEmergencia;

INSERT INTO d_meio(numMeio,nomeEntidade,tipo)
SELECT numMeio, nomeEntidade,'Apoio' FROM meioApoio;

INSERT INTO d_meio(numMeio,nomeEntidade,tipo)
SELECT numMeio, nomeEntidade,'Combate' FROM meioCombate;

INSERT INTO d_meio(numMeio,nomeEntidade,tipo)
SELECT numMeio, nomeEntidade,'Socorro' FROM meioSocorro;


/* insertion of the time range from the oldest instantechamada to the newest */
--SE FOR NUMERO SEQUENCIAL
--INSERT INTO d_tempo(dia,mes,ano)
--SELECT extract(day from instanteChamada) AS dia,
--extract(month from instanteChamada) as mes,
-- extract(year from instanteChamada) as ano FROM eventoEmergencia;

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
SELECT idEvento,idMeio,tempo_id
FROM d_evento
CROSS JOIN d_meio
CROSS JOIN d_tempo;  --colocar data, usar produto das cartesianas?? cross join e' o produto cartesiano
