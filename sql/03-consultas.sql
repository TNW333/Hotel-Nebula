USE hotel_nebula;

-- 1. Quartos disponíveis no intervalo [entrada, saída).
SET @entrada = '2026-12-10';
SET @saida = '2026-12-13';

SELECT q.numero, q.tipo, q.capacidade, q.preco_diaria
FROM quartos AS q
WHERE q.status = 'operacional'
  AND CAST(@entrada AS DATE) < CAST(@saida AS DATE)
  AND NOT EXISTS (
    SELECT 1 FROM reservas AS r
    WHERE r.id_quarto = q.id_quarto AND r.status <> 'cancelada'
      AND r.data_checkin < CAST(@saida AS DATE)
      AND r.data_checkout > CAST(@entrada AS DATE)
  )
ORDER BY q.numero;

-- 2. Hóspedes com mais reservas não canceladas.
SELECT h.id_hospede, h.nome, COUNT(*) AS total_reservas
FROM hospedes AS h
JOIN reservas AS r ON r.id_hospede = h.id_hospede
WHERE r.status <> 'cancelada'
GROUP BY h.id_hospede, h.nome
ORDER BY total_reservas DESC, h.nome, h.id_hospede;

-- 3. Faturamento recebido por mês, pela data do pagamento.
SELECT DATE_FORMAT(pago_em, '%Y-%m') AS mes, SUM(valor) AS faturamento
FROM pagamentos
WHERE status = 'confirmado'
GROUP BY DATE_FORMAT(pago_em, '%Y-%m')
ORDER BY mes;

-- 4. Serviços mais consumidos por quantidade de unidades.
SELECT s.nome, COALESCE(SUM(c.quantidade),0) AS unidades,
       COALESCE(SUM(c.quantidade * c.preco_unitario),0) AS valor_consumido
FROM servicos AS s
LEFT JOIN consumos_servicos AS c ON c.id_servico = s.id_servico
GROUP BY s.id_servico, s.nome
ORDER BY unidades DESC, s.nome;

-- 5. Quartos com as melhores médias entre os avaliados.
SELECT q.numero, ROUND(AVG(f.nota),2) AS nota_media, COUNT(*) AS avaliacoes
FROM feedbacks AS f
JOIN hospedagens AS hp ON hp.id_hospedagem = f.id_hospedagem
JOIN reservas AS r ON r.id_reserva = hp.id_reserva
JOIN quartos AS q ON q.id_quarto = r.id_quarto
GROUP BY q.id_quarto, q.numero
ORDER BY AVG(f.nota) DESC, avaliacoes DESC, q.numero;

-- 6. Reservas canceladas.
SELECT r.id_reserva, h.nome AS hospede, q.numero AS quarto,
       r.data_checkin, r.data_checkout, r.cancelada_em
FROM reservas AS r
JOIN hospedes AS h ON h.id_hospede = r.id_hospede
JOIN quartos AS q ON q.id_quarto = r.id_quarto
WHERE r.status = 'cancelada'
ORDER BY r.cancelada_em DESC, r.id_reserva;

-- 7. Hospedagens atendidas por profissional, inclusive zero.
SELECT f.id_funcionario, f.nome, f.cargo, COUNT(a.id_hospedagem) AS hospedagens
FROM funcionarios AS f
LEFT JOIN atendimentos AS a ON a.id_funcionario = f.id_funcionario
GROUP BY f.id_funcionario, f.nome, f.cargo
ORDER BY hospedagens DESC, f.nome, f.id_funcionario;
