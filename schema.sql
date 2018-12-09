DROP TABLE IF EXISTS camara cascade;
DROP TABLE IF EXISTS video cascade;
DROP TABLE IF EXISTS segmentoVideo cascade;
DROP TABLE IF EXISTS zona cascade;
DROP TABLE IF EXISTS vigia cascade;
DROP TABLE IF EXISTS processoSocorro cascade;
DROP TABLE IF EXISTS eventoEmergencia cascade;
DROP TABLE IF EXISTS entidadeMeio cascade;
DROP TABLE IF EXISTS meio cascade;
DROP TABLE IF EXISTS meioCombate cascade;
DROP TABLE IF EXISTS meioApoio cascade;
DROP TABLE IF EXISTS meioSocorro cascade;
DROP TABLE IF EXISTS transporta cascade;
DROP TABLE IF EXISTS alocado cascade;
DROP TABLE IF EXISTS acciona cascade;
DROP TABLE IF EXISTS coordenador cascade;
DROP TABLE IF EXISTS audita cascade;
DROP TABLE IF EXISTS solicita cascade;


CREATE TABLE camara (
    camNum SERIAL NOT NULL unique,
    PRIMARY KEY(camNum)
);



CREATE TABLE video (
    camNum integer NOT NULL,
    dataHoraInicio TIMESTAMP NOT NULL,
    dataHoraFim TIMESTAMP NOT NULL,
    PRIMARY KEY(camNum, dataHoraInicio),
    FOREIGN KEY(camNum) REFERENCES camara(camNum) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE segmentoVideo (
  camNum integer NOT NULL,
  segmentNum NUMERIC(255) NOT NULL,
  dataHoraInicio TIMESTAMP NOT NULL,
  duracao TIME NOT NULL,
  PRIMARY KEY(camNum, dataHoraInicio, segmentNum),
  FOREIGN KEY(camNum,dataHoraInicio) REFERENCES video(camNum, dataHoraInicio) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE zona (
    moradaLocal VARCHAR(255) UNIQUE NOT NULL CHECK (moradaLocal <> ''),
    PRIMARY KEY(moradaLocal)
);

CREATE TABLE vigia (
  moradaLocal VARCHAR(255) NOT NULL,
  camNum integer NOT NULL,
  PRIMARY KEY(moradaLocal,camNum),
  FOREIGN KEY(camNum) REFERENCES camara(camNum)  ON DELETE CASCADE ON UPDATE CASCADE
  FOREIGN KEY(moradaLocal) REFERENCES zona(moradaLocal)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE processoSocorro (
    numProcessoSocorro NUMERIC(255)  NOT NULL unique,
    PRIMARY KEY(numProcessoSocorro)
);

CREATE TABLE eventoEmergencia (
  nomePessoa VARCHAR(255) NOT NULL,
  moradaLocal VARCHAR(255) NOT NULL,
  numProcessoSocorro NUMERIC(255) NOT NULL,
  numTelefone NUMERIC(255) NOT NULL,
  instanteChamada TIMESTAMP NOT NULL,
  PRIMARY KEY(numTelefone, instanteChamada),
  FOREIGN KEY(moradaLocal) REFERENCES zona(moradaLocal),
  FOREIGN KEY(numProcessoSocorro) REFERENCES processoSocorro(numProcessoSocorro)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE entidadeMeio (
    nomeEntidade VARCHAR(255)  NOT NULL unique CHECK (nomeEntidade <> ''),
    PRIMARY KEY(nomeEntidade)
);


CREATE TABLE meio(
  numMeio NUMERIC(255) NOT NULL,
  nomeMeio VARCHAR(255) NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade),
  FOREIGN KEY(nomeEntidade) REFERENCES entidadeMeio(nomeEntidade)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE meioCombate(
  numMeio NUMERIC(255) NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade),
  FOREIGN KEY(numMeio,nomeEntidade) REFERENCES meio(numMeio, nomeEntidade) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE meioApoio(
  numMeio NUMERIC(255) NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade),
  FOREIGN KEY(numMeio,nomeEntidade) REFERENCES meio(numMeio, nomeEntidade) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE meioSocorro(
  numMeio NUMERIC(255) NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade),
  FOREIGN KEY(numMeio,nomeEntidade) REFERENCES meio(numMeio, nomeEntidade) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE transporta(
  numMeio NUMERIC(255) NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  numProcessoSocorro NUMERIC(255) NOT NULL ,
  numVitimas NUMERIC(255) NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade,numProcessoSocorro),
  FOREIGN KEY(numProcessoSocorro) REFERENCES processoSocorro(numProcessoSocorro) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(numMeio,nomeEntidade) REFERENCES meioSocorro(numMeio, nomeEntidade)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE alocado(
  numMeio NUMERIC(255) NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  numProcessoSocorro NUMERIC(255) NOT NULL ,
  numHoras NUMERIC(255) NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade,numProcessoSocorro),
  FOREIGN KEY(numProcessoSocorro) REFERENCES processoSocorro(numProcessoSocorro) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(numMeio,nomeEntidade) REFERENCES meioApoio(numMeio, nomeEntidade)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE acciona(
  numMeio NUMERIC(255) NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  numProcessoSocorro NUMERIC(255) NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade,numProcessoSocorro),
  FOREIGN KEY(numProcessoSocorro) REFERENCES processoSocorro(numProcessoSocorro)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(numMeio,nomeEntidade) REFERENCES meio(numMeio, nomeEntidade)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE coordenador (
    idCoordenador NUMERIC(255) NOT NULL unique,
    PRIMARY KEY(idCoordenador)
);

CREATE TABLE audita(
  idCoordenador NUMERIC(255) NOT NULL ,
  numMeio NUMERIC(255) NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  numProcessoSocorro NUMERIC(255) ,
  datahoraInicio TIMESTAMP NOT NULL,
  datahoraFim TIMESTAMP NOT NULL,
  dataAuditoria TIMESTAMP NOT NULL,
  texto VARCHAR(255) ,
  PRIMARY KEY(idCoordenador, numMeio, nomeEntidade,numProcessoSocorro),
  FOREIGN KEY(idCoordenador) REFERENCES coordenador(idCoordenador)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(numMeio,nomeEntidade,numProcessoSocorro) REFERENCES acciona(numMeio, nomeEntidade,numProcessoSocorro)  ON DELETE CASCADE ON UPDATE CASCADE,
  CHECK (datahoraFim > datahoraInicio),
  CHECK (dataAuditoria <= NOW())
);

CREATE TABLE solicita(
    idCoordenador NUMERIC(255) NOT NULL ,
    dataHoraInicioVideo TIMESTAMP NOT NULL,
    camNum integer NOT NULL,
    dataHoraInicio TIMESTAMP NOT NULL,
    dataHoraFim TIMESTAMP NOT NULL,
    PRIMARY KEY(idCoordenador,dataHoraInicioVideo,camNum),
    FOREIGN KEY(idCoordenador) REFERENCES coordenador(idCoordenador) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(dataHoraInicioVideo,camNum) REFERENCES video(dataHoraInicio,camNum) ON DELETE CASCADE ON UPDATE CASCADE
);
