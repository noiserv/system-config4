DROP TABLE IF EXISTS factos;
DROP TABLE IF EXISTS d_evento;
DROP TABLE IF EXISTS d_meio;
DROP TABLE IF EXISTS d_tempo;

CREATE TABLE d_evento(
  idEvento SERIAL UNIQUE,
  numTelefone VARCHAR(26) NOT NULL,
  instanteChamada TIMESTAMP NOT NULL,
  PRIMARY KEY(idEvento)
);

CREATE TABLE d_meio(
  idMeio SERIAL UNIQUE,
  numMeio INTEGER NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  tipo VARCHAR(255) NOT NULL,
  PRIMARY KEY(idMeio)
);

CREATE TABLE d_tempo(
  dia INTEGER NOT NULL ,
  mes INTEGER NOT NULL,
  ano INTEGER NOT NULL,
  PRIMARY KEY(idTempo)
);

CREATE TABLE factos(
  idFacto SERIAL UNIQUE,
  idEvento SERIAL UNIQUE,
  idMeio SERIAL UNIQUE,
  idTempo SERIAL UNIQUE,
  PRIMARY KEY(idFacto),
  FOREIGN KEY(idEvento) REFERENCES d_evento(idEvento),
  FOREIGN KEY(idMeio) REFERENCES d_meio(idMeio),
);
