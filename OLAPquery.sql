(SELECT ano,mes,
 sum(case when tipo  = 'Apoio' then 1 else 0 end) as Apoio,
  sum(case when tipo  = 'Combate' then 1 else 0 end) as Combate,
  sum(case when tipo  = 'Socorro' then 1 else 0 end) as Socorro
FROM d_tempo
NATURAL JOIN d_meio
NATURAL JOIN factos
WHERE idEvento = '15'
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
