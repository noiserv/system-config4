SELECT
      sum(case when tipo  = 'Apoio' then 1 end) as Apoio,
      sum(case when  tipo  = 'Combate' then 1 end) as Combate,
      sum(case when  tipo  = 'Socorro' then 1 end) as Socorro
from
 (SELECT idMeio FROM (
   factos
    NATURAL JOIN d_tempo NATURAL JOIN
   (SELECT ano,mes FROM d_tempo GROUP BY ano,mes
     UNION SELECT ano,NULL FROM d_tempo GROUP BY ano
     UNION SELECT NULL,mes FROM d_tempo GROUP BY mes
     UNION SELECT NULL,NULL FROM eventoEmergencia) tempoRollup
   ) factosTempoRollup
  WHERE idEvento = '15' ) evento15Rollup
NATURAL JOIN
 d_meio;
