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
SELECT e.idEvento,m.idMeio,t.idTempo,f.idFacto
FROM d_evento e
INNER JOIN d_meio m ON e.idEvento=m.idMeio
INNER JOIN d_tempo t ON m.idMeio=t.idTempo
INNER JOIN factos f ON f.idFacto=e.idEvento
