# Hotel Nebula

Projeto acadêmico de banco relacional para organizar reservas, hospedagens, pagamentos, atendimento, serviços e avaliações.

| Parte | Entrega |
|---|---|
| 1. Origem do Sistema | [Diagrama ER, modelo lógico e regras](modelagem/01-modelo.md) |
| 2. Montagem do Núcleo | [Criação do banco](sql/01-criacao.sql) e [dados fictícios](sql/02-dados.sql) |
| 3. Radar de Comando | [Sete consultas SQL](sql/03-consultas.sql) |

## Estrutura física

O projeto usa MySQL 8.0.16 ou posterior, InnoDB e UTF-8. As tabelas usam chaves primárias e estrangeiras, restrições de unicidade, verificações de domínio e índices para disponibilidade e faturamento. Datas previstas são `DATE`, ocorrências reais são `DATETIME` e os valores monetários são `DECIMAL(10,2)`.

Execute os três scripts em ordem em um banco de teste vazio. No MySQL Workbench, abra cada arquivo SQL e execute-o por inteiro. Pelo cliente MySQL, dentro do repositório:

```sql
SOURCE sql/01-criacao.sql;
SOURCE sql/02-dados.sql;
SOURCE sql/03-consultas.sql;
```

Os dados são fictícios. A carga deve ser executada uma vez no esquema novo.

## Resultados de referência

| Consulta | Resultado esperado com a carga inicial |
|---|---|
| Disponibilidade de 10 a 13 de dezembro de 2026 | Quartos 102 e 201 |
| Hóspedes por reservas não canceladas | Ana Lima (3), Bruno Reis (2) |
| Faturamento mensal recebido | Setembro de 2026, R$ 1.345,00. Outubro de 2026, R$ 800,00 |
| Serviços mais consumidos | Café da manhã (3), lavanderia (1), traslado (0) |
| Avaliações por quarto | Quarto 201 com média 5 e duas avaliações. Quarto 101 com média 4 e uma avaliação |
| Cancelamentos | Reserva 4, de Carla Luz |
| Hospedagens atendidas | Marina Paes (2), Rafael Nunes (2), Lívia Teixeira (0) |

Para consultar outro intervalo, altere `@entrada` e `@saida` no início de `03-consultas.sql`.
