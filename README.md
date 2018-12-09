# Bases de Dados - Entrega 5

Nesta entrega é-nos pedido que optimizemos uma base de dados e criemos uma "data warehouse" para a o SGBD POSTGRES.



## Coisas  a fazer

A base de dados é igual à da entrega anterior.

### Restrições de Integridade

* **a)** e **b)**, possívelmente como triggers

### Índices

Os índices aumentam a velocidade de acesso aos dados. Podem ser simples ou compostos (mais que um dado) e têm que ser pensados com base nas frequências dos pedidos.

### Modelo Multidimensional

O modelo multidimensional utiliza a informação na parte relacional da base de dados e fatoriza-a em segmentos redundantes, mas que permitem a rápida análise de dados. Isto surge porque uma típica filtragem de dados para análise corresponde a um join de quase todas as tabelas. Para evitar esse processamento cria-se este modelo.

o modelo é composto pelos factos:

* **d_evento**(idEvento, numTelefone, instanteChamada)
* **d_meio**(idMeio, numMeio, nomeMeio, nomeEntidade, tipo)
* **d_tempo**(dia, mes, ano)

que estão na forma normal 1 (podem ser redundantes) e uma parte que corresponde a todas as entradas com esses factos. Ver esquema em estrela dos slides.


### Data Analytics

* obter o número de meios de cada tipo utilizados no evento número 15, com
  rollup por ano e mês.


### Testing
WARNING: in order to test the database, a certain order needs to be respected
1. Load `schema.sql`   -- to remove old tables and setup the new schema as well as triggers
3. Load `populate.sql` -- to populate the database
4. Load `dataWarehouse.sql` -- to setup the fact analysis database
5. Load `dataPopulate.sql`  -- to populate the facts

### Questions & Doubts
* time has no id. Is that supposed to happen?
* the new restrictions imply changing the populate. Is that required?
* in the data warehouse some structures are clearly redundant. One example is the
type of "meio" which could be just a number but instread is VARCHAR(255), which must
us up a lot of unecessary space. Is this true or does the DB compensate for that?
