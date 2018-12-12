INSERT INTO d_evento(numTelefone,instanteChamada)
SELECT numTelefone, instanteChamada FROM eventoEmergencia;

INSERT INTO d_meio(numMeio,nomeEntidade,tipo)
SELECT numMeio, nomeEntidade,'Apoio' FROM meioApoio;
INSERT INTO d_meio(numMeio,nomeEntidade,tipo)
SELECT numMeio, nomeEntidade,'Combate' FROM meioCombate;
INSERT INTO d_meio(numMeio,nomeEntidade,tipo)
SELECT numMeio, nomeEntidade,'Socorro' FROM meioSocorro;

INSERT INTO d_tempo(dia,mes,ano)
SELECT extract(day from instanteChamada) AS dia,extract(month from instanteChamada) as mes, extract(year from instanteChamada) as ano FROM eventoEmergencia;

INSERT INTO factos(idEvento,idMeio,idTempo)
SELECT idEvento,idMeio,idTempo
FROM d_evento
CROSS JOIN d_meio
CROSS JOIN d_tempo;  --colocar data, usar produto das cartesianas?? cross join e' o produto cartesiano
