USE hotel_nebula;
START TRANSACTION;

INSERT INTO hospedes (id_hospede,nome,email) VALUES
(1,'Ana Lima','ana@example.com'),(2,'Bruno Reis','bruno@example.com'),
(3,'Carla Luz','carla@example.com'),(4,'Diego Melo','diego@example.com');

INSERT INTO quartos (id_quarto,numero,tipo,capacidade,preco_diaria,status,andar) VALUES
(1,'101','Standard',2,220,'operacional',1),(2,'102','Standard',2,240,'operacional',1),
(3,'201','Suíte',3,390,'operacional',2),(4,'202','Suíte',3,410,'manutencao',2);

INSERT INTO reservas
(id_reserva,id_hospede,id_quarto,data_checkin,data_checkout,status,quantidade_hospedes,diaria_contratada,criada_em,cancelada_em) VALUES
(1,1,1,'2026-09-04','2026-09-06','concluida',2,220,'2026-08-23 10:00:00',NULL),
(2,2,3,'2026-09-10','2026-09-12','concluida',1,390,'2026-08-28 10:00:00',NULL),
(3,1,3,'2026-10-02','2026-10-04','concluida',2,390,'2026-09-21 10:00:00',NULL),
(4,3,2,'2026-10-06','2026-10-08','cancelada',1,240,'2026-09-25 10:00:00','2026-10-01 10:00:00'),
(5,2,1,'2026-12-10','2026-12-13','confirmada',2,220,'2026-11-20 10:00:00',NULL),
(6,1,3,'2026-12-13','2026-12-15','confirmada',2,390,'2026-11-21 10:00:00',NULL);

INSERT INTO hospedagens (id_hospedagem,id_reserva,checkin_real,checkout_real) VALUES
(1,1,'2026-09-04 15:00:00','2026-09-06 11:00:00'),
(2,2,'2026-09-10 14:30:00','2026-09-12 10:00:00'),
(3,3,'2026-10-02 16:00:00','2026-10-04 11:00:00');

INSERT INTO funcionarios (id_funcionario,nome,cargo,email,data_admissao) VALUES
(1,'Marina Paes','Recepção','marina@example.com','2024-02-01'),
(2,'Rafael Nunes','Concierge','rafael@example.com','2024-04-01'),
(3,'Lívia Teixeira','Recepção','livia@example.com','2026-08-10');

INSERT INTO atendimentos (id_hospedagem,id_funcionario,atendido_em) VALUES
(1,1,'2026-09-04 15:00:00'),(1,2,'2026-09-05 08:00:00'),
(2,1,'2026-09-10 14:30:00'),(3,2,'2026-10-02 16:00:00');

INSERT INTO servicos (id_servico,nome,descricao,preco_atual) VALUES
(1,'Café da manhã','Buffet individual',50),(2,'Lavanderia','Lavagem por lote',25),
(3,'Traslado','Viagem até o aeroporto',90);

INSERT INTO consumos_servicos (id_hospedagem,id_servico,quantidade,preco_unitario,consumido_em) VALUES
(1,1,2,50,'2026-09-05 08:00:00'),(2,2,1,25,'2026-09-11 09:00:00'),
(3,1,1,50,'2026-10-03 08:00:00');

INSERT INTO pagamentos (id_hospedagem,valor,metodo,status,pago_em) VALUES
(1,300,'pix','confirmado','2026-09-04 15:02:00'),
(1,240,'credito','confirmado','2026-09-06 10:20:00'),
(2,805,'credito','confirmado','2026-09-12 09:50:00'),
(3,800,'pix','confirmado','2026-10-04 10:45:00'),
(3,30,'pix','pendente',NULL);

INSERT INTO feedbacks (id_hospedagem,nota,comentario,avaliado_em) VALUES
(1,4,'Quarto confortável.','2026-09-06 19:00:00'),
(2,5,'Ótimo atendimento.','2026-09-12 20:00:00'),
(3,5,'Estadia tranquila.','2026-10-05 09:00:00');

COMMIT;
