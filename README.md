# ⛪ Projeto de Banco de Dados: Gestão de Escalas - Ministério de Acólitos

Este repositório contém o projeto de implementação de banco de dados relacional para o sistema de gestão de escalas do Ministério de Acólitos.
---

## 🎯 Conteúdo e Objetivos

O principal objetivo é demonstrar a aplicação de comandos SQL (DDL e DML) para criar, popular e manipular o banco de dados, garantindo a **integridade referencial** e a **normalização (1FN, 2FN, 3FN)** do modelo.

### 📂 Estrutura do Repositório

| Arquivo | Descrição |
| :--- | :--- |
| `README.md` | Documentação do projeto e instruções de execução. |
| `scripts_sql_acolitos.sql` | **Script SQL Único** que contém a criação de toda a estrutura e a manipulação dos dados. |

---

## 🛠️ Instruções de Execução (SQL)

Para testar o modelo, execute o arquivo `scripts_sql_acolitos.sql` em um SGBD (Sistema de Gerenciamento de Banco de Dados) como MySQL (Workbench) ou PostgreSQL (PGAdmin).

### 📝 Conteúdo Detalhado do Script

O arquivo `scripts_sql_acolitos.sql` está estruturado na ordem abaixo:

1.  **DDL (Data Definition Language):**
    * Comandos `CREATE TABLE` para as 6 tabelas, definindo **Chaves Primárias (PK)** e **Chaves Estrangeiras (FK)**.

2.  **DML (Data Manipulation Language):**
    * **Comandos INSERT:** Povoamento das tabelas com dados coerentes ao minimundo (Acólitos, Funções, Eventos).
    * **Comandos UPDATE (3+):** Atualização de dados com condições (`WHERE`), demonstrando a manutenção (ex: alteração de nível de competência).
    * **Comandos DELETE (3+):** Exclusão de dados, respeitando as restrições de integridade referencial (ex: deletar escalas antes de deletar o evento pai).
    * **Comandos SELECT (5+):** Consultas complexas usando `JOIN`, `WHERE`, `ORDER BY`, `GROUP BY` e funções de agregação, demonstrando a extração de informações das escalas e competências.

---

## ✅ Autor
Rafael Ganzarolle Branquinho
