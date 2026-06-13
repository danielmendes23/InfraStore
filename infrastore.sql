--DDL:

create database infrastore;

create schema infrastore;

create table infrastore.cidade
(
  id_cidade char(7) primary key,
  nome_cidade varchar(30)
);

create table infrastore.cep
(
  id_cep serial primary key,
  logradouro varchar(75) not null,
  id_cidade_fk char(7) references infrastore.cidade(id_cidade)
);

create table infrastore.endereco
(
  id_endereco serial primary key,
  numero_casa smallint not null,
  id_cep_fk int references infrastore.cep(id_cep)
);

create table infrastore.cliente
(
  id_cliente serial primary key,
  email_cliente varchar(100) not null
);

create table infrastore.pessoa_fisica
(
  id_cliente_fk int primary key references infrastore.cliente(id_cliente),
  cpf char(11) unique not null,
  primeiro_nome_cliente varchar(30) not null,
  sobrenome_cliente varchar(100) not null
);

create table infrastore.pessoa_juridica
(
  id_cliente_fk int primary key references infrastore.cliente(id_cliente),
  cnpj_cliente char(14) unique not null,
  razao_social_cliente varchar(100) unique not null
);

create table infrastore.endereco_cliente
(
  id_cliente_fk int references infrastore.cliente(id_cliente),
  id_endereco_fk int references infrastore.endereco(id_endereco),
  primary key(id_cliente_fk, id_endereco_fk)
);

create table infrastore.telefone_cliente
(
  id_telefone_cliente serial primary key,
  numero_telefone_cliente char(11) not null,
  id_cliente_fk int references infrastore.cliente(id_cliente)
);

create table infrastore.fornecedor
(
  cnpj_fornecedor char(14) primary key,
  razao_social_fornecedor varchar(100) unique not null,
  email_fornecedor varchar(100) not null
);

create table infrastore.telefone_fornecedor
(
  id_telefone_fornecedor serial primary key,
  numero_telefone_fornecedor char(11) not null,
  cnpj_fornecedor_fk char(14) references infrastore.fornecedor(cnpj_fornecedor)
);

create table infrastore.categoria
(
  id_categoria_produto serial primary key,
  nome_categoria varchar(50) not null
);

create table infrastore.produto
(
  cod_produto char(7) primary key,
  preco_base decimal(10, 2) not null CHECK (preco_base > 0.00),
  descricao_produto text not null,
  nome_produto varchar(50) not null,
  quant_produto int not null CHECK (quant_produto >= 0),
  id_categoria_produto_fk int references infrastore.categoria(id_categoria_produto)
);

create table infrastore.transportadora
(
  cnpj_transportadora char(14) primary key,
  prazo_dias smallint not null,
  razao_social_transportadora varchar(100) unique not null
);

create table infrastore.telefone_transportadora
(
  id_telefone_transportadora serial primary key,
  numero_telefone_transportadora char(11) not null,
  cnpj_transportadora_fk char(14) references infrastore.transportadora(cnpj_transportadora)
);

create table infrastore.cargo
(
  id_cargo serial primary key,
  descricao_cargo text not null,
  nome_cargo varchar(35) not null,
  nivel_permissao smallint not null
);

create table infrastore.funcionario
(
  matricula_funcionario char(6) primary key,
  primeiro_nome_funcionario varchar(30) not null,
  sobrenome_funcionario varchar(100) not null,
  cpf_funcionario char(11) not null unique,
  email_corporativo varchar(100) unique not null,
  data_admissao date not null,
  id_cargo_fk int references infrastore.cargo(id_cargo)
);

create type infrastore.status_entrega as enum ('entregue', 'pedido_gerado', 'cancelado', 'a_caminho');

create table infrastore.pedido
(
  numero_pedido serial primary key,
  data_hora timestamp not null default now(),
  status_pedido infrastore.status_entrega not null,
  id_cliente_fk int references infrastore.cliente(id_cliente),
  cnpj_transportadora_fk char(14) references infrastore.transportadora(cnpj_transportadora),
  id_endereco_fk int references infrastore.endereco(id_endereco)
);

create table infrastore.pedido_produto
(
  numero_pedido_fk int references infrastore.pedido(numero_pedido),
  cod_produto_fk char(7) references infrastore.produto(cod_produto),
  preco_unitario decimal(10, 2) not null,
  quantidade smallint not null,
  primary key(numero_pedido_fk, cod_produto_fk)
);

create table infrastore.pedido_funcionario
(
  numero_pedido_fk int references infrastore.pedido(numero_pedido),
  matricula_funcionario_fk char(6) references infrastore.funcionario(matricula_funcionario),
  data_hora timestamp not null default now(),
  primary key(numero_pedido_fk, matricula_funcionario_fk, data_hora)
);

create table infrastore.produto_funcionario
(
  cod_produto_fk char(7) references infrastore.produto(cod_produto),
  matricula_funcionario_fk char(6) references infrastore.funcionario(matricula_funcionario),
  primary key(cod_produto_fk, matricula_funcionario_fk)
);

create table infrastore.produto_fornecedor
(
  cod_produto_fk char(7) references infrastore.produto(cod_produto),
  cnpj_fornecedor_fk char(14) references infrastore.fornecedor(cnpj_fornecedor),
  primary key(cod_produto_fk, cnpj_fornecedor_fk)
);

create type infrastore.metodo_pag as enum ('cartao_credito', 'cartao_debito', 'pix', 'boleto');
create type infrastore.status_pag as enum ('aguardando_pagamento', 'pago', 'cancelado');

create table infrastore.pagamento
(
  id_pagamento serial primary key,
  forma_pagamento infrastore.metodo_pag not null,
  status_pagamento infrastore.status_pag not null,
  data_pagamento timestamp not null default now(),
  numero_pedido_fk int references infrastore.pedido(numero_pedido)
);

--DML:

INSERT INTO infrastore.cidade VALUES 
('CID0001', 'São Paulo'),
('CID0002', 'Rio de Janeiro'),
('CID0003', 'Belo Horizonte'),
('CID0004', 'Curitiba'),
('CID0005', 'Maceió');

INSERT INTO infrastore.cep VALUES 
(1, 'Avenida Paulista', 'CID0001'),
(2, 'Rua Faria Lima', 'CID0001'),
(3, 'Avenida Atlântica', 'CID0002'),
(4, 'Rua da Bahia', 'CID0003'),
(5, 'Avenida Silvio Vianna', 'CID0005');

INSERT INTO infrastore.endereco VALUES 
(1, 1000, 1),
(2, 250, 2),
(3, 500, 3),
(4, 120, 4),
(5, 75, 5);

INSERT INTO infrastore.cliente VALUES 
(1, 'joao.silva@email.com'),      
(2, 'contato@techcorp.com.br'),   
(3, 'maria.souza@email.com'),     
(4, 'compras@pequenaempresa.com'),
(5, 'carlos.semcompra@email.com'),
(6, 'nula@semcompras.com.br'),
(7, 'lucas.mendes@email.com'),
(8, 'fernanda.lima@email.com'),
(9, 'compras@inovamais.com.br'),
(10, 'contato@construtoratop.com.br');

INSERT INTO infrastore.pessoa_fisica VALUES 
(1, '11111111111', 'João', 'Silva'),
(3, '33333333333', 'Maria', 'Souza'),
(5, '55555555555', 'Carlos', 'Oliveira'),
(7, '77777777777', 'Lucas', 'Mendes'),
(9, '99999999999', 'Fernanda', 'Lima');

INSERT INTO infrastore.pessoa_juridica VALUES 
(2, '22222222222222', 'TechCorp Soluções em TI Ltda'),
(4, '44444444444444', 'Pequena Empresa Comércio Ltda'),
(6, '66666666666666', 'Empresa Fantasma S/A'),
(8, '88888888888888', 'Inova Mais Tecnologia Ltda'),
(10, '10101010101010', 'Construtora Top S/A');

INSERT INTO infrastore.endereco_cliente VALUES 
(1, 1), (1, 2), 
(2, 2), (2, 3), 
(3, 3), (3, 4), 
(4, 4), (4, 5), 
(5, 5), 
(6, 1);

INSERT INTO infrastore.telefone_cliente VALUES 
(1, '11999999999', 1),
(2, '11333333333', 2),
(3, '21988888888', 3),
(4, '31322222222', 4),
(5, '82977777777', 5);

INSERT INTO infrastore.fornecedor VALUES 
('10000000000001', 'Cisco Systems Brasil', 'vendas@cisco.com'),
('20000000000002', 'Dell Computadores do Brasil', 'contato@dell.com.br'),
('30000000000003', 'Seagate Technology', 'distribuicao@seagate.com'),
('40000000000004', 'Logitech do Brasil', 'vendas@logitech.com'),
('50000000000005', 'Furukawa Eletric', 'comercial@furukawa.com');

INSERT INTO infrastore.telefone_fornecedor VALUES 
(1, '11400010000', '10000000000001'),
(2, '11400020000', '20000000000002'),
(3, '11400030000', '30000000000003'),
(4, '11400040000', '40000000000004'),
(5, '11400050000', '50000000000005');

INSERT INTO infrastore.categoria VALUES 
(1, 'Servidores'),
(2, 'Equipamentos de Rede'),
(3, 'Armazenamento'),
(4, 'Periféricos'),
(5, 'Licenças de Software'),
(6, 'Cabeamento Estruturado');

INSERT INTO infrastore.produto VALUES 
('PROD001', 15000.00, 'Servidor Rack 1U Xeon', 'Servidor PowerEdge', 40, 1),
('PROD002', 1200.00, 'Switch 24 portas Gigabit', 'Switch Cisco Catalyst', 54, 2),
('PROD003', 350.00, 'Roteador Dual Band', 'Roteador Wi-Fi 6', 50, 2),
('PROD004', 450.00, 'HD Externo 2TB USB 3.0', 'HD Externo Seagate', 20, 3),
('PROD005', 15.00, 'Cabo de rede Cat6 2 metros', 'Patch Cord Cat6', 70, 6), 
('PROD006', 45.00, 'Mouse óptico com fio', 'Mouse Básico Logi', 90, 4),  
('PROD007', 8000.00, 'Servidor Torre de entrada', 'Servidor Torre Dell', 50, 1);

INSERT INTO infrastore.transportadora VALUES 
('12345678000199', 5, 'Logística Rápida S/A'),
('98765432000188', 10, 'Transportes Pesados Ltda'),
('11122233000177', 3, 'Sedex Expresso'),
('44455566000155', 7, 'Norte Sul Transportes'),
('77788899000144', 15, 'Econômica Entregas');

INSERT INTO infrastore.telefone_transportadora VALUES 
(1, '11333344444', '12345678000199'),
(2, '11333355555', '98765432000188'),
(3, '11333366666', '11122233000177'),
(4, '11333377777', '44455566000155'),
(5, '11333388888', '77788899000144');

INSERT INTO infrastore.cargo VALUES 
(1, 'Gerencia a loja e equipe', 'Gerente Geral', 5),
(2, 'Atende clientes e processa vendas', 'Vendedor', 2),
(3, 'Cuida do estoque de produtos', 'Estoquista', 2),
(4, 'Gerencia contas e pagamentos', 'Analista Financeiro', 4),
(5, 'Suporte de TI interno', 'Analista de Sistemas', 3);

INSERT INTO infrastore.funcionario VALUES 
('FUN001', 'Ana', 'Borges', '99988877766', 'ana.borges@infrastore.com', '2020-01-15', 1),
('FUN002', 'Bruno', 'Costa', '88877766655', 'bruno.costa@infrastore.com', '2021-03-10', 2),
('FUN003', 'Carla', 'Dias', '77766655544', 'carla.dias@infrastore.com', '2021-06-20', 3),
('FUN004', 'Diego', 'Farias', '66655544433', 'diego.farias@infrastore.com', '2019-11-05', 4),
('FUN005', 'Eva', 'Gomes', '55544433322', 'eva.gomes@infrastore.com', '2022-02-01', 2);

INSERT INTO infrastore.pedido VALUES 
(1, '2023-01-10 10:00:00', 'entregue', 1, '11122233000177', 1),
(2, '2023-05-15 14:30:00', 'entregue', 1, '12345678000199', 2), 
(3, '2023-02-20 09:15:00', 'entregue', 2, '98765432000188', 3),
(4, '2023-08-01 16:45:00', 'a_caminho', 2, '44455566000155', 2), 
(5, '2023-09-10 11:00:00', 'pedido_gerado', 3, '12345678000199', 4),
(6, '2023-10-05 13:20:00', 'cancelado', 4, '77788899000144', 5);

INSERT INTO infrastore.pedido_produto VALUES 
(1, 'PROD001', 15000.00, 1),
(1, 'PROD004', 450.00, 2),
(2, 'PROD005', 15.00, 10),
(2, 'PROD006', 45.00, 1),
(3, 'PROD007', 8000.00, 1),
(3, 'PROD004', 450.00, 5),
(4, 'PROD002', 1200.00, 2),
(5, 'PROD003', 350.00, 1),
(5, 'PROD005', 15.00, 2),
(6, 'PROD006', 45.00, 2); 

INSERT INTO infrastore.pedido_funcionario VALUES 
(1, 'FUN002', '2023-01-10 10:05:00'),
(1, 'FUN003', '2023-01-10 11:00:00'),
(2, 'FUN002', '2023-05-15 14:35:00'),
(2, 'FUN003', '2023-05-15 15:00:00'),
(3, 'FUN005', '2023-02-20 09:20:00'),
(4, 'FUN005', '2023-08-01 16:50:00'),
(4, 'FUN003', '2023-08-01 17:30:00'),
(5, 'FUN002', '2023-09-10 11:05:00'),
(6, 'FUN005', '2023-10-05 13:25:00'),
(6, 'FUN004', '2023-10-05 14:00:00');

INSERT INTO infrastore.produto_funcionario VALUES 
('PROD001', 'FUN003'), ('PROD002', 'FUN003'),
('PROD003', 'FUN003'), ('PROD004', 'FUN003'),
('PROD005', 'FUN003'), ('PROD006', 'FUN003'),
('PROD007', 'FUN003'), ('PROD001', 'FUN001'),
('PROD002', 'FUN001'), ('PROD007', 'FUN001');

INSERT INTO infrastore.produto_fornecedor VALUES 
('PROD001', '20000000000002'), ('PROD007', '20000000000002'),
('PROD002', '10000000000001'), ('PROD003', '10000000000001'),
('PROD004', '30000000000003'), ('PROD006', '40000000000004'),
('PROD005', '50000000000005'), ('PROD001', '10000000000001'),
('PROD004', '20000000000002'), ('PROD002', '50000000000005');

INSERT INTO infrastore.pagamento VALUES 
(1, 'pix', 'pago', '2023-01-10 10:10:00', 1),
(2, 'cartao_credito', 'pago', '2023-05-15 14:35:00', 2),
(3, 'boleto', 'pago', '2023-02-22 09:00:00', 3),
(4, 'cartao_credito', 'aguardando_pagamento', '2023-08-01 16:45:00', 4),
(5, 'pix', 'aguardando_pagamento', '2023-09-10 11:05:00', 5),
(6, 'boleto', 'cancelado', '2023-10-05 13:20:00', 6);

--DQL:

select p.nome_produto, c.nome_categoria, p.preco_base from infrastore.produto p
join infrastore.categoria c on p.id_categoria_produto_fk = c.id_categoria_produto
where preco_base > 100
order by preco_base ASC;

select p.numero_pedido, p.data_hora, 
COALESCE(j.razao_social_cliente, CONCAT(f.primeiro_nome_cliente, ' ', f.sobrenome_cliente)) AS nome_do_cliente,p.status_pedido 
FROM infrastore.pedido p
JOIN infrastore.cliente c ON p.id_cliente_fk = c.id_cliente
LEFT JOIN infrastore.pessoa_fisica f ON c.id_cliente = f.id_cliente_fk 
LEFT JOIN infrastore.pessoa_juridica j ON c.id_cliente = j.id_cliente_fk;

select COALESCE(j.razao_social_cliente, CONCAT(f.primeiro_nome_cliente, ' ',f.sobrenome_cliente)) AS nome_do_cliente, p.data_hora 
from infrastore.cliente c
left join infrastore.pedido p on p.id_cliente_fk = c.id_cliente
left join infrastore.pessoa_fisica f on c.id_cliente = f.id_cliente_fk 
left join infrastore.pessoa_juridica j on c.id_cliente = j.id_cliente_fk;

select p.nome_produto, c.nome_categoria 
from infrastore.produto p
right join infrastore.categoria c on c.id_categoria_produto = p.id_categoria_produto_fk;

select sum(pp.quantidade), sum(pp.preco_unitario * pp.quantidade), c.nome_categoria 
from infrastore.categoria c
join infrastore.produto p on p.id_categoria_produto_fk = c.id_categoria_produto
join infrastore.pedido_produto pp on p.cod_produto = pp.cod_produto_fk
group by c.id_categoria_produto;

SELECT c.id_cliente, COALESCE(j.razao_social_cliente, CONCAT(f.primeiro_nome_cliente, ' ', f.sobrenome_cliente)) AS nome_do_cliente, SUM(pp.preco_unitario * pp.quantidade) AS valor_total_gasto
FROM infrastore.cliente c
LEFT JOIN infrastore.pessoa_fisica f ON c.id_cliente = f.id_cliente_fk 
LEFT JOIN infrastore.pessoa_juridica j ON c.id_cliente = j.id_cliente_fk
JOIN infrastore.pedido p ON c.id_cliente = p.id_cliente_fk
JOIN infrastore.pedido_produto pp ON p.numero_pedido = pp.numero_pedido_fk
GROUP BY c.id_cliente,j.razao_social_cliente,f.primeiro_nome_cliente,f.sobrenome_cliente
HAVING SUM(pp.preco_unitario * pp.quantidade) > 2000.00
ORDER BY valor_total_gasto DESC;

SELECT cod_produto,nome_produto,preco_base 
FROM infrastore.produto
WHERE preco_base > (
SELECT AVG(preco_base) FROM infrastore.produto
)
ORDER BY preco_base DESC;

SELECT COALESCE(j.razao_social_cliente, CONCAT(f.primeiro_nome_cliente, ' ',f.sobrenome_cliente)) AS nome_do_cliente,(
SELECT MAX(p.data_hora) 
FROM infrastore.pedido p 
WHERE p.id_cliente_fk = c.id_cliente
) AS data_ultimo_pedido
FROM infrastore.cliente c
LEFT JOIN infrastore.pessoa_fisica f ON c.id_cliente = f.id_cliente_fk 
LEFT JOIN infrastore.pessoa_juridica j ON c.id_cliente = j.id_cliente_fk;

SELECT COALESCE(j.razao_social_cliente, CONCAT(f.primeiro_nome_cliente, ' ',f.sobrenome_cliente)) AS nome_contato, c.email_cliente AS email_contato, 'Cliente' AS origem_contato
FROM infrastore.cliente c
LEFT JOIN infrastore.pessoa_fisica f ON c.id_cliente = f.id_cliente_fk 
LEFT JOIN infrastore.pessoa_juridica j ON c.id_cliente = j.id_cliente_fk
UNION SELECT razao_social_fornecedor AS nome_contato, email_fornecedor AS email_contato, 'Fornecedor' AS origem_contato
FROM infrastore.fornecedor
UNION SELECT CONCAT(primeiro_nome_funcionario, ' ', sobrenome_funcionario) AS nome_contato, email_corporativo AS email_contato, 'Funcionário' AS origem_contato
FROM infrastore.funcionario
ORDER BY origem_contato, nome_contato;

WITH RankingVendas AS (
SELECT c.nome_categoria,p.nome_produto,SUM(pp.quantidade) AS total_vendido,
RANK() OVER (PARTITION BY c.id_categoria_produto ORDER BY SUM(pp.quantidade) DESC) as posicao_ranking
FROM infrastore.categoria c
JOIN infrastore.produto p ON c.id_categoria_produto = p.id_categoria_produto_fk
JOIN infrastore.pedido_produto pp ON p.cod_produto = pp.cod_produto_fk
JOIN infrastore.pedido ped ON pp.numero_pedido_fk = ped.numero_pedido
WHERE ped.status_pedido != 'cancelado' 
GROUP BY c.id_categoria_produto, c.nome_categoria, 
p.nome_produto)
SELECT nome_categoria, posicao_ranking, nome_produto,total_vendido
FROM RankingVendas
WHERE posicao_ranking <= 2 
ORDER BY nome_categoria, posicao_ranking;

CREATE VIEW infrastore.vw_resumo_pedidos AS
SELECT p.numero_pedido,COALESCE(j.razao_social_cliente, CONCAT(f.primeiro_nome_cliente, ' ',f.sobrenome_cliente)) AS nome_do_cliente, SUM(pp.quantidade) AS quantidade_total_itens, SUM(pp.preco_unitario * pp.quantidade) AS valor_total_pedido,pag.status_pagamento
FROM infrastore.pedido p
JOIN infrastore.cliente c ON p.id_cliente_fk = c.id_cliente
LEFT JOIN infrastore.pessoa_fisica f ON c.id_cliente = f.id_cliente_fk 
LEFT JOIN infrastore.pessoa_juridica j ON c.id_cliente = j.id_cliente_fk
JOIN infrastore.pedido_produto pp ON p.numero_pedido = pp.numero_pedido_fk
LEFT JOIN infrastore.pagamento pag ON p.numero_pedido = pag.numero_pedido_fk
GROUP BY p.numero_pedido, j.razao_social_cliente, f.primeiro_nome_cliente,f.sobrenome_cliente,pag.status_pagamento;

select * from infrastore.vw_resumo_pedidos;

-- Parte 2 

-- Acelera relatórios de vendas baseados em datas
CREATE INDEX idx_pedido_data ON infrastore.pedido(data_hora); 
-- Acelera o processo de busca e login de clientes pelo e-mail
CREATE INDEX idx_cliente_email ON infrastore.cliente(email_cliente);
-- Otimiza as buscas e JOINs filtrados por categoria
CREATE INDEX idx_produto_categoria ON infrastore.produto(id_categoria_produto_fk); 

CREATE USER gerente_user WITH PASSWORD '123';
CREATE USER operador_logistica_user WITH PASSWORD '123';
CREATE USER analista_user WITH PASSWORD '123';

CREATE ROLE Gerente_role;
CREATE ROLE operador_logistica_role;
CREATE ROLE analista_role; 

GRANT Gerente_role TO gerente_user;
GRANT analista_role TO analista_user; 
GRANT operador_logistica_role TO operador_logistica_user;

GRANT USAGE ON SCHEMA infrastore TO Gerente_role;
GRANT SELECT ON ALL TABLES IN SCHEMA infrastore TO Gerente_role;
GRANT UPDATE ON infrastore.produto TO Gerente_role;

GRANT USAGE ON SCHEMA infrastore TO operador_logistica_role;
GRANT SELECT, UPDATE ON infrastore.pedido TO operador_logistica_role;
GRANT SELECT, UPDATE ON infrastore.produto TO operador_logistica_role;
GRANT SELECT ON infrastore.transportadora, infrastore.endereco, infrastore.cep, infrastore.cidade 
TO operador_logistica_role;

GRANT USAGE ON SCHEMA infrastore TO analista_role; 
GRANT SELECT ON ALL TABLES IN SCHEMA infrastore TO analista_role; 

CREATE OR REPLACE VIEW College_Restricted_Logistica_View AS
SELECT
p.numero_pedido,
p.status_pedido,
p.data_hora,
c.email_cliente,
cep.logradouro,
e.numero_casa,
t.razao_social_transportadora
FROM infrastore.pedido p
JOIN infrastore.cliente c ON p.id_cliente_fk = c.id_cliente
JOIN infrastore.endereco e ON p.id_endereco_fk = e.id_endereco
JOIN infrastore.cep cep ON e.id_cep_fk = cep.id_cep
JOIN infrastore.transportadora t ON p.cnpj_transportadora_fk = t.cnpj_transportadora;
REVOKE ALL PRIVILEGES ON
infrastore.pessoa_fisica,
infrastore.pessoa_juridica,
infrastore.pagamento
FROM operador_logistica_role;
GRANT SELECT ON College_Restricted_Logistica_View TO operador_logistica_role;


CREATE OR REPLACE FUNCTION infrastore.tg_atualizar_gerente_produtos()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE infrastore.produto
    SET preco_base = NEW.preco_base,
        quant_produto = NEW.quant_produto,
        nome_produto = NEW.nome_produto,
        descricao_produto = NEW.descricao_produto
    WHERE cod_produto = OLD.cod_produto;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_gerente_update_view
INSTEAD OF UPDATE ON infrastore.vw_gerente_gestao_produtos
FOR EACH ROW
EXECUTE FUNCTION infrastore.tg_atualizar_gerente_produtos();

CREATE OR REPLACE VIEW infrastore.vw_gerente_gestao_produtos AS
SELECT 
   p.cod_produto,
   p.nome_produto,
   p.preco_base,
   p.quant_produto,
   c.nome_categoria,
   p.descricao_produto
FROM infrastore.produto p
JOIN infrastore.categoria c ON p.id_categoria_produto_fk = c.id_categoria_produto;

GRANT SELECT, UPDATE ON infrastore.vw_gerente_gestao_produtos TO Gerente_role;

CREATE EXTENSION IF NOT EXISTS pgcrypto;
ALTER TABLE infrastore.funcionario ADD COLUMN senha_funcionario text;

UPDATE infrastore.funcionario SET senha_funcionario = crypt('mudar123', gen_salt('bf'));

ALTER TABLE infrastore.funcionario ALTER COLUMN senha_funcionario SET NOT NULL;

UPDATE infrastore.funcionario 
SET senha_funcionario = crypt('senhaAna123', gen_salt('bf')) WHERE matricula_funcionario = 'FUN001';

UPDATE infrastore.funcionario 
SET senha_funcionario = crypt('bruno@pass', gen_salt('bf')) WHERE matricula_funcionario = 'FUN002';

UPDATE infrastore.funcionario 
SET senha_funcionario = crypt('carlaAcesso', gen_salt('bf')) WHERE matricula_funcionario = 'FUN003';

UPDATE infrastore.funcionario 
SET senha_funcionario = crypt('diegoMudar9', gen_salt('bf')) WHERE matricula_funcionario = 'FUN004';

UPDATE infrastore.funcionario 
SET senha_funcionario = crypt('eva@2026', gen_salt('bf')) WHERE matricula_funcionario = 'FUN005';