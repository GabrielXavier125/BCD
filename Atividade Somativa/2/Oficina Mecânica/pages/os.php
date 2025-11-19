<?php
// CRUD básico de Ordens de Serviço
// Modelo simplificado: 1 veículo, 1 mecânico, 1 serviço e 1 peça (opcionais).

// Listas para selects
$veiculos = $pdo->query("SELECT v.id_veiculo, v.placa, v.modelo, c.nome AS cliente
                         FROM veiculos v
                         JOIN clientes c ON c.id_cliente = v.id_cliente
                         ORDER BY c.nome, v.placa")->fetchAll();

$mecanicos = $pdo->query("SELECT * FROM mecanicos ORDER BY nome")->fetchAll();
$servicos  = $pdo->query("SELECT * FROM servicos ORDER BY descricao")->fetchAll();
$pecas     = $pdo->query("SELECT * FROM pecas ORDER BY descricao")->fetchAll();

// CREATE
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id_veiculo   = (int)($_POST['id_veiculo'] ?? 0);
    $data_abertura= $_POST['data_abertura'] ?? date('Y-m-d');
    $status       = $_POST['status'] ?? 'ABERTA';
    $observacoes  = trim($_POST['observacoes'] ?? '');

    $id_mecanico  = (int)($_POST['id_mecanico'] ?? 0);
    $id_servico   = (int)($_POST['id_servico'] ?? 0);
    $qtd_servico  = (int)($_POST['qtd_servico'] ?? 1);
    $id_peca      = (int)($_POST['id_peca'] ?? 0);
    $qtd_peca     = (int)($_POST['qtd_peca'] ?? 1);

    if ($id_veiculo) {
        // Nova OS
        $stmt = $pdo->prepare("INSERT INTO ordens_servico (id_veiculo, data_abertura, status, observacoes)
                               VALUES (?, ?, ?, ?)");
        $stmt->execute([$id_veiculo, $data_abertura, $status, $observacoes]);
        $novoId = (int)$pdo->lastInsertId();

        // Mecânico (1 opcional)
        if ($id_mecanico) {
            $pdo->prepare("INSERT INTO os_mecanicos (id_os, id_mecanico) VALUES (?, ?)")
                ->execute([$novoId, $id_mecanico]);
        }

        // Serviço (1 opcional)
        if ($id_servico && $qtd_servico > 0) {
            $serv = $pdo->prepare("SELECT valor FROM servicos WHERE id_servico = ?");
            $serv->execute([$id_servico]);
            if ($row = $serv->fetch()) {
                $valorUnit = (float)$row['valor'];
                $subtotal  = $valorUnit * $qtd_servico;
                $pdo->prepare("INSERT INTO os_servicos (id_os, id_servico, quantidade, valor_unitario, subtotal)
                               VALUES (?, ?, ?, ?, ?)")
                    ->execute([$novoId, $id_servico, $qtd_servico, $valorUnit, $subtotal]);
            }
        }

        // Peça (1 opcional)
        if ($id_peca && $qtd_peca > 0) {
            $pc = $pdo->prepare("SELECT valor, estoque FROM pecas WHERE id_peca = ?");
            $pc->execute([$id_peca]);
            if ($row = $pc->fetch()) {
                $valorUnit = (float)$row['valor'];
                $subtotal  = $valorUnit * $qtd_peca;
                $pdo->prepare("INSERT INTO os_pecas (id_os, id_peca, quantidade, valor_unitario, subtotal)
                               VALUES (?, ?, ?, ?, ?)")
                    ->execute([$novoId, $id_peca, $qtd_peca, $valorUnit, $subtotal]);

                // baixa de estoque simples
                $novoEstoque = max(0, (int)$row['estoque'] - $qtd_peca);
                $pdo->prepare("UPDATE pecas SET estoque=? WHERE id_peca=?")
                    ->execute([$novoEstoque, $id_peca]);
            }
        }
    }

    header("Location: index.php?page=os");
    exit;
}

// DELETE
if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $pdo->prepare("DELETE FROM ordens_servico WHERE id_os = ?")->execute([$id]);
    header("Location: index.php?page=os");
    exit;
}

// LISTA (com totais)
$sql = "
SELECT
  os.id_os,
  os.data_abertura,
  os.status,
  os.observacoes,
  v.placa,
  v.modelo,
  c.nome AS cliente,
  IFNULL((SELECT SUM(subtotal) FROM os_servicos s WHERE s.id_os = os.id_os),0) AS total_servicos,
  IFNULL((SELECT SUM(subtotal) FROM os_pecas p WHERE p.id_os = os.id_os),0) AS total_pecas
FROM ordens_servico os
JOIN veiculos v ON v.id_veiculo = os.id_veiculo
JOIN clientes c ON c.id_cliente = v.id_cliente
ORDER BY os.id_os DESC
";
$ordens = $pdo->query($sql)->fetchAll();

function formatMoneyBR($v) {
    return number_format((float)$v, 2, ',', '.');
}
?>
<div class="section-header">
  <h2>Ordens de Serviço</h2>
</div>

<div class="card form-card">
  <h3>Nova OS (simplificada)</h3>
  <form method="post">
    <div class="grid-3">
      <div class="form-group">
        <label>Veículo</label>
        <select name="id_veiculo" required>
          <option value="">Selecione...</option>
          <?php foreach ($veiculos as $v): ?>
            <option value="<?php echo $v['id_veiculo']; ?>">
              <?php echo htmlspecialchars($v['cliente'] . ' - ' . $v['placa'] . ' (' . $v['modelo'] . ')'); ?>
            </option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="form-group">
        <label>Data de abertura</label>
        <input type="date" name="data_abertura"
               value="<?php echo date('Y-m-d'); ?>" required>
      </div>
      <div class="form-group">
        <label>Status</label>
        <select name="status">
          <option value="ABERTA">ABERTA</option>
          <option value="EM_ANDAMENTO">EM_ANDAMENTO</option>
          <option value="CONCLUIDA">CONCLUIDA</option>
          <option value="CANCELADA">CANCELADA</option>
        </select>
      </div>
    </div>

    <div class="form-group">
      <label>Observações</label>
      <textarea name="observacoes" placeholder="Descreva o problema relatado pelo cliente, etc."></textarea>
    </div>

    <div class="grid-3">
      <div class="form-group">
        <label>Mecânico (opcional)</label>
        <select name="id_mecanico">
          <option value="0">-- Nenhum --</option>
          <?php foreach ($mecanicos as $m): ?>
            <option value="<?php echo $m['id_mecanico']; ?>">
              <?php echo htmlspecialchars($m['nome']); ?>
            </option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="form-group">
        <label>Serviço (opcional)</label>
        <select name="id_servico">
          <option value="0">-- Nenhum --</option>
          <?php foreach ($servicos as $s): ?>
            <option value="<?php echo $s['id_servico']; ?>">
              <?php echo htmlspecialchars($s['descricao']); ?> (R$ <?php echo formatMoneyBR($s['valor']); ?>)
            </option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="form-group">
        <label>Qtd. Serviço</label>
        <input type="number" name="qtd_servico" min="1" value="1">
      </div>
    </div>

    <div class="grid-3">
      <div class="form-group">
        <label>Peça (opcional)</label>
        <select name="id_peca">
          <option value="0">-- Nenhuma --</option>
          <?php foreach ($pecas as $p): ?>
            <option value="<?php echo $p['id_peca']; ?>">
              <?php echo htmlspecialchars($p['descricao']); ?> (R$ <?php echo formatMoneyBR($p['valor']); ?> | estoque: <?php echo $p['estoque']; ?>)
            </option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="form-group">
        <label>Qtd. Peça</label>
        <input type="number" name="qtd_peca" min="1" value="1">
      </div>
    </div>

    <button type="submit" class="btn primary big">Salvar OS</button>
  </form>
</div>

<div class="card">
  <h3>Lista de Ordens de Serviço</h3>
  <div class="table-wrapper">
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Cliente / Veículo</th>
          <th>Data</th>
          <th>Status</th>
          <th>Total Serviços</th>
          <th>Total Peças</th>
          <th>Total Geral</th>
          <th>Ações</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($ordens as $os): 
          $totalServ = $os['total_servicos'];
          $totalPec  = $os['total_pecas'];
          $totalGeral= $totalServ + $totalPec;
        ?>
          <tr>
            <td><?php echo $os['id_os']; ?></td>
            <td>
              <?php echo htmlspecialchars($os['cliente']); ?><br>
              <small><?php echo htmlspecialchars($os['placa'] . ' - ' . $os['modelo']); ?></small>
            </td>
            <td><?php echo htmlspecialchars($os['data_abertura']); ?></td>
            <td><?php echo htmlspecialchars($os['status']); ?></td>
            <td>R$ <?php echo formatMoneyBR($totalServ); ?></td>
            <td>R$ <?php echo formatMoneyBR($totalPec); ?></td>
            <td>R$ <?php echo formatMoneyBR($totalGeral); ?></td>
            <td>
              <a class="btn danger" href="index.php?page=os&delete=<?php echo $os['id_os']; ?>"
                 onclick="return confirm('Deseja realmente excluir esta OS?');">
                Excluir
              </a>
            </td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>
