SELECT
  sum(case when tipo  = 'Apoio' then 1 else 0 end) as Apoio,
  sum(case when tipo  = 'Combate' then 1 else 0 end) as Combate,
  sum(case when tipo  = 'Socorro' then 1 else 0 end) as Socorro
FROM d_meio NATURAL JOIN (
  SELECT idMeio FROM (
    factos NATURAL JOIN d_tempo
    NATURAL JOIN (
      SELECT ano,mes
      FROM d_tempo
      GROUP BY ano,mes

      UNION

      SELECT ano, NULL
      FROM d_tempo
      GROUP BY ano
		
      UNION 
      SELECT NULL,NULL
      FROM d_tempo
      ) tempoRollup
    ) factosTempoRollup
  WHERE idEvento = '15' ) evento15Rollup;


SELECT
  sum(case when tipo  = 'Apoio' then 1 else 0 end) as Apoio,
  sum(case when tipo  = 'Combate' then 1 else 0 end) as Combate,
  sum(case when tipo  = 'Socorro' then 1 else 0 end) as Socorro
FROM d_meio NATURAL JOIN (
  SELECT idMeio FROM (
    factos NATURAL JOIN d_tempo
    NATURAL JOIN (
      SELECT ano,mes
      FROM d_tempo
      GROUP BY ano,mes

      UNION

      SELECT ano, NULL
      FROM d_tempo
      GROUP BY ano
		
      UNION 
      SELECT NULL,NULL
      FROM d_tempo
      ) tempoRollup
    ) factosTempoRollup
  WHERE idEvento = '15' ) evento15Rollup;

(SELECT ano,mes,
 sum(case when tipo  = 'Apoio' then 1 else 0 end) as Apoio,
  sum(case when tipo  = 'Combate' then 1 else 0 end) as Combate,
  sum(case when tipo  = 'Socorro' then 1 else 0 end) as Socorro
FROM d_tempo
NATURAL JOIN d_meio
NATURAL JOIN factos 
--WHERE idEvento = '15'
GROUP BY ano,mes ORDER BY ano, mes)

UNION

(SELECT ano, NULL,
 sum(case when tipo  = 'Apoio' then 1 else 0 end) as Apoio,
  sum(case when tipo  = 'Combate' then 1 else 0 end) as Combate,
  sum(case when tipo  = 'Socorro' then 1 else 0 end) as Socorro
FROM d_tempo
NATURAL JOIN d_meio
NATURAL JOIN factos
WHERE idEvento = '15'
GROUP BY ano ORDER BY ano)

UNION

(SELECT NULL, NULL,
 sum(case when tipo  = 'Apoio' then 1 else 0 end) as Apoio,
  sum(case when tipo  = 'Combate' then 1 else 0 end) as Combate,
  sum(case when tipo  = 'Socorro' then 1 else 0 end) as Socorro
FROM d_tempo
NATURAL JOIN d_meio
NATURAL JOIN factos
WHERE idEvento = '15')
