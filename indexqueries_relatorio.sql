--Índices baseados em funções de dispersão(hash):
--     são os mais eficientes para testes de igualdade
--     Não podem suportar pesquisas por intervalo
--     Tem uma complexidade de O(1)

--Índices BTREE:
--     Adaptam-se a inserções/remoções
--     As entradas de dados no índice estão odernadas pelo valor da chave de pesquisa e é mantida uma estrutura
-- de pesquisa hierárquica que dirige as pesquisas para as páginas de entradas de dados corretas
--     Tem uma complexidade de O(log(n))

-- **BTREE é melhor que hash em casos que requerem vários hash codes.
-- A função de dispersão (hash) recebe como parâmetro o valor da chave de pesquisa e determina o contentor (bucket)
-- em que se situa o registo, se tivermos vários hash codes, temos que escolher um dos códigos para associar a um contentor.
-- Depois, se quisermos pesquisar, usando o hash code, temos que pesquisar todos os buckets, o que demoraria muito mais
-- tempo do que simplesmente usar uma btree.

--###########--------------- 1) ---------------###########
EXPLAIN SELECT dataHoraInicio, dataHoraFim
 FROM video V, vigia I
 WHERE V.camNum = I.camNum
        AND V.camNum = 10
       AND I.moradaLocal = 'Loures';

--Verificação da existençia dos índices e eliminação dos mesmos se existirem
DROP INDEX IF EXISTS video_cam;
DROP INDEX IF EXISTS vigia_cam;
DROP INDEX IF EXISTS vigia_mor;
-- Tendo em conta que existem três igualdades na condição WHERE, e assumindo que
--as tabelas "video" e "vigia" não sofrerão muitas alterações(inserções e remoções)
-- é necessário criar os seguintes indices de dispersão:
CREATE INDEX video_cam ON video USING HASH(camNum);
CREATE INDEX vigia_cam ON vigia USING HASH(camNum);
CREATE INDEX vigia_mor ON vigia USING HASH(moradaLocal);


--###########--------------- 2) ---------------###########
EXPLAIN SELECT​​ ​sum​​(numVitimas)
FROM transporta T, eventoEmergencia E
WHERE T.numProcessoSocorro = E.numProcessoSocorro
GROUP BY ​​numTelefone, instanteChamada

--Verificação da existençia dos índices e eliminação dos mesmos se existirem
DROP INDEX IF EXISTS trans_numP;
DROP INDEX IF EXISTS even_numP;
DROP INDEX IF EXISTS evento_numTinstC;
-- Apesar da existençia da igualdade na condição WHERE,
--como provavelmente as tabelas "transporta" e "eventoEmergencia"
--sofreram muitas alterações é mais eficiente escolher indices árvore B+
--devido a sua boa adptacao com inserções e remoções:
CREATE INDEX trans_numP ON transporta(numProcessoSocorro);
CREATE INDEX even_numP ON eventoEmergencia(numProcessoSocorro);
--Agora observando a condição GROUP BY é necessário criar um indice composto
--árvore B+ :
CREATE INDEX evento_numTinstC ON eventoEmergencia(numTelefone,instanteChamada);
