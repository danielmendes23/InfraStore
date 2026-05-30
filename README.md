# 🚀 InfraStore - ERP Database

> Sistema de Gestão de Banco de Dados Relacional para E-commerce de Hardware e Infraestrutura.

## 📌 Sobre o Projeto
O **InfraStore** é um projeto de banco de dados estruturado para suportar as operações complexas de um e-commerce real. O modelo foi desenhado com foco em escalabilidade, separando a operação diária (logística, rastreio e estoque) da análise estratégica (gestão de catálogos e faturamento), garantindo integridade referencial rígida e transações financeiras seguras.

## ⚙️ Destaques da Arquitetura
* **Modelagem Madura:** Normalização rigorosa aplicada até a 3ª Forma Normal (3FN), eliminando redundâncias (incluindo tratamento de CEPs e Herança de Clientes).
* **Controle de Acesso (RBAC):** Sistema de permissões via hierarquia de Cargos, evitando a exclusão e recriação de usuários em caso de promoções.
* **Segurança de Negócio:** Congelamento de preços no momento da compra e proteção contra baixa de estoque negativa.
* **SQL Avançado:** Consultas analíticas de alto nível utilizando *CTEs (WITH)*, *Window Functions (RANK OVER)*, *Subconsultas Correlacionadas*, agregações financeiras e *Views*.

## 🛠️ Tecnologias Utilizadas
* **SGBD:** PostgreSQL
* **Linguagem:** SQL (DDL, DML e DQL)
* **Modelagem:** Lucidchart (Diagrama Entidade-Relacionamento)

---

**Instituição:** Universidade Federal de Alagoas (UFAL) - Campus Arapiraca  
**Discentes:** Enrique Ferreira da Silva e Daniel Mendes da Silva  
**Disciplina:** Banco de Dados
**Professor:** Rodolfo Carneiro
