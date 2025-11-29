-- DDL: CRIAÇÃO DAS TABELAS

-- 1. Tabela PERFIL_ACESSO
CREATE TABLE PERFIL_ACESSO (
    ID_Perfil INT PRIMARY KEY AUTO_INCREMENT,
    NomePerfil VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Tabela ACÓLITO
CREATE TABLE ACOLITO (
    ID_Acolito INT PRIMARY KEY AUTO_INCREMENT,
    NomeCompleto VARCHAR(100) NOT NULL,
    DataNascimento DATE NOT NULL,
    TelefoneContato VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    DataCadastro DATE NOT NULL,
    ID_Perfil INT NOT NULL,
    FOREIGN KEY (ID_Perfil) REFERENCES PERFIL_ACESSO(ID_Perfil)
);

-- 3. Tabela FUNÇÃO_LITÚRGICA
CREATE TABLE FUNCAO_LITURGICA (
    ID_Funcao INT PRIMARY KEY AUTO_INCREMENT,
    NomeFuncao VARCHAR(50) NOT NULL UNIQUE,
    Descricao VARCHAR(255),
    NivelNecessario VARCHAR(20) DEFAULT 'Básico'
);

-- 4. Tabela EVENTO_LITÚRGICO
CREATE TABLE EVENTO_LITURGICO (
    ID_Evento INT PRIMARY KEY AUTO_INCREMENT,
    NomeEvento VARCHAR(100) NOT NULL,
    DataHora DATETIME NOT NULL,
    TipoCelebracao VARCHAR(50),
    Localizacao VARCHAR(100)
);

-- 5. Tabela ACÓLITO_FUNÇÃO (Associação N:N)
CREATE TABLE ACOLITO_FUNCAO (
    ID_Acolito INT NOT NULL,
    ID_Funcao INT NOT NULL,
    NivelCompetencia INT CHECK (NivelCompetencia BETWEEN 1 AND 5),
    PRIMARY KEY (ID_Acolito, ID_Funcao),
    FOREIGN KEY (ID_Acolito) REFERENCES ACOLITO(ID_Acolito),
    FOREIGN KEY (ID_Funcao) REFERENCES FUNCAO_LITURGICA(ID_Funcao)
);

-- 6. Tabela ESCALA
CREATE TABLE ESCALA (
    ID_Escala INT PRIMARY KEY AUTO_INCREMENT,
    ID_Acolito INT NOT NULL,
    ID_Funcao INT NOT NULL,
    ID_Evento INT NOT NULL,
    StatusFrequencia VARCHAR(20) DEFAULT 'Pendente', -- Valores: Pendente, Presente, Ausente, Substituido
    ObservacoesLider TEXT,
    FOREIGN KEY (ID_Acolito) REFERENCES ACOLITO(ID_Acolito),
    FOREIGN KEY (ID_Funcao) REFERENCES FUNCAO_LITURGICA(ID_Funcao),
    FOREIGN KEY (ID_Evento) REFERENCES EVENTO_LITURGICO(ID_Evento)
);

-- DML: INSERÇÃO DE DADOS (Povoamento)

-- Inserção em PERFIL_ACESSO
INSERT INTO PERFIL_ACESSO (NomePerfil) VALUES ('Acólito Básico'), ('Cerimoniário'), ('Administrador');

-- Inserção em FUNÇÃO_LITÚRGICA
INSERT INTO FUNCAO_LITURGICA (NomeFuncao, Descricao, NivelNecessario) VALUES 
('Mestre de Cerimônias', 'Lidera a celebração', 'Avançado'),
('Turiferário', 'Responsável pelo incenso', 'Intermediário'),
('Ceroferário', 'Portador de velas', 'Básico'),
('Acólito do Livro', 'Responsável pelo missal', 'Básico');

-- Inserção em ACÓLITO (Assume-se que ID_Perfil 1=Acólito, 2=Cerimoniário)
INSERT INTO ACOLITO (NomeCompleto, DataNascimento, Email, ID_Perfil, DataCadastro) VALUES
('Ana Clara Lima', '2008-05-15', 'ana.clara@paroquia.com', 1, '2022-01-10'),
('Pedro Henrique Souza', '2005-11-20', 'pedro.h@paroquia.com', 2, '2020-03-01'), -- Cerimoniário
('Mariana Costa', '2009-02-28', 'mariana.c@paroquia.com', 1, '2023-09-05'),
('Lucas Fernandes', '2007-07-07', 'lucas.f@paroquia.com', 1, '2021-05-20');

-- Inserção em ACÓLITO_FUNÇÃO (Competências)
-- Ana (ID 1) é apta para Ceroferário (ID 3) e Acólito do Livro (ID 4)
INSERT INTO ACOLITO_FUNCAO (ID_Acolito, ID_Funcao, NivelCompetencia) VALUES (1, 3, 3), (1, 4, 3);
-- Pedro (ID 2) é apto para todas
INSERT INTO ACOLITO_FUNCAO (ID_Acolito, ID_Funcao, NivelCompetencia) VALUES (2, 1, 5), (2, 2, 4), (2, 3, 5), (2, 4, 5);
-- Lucas (ID 4) é apto para Turiferário (ID 2)
INSERT INTO ACOLITO_FUNCAO (ID_Acolito, ID_Funcao, NivelCompetencia) VALUES (4, 2, 3);

-- Inserção em EVENTO_LITÚRGICO
INSERT INTO EVENTO_LITURGICO (NomeEvento, DataHora, TipoCelebracao, Localizacao) VALUES
('Missa Dominical', '2025-12-07 10:00:00', 'Comum', 'Matriz'),
('Missa Solene da Imaculada', '2025-12-08 19:30:00', 'Solene', 'Matriz');

-- Inserção em ESCALA (Alocação)
-- Escala 1 (Missa Dominical 10h)
INSERT INTO ESCALA (ID_Acolito, ID_Funcao, ID_Evento) VALUES (1, 4, 1); -- Ana -> Acólito do Livro
INSERT INTO ESCALA (ID_Acolito, ID_Funcao, ID_Evento) VALUES (3, 3, 1); -- Mariana -> Ceroferário
-- Escala 2 (Missa Solene 19:30h)
INSERT INTO ESCALA (ID_Acolito, ID_Funcao, ID_Evento) VALUES (2, 1, 2); -- Pedro -> Mestre de Cerimônias
INSERT INTO ESCALA (ID_Acolito, ID_Funcao, ID_Evento) VALUES (4, 2, 2); -- Lucas -> Turiferário

-- DML: COMANDOS SELECT (Consultas)

-- 1. Consulta simples: Retornar acólitos cadastrados após uma data específica (WHERE)
SELECT 
    NomeCompleto, DataCadastro, Email
FROM 
    ACOLITO
WHERE 
    DataCadastro > '2022-01-01'
ORDER BY 
    DataCadastro DESC;

-- 2. Consulta com JOIN: Quais acólitos são aptos a serem Turiferário (N:N resolvido)
SELECT 
    A.NomeCompleto AS Acolito,
    F.NomeFuncao AS Funcao
FROM 
    ACOLITO AS A
JOIN 
    ACOLITO_FUNCAO AS AF ON A.ID_Acolito = AF.ID_Acolito
JOIN 
    FUNCAO_LITURGICA AS F ON AF.ID_Funcao = F.ID_Funcao
WHERE 
    F.NomeFuncao = 'Turiferário';

-- 3. Consulta complexa: Detalhamento das próximas escalas (JOINs e ORDER BY)
SELECT
    E.NomeEvento,
    DATE_FORMAT(E.DataHora, '%d/%m/%Y %H:%i') AS DataHora,
    A.NomeCompleto AS AcolitoEscalado,
    F.NomeFuncao AS Funcao,
    S.StatusFrequencia
FROM
    ESCALA AS S
JOIN
    ACOLITO AS A ON S.ID_Acolito = A.ID_Acolito
JOIN
    FUNCAO_LITURGICA AS F ON S.ID_Funcao = F.ID_Funcao
JOIN
    EVENTO_LITURGICO AS E ON S.ID_Evento = E.ID_Evento
ORDER BY
    E.DataHora ASC;

-- 4. Consulta com Contagem: Contar quantos acólitos têm o perfil 'Cerimoniário' (JOIN e GROUP BY)
SELECT 
    P.NomePerfil,
    COUNT(A.ID_Acolito) AS TotalAcolitos
FROM 
    ACOLITO AS A
JOIN 
    PERFIL_ACESSO AS P ON A.ID_Perfil = P.ID_Perfil
GROUP BY 
    P.NomePerfil
HAVING
    P.NomePerfil = 'Cerimoniário';

-- DML: COMANDOS UPDATE E DELETE

-- ------------------
-- COMANDOS UPDATE
-- ------------------

-- 1. UPDATE: Atualizar o status de um acólito (Mariana - ID 3) para 'Presente' após um evento (uso de WHERE simples).
UPDATE ESCALA
SET StatusFrequencia = 'Presente'
WHERE ID_Acolito = 3 AND ID_Evento = 1;

-- 2. UPDATE: Atualizar o Nível de Competência de um Cerimoniário após um treinamento (N:N - Chave Composta).
-- Aumenta o NívelCompetencia do Pedro (ID 2) para '5' em 'Turiferário' (ID 2).
UPDATE ACOLITO_FUNCAO
SET NivelCompetencia = 5
WHERE ID_Acolito = 2 AND ID_Funcao = 2;

-- 3. UPDATE: Alterar a data/hora de um evento específico.
UPDATE EVENTO_LITURGICO
SET DataHora = '2025-12-08 20:00:00'
WHERE ID_Evento = 2;


-- ------------------
-- COMANDOS DELETE
-- ------------------

-- 1. DELETE: Remover um acólito da escala (não remove o acólito do cadastro, apenas da escala).
-- Remove a Ana (ID 1) da escala do evento 1 (Missa Dominical).
DELETE FROM ESCALA
WHERE ID_Acolito = 1 AND ID_Evento = 1;

-- 2. DELETE: Remover uma função litúrgica (A integridade referencial pode exigir a remoção primeiro das tabelas filhas).
-- Caso a função 'Acólito do Livro' (ID 4) não seja mais usada.
-- Necessário remover primeiro de ACOLITO_FUNCAO e ESCALA.
DELETE FROM ACOLITO_FUNCAO WHERE ID_Funcao = 4;
-- (A tabela ESCALA já foi verificada e a linha removida no DELETE anterior.)
DELETE FROM FUNCAO_LITURGICA WHERE ID_Funcao = 4;

-- 3. DELETE: Excluir um evento completo e todas as suas escalas associadas.
-- Exclui o Evento 1 (Missa Dominical).
-- O comando deve ser feito DELETANDO primeiro as linhas filhas (ESCALA) e depois o pai (EVENTO_LITURGICO).
DELETE FROM ESCALA WHERE ID_Evento = 1;
DELETE FROM EVENTO_LITURGICO WHERE ID_Evento = 1;
