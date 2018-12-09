--Assumindo que nao existe indices sobre qualquer tabelas

--1) Para a primeira interregocao faria sentido criar os seguintes indices:
DROP INDEX user_idx IF EXISTS
CREATE INDEX user_idx ON video USING HASH(camNum); -- Para igualdades em condicoes WHERE e' util usar o HASH mais do que BTREE
CREATE INDEX user_id ON vigia USING BTREE(camNum,moradaLocal); -- Criar indice para a foreign key do vigia , HASH nao da para multiplas colunas logo usar BTREE
-- BTREE IS A CLUSTERED INDEX

EXPLAIN SELECT dataHoraInicio, dataHoraFim
 FROM video V, vigia I
 WHERE V.camNum = I.camNum
        AND V.camNum = 10
       AND I.moradaLocal = 'Loures';


--2) Para a segunda interrogcao faz sentido criar os seguintes indices:
CREATE INDEX user_idpE ON eventoEmergencia USING HASH(numProcessoSocorro);
CREATE INDEX user_idpT ON transporta USING HASH(numProcessoSocorro);
CREATE INDEX user_idg ON eventoEmergencia USING BTREE(numTelefone,instanteChamada);

EXPLAIN SELECT​​ ​sum​​(numVitimas)
FROM transporta T, eventoEmergencia E
WHERE T.numProcessoSocorro = E.numProcessoSocorro
GROUP BY ​​numTelefone, instanteChamada


--HOW TO DROP INDEXES
--DROP INDEX index_name
--HOW TO CREATE INDEXES
--CREATE INDEX index_name ON table_name USING WAY(collum_name)
