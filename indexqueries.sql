EXPLAIN SELECT​​ dataHoraInício, dataHoraFim
 FROM video V, vigia I
 WHERE V.numCamara = I.numCamara
        AND V.numCamara = 10
       AND I.moradaLocal = “Loures”

EXPLAIN SELECT​​ ​sum​​(numVitimas)
FROM transporta T, EventoEmergencia E
WHERE T.numProcessoSocorro = E.numProcessoSocorro
GROUP BY ​​numTelefone, instanteChamada
