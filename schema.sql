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
  FOREIGN KEY(camNum) REFERENCES camara(camNum)  ON DELETE CASCADE ON UPDATE CASCADE,
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


CREATE TABLE acciona(
  numMeio NUMERIC(255) NOT NULL,
  nomeEntidade VARCHAR(255) NOT NULL,
  numProcessoSocorro NUMERIC(255) NOT NULL,
  PRIMARY KEY(numMeio, nomeEntidade,numProcessoSocorro),
  FOREIGN KEY(numProcessoSocorro) REFERENCES processoSocorro(numProcessoSocorro)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(numMeio,nomeEntidade) REFERENCES meio(numMeio, nomeEntidade)  ON DELETE CASCADE ON UPDATE CASCADE
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
-- b) Um Meio de Apoio só pode ser alocado a Processos de Socorro para os quais tenha
-- sido accionado.

-- uma maneira alterativa de fazer isto seria adicionar uma foreign key a acciona
-- FOREIGN KEY(numMeio, nomeEntidade,numProcessoSocorro) REFERENCES alocado(numMeio, nomeEntidade,numProcessoSocorro)
-- em vez das outras foreign keys
-- FIXME perguntar aos profes se podemos alterar o modelo relacional para a restricao FIXME

CREATE OR REPLACE FUNCTION accionado_before_alocado() RETURNS TRIGGER AS $body$
    DECLARE success INT;
    DECLARE morada VARCHAR(255);
    BEGIN
    success := (SELECT count(*) FROM acciona
                WHERE new.numMeio = numMeio
                AND new.nomeEntidade = nomeEntidade
                AND new.numProcessoSocorro = numProcessoSocorro
            );
    IF success = 0 THEN
        RAISE EXCEPTION 'restriction b) violated';
    END IF;
    RETURN new;
  END;
$body$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS accionado_before_alocado on alocado;
CREATE TRIGGER accionado_before_alocado BEFORE INSERT ON alocado
  FOR EACH ROW EXECUTE PROCEDURE accionado_before_alocado();
-- end of trigger

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

-- a) Um Coordenador só pode solicitar vídeos de câmaras colocadas num local cujo
-- accionamento de meios esteja a ser (ou tenha sido) auditado por ele próprio.

CREATE OR REPLACE FUNCTION solicita_permit() RETURNS TRIGGER AS $body$
    DECLARE success INT;
    DECLARE morada VARCHAR(255);
    BEGIN
    morada  := (SELECT moradaLocal FROM vigia
                  WHERE new.camNum = camNum);
    success := (SELECT count(*) FROM audita NATURAL JOIN eventoEmergencia
              NATURAL JOIN vigia
              WHERE idCoordenador = new.idCoordenador
              AND   moradaLocal   = morada
              AND   dataAuditoria <= NOW()
            );
    IF success = 0 THEN
        RAISE EXCEPTION 'restriction a) violated when inserting %', new ;
    END IF;
    RETURN new;
  END;
$body$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS solicita_permit on solicita;
CREATE TRIGGER solicita_permit BEFORE INSERT ON solicita
  FOR EACH ROW EXECUTE PROCEDURE solicita_permit();

-- end of trigger

