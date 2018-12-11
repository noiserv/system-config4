
--INDICES DESAGRUPADOS SAO DENSOS E INDICES AGRUPADOS SAO ESPARSOS
--HASH AND BTREE INDEXES:

--With BTREE you can select ranges. Use BTREE for WHERE with <=,>=,<,>,= ... ,BETWEEN, LIKE
--To acess an elemnt in a b-tree takes O(log(n))
-- With HASH, only works for = or <=> conditions. Can's use with ORDER BY and
--you cannot select ranges (everything in between x and y).
--You can only access elements by their primary key in a hashtable.
-- This is faster than with a tree algorithm (O(1) instead of log(n)).

--1) FOR THE FIRST ONE:

--EXISTING INDEXES OF TABLES VIGIA AND VIDEO:
-- VIGIA: Has a unique index using btree for colluns (moradaLocal,camNum) corresponding to the primary key
--VIDEO:Has a unique index using btree for colluns (camNum,dataHoraInicio) corresponding to the primary key
--Assuming there is no previous indexes, we need to create the following indexes:
CREATE INDEX video_cam ON video USING HASH(camNum); --INDICE DENSO E DASAGRUPADO
 -- For WHERE conditions using =, it´s easiar to use HASH than BTREE
CREATE INDEX vigia_cm ON vigia USING BTREE(camNum,moradaLocal); --INDICE ESPARSO E AGRUPADO  UMA DAS COLUNAS
-- Create indexes for foreing keys , impossible to use HASH for multiple collums, so we use BTREE
EXPLAIN SELECT dataHoraInicio, dataHoraFim
 FROM video V, vigia I
 WHERE V.camNum = I.camNum
        AND V.camNum = 10
       AND I.moradaLocal = 'Loures';

--Runing the query without the indexes we have 7 rows in total, with a time of execution equal to 53 msec
--Runing the query with the indexes we have 5 rows  in total, with a time of execution equal to 48 msec
--ERASING THE INDEXES:
DROP INDEX video_cam;
DROP INDEX vigia_cm;

--2) Para a segunda interrogcao faz sentido criar os seguintes indices:
CREATE INDEX trans_numP ON transporta USING HASH(numProcessoSocorro); --INDICE DENSO E DASAGRUPADO
CREATE INDEX evento_numTinstC ON eventoEmergencia USING BTREE(numTelefone,instanteChamada,numProcessoSocorro); --INDICE ESPARSO E AGRUPADO UMA DAS COLUNAS



EXPLAIN SELECT​​ ​sum​​(numVitimas)
FROM transporta T, eventoEmergencia E
WHERE T.numProcessoSocorro = E.numProcessoSocorro
GROUP BY ​​numTelefone, instanteChamada
--It was necessary to run "set enable_seqscan=false;" because our populate made the database ignore the indexes
--Runing the query without the indexes we have 7 rows in total, with a time of execution equal to 92 msec
--Runing the query with the indexes we have 6 rows  in total, with a time of execution equal to 48 msec

--ERASING THE INDEXES:
DROP INDEX evento_numP;
DROP INDEX trans_numP;
DROP INDEX evento_numTinstC;

--HOW TO DROP INDEXES
--DROP INDEX index_name
--HOW TO CREATE INDEXES
--CREATE INDEX index_name ON table_name USING WAY(collum_name)
